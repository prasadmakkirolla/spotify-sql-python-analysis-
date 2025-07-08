-- Spotify Daily Listeners Analysis
-- These queries analyze average daily engagement using popularity as a proxy for listeners

-- Query 1: Average Daily Popularity (Basic Daily Analysis)
-- This query calculates the average popularity of tracks released each day
SELECT 
    release_date,
    COUNT(*) AS tracks_released,
    AVG(popularity) AS avg_daily_popularity,
    MIN(popularity) AS min_popularity,
    MAX(popularity) AS max_popularity,
    ROUND(STDDEV(popularity), 2) AS popularity_stddev
FROM spotify_tracks 
WHERE popularity IS NOT NULL 
    AND release_date IS NOT NULL
GROUP BY release_date
ORDER BY release_date DESC;

-- Query 2: Average Daily Popularity by Year
-- This provides yearly trends in average daily listener engagement
SELECT 
    year,
    COUNT(*) AS total_tracks,
    AVG(popularity) AS avg_yearly_popularity,
    COUNT(DISTINCT release_date) AS days_with_releases
FROM spotify_tracks 
WHERE popularity IS NOT NULL 
    AND year IS NOT NULL
GROUP BY year
ORDER BY year DESC;

-- Query 3: Top 10 Days with Highest Average Popularity
-- Identifies the most successful release days
SELECT 
    release_date,
    COUNT(*) AS tracks_released,
    ROUND(AVG(popularity), 2) AS avg_popularity,
    GROUP_CONCAT(name || ' by ' || artists, '; ') AS top_tracks
FROM spotify_tracks 
WHERE popularity IS NOT NULL 
    AND release_date IS NOT NULL
GROUP BY release_date
HAVING COUNT(*) >= 5  -- Only days with 5+ releases for statistical significance
ORDER BY avg_popularity DESC
LIMIT 10;

-- Query 4: Weekly Average Analysis
-- Groups data by week for trend analysis
SELECT 
    strftime('%Y-W%W', release_date) AS week,
    COUNT(*) AS tracks_released,
    ROUND(AVG(popularity), 2) AS avg_weekly_popularity,
    COUNT(DISTINCT artists) AS unique_artists
FROM spotify_tracks 
WHERE popularity IS NOT NULL 
    AND release_date IS NOT NULL
GROUP BY strftime('%Y-W%W', release_date)
ORDER BY week DESC
LIMIT 20;

-- Query 5: Monthly Trends in Daily Average Popularity
-- Shows seasonal patterns in listener engagement
SELECT 
    strftime('%Y-%m', release_date) AS month,
    COUNT(*) AS tracks_released,
    ROUND(AVG(popularity), 2) AS avg_monthly_popularity,
    COUNT(DISTINCT release_date) AS release_days,
    ROUND(AVG(popularity) / COUNT(DISTINCT release_date), 2) AS avg_daily_popularity_per_month
FROM spotify_tracks 
WHERE popularity IS NOT NULL 
    AND release_date IS NOT NULL
GROUP BY strftime('%Y-%m', release_date)
ORDER BY month DESC;

-- Query 6: Day of Week Analysis
-- Analyzes which days of the week have higher average popularity
SELECT 
    CASE strftime('%w', release_date)
        WHEN '0' THEN 'Sunday'
        WHEN '1' THEN 'Monday'
        WHEN '2' THEN 'Tuesday'
        WHEN '3' THEN 'Wednesday'
        WHEN '4' THEN 'Thursday'
        WHEN '5' THEN 'Friday'
        WHEN '6' THEN 'Saturday'
    END AS day_of_week,
    COUNT(*) AS tracks_released,
    ROUND(AVG(popularity), 2) AS avg_popularity,
    COUNT(DISTINCT release_date) AS unique_dates
FROM spotify_tracks 
WHERE popularity IS NOT NULL 
    AND release_date IS NOT NULL
GROUP BY strftime('%w', release_date)
ORDER BY avg_popularity DESC;

-- Query 7: Artist Performance on High-Engagement Days
-- Identifies artists who consistently release popular tracks
SELECT 
    artists,
    COUNT(DISTINCT release_date) AS release_days,
    COUNT(*) AS total_tracks,
    ROUND(AVG(popularity), 2) AS avg_popularity,
    ROUND(MIN(popularity), 2) AS min_popularity,
    ROUND(MAX(popularity), 2) AS max_popularity
FROM spotify_tracks 
WHERE popularity IS NOT NULL 
    AND artists IS NOT NULL
    AND release_date IS NOT NULL
GROUP BY artists
HAVING COUNT(*) >= 10  -- Artists with at least 10 tracks
ORDER BY avg_popularity DESC
LIMIT 15;

-- Query 8: Moving Average of Daily Popularity (7-day window)
-- Smooths out daily fluctuations to show trends
WITH daily_stats AS (
    SELECT 
        release_date,
        AVG(popularity) AS daily_avg_popularity,
        COUNT(*) AS daily_track_count
    FROM spotify_tracks 
    WHERE popularity IS NOT NULL 
        AND release_date IS NOT NULL
    GROUP BY release_date
)
SELECT 
    release_date,
    daily_avg_popularity,
    daily_track_count,
    ROUND(AVG(daily_avg_popularity) OVER (
        ORDER BY release_date 
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ), 2) AS moving_avg_7day
FROM daily_stats
ORDER BY release_date DESC
LIMIT 30;

-- Query 9: Peak vs Off-Peak Daily Analysis
-- Compares high-engagement vs low-engagement days
WITH daily_popularity AS (
    SELECT 
        release_date,
        AVG(popularity) AS daily_avg,
        COUNT(*) AS track_count
    FROM spotify_tracks 
    WHERE popularity IS NOT NULL 
    GROUP BY release_date
),
percentiles AS (
    SELECT 
        *,
        NTILE(4) OVER (ORDER BY daily_avg) AS quartile
    FROM daily_popularity
)
SELECT 
    CASE 
        WHEN quartile = 4 THEN 'Peak Days (Top 25%)'
        WHEN quartile = 1 THEN 'Off-Peak Days (Bottom 25%)'
        ELSE 'Medium Days'
    END AS engagement_level,
    COUNT(*) AS number_of_days,
    ROUND(AVG(daily_avg), 2) AS avg_popularity,
    ROUND(AVG(track_count), 1) AS avg_tracks_per_day
FROM percentiles
WHERE quartile IN (1, 4)
GROUP BY quartile
ORDER BY quartile DESC;
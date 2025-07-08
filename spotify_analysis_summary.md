# Spotify Daily Listeners Analysis - SQL Queries

This document provides SQL queries to analyze average daily listeners from Spotify data using the `spotify_tracks` table.

## Data Overview
- **Table**: `spotify_tracks`
- **Key Columns**: `release_date`, `popularity`, `artists`, `name`, `year`
- **Popularity Metric**: 0-100 scale used as proxy for listener engagement

## Query Descriptions

### 1. Basic Daily Analysis
**Purpose**: Calculate average popularity of tracks released each day
**Use Case**: Identify daily trends in track performance
**Key Metrics**: Daily track count, average/min/max popularity, standard deviation

### 2. Yearly Trends
**Purpose**: Analyze yearly patterns in average daily listener engagement
**Use Case**: Long-term trend analysis and year-over-year comparisons
**Key Metrics**: Total tracks per year, average yearly popularity

### 3. Top Release Days
**Purpose**: Identify the most successful release days (highest average popularity)
**Use Case**: Find optimal release timing strategies
**Key Metrics**: Days with 5+ releases and highest engagement

### 4. Weekly Analysis
**Purpose**: Group data by week for medium-term trend analysis
**Use Case**: Identify weekly patterns and seasonal trends
**Key Metrics**: Weekly popularity averages, unique artists per week

### 5. Monthly Trends
**Purpose**: Show seasonal patterns in listener engagement
**Use Case**: Identify best months for releases
**Key Metrics**: Monthly averages, release frequency

### 6. Day of Week Analysis
**Purpose**: Determine which days of the week have higher engagement
**Use Case**: Optimize release day strategy (e.g., "Music Tuesday" vs "Friday releases")
**Key Metrics**: Average popularity by day of week

### 7. Artist Performance
**Purpose**: Identify artists who consistently release popular tracks
**Use Case**: Artist benchmarking and success pattern analysis
**Key Metrics**: Multi-track artists with consistent high engagement

### 8. Moving Average (7-day)
**Purpose**: Smooth out daily fluctuations to show underlying trends
**Use Case**: Trend analysis without daily noise
**Key Metrics**: 7-day rolling average of daily popularity

### 9. Peak vs Off-Peak Analysis
**Purpose**: Compare high-engagement vs low-engagement days
**Use Case**: Understand what makes certain days more successful
**Key Metrics**: Quartile analysis of daily performance

## How to Run

1. **Prerequisites**: SQLite database with `spotify_tracks` table loaded
2. **Execute**: Run individual queries or combine them for comprehensive analysis
3. **Customize**: Modify date ranges, thresholds, or add additional filters as needed

## Key Insights You Can Gain

- **Optimal Release Timing**: Best days/weeks/months for releases
- **Seasonal Patterns**: How listener engagement varies throughout the year
- **Artist Benchmarks**: Performance comparisons across artists
- **Trend Analysis**: Long-term and short-term engagement patterns
- **Strategic Planning**: Data-driven release calendar optimization

## Notes

- Popularity (0-100) is used as a proxy for "daily listeners"
- Queries filter out NULL values for reliable results
- Statistical significance thresholds applied where appropriate
- Results can be exported for visualization in tools like Python/R or BI platforms
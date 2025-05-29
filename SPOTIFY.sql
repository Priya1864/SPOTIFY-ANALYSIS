select*from spotify;
-- 1. Retrieve tracks with more than 1 billion streams
SELECT * FROM spotify
WHERE stream > 1000000000;

-- 2. List all albums with their respective artists
SELECT DISTINCT album, artist
FROM spotify
ORDER BY artist;

-- 3. Get total number of comments where licensed is TRUE
SELECT licensed, SUM(comments) AS no_of_comments
FROM spotify
WHERE licensed = TRUE
GROUP BY licensed
ORDER BY no_of_comments DESC;

-- 4. Find all tracks of album type 'single'
SELECT track, album_type
FROM spotify
WHERE album_type = 'single';

-- 5. Count total tracks by each artist
SELECT artist, COUNT(*) AS number_of_tracks
FROM spotify
GROUP BY artist
ORDER BY number_of_tracks;

-- ### Medium Level

-- 1. Calculate average danceability per album
SELECT album, AVG(danceability) AS avg_danceability
FROM spotify
GROUP BY album
ORDER BY avg_danceability DESC;

-- 2. Top 5 tracks with highest energy values
SELECT track, energy
FROM spotify
ORDER BY energy DESC
LIMIT 5;

-- 3. List tracks with views and likes where official_video = TRUE
SELECT track, SUM(views) AS total_views, SUM(likes) AS total_likes
FROM spotify
WHERE official_video = TRUE
GROUP BY track;

-- 4. Total views for each album (sum of all track views)
SELECT album, SUM(views) AS total_views
FROM spotify
GROUP BY album
ORDER BY total_views DESC;

-- 5. Tracks streamed more on Spotify than YouTube
SELECT *
FROM (
    SELECT track,
           COALESCE(SUM(CASE WHEN most_playedon = 'Youtube' THEN stream END), 0) AS stream_as_youtube,
           COALESCE(SUM(CASE WHEN most_playedon = 'Spotify' THEN stream END), 0) AS stream_as_spotify
    FROM spotify
    GROUP BY track
) sub
WHERE stream_as_spotify > stream_as_youtube
  AND stream_as_youtube <> 0;

-- ### Advanced Level

-- 1. Top 3 most viewed tracks per artist using window functions
SELECT artist, track, most_views
FROM (
    SELECT artist,
           track,
           SUM(views) AS most_views,
           DENSE_RANK() OVER (PARTITION BY artist ORDER BY SUM(views) DESC) AS rank
    FROM spotify
    GROUP BY artist, track
) ranked
WHERE rank <= 3
ORDER BY artist, most_views DESC;

-- 2. Tracks where liveness is above average
SELECT track, artist, liveness
FROM spotify
WHERE liveness > (SELECT AVG(liveness) FROM spotify);

-- 3. Difference between highest and lowest energy per album (using WITH clause)
WITH energy_diff AS (
    SELECT album,
           MAX(energy) AS highest_energy,
           MIN(energy) AS lowest_energy
    FROM spotify
    GROUP BY album
)
SELECT album, highest_energy - lowest_energy AS energy_difference
FROM energy_diff
ORDER BY energy_difference DESC;



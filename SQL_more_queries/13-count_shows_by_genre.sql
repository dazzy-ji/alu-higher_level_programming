-- Lists each genre with the number of shows linked to it
-- Genres without any linked show are not displayed
SELECT tv_genres.name AS genre, COUNT(*) AS number_of_shows FROM tv_genres
    INNER JOIN tv_show_genres ON tv_genres.id = tv_show_genres.genre_id
    GROUP BY tv_genres.name
    ORDER BY number_of_shows DESC;

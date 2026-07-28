-- Lists the number of records sharing each score, most common first
SELECT score, COUNT(*) AS number FROM second_table
    GROUP BY score
    ORDER BY number DESC;

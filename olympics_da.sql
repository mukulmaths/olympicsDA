# Athele Data Base 
SELECT*FROM mytable;

# 1. How Many olympic games have ever been held ? Ans :- 51
SELECT 
    COUNT(DISTINCT Games)
FROM
    mytable;

# 2. List down all olympic games held so far.
SELECT DISTINCT
    Games
FROM
    mytable
ORDER BY Games;

# 3. Mention the total number of nations participated in each olypics game. Ans:- 207
SELECT 
    COUNT(DISTINCT n.region) AS countries_participated
FROM
    noc_regions n
        LEFT JOIN
    mytable m ON n.NOC = m.NOC;

# 4. Which year saw the highest and the lowest of the countries participating in olympics ?  Ans :- 
# For lowest participations :- year_1896 , 12
# For highest participations :- year_2016 , 204
SELECT 
    m.Year, COUNT(DISTINCT n.region) AS no_countries
FROM
    noc_regions n
        JOIN
    mytable m ON m.NOC = n.NOC
GROUP BY m.Year
ORDER BY m.Year ASC;

# 5. Which nation have participated in all of the olympic games ? Ans :- UK,Swizerland,France,Italy
SELECT 
    *
FROM
    (SELECT DISTINCT
        n.region AS country,
            COUNT(DISTINCT m.Games) AS participations
    FROM
        noc_regions n
    JOIN mytable m ON m.NOC = n.NOC
    GROUP BY n.region) a
ORDER BY a.participations DESC; 

# 6. Identify the sport which was played most in all summer olympics. Ans :- Athletics
SELECT 
    *
FROM
    (SELECT 
        Sport, COUNT(Sport) AS sport_counts
    FROM
        mytable
    WHERE
        Season = 'Summer'
    GROUP BY Sport) a
ORDER BY a.sport_counts DESC;

# 7. Which sport was played just once in the olympics ? Ans :- Aeronautics
SELECT 
    *
FROM
    (SELECT 
        Sport, COUNT(Sport) AS sport_count
    FROM
        mytable
    GROUP BY Sport) a
ORDER BY a.sport_count ASC;

# 8. Fetch the total number of sports played in each olympic game. 
SELECT 
    *
FROM
    (SELECT 
        Games, COUNT(Sport) AS sport_counts
    FROM
        mytable
    GROUP BY Games) a
ORDER BY a.Games ASC;

# 9. Fetch the details of oldest athlete who won gold medal. Ans :- Patrick Joseph Pat
SELECT 
    *
FROM
    mytable
WHERE
    Medal = 'Gold' AND Sport = 'Athletics'
ORDER BY Age DESC
LIMIT 1;

# 10. Find the ratio of male and female athletes in all olympic games. Ans :- 12:7
SELECT 
    a.male_count, b.female_count
FROM
    ((SELECT 
        COUNT(Sex) AS male_count
    FROM
        mytable
    WHERE
        Sex = 'M' AND Sport = 'Athletics') a
    CROSS JOIN (SELECT 
        COUNT(Sex) AS female_count
    FROM
        mytable
    WHERE
        Sex = 'F' AND Sport = 'Athletics') b);

# 11. Fetch the top 5 players who have won most gold medals. 
SELECT 
    *
FROM
    (SELECT 
        Name, COUNT(Medal) AS gold_medals
    FROM
        athlete_events
    WHERE
        Medal = 'Gold'
    GROUP BY Name) a
ORDER BY a.gold_medals DESC
LIMIT 5;

# 12. Fetch top 5 players who have won most medals (gold/silver/bronze). 
SELECT 
    *
FROM
    (SELECT 
        Name, COUNT(Medal) AS medal_counts
    FROM
        mytable
    GROUP BY Name) a
ORDER BY a.medal_counts DESC
LIMIT 5;

# 13. Fetch top 5 successful countries in olympics.
SELECT 
    *
FROM
    (SELECT 
        Team AS Country, COUNT(Medal) medal_counts
    FROM
        athlete_events
    GROUP BY Team) a
ORDER BY a.medal_counts DESC
LIMIT 5;

# 14. List total gold,silver & bronze medals won by all countries. 
SELECT 
    g.country, g.gold_medals, s.silver_medals, b.bronze_medals
FROM
    (SELECT 
        n.region AS country,
            SUM(CASE
                WHEN m.Medal = 'Gold' THEN 1
                ELSE 0
            END) AS gold_medals
    FROM
        noc_regions n
    LEFT JOIN mytable m ON n.NOC = m.NOC
    GROUP BY n.region
    ORDER BY n.region ASC) g
        LEFT JOIN
    (SELECT 
        n.region AS country,
            SUM(CASE
                WHEN m.Medal = 'Silver' THEN 1
                ELSE 0
            END) AS silver_medals
    FROM
        noc_regions n
    LEFT JOIN mytable m ON n.NOC = m.NOC
    GROUP BY n.region
    ORDER BY n.region ASC) s ON g.country = s.country
        LEFT JOIN
    (SELECT 
        n.region AS country,
            SUM(CASE
                WHEN m.Medal = 'Bronze' THEN 1
                ELSE 0
            END) AS bronze_medals
    FROM
        noc_regions n
    LEFT JOIN mytable m ON n.NOC = m.NOC
    GROUP BY n.region
    ORDER BY n.region ASC) b ON s.country = b.country;

# 15. List the total number of gold/silver/bronze medals won by countries in different olympic games.
SELECT 
    g.Games,
    g.country,
    g.gold_medals,
    s.silver_medals,
    b.bronze_medals
FROM
    (SELECT 
        m.Games,
            n.region AS country,
            SUM(CASE
                WHEN m.Medal = 'Gold' THEN 1
                ELSE 0
            END) AS gold_medals
    FROM
        noc_regions n
    LEFT JOIN mytable m ON n.NOC = m.NOC
    GROUP BY m.Games , n.region) g
        JOIN
    (SELECT 
        m.Games,
            n.region AS country,
            SUM(CASE
                WHEN m.Medal = 'Silver' THEN 1
                ELSE 0
            END) AS silver_medals
    FROM
        noc_regions n
    LEFT JOIN mytable m ON n.NOC = m.NOC
    GROUP BY m.Games , n.region) s ON g.country = s.country
        JOIN
    (SELECT 
        m.Games,
            n.region AS country,
            SUM(CASE
                WHEN m.Medal = 'Bronze' THEN 1
                ELSE 0
            END) AS bronze_medals
    FROM
        noc_regions n
    LEFT JOIN mytable m ON n.NOC = m.NOC
    GROUP BY m.Games , n.region) b ON s.country = b.country
ORDER BY g.Games;

# 16. Identify which country have won most Gold, most Silver & most Bronze medals ?
# Gold Medals = USA (2638)
# Silver Medals = USA (1641)
# Bronze Medals = USA (1358)
SELECT 
    g.country, g.gold_medals, s.silver_medals, b.bronze_medals
FROM
    (SELECT 
        n.region AS country,
            SUM(CASE
                WHEN m.Medal = 'Gold' THEN 1
                ELSE 0
            END) AS gold_medals
    FROM
        noc_regions n
    LEFT JOIN mytable m ON n.NOC = m.NOC
    GROUP BY n.region
    ORDER BY n.region ASC) g
        LEFT JOIN
    (SELECT 
        n.region AS country,
            SUM(CASE
                WHEN m.Medal = 'Silver' THEN 1
                ELSE 0
            END) AS silver_medals
    FROM
        noc_regions n
    LEFT JOIN mytable m ON n.NOC = m.NOC
    GROUP BY n.region
    ORDER BY n.region ASC) s ON g.country = s.country
        LEFT JOIN
    (SELECT 
        n.region AS country,
            SUM(CASE
                WHEN m.Medal = 'Bronze' THEN 1
                ELSE 0
            END) AS bronze_medals
    FROM
        noc_regions n
    LEFT JOIN mytable m ON n.NOC = m.NOC
    GROUP BY n.region
    ORDER BY n.region ASC) b ON s.country = b.country
ORDER BY bronze_medals DESC;

# 17. Identify all types of medals won by countries in each game and most medals won in each game. 
SELECT 
    g.Games,
    g.country,
    g.gold_medals,
    s.silver_medals,
    b.bronze_medals,
    b.total_medals
FROM
    (SELECT 
        m.Games,
            n.region AS country,
            SUM(CASE
                WHEN m.Medal = 'Gold' THEN 1
                ELSE 0
            END) AS gold_medals
    FROM
        noc_regions n
    LEFT JOIN mytable m ON n.NOC = m.NOC
    GROUP BY m.Games , n.region) g
        JOIN
    (SELECT 
        m.Games,
            n.region AS country,
            SUM(CASE
                WHEN m.Medal = 'Silver' THEN 1
                ELSE 0
            END) AS silver_medals
    FROM
        noc_regions n
    LEFT JOIN mytable m ON n.NOC = m.NOC
    GROUP BY m.Games , n.region) s ON g.country = s.country
        JOIN
    (SELECT 
        m.Games,
            n.region AS country,
            SUM(CASE
                WHEN m.Medal = 'Bronze' THEN 1
                ELSE 0
            END) AS bronze_medals,
            SUM(CASE
                WHEN NOT m.Medal = 'NA' THEN 1
                ELSE 0
            END) AS total_medals
    FROM
        noc_regions n
    LEFT JOIN mytable m ON n.NOC = m.NOC
    GROUP BY m.Games , n.region) b ON s.country = b.country
ORDER BY g.Games;

# 18. Which countries have never won gold medal, but have won silver & bronze medals.
SELECT 
    g.country, g.gold_medals, s.silver_medals, b.bronze_medals
FROM
    (SELECT 
        n.region AS country,
            SUM(CASE
                WHEN m.Medal = 'Gold' THEN 1
                ELSE 0
            END) AS gold_medals
    FROM
        noc_regions n
    LEFT JOIN mytable m ON n.NOC = m.NOC
    GROUP BY n.region
    ORDER BY n.region ASC) g
        LEFT JOIN
    (SELECT 
        n.region AS country,
            SUM(CASE
                WHEN m.Medal = 'Silver' THEN 1
                ELSE 0
            END) AS silver_medals
    FROM
        noc_regions n
    LEFT JOIN mytable m ON n.NOC = m.NOC
    GROUP BY n.region
    ORDER BY n.region ASC) s ON g.country = s.country
        LEFT JOIN
    (SELECT 
        n.region AS country,
            SUM(CASE
                WHEN m.Medal = 'Bronze' THEN 1
                ELSE 0
            END) AS bronze_medals
    FROM
        noc_regions n
    LEFT JOIN mytable m ON n.NOC = m.NOC
    GROUP BY n.region
    ORDER BY n.region ASC) b ON s.country = b.country
WHERE
    g.gold_medals = 0
        AND NOT s.silver_medals = 0
        AND NOT b.bronze_medals = 0;

# 19. In which sport/event India has won highest Medals ? Ans :- Hockey
SELECT 
    *
FROM
    (SELECT 
        n.region AS country,
            m.Sport,
            SUM(CASE
                WHEN m.Medal = 'NA' THEN 0
                ELSE 1
            END) AS medals
    FROM
        noc_regions n
    LEFT JOIN mytable m ON n.NOC = m.NOC
    GROUP BY n.region , m.Sport) a
WHERE
    a.country = 'India'
ORDER BY a.medals DESC;

# 20. Break down all olympic games where India won medals in Hockey and number of medals in each game.
SELECT 
    *
FROM
    (SELECT 
        m.Games,
            n.region AS country,
            m.Sport,
            SUM(CASE
                WHEN m.Medal = 'NA' THEN 0
                ELSE 1
            END) AS medals
    FROM
        noc_regions n
    LEFT JOIN mytable m ON n.NOC = m.NOC
    GROUP BY m.Games , n.region , m.Sport) a
WHERE
    a.country = 'India'
        AND a.Sport = 'Hockey'
ORDER BY a.Games ASC;




SELECT 
    SUM(VOTES) AS TotalVotes, year AS Year
FROM
    (SELECT 
        COUNT(DISTINCT CNIC) AS Votes, year
    FROM
        Votes_Casted_National
    WHERE
        year = 2018 UNION SELECT 
        COUNT(DISTINCT CNIC) AS Votes, year
    FROM
        Votes_Casted_Provincial
    WHERE
        year = 2018) AS sumindividual;
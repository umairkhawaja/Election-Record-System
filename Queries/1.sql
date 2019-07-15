SELECT 
    MAX(Total_Votes) Total_Votes,
    PartyID,
    pname AS Party_name,
    Year
FROM
    (SELECT 
        p.Party_id AS PartyID,
            SUM(combined_votes.Count) AS Total_Votes,
            p.pname,
            Year
    FROM
        (SELECT 
        a.Cand_id AS Cand_ID,
            a.CNIC as Candidate_CNIC,
            COUNT(a.Cand_id) AS Count,
            a.Party_id,
            b.Year AS Year
    FROM
        N_Candidate AS a
    INNER JOIN Votes_Casted_National AS b ON a.Cand_id = b.Cand_id
    WHERE
        b.Year = 2018
    GROUP BY a.Cand_id UNION SELECT 
        c.Cand_id AS Cand_ID,
            c.CNIC as Candidate_CNIC,
            COUNT(c.Cand_id) AS Count,
            c.Party_id,
            d.Year AS Year
    FROM
        P_Candidate AS c
    INNER JOIN Votes_Casted_Provincial AS d ON c.Cand_id = d.Cand_id
    WHERE
        d.Year = 2018
    GROUP BY c.Cand_id) AS combined_votes
    INNER JOIN Parties AS p ON combined_votes.Party_id = p.Party_id
    GROUP BY p.Party_id) AS sum_votes;
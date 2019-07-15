SELECT 
    SUM(VOTES) AS TotalVotes, Party, Party_id, Year
FROM
    (SELECT 
        COUNT(DISTINCT CNIC) AS Votes,
            Party,
            Party_id,
            vp.year AS Year
    FROM
        (SELECT 
        pc.Cand_id AS CandID, p.pname AS Party, p.Party_id
    FROM
        Parties AS p
    INNER JOIN P_Candidate AS pc ON p.Party_id = pc.Party_id
    WHERE
        p.Party_id = 101) AS candidates
    INNER JOIN Votes_Casted_Provincial AS vp ON candidates.CandID = vp.Cand_id
    WHERE
        year = 2018 UNION SELECT 
        COUNT(DISTINCT CNIC) AS Votes,
            Party,
            Party_id,
            v.year AS Year
    FROM
        (SELECT 
        nc.Cand_id AS CandID, p.pname AS Party, p.Party_id
    FROM
        Parties AS p
    INNER JOIN N_Candidate AS nc ON p.Party_id = nc.Party_id
    WHERE
        p.Party_id = 101) AS candidates
    INNER JOIN Votes_Casted_National AS v ON candidates.CandID = v.Cand_id
    WHERE
        year = 2018) AS last;
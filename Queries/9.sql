SELECT 
    V1.*
FROM
    (SELECT 
        P.Fname, sq.CNIC, sq.Year, sq.Cand_id, sq.votes
    FROM
        (SELECT 
        NC.CNIC, V.Year, V.Cand_id, COUNT(V.Cand_id) AS votes
    FROM
        Votes_Casted_National V
    JOIN N_Candidate NC ON V.Cand_id = NC.Cand_id
    GROUP BY Cand_id) sq
    JOIN Person P ON P.CNIC = sq.CNIC UNION SELECT 
        P.Fname, sq.CNIC, sq.Year, sq.Cand_id, sq.votes
    FROM
        (SELECT 
        PC.CNIC, P.Year, P.Cand_id, COUNT(P.Cand_id) AS votes
    FROM
        Votes_Casted_Provincial P
    JOIN P_Candidate PC ON P.Cand_id = PC.Cand_id
    GROUP BY Cand_id) sq
    JOIN Person P ON P.CNIC = sq.CNIC) V1
        LEFT JOIN
    (SELECT 
        P.Fname, sq.CNIC, sq.Year, sq.Cand_id, sq.votes
    FROM
        (SELECT 
        NC.CNIC, V.Year, V.Cand_id, COUNT(V.Cand_id) AS votes
    FROM
        Votes_Casted_National V
    JOIN N_Candidate NC ON V.Cand_id = NC.Cand_id
    GROUP BY Cand_id) sq
    JOIN Person P ON P.CNIC = sq.CNIC UNION SELECT 
        P.Fname, sq.CNIC, sq.Year, sq.Cand_id, sq.votes
    FROM
        (SELECT 
        PC.CNIC, P.Year, P.Cand_id, COUNT(P.Cand_id) AS votes
    FROM
        Votes_Casted_Provincial P
    JOIN P_Candidate PC ON P.Cand_id = PC.Cand_id
    GROUP BY Cand_id) sq
    JOIN Person P ON P.CNIC = sq.CNIC) V2 ON V1.Year = V2.Year
        AND V1.votes < V2.votes
WHERE
    V2.votes IS NULL
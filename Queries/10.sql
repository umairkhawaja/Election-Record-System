SELECT 
    sq3.Fname, P.Pname, sq3.CNIC, sq3.num_apppear
FROM
    (SELECT DISTINCT
        sq2.Fname,
            sq2.Cand_id,
            sq2.Year,
            sq2.Party_id,
            sq2.CNIC,
            COUNT(sq2.Fname) AS num_apppear
    FROM
        (SELECT 
        P.Fname, sq.CNIC, sq.Year, sq.Cand_id, sq.Party_id
    FROM
        (SELECT 
        NC.CNIC, V.Year, V.Cand_id, NC.Party_id
    FROM
        Votes_Casted_National V
    JOIN N_Candidate NC ON V.Cand_id = NC.Cand_id) sq
    JOIN Person P ON P.CNIC = sq.CNIC UNION SELECT 
        P.Fname, sq.CNIC, sq.Year, sq.Cand_id, sq.Party_id
    FROM
        (SELECT 
        PC.CNIC, P.Year, P.Cand_id, PC.Party_id
    FROM
        Votes_Casted_Provincial P
    JOIN P_Candidate PC ON P.Cand_id = PC.Cand_id) sq
    JOIN Person P ON P.CNIC = sq.CNIC) sq2
    GROUP BY sq2.Fname
    ORDER BY num_apppear DESC
    LIMIT 1) sq3
        INNER JOIN
    Parties P ON P.Party_id = sq3.Party_id
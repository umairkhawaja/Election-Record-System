SELECT 
    MIN(Votes) AS Votes,
    Code,
    City_Division,
    Fname,
    Cand_ID,
    CNIC
FROM
    (SELECT 
        CONCAT(Prov.Assembly, ' ', Prov.Code) AS Code,
            Prov.City_Div AS City_Division,
            sub_que.Fname AS Fname,
            sub_que.CNIC AS CNIC,
            sub_que.Cand_id AS Cand_ID,
            COUNT(sub_que.Cand_id) AS Votes
    FROM
        (SELECT 
        PC.CNIC, PC.Cand_id, PC.Prov_id, P.Fname
    FROM
        (SELECT 
        P.Prov_id, P.Cand_id, PC.CNIC
    FROM
        Votes_Casted_Provincial AS P
    INNER JOIN P_Candidate AS PC ON P.Cand_id = PC.Cand_id) AS PC
    INNER JOIN Person AS P ON P.CNIC = PC.CNIC) AS sub_que
    INNER JOIN Provincial AS Prov ON sub_que.Prov_id = Prov.Const_id
    GROUP BY sub_que.Cand_id UNION SELECT 
        CONCAT('NA ', Nat.Code) AS Code,
            Nat.City_Div,
            sub_que.Fname,
            sub_que.CNIC AS CNIC,
            sub_que.Cand_id,
            COUNT(sub_que.Cand_id) AS count
    FROM
        (SELECT 
        cand_join.CNIC, cand_join.Cand_id, cand_join.N_code, P.Fname
    FROM
        (SELECT 
        N.N_code, N.Cand_id, NC.CNIC
    FROM
        Votes_Casted_National AS N
    INNER JOIN N_Candidate AS NC ON N.Cand_id = NC.Cand_id) AS cand_join
    INNER JOIN Person AS P ON P.CNIC = cand_join.CNIC) sub_que
    INNER JOIN National AS Nat ON sub_que.N_code = Nat.Code
    GROUP BY sub_que.Cand_id) AS finalresult;
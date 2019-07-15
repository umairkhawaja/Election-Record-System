SELECT 
    SUM(Votes) SumVotes,
    Cand_id,
    CandidateCNIC,
    Person.fname,
    Person.lname
FROM
    (SELECT 
        Votes, Cand_id, CandidateCNIC
    FROM
        (SELECT 
        COUNT(v.CNIC) AS Votes, n.Cand_id, n.CNIC AS CandidateCNIC
    FROM
        N_Candidate AS n
    INNER JOIN Votes_Casted_National AS v ON n.Cand_id = v.Cand_id
    WHERE
        n.CNIC = 3520112345756 UNION SELECT 
        COUNT(p.CNIC) AS Votes, p.Cand_id, p.CNIC AS CandidateCNIC
    FROM
        P_Candidate AS p
    INNER JOIN Votes_Casted_Provincial AS pv ON p.Cand_id = pv.Cand_id
    WHERE
        p.CNIC = 3520112345756) AS final
    WHERE
        Cand_id IS NOT NULL) AS final2
        INNER JOIN
    Person ON Person.CNIC = CandidateCNIC
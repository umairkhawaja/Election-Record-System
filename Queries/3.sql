SELECT 
    Constituency,
    CandID,
    MAX(Count) Count,
    finaltab2.Year AS Year,
    finaltab2.CNIC AS CNIC,
    y.fname AS FName,
    y.lname AS LName
FROM
    (SELECT 
        Constituency,
            CandID,
            MAX(Count) Count,
            finaltab.Year AS Year,
            x.CNIC AS CNIC
    FROM
        (SELECT 
        Constituency, CandID, MAX(Count) Count, Year
    FROM
        (SELECT 
        Constituency,
            VoterCNIC,
            CandID,
            Year,
            COUNT(DISTINCT VoterCNIC) AS Count,
            Code
    FROM
        (SELECT 
        CONCAT(p.Assembly, ' ', p.Code) AS Constituency,
            v.Prov_id AS Code,
            p.City_Div AS City_Division,
            v.CNIC AS VoterCNIC,
            v.Cand_id AS CandID,
            year AS Year
    FROM
        Provincial AS p
    INNER JOIN Votes_Casted_Provincial AS v ON p.Const_id = v.Prov_id
    WHERE
        v.year = 2018) AS tab
    GROUP BY CandID) AS fin
    GROUP BY Constituency) AS finaltab
    INNER JOIN P_Candidate AS x ON finaltab.CandID = x.Cand_id
    GROUP BY Constituency) AS finaltab2
        INNER JOIN
    Person AS y ON finaltab2.CNIC = y.CNIC
GROUP BY Constituency 
UNION SELECT 
    Constituency,
    CandID,
    MAX(Count) Count,
    finaltab21.Year AS Year,
    finaltab21.CNIC AS CNIC,
    y1.fname AS FName,
    y1.lname AS LName
FROM
    (SELECT 
        Constituency,
            CandID,
            MAX(Count) Count,
            finaltab1.Year AS Year,
            x1.CNIC AS CNIC
    FROM
        (SELECT 
        Constituency, CandID, MAX(Count) Count, Year
    FROM
        (SELECT 
        Constituency,
            VoterCNIC,
            CandID,
            Year,
            COUNT(DISTINCT VoterCNIC) AS Count,
            Code
    FROM
        (SELECT 
        CONCAT('NA ', q.Code) AS Constituency,
            w.N_code AS Code,
            q.City_Div AS City_Division,
            w.CNIC AS VoterCNIC,
            w.Cand_id AS CandID,
            year AS Year
    FROM
        National AS q
    INNER JOIN Votes_Casted_National AS w ON q.Code = w.N_code
    WHERE
        w.Year = 2018) AS tab
    GROUP BY CandID) AS fin1
    GROUP BY Constituency) AS finaltab1
    INNER JOIN N_Candidate AS x1 ON finaltab1.CandID = x1.Cand_id
    GROUP BY Constituency) AS finaltab21
        INNER JOIN
    Person AS y1 ON finaltab21.CNIC = y1.CNIC
GROUP BY Constituency;
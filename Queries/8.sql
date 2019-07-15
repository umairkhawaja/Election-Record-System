SELECT 
    VN.CNIC, P.FName, P.Gender, COUNT(VN.CNIC) AS count
FROM
    Votes_Casted_National AS VN
        INNER JOIN
    Person AS P ON P.CNIC = VN.CNIC
GROUP BY VN.CNIC 
UNION SELECT 
    VP.CNIC, P.FName, P.Gender, COUNT(VP.CNIC) AS count
FROM
    Votes_Casted_Provincial AS VP
        INNER JOIN
    Person AS P ON P.CNIC = VP.CNIC
GROUP BY VP.CNIC
ORDER BY count ASC
LIMIT 1
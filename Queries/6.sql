SELECT
  MAX(count) AS Count,
  ANY_VALUE(Polling_Station) as PollingStation,
  ANY_VALUE(City_Division) as CityDivision,
  ANY_VALUE(Code) as ConstituencyCode
FROM
  (
    SELECT
      a.Prov_id AS Polling_Station,
      b.City_Div AS City_Division,
      CONCAT(b.Assembly, ' ', b.Code) AS Code,
      COUNT(a.Prov_id) AS count
    FROM
      Votes_Casted_Provincial AS a
      INNER JOIN Provincial AS b ON a.Prov_id = b.Const_id
    GROUP BY
      a.Prov_id
    UNION
    SELECT
      N_code AS Polling_Station,
      d.City_Div AS City_Dvision,
      CONCAT('NA ', d.Code) AS Code,
      COUNT(N_code) AS count
    FROM
      Votes_Casted_National AS c
      INNER JOIN National AS d ON c.N_code = d.Code
    GROUP BY
      N_code
    ORDER BY
      count DESC
  ) AS total_votes;
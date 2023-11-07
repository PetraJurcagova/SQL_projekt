/*Tvorba tabulky t_Petra_Jurcagova_project_SQL_secondary_final*/
/*spojení tabulek economies a countries, kde jsou vybrané jen evropské státy a vytvoření pomocné tabulky*/
CREATE TABLE t_Petra_Jurcagova_europe AS (SELECT 
c.country, c.continent, c.region_in_world, e.YEAR, e.GDP HDP,e.gini, e.population
FROM
economies e JOIN countries c ON 
e.country = c.country
WHERE 
c.continent LIKE 'Eur%' AND YEAR >= 2006 AND YEAR <= 2018
ORDER BY 
YEAR DESC);

/*stanovení meziročního percentuálního rozdílu HDP v evropských zemích s využitím funkce LAG*/
SELECT 
S.*,LAG(HDP) OVER(PARTITION BY country ORDER BY year )HDP_last_year,
ROUND(((HDP/LAG(HDP) OVER(PARTITION BY country ORDER BY year )-1)*100),1)interannual_percentage_difference
FROM 
t_Petra_Jurcagova_europe S
ORDER BY
YEAR DESC, country;

/*finalni podoba tabulky*/
CREATE TABLE t_Petra_Jurcagova_project_SQL_secondary_final AS 
(SELECT 
S.*,LAG(HDP) OVER(PARTITION BY country ORDER BY year )HDP_last_year,
ROUND(((HDP/LAG(HDP) OVER(PARTITION BY country ORDER BY year )-1)*100),1)interannual_percentage_difference
FROM 
t_Petra_Jurcagova_europe S
ORDER BY
YEAR DESC, country);

/*zobrazení NULL hodnot*/
SELECT 
*
FROM
t_Petra_Jurcagova_project_SQL_secondary_final
WHERE 
gini IS NULL OR HDP IS NULL;

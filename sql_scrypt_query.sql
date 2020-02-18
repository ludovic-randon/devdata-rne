/*
Pour chacune des requêtes qui suit vous devrez créer les index pertinents permettant de les accélérer. 
Vous ferais aussi en sorte de mettre en œuvre l’optimisation logique vue en cour. */

-- 8. Quel sont les parties politiques qui dans leur libellé comporte le terme « Union »

CREATE INDEX LIBELLE_PARTI 
ON NUANCIER (libelle)
;

SELECT LIBELLE LIBELLE_UNION 
FROM NUANCIER 
WHERE LIBELLE 
LIKE "%UNION%"
;

-- 9. Quels élus du département du « var » sont nais entre le mois de juin et aout ?

CREATE INDEX IDENTITE
ON ELUS (nom, prenom, date_de_naissance)
;
CREATE INDEX DEPARTEMENT_NUM
ON VILLES (departement_code)
;

SELECT NOM
,PRENOM
,DEPARTEMENT_CODE
,DATE_DE_NAISSANCE
FROM ELUS
INNER JOIN VILLES ON ELUS.CODE_INSEE = VILLES.CODE_INSEE
WHERE DEPARTEMENT_CODE = "83"
AND MONTH(DATE_DE_NAISSANCE) 
BETWEEN 06 AND 08
;


-- 10. Quel est l’âge moyen des élus homme au 01/01/2014 ? Celui des élus femme ?
--HOMME
WITH AGE_2014 AS
(
SELECT 2013 - YEAR(DATE_DE_NAISSANCE) AS AGE, DATE_DE_NAISSANCE, SEXE
FROM ELUS
)
SELECT AVG(AGE) AGE_MOYEN, 
SEXE
FROM AGE_2014
WHERE SEXE = "M"
--FEMME
WITH AGE_2014 AS
(
SELECT 2013 - YEAR(DATE_DE_NAISSANCE) AS AGE, DATE_DE_NAISSANCE, SEXE
FROM ELUS
)
SELECT AVG(AGE) AGE_MOYEN, 
SEXE
FROM AGE_2014
WHERE SEXE = "F"

-- 11. Afficher la population totale du département des « Bouches-du-Rhône »

SELECT SUM(POPULATION_LEGALE) AS POPULATION_TOTALE
,DEPARTEMENT_CODE
FROM POPULATION 
INNER JOIN VILLES ON POPULATION.CODE_INSEE = VILLES.CODE_INSEE
WHERE DEPARTEMENT_CODE = "13"
;

-- 12. Quel sont les 10 départements comptant le plus d’ouvriers.

CREATE INDEX CAT_INDEX_1
ON CATEGORIE (OUVRIERS, CODE)	
;

CREATE INDEX CAT_INDEX_2
ON VILLES (CODE_INSEE, DEPARTEMENT_CODE)
;		

SELECT SUM(OUVRIERS) AS NB_OUVRIERS, DEPARTEMENT_CODE
FROM CATEGORIE
INNER JOIN POPULATION ON CATEGORIE.CODE = POPULATION.CODE_INSEE
INNER JOIN VILLES ON POPULATION.CODE_INSEE = VILLES.CODE_INSEE
GROUP BY DEPARTEMENT_CODE
ORDER BY SUM(OUVRIERS) DESC
LIMIT 10
;

-- 13. Afficher le nombre d’élus regrouper par nuance politique et par département.

SELECT COUNT(NOM) AS NOMBRE_ELU
,LIBELLE AS PARTI_POLITIQUE
,DEPARTEMENT_CODE AS NUM_DEPARTEMENT
FROM ELUS
INNER JOIN NUANCIER ON ELUS.CODE_NUANCE_DE_LA_LISTE = NUANCIER.CODE
INNER JOIN VILLES ON ELUS.CODE_INSEE = VILLES.CODE_INSEE
GROUP BY LIBELLE, DEPARTEMENT_CODE
ORDER BY DEPARTEMENT_CODE
;

/* 14. Afficher le nombre d’élus regroupé par nuance politique et par villes pour le
département des « Bouches-du-Rhône ». */

SELECT COUNT(NOM) AS NOMBRE_ELU
,LIBELLE AS PARTI_POLITIQUE
,NAME AS NOM_VILLE
,DEPARTEMENT_CODE AS NUM_DEPARTEMENT
FROM ELUS
INNER JOIN NUANCIER ON ELUS.CODE_NUANCE_DE_LA_LISTE = NUANCIER.CODE
INNER JOIN VILLES ON ELUS.CODE_INSEE = VILLES.CODE_INSEE
WHERE DEPARTEMENT_CODE = "13"
GROUP BY LIBELLE, NAME, DEPARTEMENT_CODE
ORDER BY NAME
;

/* 15. Afficher les 10 départements dans lesquelles il y a le plus d’élus femme, ainsi que le
nombre d’élus femme correspondant. */

SELECT DEPARTEMENT_CODE AS NUM_DEPARTEMENT
,COUNT(NOM) AS NOMBRE_ELU
,SEXE
FROM ELUS
INNER JOIN VILLES ON ELUS.CODE_INSEE = VILLES.CODE_INSEE
WHERE SEXE = "F"
GROUP BY NUM_DEPARTEMENT
ORDER BY NOMBRE_ELU DESC LIMIT 10
;

/* 16. Donner l’âge moyen des élus par départements au 01/01/2014. Les afficher par ordre
décroissant. */

WITH AGE_2014 AS
(
SELECT 2013 - YEAR(DATE_DE_NAISSANCE) AS AGE, DATE_DE_NAISSANCE, DEPARTEMENT_CODE
FROM ELUS
INNER JOIN VILLES ON ELUS.CODE_INSEE = VILLES.CODE_INSEE
)
SELECT AVG(AGE) AGE_MOYEN
,DEPARTEMENT_CODE
FROM AGE_2014
GROUP BY DEPARTEMENT_CODE
ORDER BY AGE_MOYEN DESC
;

-- 17. Afficher les départements où l’âge moyen des élus est strictement inférieur à 54 ans.

WITH AGE_2020 AS
(
SELECT 2019 - YEAR(DATE_DE_NAISSANCE) AS AGE, DATE_DE_NAISSANCE, DEPARTEMENT_CODE
FROM ELUS
INNER JOIN VILLES ON ELUS.CODE_INSEE = VILLES.CODE_INSEE
)
SELECT AVG(AGE) AGE_MOYEN
,DEPARTEMENT_CODE
FROM AGE_2020
GROUP BY DEPARTEMENT_CODE
HAVING AVG(AGE) < 54 
ORDER BY AGE_MOYEN
;


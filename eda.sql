
--- Find the top species in each personality type 
WITH Num_Personality AS
(
SELECT species,personality,COUNT(personality) as pers_count
FROM villagers
GROUP BY personality,species
ORDER BY personality,count(personality) DESC
), Personality_Rank AS(
SELECT *, DENSE_RANK() OVER(PARTITION BY personality ORDER BY pers_count DESC) as pers_rank
FROM Num_Personality
)
SELECT personality,species FROM Personality_Rank
WHERE pers_rank = 1
;



---TESTING!!!!! finding prices of each villager 


---
---Finds the price of all of the items in the villager_furniture list
---however,note that there are less tables here than in the villager_furniture list
--------------------------------------------------------
WITH furniture_price AS
(SELECT DISTINCT(internal_id), name,buy,sell
FROM housewares h
UNION ALL 
SELECT DISTINCT(internal_id),name, buy,sell
FROM miscellaneous
UNION ALL
SELECT DISTINCT(internal_id),name, buy,sell
FROM wall_mounted
UNION ALL
SELECT DISTINCT(internal_id),name, buy,sell
FROM wallpaper
UNION ALL
SELECT DISTINCT(internal_id),name, buy,sell
FROM rugs
UNION ALL
SELECT DISTINCT(internal_id),name, buy,sell
FROM floors
UNION ALL
SELECT DISTINCT(internal_id),name, buy,sell
FROM ceiling_decor
)
SELECT v.name,v.furniture_id,h.name,h.sell,SUM(h.sell) OVER(PARTITION BY v.name ORDER BY v.name) as sum_furniture
FROM villager_furniture v
JOIN furniture_price h
ON v.furniture_id = CAST(h.internal_id AS TEXT)
ORDER BY sum_furniture DESC

---after closer inspection this is because clothing items that are displayed as furniture 
---are also included in the list, we will have to merge with the lcothing table as well to 
--- include this in the price estimate. 
--------------------
 
WITH furniture_price AS
(SELECT DISTINCT(internal_id), name,buy,sell
FROM housewares h
UNION ALL 
SELECT DISTINCT(internal_id),name, buy,sell
FROM miscellaneous
UNION ALL
SELECT DISTINCT(internal_id),name, buy,sell
FROM wall_mounted
UNION ALL
SELECT DISTINCT(internal_id),name, buy,sell
FROM wallpaper
UNION ALL
SELECT DISTINCT(internal_id),name, buy,sell
FROM rugs
UNION ALL
SELECT DISTINCT(internal_id),name, buy,sell
FROM floors
UNION ALL
SELECT DISTINCT(internal_id),name, buy,sell
FROM ceiling_decor
), villager_price AS
(SELECT v.name,v.furniture_id,h.name,h.sell,SUM(h.sell) OVER(PARTITION BY v.name ORDER BY v.name) as sum_furniture
FROM villager_furniture v
JOIN furniture_price h
ON v.furniture_id = CAST(h.internal_id AS TEXT)
ORDER BY sum_furniture DESC )

SELECT vf.furniture_id,vf.name
FROM villager_price vp
RIGHT JOIN villager_furniture vf
ON vp.furniture_id = vf.furniture_id
WHERE vp.furniture_id IS NULL

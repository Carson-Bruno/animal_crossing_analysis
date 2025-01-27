
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
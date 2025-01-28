---creating new tables---


---villager furniture---

---we need to normalize some of our data in the villagers table
---the furniture list row contains all of the furniture in that villagers house
---we should normalize the data by converting this into another table
---and also add the other furniture from the flooring,wallpaper,workbench,
---and kitchen columns to have a comphrensive table of all of a villagers furniture
---also remove any duplicates before creating final table
DROP TABLE IF EXISTS villager_furniture;
CREATE TABLE villager_furniture AS
(
WITH other_furniture AS
(
SELECT w.internal_id as villager_wall,
v.name,SPLIT_PART(v.diy_workbench,',',1) as work,
SPLIT_PART(v.kitchen_equipment,',',1) as kitchen,
f.internal_id as floor_id,furniture_list
FROM villagers v 
JOIN wallpaper w 
ON v.wallpaper = w.name
JOIN floors f 
ON f.name = v.flooring
),

all_furniture as 
(SELECT name, 
CONCAT(work,';',kitchen,';',villager_wall,';',floor_id,';',furniture_list) as all_list
FROM other_furniture 
ORDER BY name),

villager_furniture AS 
(SELECT name, regexp_split_to_table(all_list,';') as furniture
FROM all_furniture),

row_number AS (
    SELECT *, ROW_NUMBER() OVER(PARTITION BY name, furniture ORDER BY name, furniture) AS RN
    FROM villager_furniture
)

SELECT name,furniture FROM row_number 
WHERE RN=1);


---create furniture items table

---since furniture items from tables such as housewares and wall_mounted can
---contain multiple variations with the same unique id and price,
---we will create a table with unique ids for all items and their associates price
--- from all of our tables containing furniture




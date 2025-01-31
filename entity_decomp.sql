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
SELECT CAST(w.internal_id as TEXT) as villager_wall,
v.name,SPLIT_PART(v.diy_workbench,',',1) as work,
SPLIT_PART(v.kitchen_equipment,',',1) as kitchen,
CAST(f.internal_id as TEXT) as floor_id,
regexp_split_to_table(furniture_list,';')as furniture
FROM villagers v 
JOIN wallpaper w 
ON v.wallpaper = w.name
JOIN floors f 
ON f.name = v.flooring
)

SELECT name, 
UNNEST(ARRAY[work,kitchen,villager_wall,floor_id,furniture]) as furniture_id
FROM other_furniture 
GROUP BY name,furniture_id
ORDER BY name);

---add constraints
ALTER TABLE villager_furniture
ADD PRIMARY KEY(name,furniture);

ALTER TABLE villager_furniture
ADD FOREIGN KEY (name) REFERENCES villagers(name);


---drop furniture items from the villagers table
ALTER TABLE villagers
DROP COLUMN furniture_list,
DROP COLUMN wallpaper,
DROP COLUMN flooring,
DROP COLUMN furniture_name_list,
DROP COLUMN diy_workbench,
DROP COLUMN kitchen_equipment;



---create furniture items table

---since furniture items from tables such as housewares and wall_mounted can
---contain multiple variations with the same unique id and price,
---we will create a table with unique ids for all items and their associates price
---from all of our tables containing furniture

DROP TABLE IF EXISTS all_furniture;
CREATE TABLE all_furniture 
(internal_id INT PRIMARY KEY,
name TEXT,
diy TEXT,
buy INT,
sell INT,
size TEXT,
surface TEXT,
interact TEXT,
tag TEXT,
version_added TEXT
);







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
---contain multiple variations with the same unique id
---we will create a table with unique ids for all items and their characteristics
---from all of our tables containing furniture

DROP TABLE IF EXISTS all_furniture;
CREATE TABLE all_furniture AS
(SELECT DISTINCT(internal_id), 
name,diy, buy,sell, tag,source,season_even as season_event,version_added,exchange_price,exchange_currency,
'housewares' as type_furniture
FROM housewares h
UNION ALL 
SELECT DISTINCT(internal_id), 
name,diy, buy,sell, tag,source,season_event,version_added,exchange_price,exchange_currency,
'miscellaneous' as type_furniture
FROM miscellaneous
UNION ALL
SELECT DISTINCT(internal_id), 
name,diy, buy,sell, tag,source,season_event,version_added,exchange_price,exchange_currency,
'wall_mounted' as type_furniture
FROM wall_mounted
UNION ALL
SELECT DISTINCT(internal_id), 
name,diy, buy,sell, tag,source,season_event,version_added,exchange_price,exchange_currency,
'wallpaper' as type_furniture
FROM wallpaper
UNION ALL
SELECT DISTINCT(internal_id), 
name,diy, buy,sell,tag,source,season_event,version_added,exchange_price,exchange_currency,
'rugs' as type_furniture
FROM rugs
UNION ALL
SELECT DISTINCT(internal_id), 
name,diy, buy,sell,tag,source,season_event,version_added,exchange_price,exchange_currency,
'floors' as type_furniture
FROM floors
UNION ALL
SELECT DISTINCT(internal_id), 
name,diy, buy,sell, tag,source,season_event,version_added,exchange_price,exchange_currency,
'ceiling_decor' as type_furniture
FROM ceiling_decor
);

--- deal with nfs and na values 
UPDATE all_furniture
SET
	buy = NULLIF(buy,'NFS'),
	season_event = NULLIF(season_event,'NA'),
	exchange_price = NULLIF(exchange_price,'NA'),
	exchange_currency = NULLIF(exchange_currency,'NA');
SELECT * FROM all_furniture LIMIT 20;

--- Create a table with hha information for all furniture
DROP TABLE IF EXISTS hha_info;
CREATE TABLE hha_info AS
(SELECT DISTINCT(internal_id), hha_base, hha_concept_1,hha_concept_2, hha_series,hha_set,hha_category
FROM housewares h
UNION ALL 
SELECT DISTINCT(internal_id), hha_base, hha_concept_1,hha_concept_2, hha_series,hha_set,hha_category
FROM miscellaneous
UNION ALL
SELECT DISTINCT(internal_id), hha_base, hha_concept_1,hha_concept_2, hha_series,hha_set,hha_category
FROM wall_mounted
UNION ALL
SELECT DISTINCT(internal_id), hha_base, hha_concept_1,hha_concept_2, hha_series,'None' as hha_set,'None' as hha_category
FROM wallpaper
UNION ALL
SELECT DISTINCT(internal_id), hha_base, hha_concept_1,hha_concept_2, hha_series,'None' as hha_set,'None' as hha_category
FROM rugs
UNION ALL
SELECT DISTINCT(internal_id), hha_base, hha_concept_1,hha_concept_2, hha_series,'None' as hha_set,'None' as hha_category
FROM floors
UNION ALL
SELECT DISTINCT(internal_id), hha_base, hha_concept_1,hha_concept_2, hha_series,hha_set,hha_category
FROM ceiling_decor
)
--- deal with none values 
UPDATE hha_info 
SET 
    hha_concept_2 = NULLIF(hha_concept_2, 'None'),
    hha_series = NULLIF(hha_series, 'None'),
    hha_set = NULLIF(hha_set, 'None'),
    hha_category = NULLIF(hha_category, 'None');

SELECT * FROM hha_info LIMIT 5;

---TO-DO
-----create constraints on tables 
-----create variation tables from original furniture tables
-----create masterlist and variations for clothing




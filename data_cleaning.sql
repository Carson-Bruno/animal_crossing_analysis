---Data cleaning---

---any image data was turned to nulls in converting to csvs,
---we can remove these from all of our datasets

ALTER TABLE housewares DROP COLUMN image;

ALTER TABLE floors DROP COLUMN image;

ALTER TABLE ceiling_decor DROP COLUMN image;

ALTER TABLE rugs DROP COLUMN image;

ALTER TABLE wall_mounted DROP COLUMN image;

ALTER TABLE wallpaper DROP COLUMN image;

ALTER TABLE miscellaneous DROP COLUMN image;

ALTER TABLE villagers 
DROP COLUMN icon,
DROP COLUMN photo,
DROP COLUMN house;

ALTER TABLE tops
DROP COLUMN closet,
DROP COLUMN storage;

ALTER TABLE bottoms
DROP COLUMN closet,
DROP COLUMN storage;

ALTER TABLE dress_up
DROP COLUMN closet,
DROP COLUMN storage;

ALTER TABLE headwear
DROP COLUMN closet,
DROP COLUMN storage;

ALTER TABLE accesories
DROP COLUMN closet,
DROP COLUMN storage;

ALTER TABLE socks
DROP COLUMN closet,
DROP COLUMN storage;

ALTER TABLE shoes
DROP COLUMN closet,
DROP COLUMN storage;

ALTER TABLE bags
DROP COLUMN closet,
DROP COLUMN storage;

ALTER TABLE clothing_other
DROP COLUMN closet,
DROP COLUMN storage;

ALTER TABLE umbrellas
DROP COLUMN storage;




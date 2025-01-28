---Data cleaning---

---any image data was turned to nulls in converting to csvs,
---we can remove these from all of our datasets

ALTER TABLE housewares DROP COLUMN image;
ALTER TABLE floors DROP COLUMN image;
ALTER TABLE ceiling_decor DROP COLUMN image;
ALTER TABLE rugs DROP COLUMN image;
ALTER TABLE wall_mounted DROP COLUMN image;
ALTER TABLE wallpaper DROP COLUMN image;

---next let's convert values coded as 'NA','None',or 'NFS' to null
SELECT * FROM ceiling_decor LIMIT 20;

UPDATE ceiling_decor 
SET
pattern = NULLIF(pattern,'NA'),
pattern_title = NULLIF(pattern_title,'NA'),
pattern_customize_options = NULLIF(pattern_customize_options,'NA'),
kit_cost = NULLIF(kit_cost,'NA'),
pattern_title = NULLIF(pattern_title,'NA'),
kit_type = NULLIF(kit_type,'None'),
buy = NULLIF(buy,'NFS'),
exchange_price = NULLIF(exchange_price,'NA'),
exchange_currency = NULLIF(exchange_currency,'NA'),
season_event = NULLIF(season_event,'NA'),
season_event_exclusive = NULLIF(season_event_exclusive,'NA'),
hha_series = NULLIF(hha_series,'NA'),


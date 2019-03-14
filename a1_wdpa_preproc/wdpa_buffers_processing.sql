--CREATE OVER 20 TABLE SINGLE PART
CREATE TABLE :vSCHEMA.wdpa_o20_geog AS 
WITH
single_part AS (
SELECT
wdpaid,
(ST_Dump(geom)).path[1] id,
(ST_Dump(geom)).geom geom
FROM
:vSCHEMA.wdpa_:vDATE
WHERE area_geo >= 20 and type NOT IN ('Point')
)
SELECT
wdpaid,
id,
geom::geography(Polygon) geog
FROM single_part;
ALTER TABLE :vSCHEMA.wdpa_o20_geog
ADD PRIMARY KEY (wdpaid,id);
CREATE INDEX wdpa_o20_geog_idx ON :vSCHEMA.wdpa_o20_geog USING gist (geog);

--CREATE 10km buffers
CREATE TABLE :vSCHEMA.wdpa_o20_geog_buffers AS 
SELECT
wdpaid,
id,
(ST_Buffer(geog,10000)) geog
FROM :vSCHEMA.wdpa_o20_geog;
ALTER TABLE :vSCHEMA.wdpa_o20_geog_buffers
ADD PRIMARY KEY (wdpaid,id);
CREATE INDEX wdpa_o20_geog_buffers_idx ON :vSCHEMA.wdpa_o20_geog_buffers USING gist (geog);

--SELECT AND MARK BUFFERS NON INTERSECTING ANTIMERIDIAN
CREATE TABLE :vSCHEMA.wdpa_o20_geog_buffers_not_intersecting AS
WITH discarded AS (
SELECT DISTINCT
wdpaid,
ST_INTERSECTS(geog, ST_GeogFromText('LINESTRING(180 90, 180 0, 180 -90)')) intersection
FROM :vSCHEMA.wdpa_o20_geog_buffers
WHERE ST_INTERSECTS(geog, ST_GeogFromText('LINESTRING(180 -90, 180 0, 180 90)')) IS true)
SELECT
wdpaid,
id,
geog::geometry geom
FROM :vSCHEMA.wdpa_o20_geog_buffers
WHERE wdpaid NOT IN (SELECT wdpaid FROM discarded)
ORDER BY wdpaid,id;
ALTER TABLE :vSCHEMA.wdpa_o20_geog_buffers_not_intersecting
ADD PRIMARY KEY (wdpaid,id),
ADD COLUMN valid_geom boolean,
ALTER COLUMN geom SET DATA TYPE geometry(MultiPolygon) USING ST_Multi(geom);
SELECT UpdateGeometrySRID(:'vSCHEMA', 'wdpa_o20_geog_buffers_not_intersecting', 'geom', 4326);
CREATE INDEX wdpa_o20_geog_buffers_not_intersecting_idx ON :vSCHEMA.wdpa_o20_geog_buffers_not_intersecting USING gist (geom);

-- MARK NOT VALID BUFFERS
UPDATE :vSCHEMA.wdpa_o20_geog_buffers_not_intersecting
SET valid_geom = ST_ISValid(geom);
-- CHECK IF THERE ARE NOT VALID GEOMS
SELECT DISTINCT valid_geom FROM :vSCHEMA.wdpa_o20_geog_buffers_not_intersecting;
-- FIX NOT VALID BUFFERS IF NEEDED AND UPDATE valid_geom
UPDATE :vSCHEMA.wdpa_o20_geog_buffers_not_intersecting
SET geom = ST_MakeValid(geom)
WHERE valid_geom IS false;
-- RE-CHECK NOT VALID BUFFERS IF NEEDED
UPDATE :vSCHEMA.wdpa_o20_geog_buffers_not_intersecting
SET valid_geom = ST_ISValid(geom);

-- AGGREGATE NOT INTERSECTING BUFFERS BY WDPAID
DROP TABLE IF EXISTS :vSCHEMA.wdpa_o20_geog_buffers_not_intersecting_unique ;
CREATE TABLE :vSCHEMA.wdpa_o20_geog_buffers_not_intersecting_unique AS
SELECT
wdpaid,
ST_Union(geom) geom
FROM :vSCHEMA.wdpa_o20_geog_buffers_not_intersecting
GROUP BY wdpaid;
ALTER TABLE :vSCHEMA.wdpa_o20_geog_buffers_not_intersecting_unique
ADD PRIMARY KEY (wdpaid),
ADD COLUMN valid_geom boolean,
ALTER COLUMN geom SET DATA TYPE geometry(MultiPolygon) USING ST_Multi(geom);
SELECT UpdateGeometrySRID(:'vSCHEMA', 'wdpa_o20_geog_buffers_not_intersecting_unique', 'geom', 4326);
CREATE INDEX wdpa_o20_geog_buffers_not_intersecting_unique_idx ON :vSCHEMA.wdpa_o20_geog_buffers_not_intersecting_unique USING gist (geom);
UPDATE :vSCHEMA.wdpa_o20_geog_buffers_not_intersecting_unique
SET valid_geom = ST_ISValid(geom);

--SELECT AND SHIFT WDPA OF INTERSECTING BUFFERS WITH ANTIMERIDIAN
CREATE TABLE :vSCHEMA.wdpa_o20_geog_intersecting_shifted AS
WITH discarded AS (
SELECT DISTINCT
wdpaid
FROM :vSCHEMA.wdpa_o20_geog_buffers
WHERE ST_INTERSECTS(geog, ST_GeogFromText('LINESTRING(180 -90, 180 0, 180 90)')) IS true)
SELECT
wdpaid,
id,
(ST_Translate(geog::geometry, +180, 0))::geography as geog
FROM :vSCHEMA.wdpa_o20_geog
WHERE wdpaid IN (SELECT DISTINCT wdpaid FROM discarded)
ORDER BY wdpaid,id;
ALTER TABLE :vSCHEMA.wdpa_o20_geog_intersecting_shifted
ADD PRIMARY KEY (wdpaid,id);
CREATE INDEX wdpa_o20_geog_intersecting_shifted_idx ON :vSCHEMA.wdpa_o20_geog_intersecting_shifted USING gist (geog);

-- CREATE INTERSECTING SHIFTED BUFFERS GEOG
CREATE TABLE :vSCHEMA.wdpa_o20_geog_intersecting_shifted_buffers AS 
SELECT
wdpaid,
id,
(ST_Buffer(geog,20000)) geog
FROM :vSCHEMA.wdpa_o20_geog_intersecting_shifted;
ALTER TABLE :vSCHEMA.wdpa_o20_geog_intersecting_shifted_buffers
ADD PRIMARY KEY (wdpaid,id);
CREATE INDEX wdpa_o20_geog_intersecting_shifted_buffers_idx ON :vSCHEMA.wdpa_o20_geog_intersecting_shifted_buffers USING gist (geog);

-- SPLIT SHIFTED INTERSECTING BUFFERS at 0
CREATE TABLE :vSCHEMA.wdpa_o20_geog_intersecting_shifted_buffers_split AS 
SELECT
wdpaid,
id,
ST_Split(geog::geometry, ST_GeomFromText('LINESTRING(0 -90, 0 90)',4326)) geom
FROM :vSCHEMA.wdpa_o20_geog_intersecting_shifted_buffers;
CREATE INDEX wdpa_o20_geog_intersecting_shifted_buffers_split_idx ON :vSCHEMA.wdpa_o20_geog_intersecting_shifted_buffers_split USING gist (geom);

-- DUMP SPLIT SHIFTED INTERSECTING BUFFERS
CREATE TABLE :vSCHEMA.wdpa_o20_geog_intersecting_shifted_buffers_split_dump AS 
SELECT
wdpaid,
(ST_Dump(geom)).path[1] id,
(ST_Dump(geom)).geom geom
FROM :vSCHEMA.wdpa_o20_geog_intersecting_shifted_buffers_split;
CREATE INDEX wdpa_o20_geog_intersecting_shifted_buffers_split_dump_idx ON :vSCHEMA.wdpa_o20_geog_intersecting_shifted_buffers_split_dump USING gist (geom);

-- SHIFT BACK BUFFERS
CREATE TABLE :vSCHEMA.wdpa_o20_geog_intersecting_buffers_split_dump AS
SELECT
wdpaid,
id,
CASE WHEN ST_XMAX(geom) > 0
THEN
ST_Translate(geom, -180, 0)
ELSE
ST_Translate(geom, 180, 0)
END AS geom
FROM :vSCHEMA.wdpa_o20_geog_intersecting_shifted_buffers_split_dump;

-- FIXES AND CHECK TO INTERSECTING BUFFERS geometry type
ALTER TABLE :vSCHEMA.wdpa_o20_geog_intersecting_buffers_split_dump
ADD COLUMN valid_geom boolean,
ALTER COLUMN geom SET DATA TYPE geometry(MultiPolygon) USING ST_Multi(geom);
SELECT UpdateGeometrySRID(:'vSCHEMA', 'wdpa_o20_geog_intersecting_buffers_split_dump', 'geom', 4326);
CREATE INDEX wdpa_o20_geog_intersecting_buffers_split_dump_idx ON :vSCHEMA.wdpa_o20_geog_intersecting_buffers_split_dump USING gist (geom);
--MARK NOT VALID BUFFERS
UPDATE :vSCHEMA.wdpa_o20_geog_intersecting_buffers_split_dump
SET valid_geom = ST_ISValid(geom);
--CHECK IF THERE ARE NOT VALID GEOMS
SELECT DISTINCT valid_geom FROM :vSCHEMA.wdpa_o20_geog_intersecting_buffers_split_dump;

--AGGREGATE INTERSECTING BUFFERS BY WDPAID
CREATE TABLE :vSCHEMA.wdpa_o20_geog_buffers_intersecting_unique AS
SELECT
wdpaid,
ST_Union(geom) geom
FROM :vSCHEMA.wdpa_o20_geog_intersecting_buffers_split_dump
GROUP BY wdpaid;
ALTER TABLE :vSCHEMA.wdpa_o20_geog_buffers_intersecting_unique
ADD PRIMARY KEY (wdpaid),
ADD COLUMN valid_geom boolean,
ALTER COLUMN geom SET DATA TYPE geometry(MultiPolygon) USING ST_Multi(geom);
SELECT UpdateGeometrySRID(:'vSCHEMA', 'wdpa_o20_geog_buffers_intersecting_unique', 'geom', 4326);
CREATE INDEX wdpa_o20_geog_buffers_intersecting_unique_idx ON :vSCHEMA.wdpa_o20_geog_buffers_intersecting_unique USING gist (geom);
UPDATE :vSCHEMA.wdpa_o20_geog_buffers_intersecting_unique
SET valid_geom = ST_ISValid(geom);

-- UNION BUFFERS
CREATE TABLE :vSCHEMA.wdpa_o20_buffers AS
SELECT
wdpaid,
geom,
valid_geom
FROM :vSCHEMA.wdpa_o20_geog_buffers_not_intersecting_unique
UNION
SELECT
wdpaid,
geom,
valid_geom
FROM :vSCHEMA.wdpa_o20_geog_buffers_intersecting_unique
ORDER BY wdpaid;
ALTER TABLE :vSCHEMA.wdpa_o20_buffers
ADD PRIMARY KEY (wdpaid),
ALTER COLUMN geom SET DATA TYPE geometry(MultiPolygon) USING ST_Multi(geom);
 
SELECT UpdateGeometrySRID(:'vSCHEMA', 'wdpa_o20_buffers', 'geom', 4326);

ALTER TABLE :vSCHEMA.wdpa_o20_buffers RENAME TO wdpa_o20_buffers_:vDATE;

CREATE INDEX wdpa_o20_buffers_idx_:vDATE ON :vSCHEMA.wdpa_o20_buffers_:vDATE USING gist (geom);

--DATA CLEAN-UP (remove intermediate steps)
DROP TABLE IF EXISTS :vSCHEMA.wdpa_o20_geog;
DROP TABLE IF EXISTS :vSCHEMA.wdpa_o20_geog_buffers;
DROP TABLE IF EXISTS :vSCHEMA.wdpa_o20_geog_buffers_intersecting_unique;
DROP TABLE IF EXISTS :vSCHEMA.wdpa_o20_geog_buffers_not_intersecting;
DROP TABLE IF EXISTS :vSCHEMA.wdpa_o20_geog_buffers_not_intersecting_unique;
DROP TABLE IF EXISTS :vSCHEMA.wdpa_o20_geog_intersecting_buffers_split_dump;
DROP TABLE IF EXISTS :vSCHEMA.wdpa_o20_geog_intersecting_shifted;
DROP TABLE IF EXISTS :vSCHEMA.wdpa_o20_geog_intersecting_shifted_buffers;
DROP TABLE IF EXISTS :vSCHEMA.wdpa_o20_geog_intersecting_shifted_buffers_split;
DROP TABLE IF EXISTS :vSCHEMA.wdpa_o20_geog_intersecting_shifted_buffers_split_dump;

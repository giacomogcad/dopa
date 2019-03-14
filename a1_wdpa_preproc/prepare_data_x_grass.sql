-- CREATE SCHEMAS for PA and BU
-- pa
CREATE SCHEMA IF NOT EXISTS :paschema;
GRANT ALL ON SCHEMA :paschema TO h05ibex;
GRANT USAGE ON SCHEMA :paschema TO h05ibexro;
-- bu
CREATE SCHEMA IF NOT EXISTS :buschema;
GRANT ALL ON SCHEMA :buschema TO h05ibex;
GRANT USAGE ON SCHEMA :buschema TO h05ibexro;


-- CREATE TABLES WITH LIST OF PAs and BUs (All, only terrestrial and coastal, only marine)
CREATE TABLE :paschema.list_pa AS
SELECT 'pa_'||wdpaid::text gname
FROM :wdpaschema.wdpa_o20_:vDATE
ORDER BY wdpaid;

CREATE TABLE :paschema.list_pa_tc AS
SELECT 'pa_'||a.wdpaid::text gname
FROM :wdpaschema.wdpa_o20_:vDATE a
LEFT JOIN :wdpaschema.wdpa_:vDATE b ON a.wdpaid=b.wdpaid
WHERE b.marine NOT IN (2)
ORDER BY a.wdpaid;

CREATE TABLE :paschema.list_pa_ma AS
SELECT 'pa_'||a.wdpaid::text gname
FROM :wdpaschema.wdpa_o20_:vDATE a
LEFT JOIN :wdpaschema.wdpa_:vDATE b ON a.wdpaid=b.wdpaid
WHERE b.marine IN (2)
ORDER BY a.wdpaid;

CREATE TABLE :buschema.list_bu AS
SELECT 'bu_'||wdpaid::text gname
FROM :wdpaschema.wdpa_o20_buffers_:vDATE
ORDER BY wdpaid;

CREATE TABLE :buschema.list_bu_tc AS
SELECT 'bu_'||a.wdpaid::text gname
FROM :wdpaschema.wdpa_o20_buffers_:vDATE a
LEFT JOIN :wdpaschema.wdpa_o20_:vDATE b ON a.wdpaid=b.wdpaid
WHERE b.marine NOT IN (2)
ORDER BY a.wdpaid;

CREATE TABLE :buschema.list_bu_ma AS
SELECT 'bu_'||a.wdpaid::text gname
FROM :wdpaschema.wdpa_o20_buffers_:vDATE a
LEFT JOIN :wdpaschema.wdpa_o20_:vDATE b ON a.wdpaid=b.wdpaid
WHERE b.marine IN (2)
ORDER BY a.wdpaid;

# WDPA Pre-processing workflow

The workflow herewith described refers to WDPA data pre-processing. It covers all steps required to have a GRASS database ready for subsequent analysis fo raster datasets.
Namely, it covers the following steps:

## 1. WDPA data import (`exec_wdpa_preprocessing.sh` and its slave `wdpa_full_preprocessing.sql`)
1.1 Imports in PG database relevant WDPA data: access the downloaded .zip file, imports attributes and geometries of points and polygons in three distinct tables of PG database.
	Objects are filtered as follows:
	* points: `STATUS NOT IN ('Not Reported', 'Proposed') And DESIG_ENG NOT IN ('UNESCO-MAB Biosphere Reserve') And REP_AREA > 0`
	* polygons: `STATUS NOT IN ('Not Reported', 'Proposed') And DESIG_ENG NOT IN ('UNESCO-MAB Biosphere Reserve')  And WDPAID NOT IN (903141)`
	N.B.: from February 2018: wdpaid 903141 (Primeval Beech Forests of the Carpathians and Other Regions of Europe) is excluded from all the analysis.
1.2 Buffering of point PAs. Buffer radius is computed from the 'rep_area' field.
1.3 Flagging invalid geometries and repairing them with ST_MakeValid.
1.4 Creation of final wdpa table with attributes and wdpa_o20 (>20 sq.km.) table.

## 2. Creation of 10 km buffers (`exec_buffers_processing.sh` and its slave `wdpa_buffers_processing.sql`)
2.1 Computes buffers on all features.
2.2 Selects buffers intersecting anti-meridian, shift corresponding PAs, recompute buffers and shift them back.
2.3 Creates the final buffers table.

## 3. Data preparation for GRASS (`exec_prepare_data_x_grass.sh` and its slave `prepare_data_x_grass.sql`)
3.1 Creates necessary schemes for PAs and buffers.
3.2 Creates PAs and buffers lists (full list, only terrestrial and coastal, only marine) as text files, for later use in GRASS analysis loops.
3.3 Creates individual views for each PA and for each Buffer.
N.B. the iteration has been moved to the bash side (FOR cycle) because of the impossibility to pass a variable from bash to a function in PL/pgsql.
The cycle in bash is much slower (about 2 hours to create about 32000 pas and 32000 buffers views, against a couple of minutes in PL/pgsql).

## 3. Creation of wdpa_flat (`exec_make_flat.sh` and its slave `slave_make_flat.sh`)
3.1 Import in GRASS database the whole WDPA dataset, without attributes table.
3.2 Running in parallel on 32 different regions, converts to raster the vector WDPA at 3 arc-seconds resolution (about 90m).
3.3 Using r.patch, mosaic the 32 raster tiles into a single raster layer.

## 5. Data transfer from PG to GRASS (`exec_pg_to_grass.sh` and its slave `slave_pg_to_grass.sh`)
5.1 Iterates views of PAs and buffers to export each view in shapefile with pgsql2shp.
5.2	Imports individual shapefiles of PAs in GRASS database using v.in.ogr.
5.3 Import and process individual shapefiles of BUs: buffers are erased with wdpa_flat in order to keep only their unprotected portion.
N.B. direct import in GRASS of PG views with v.in.ogr randomly fails on about 20% of views for unknown reasons (error message: Segmentation fault).

## 6. reprojection in Mollweide of individual PAs and BUs layers (`exec_project_pa_bu.sh` and its slave `project_pa_bu.sh`)
6.1 Iterates vector layers in GRASS database (WGS84LL location) of PAs and buffers and reproject them in Mollweide. Results are stored into MOLLWEIDE location.

## 7. import as external link of all rasters required for subsequent analysis (`exec_link_rasters.sh` and its slaves `link_rasters_wgs84ll.sh`, `link_rasters_mollweide.sh` and `link_rasters_sst.sh) 
7.1 All rasters to be analysed for computation of indicators have been grouped in two major categories:
    * categorical rasters: raster representing classes, such as Land Cover, Built up, etc. For those rasters, the area of each class within each PA needs to be calculated. Therefore, rasters datasets distributed in LatLong need to be previously reprojected in Mollweide in order to compute equivalent areas.
    * continuous rasters: raster representing continuous values such as elevation, temperature, etc. For those rasters, standard statistics for each PA need to be computed. Therefore, such raster can be analysed in their native projection.
    Such rasters are imported in two different mapsets according to  type:
		- mapset CATRASTERS is used for categorical rasters
		- mapset CONRASTERS is used for continous rasters

    Depending on the tool used for analysis, rasters are imported in Wgs84ll (for continuous rasters) or in Mollweide (for categorical rasters) projection, using the relevant location in the GRASS database.

### Prerequisites
In order to run successfully, the workflow requires the followings:
1. a PostgreSQL database with Postgis extension must exist
2. a GRASS database with two locations (one in latlong and one in Mollweide) must exist.

### Notes
- All parameters used by scripts are stored in the configuration file **wdpa_preprocessing.conf**. It has to be checked/edited before running the scripts.
- Total running time on dopaprc (using NCORES=40 for step 4) is approximately 15 hours.
- Using  values of NCORES higher than 40 may give incomplete results. In a test done using 64 cores, FATAL errors of pgsql2shp came out (too many connections). With 40 cores no error messages were obtained.


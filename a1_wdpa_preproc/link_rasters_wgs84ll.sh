#!/bin/bash
# set variables
ORIGDATA=$1
DATAGFC=$2
DERIVDATA=$3

# LINK RASTERS IN WGS84LL

## Create mapsets and grant access
g.mapset --q -c --overwrite mapset=CATRASTERS
g.mapset --q -c --overwrite mapset=CONRASTERS

## Import external continuous rasters (with r.external analysis fails, NoData value not acknowledged)

## WORLDCLIM
r.external --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_prec/wc2.0_30s_prec_01.tif" output="worldclim_prec_01"
r.external --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_prec/wc2.0_30s_prec_02.tif" output="worldclim_prec_02"
r.external --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_prec/wc2.0_30s_prec_03.tif" output="worldclim_prec_03"
r.external --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_prec/wc2.0_30s_prec_04.tif" output="worldclim_prec_04"
r.external --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_prec/wc2.0_30s_prec_05.tif" output="worldclim_prec_05"
r.external --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_prec/wc2.0_30s_prec_06.tif" output="worldclim_prec_06"
r.external --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_prec/wc2.0_30s_prec_07.tif" output="worldclim_prec_07"
r.external --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_prec/wc2.0_30s_prec_08.tif" output="worldclim_prec_08"
r.external --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_prec/wc2.0_30s_prec_09.tif" output="worldclim_prec_09"
r.external --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_prec/wc2.0_30s_prec_10.tif" output="worldclim_prec_10"
r.external --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_prec/wc2.0_30s_prec_11.tif" output="worldclim_prec_11"
r.external --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_prec/wc2.0_30s_prec_12.tif" output="worldclim_prec_12"

r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tavg/wc2.0_30s_tavg_01.tif" output="worldclim_tavg_01" memory=1024
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tavg/wc2.0_30s_tavg_02.tif" output="worldclim_tavg_02" memory=1024
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tavg/wc2.0_30s_tavg_03.tif" output="worldclim_tavg_03" memory=1024
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tavg/wc2.0_30s_tavg_04.tif" output="worldclim_tavg_04" memory=1024
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tavg/wc2.0_30s_tavg_05.tif" output="worldclim_tavg_05" memory=1024
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tavg/wc2.0_30s_tavg_06.tif" output="worldclim_tavg_06" memory=1024
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tavg/wc2.0_30s_tavg_07.tif" output="worldclim_tavg_07" memory=1024
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tavg/wc2.0_30s_tavg_08.tif" output="worldclim_tavg_08" memory=1024
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tavg/wc2.0_30s_tavg_09.tif" output="worldclim_tavg_09" memory=1024
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tavg/wc2.0_30s_tavg_10.tif" output="worldclim_tavg_10" memory=1024
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tavg/wc2.0_30s_tavg_11.tif" output="worldclim_tavg_11" memory=1024
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tavg/wc2.0_30s_tavg_12.tif" output="worldclim_tavg_12" memory=1024

r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tmax/wc2.0_30s_tmax_01.tif" output="worldclim_tmax_01" memory=1024
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tmax/wc2.0_30s_tmax_02.tif" output="worldclim_tmax_02" memory=1024
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tmax/wc2.0_30s_tmax_03.tif" output="worldclim_tmax_03" memory=1024
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tmax/wc2.0_30s_tmax_04.tif" output="worldclim_tmax_04" memory=1024
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tmax/wc2.0_30s_tmax_05.tif" output="worldclim_tmax_05" memory=1024
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tmax/wc2.0_30s_tmax_06.tif" output="worldclim_tmax_06" memory=1024
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tmax/wc2.0_30s_tmax_07.tif" output="worldclim_tmax_07" memory=1024
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tmax/wc2.0_30s_tmax_08.tif" output="worldclim_tmax_08" memory=1024
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tmax/wc2.0_30s_tmax_09.tif" output="worldclim_tmax_09" memory=1024
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tmax/wc2.0_30s_tmax_10.tif" output="worldclim_tmax_10" memory=1024
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tmax/wc2.0_30s_tmax_11.tif" output="worldclim_tmax_11" memory=1024
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tmax/wc2.0_30s_tmax_12.tif" output="worldclim_tmax_12" memory=1024

r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tmin/wc2.0_30s_tmin_01.tif" output="worldclim_tmin_01" memory=1024
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tmin/wc2.0_30s_tmin_02.tif" output="worldclim_tmin_02" memory=1024
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tmin/wc2.0_30s_tmin_03.tif" output="worldclim_tmin_03" memory=1024
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tmin/wc2.0_30s_tmin_04.tif" output="worldclim_tmin_04" memory=1024
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tmin/wc2.0_30s_tmin_05.tif" output="worldclim_tmin_05" memory=1024
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tmin/wc2.0_30s_tmin_06.tif" output="worldclim_tmin_06" memory=1024
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tmin/wc2.0_30s_tmin_07.tif" output="worldclim_tmin_07" memory=1024
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tmin/wc2.0_30s_tmin_08.tif" output="worldclim_tmin_08" memory=1024
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tmin/wc2.0_30s_tmin_09.tif" output="worldclim_tmin_09" memory=1024
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tmin/wc2.0_30s_tmin_10.tif" output="worldclim_tmin_10" memory=1024
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tmin/wc2.0_30s_tmin_11.tif" output="worldclim_tmin_11" memory=1024
r.import --overwrite input=${ORIGDATA}"/WORLDCLIM/uncompressed/D_30_seconds/wc2.0_30s_tmin/wc2.0_30s_tmin_12.tif" output="worldclim_tmin_12" memory=1024

## GEBCO
r.external --overwrite input=${ORIGDATA}"/GEBCO/uncompressed/TIF/GRID/gebco.vrt" output="gebco"

## CROPLAND2005
r.external --overwrite input=${ORIGDATA}"/CROPLAND2005/uncompressed/cropland_hybrid_10042015v9/Hybrid_10042015v9.img" output="cropland2005"

## GLOBAL FOREST CHANGE - TREECOVER
r.external --overwrite input=${DATAGFC}"/GFC_2000_2016/Hansen_GFC-2016-v14_treecover.vrt" output="gfc_treecover"
r.external --overwrite input=${DATAGFC}"/GFC_2000_2016/Hansen_GFC-2016-v14_treecover_over30.vrt" output="gfc_treecover_over30"

## GLOBAL SOIL ORGANIC CARBON
r.external --overwrite input=${ORIGDATA}"/GSOC/uncompressed/GSOCmapV1.2.0.tif" output="GSOCmapV1"

## Link external categorical rasters (mapset=CATRASTERS)

## CEP (gaul_eez+ecoregions+flat)
g.mapset --q mapset=CATRASTERS
r.external --overwrite input=${DERIVDATA}"/DOPA_PROCESSING_2018/cep.tif" output="cep"

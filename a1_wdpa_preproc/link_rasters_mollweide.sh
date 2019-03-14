#!/bin/bash
# LINK RASTERS IN MOLLWEIDE (to be run in MOLLWEIDE location)

# set variables
DATAMOLL=$1
DATAGHS=$2
DATAGROADS=$3

## Create mapsets and grant access
g.mapset --q -c --overwrite mapset=CONRASTERS
g.mapset --q -c --overwrite mapset=CATRASTERS

## Link external categorical rasters (mapset=CATRASTERS)

##ESA-CCI LAND COVER
r.external --overwrite input=${DATAMOLL}"/ESA-CCI/ESACCI-LC-L4-LCCS-Map-300m-P1Y-1995-v2.0.7.tif" output="esalc_1995"
r.external --overwrite input=${DATAMOLL}"/ESA-CCI/ESACCI-LC-L4-LCCS-Map-300m-P1Y-2000-v2.0.7.tif" output="esalc_2000"
r.external --overwrite input=${DATAMOLL}"/ESA-CCI/ESACCI-LC-L4-LCCS-Map-300m-P1Y-2005-v2.0.7.tif" output="esalc_2005"
r.external --overwrite input=${DATAMOLL}"/ESA-CCI/ESACCI-LC-L4-LCCS-Map-300m-P1Y-2010-v2.0.7.tif" output="esalc_2010"
r.external --overwrite input=${DATAMOLL}"/ESA-CCI/ESACCI-LC-L4-LCCS-Map-300m-P1Y-2015-v2.0.7.tif" output="esalc_2015"

##LANDSCAPE FRAGMENTATION (MSPA)
r.external --overwrite input=${DATAMOLL}"/MSPA_LC/CCI_SPA_1995_2015/CCI1995_spa6.tif" output="mspa_lc_1995"
r.external --overwrite input=${DATAMOLL}"/MSPA_LC/CCI_SPA_1995_2015/CCI2000_spa6.tif" output="mspa_lc_2000"
r.external --overwrite input=${DATAMOLL}"/MSPA_LC/CCI_SPA_1995_2015/CCI2005_spa6.tif" output="mspa_lc_2005"
r.external --overwrite input=${DATAMOLL}"/MSPA_LC/CCI_SPA_1995_2015/CCI2010_spa6.tif" output="mspa_lc_2010"
r.external --overwrite input=${DATAMOLL}"/MSPA_LC/CCI_SPA_1995_2015/CCI2015_spa6.tif" output="mspa_lc_2015"

## GLOBAL FOREST CHANGE - GAIN AND LOSSYEAR
r.external --overwrite input=${DATAMOLL}"/GFC_2000_2016/Hansen_GFC-2016-v14_gain.vrt" output="gfc_gain"
r.external --overwrite input=${DATAMOLL}"/GFC_2000_2016/Hansen_GFC-2016-v14_lossyear.vrt" output="gfc_lossyear"

## GLOBAL SURFACE WATER
r.external --overwrite input=${DATAMOLL}"/GSW/gsw.vrt" output="gsw_transitions"

## BUILT UP AREAS
r.external --overwrite input=${DATAMOLL}"/GHS_BUILT_LDSMT_MOLL/MT_2017_B.vrt" output="ghs_built"

## LPD 945 m
r.external --overwrite input=${DATAMOLL}"/RESTRICTED_LPD/LPD.tif" output="lpd"


## Link external continuous rasters in Mollweide  (mapset=CONRASTERS)

g.mapset --q mapset=CONRASTERS

## GHS_POP
r.external --overwrite input=${DATAGHS}"/GHS_POP_GPW41975_GLOBE_R2015A_54009_1k_v1_0/GHS_POP_GPW41975_GLOBE_R2015A_54009_1k_v1_0.tif" output="ghs_pop_1975"
r.external --overwrite input=${DATAGHS}"/GHS_POP_GPW41990_GLOBE_R2015A_54009_1k_v1_0/GHS_POP_GPW41990_GLOBE_R2015A_54009_1k_v1_0.tif" output="ghs_pop_1990"
r.external --overwrite input=${DATAGHS}"/GHS_POP_GPW42000_GLOBE_R2015A_54009_1k_v1_0/GHS_POP_GPW42000_GLOBE_R2015A_54009_1k_v1_0.tif" output="ghs_pop_2000"
r.external --overwrite input=${DATAGHS}"/GHS_POP_GPW42015_GLOBE_R2015A_54009_1k_v1_0/GHS_POP_GPW42015_GLOBE_R2015A_54009_1k_v1_0.tif" output="ghs_pop_2015"

## gROADS Buffers 250 m
r.external --overwrite input=${DATAGROADS}"/groads_buffer_250m_moll.tif" output="groads"

## GLOBAL SOIL ORGANIC CARBON
r.external --overwrite input=${DATAMOLL}"/GSOC/GSOCmapV1.tif" output="GSOCmapV1"

exit

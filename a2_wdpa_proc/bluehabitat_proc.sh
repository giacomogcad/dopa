#!/bin/bash

echo " "
echo "---------------------------------------------------"
echo "- Script $(basename "$0") started at $(date)"
echo " "

## READ VARIABLES FROM CONFIGURATION FILE
SERVICEDIR="/globes/PROCESSING/WDPA/scripts/a0_servicefiles"
source ${SERVICEDIR}/wdpa_processing.conf

## Derived variables
LOCATION_LL_PATH=${DATABASE}/${LOCATION_LL}
PERMANENT_LL_MAPSET=${DATABASE}/${LOCATION_LL}"/PERMANENT"
PA_LL_MAPSET_PATH=${DATABASE}/${LOCATION_LL}/${PA_MAPSET}
BU_LL_MAPSET_PATH=${DATABASE}/${LOCATION_LL}/${BU_MAPSET}

BLUEMAPSET="BLUEHABITAT"
BLUEMAPSET_PATH_LL=${DATABASE}/${LOCATION_LL}/${BLUEMAPSET}
BASELAYERS_PATH="/globes/USERS/GIACOMO/DERIVED_DATASETS/WGS84LL/BLUEHABITAT"
SHPDIR="/spatial_data/Original_Datasets/BLUEHABITATS/uncompressed/global seafloor geomorphic features map"
REEFDIR="/spatial_data/Original_Datasets/BLUEHABITATS/uncompressed/reefs_at_risk_revisited_base_data/Base_Data/Reefs"
PA_LIST_FILE=${SERVICEDIR}/${pa_ma_list}.txt

baselyrs="Shelf
Slope
Abyss
Hadal
"
a=0
bl_list=`echo ${baselyrs,,}|awk -v OFS="," '$1=$1'`

# MAKE LIST OFGEOMORPHIC FEATURES TO BE USED FOR ANALYSIS - TO BE EDITED!!!
features="Escarpments
Canyons
Guyots
Seamounts
Ridges
"

# ## FIRST PART: IMPORT AND PREPROCESS BLUEHABITAT LAYERS 

# # IMPORT, CONVERT TO RASTER AND PATCH BASE LAYERS
# for lyr in ${baselyrs}
# do
	# echo "------------------------------"
	# echo "Importing ${lyr} ..."
	# lcaselyr=${lyr,,}
	# a=$((a + 1))
	# echo ${a}
	# grass ${BLUEMAPSET_PATH_LL} --exec v.in.ogr --quiet --overwrite -o  input="${SHPDIR}"/${lyr}.shp output=${lcaselyr}
	# grass ${BLUEMAPSET_PATH_LL} --exec g.region raster=wdpa_flat@WDPA res=0:00:30 -p
	# grass ${BLUEMAPSET_PATH_LL} --exec v.to.rast --overwrite input=${lcaselyr} output=${lcaselyr} use=val value=${a} memory=8192
	# echo "Layer ${lyr} completed"
# done

# grass ${BLUEMAPSET_PATH_LL} --exec  r.patch --quiet --overwrite input=${bl_list} output=baselayers


# # IMPORT AND CONVERT TO RASTER GEOMORPHIC FEATURES
# value=1

# for lyr in ${features}
# do
	# echo "------------------------------"
	# echo "Importing ${lyr} ..."
	# lcaselyr=${lyr,,}
	# grass ${BLUEMAPSET_PATH_LL} --exec v.in.ogr --quiet --overwrite -o  input="${SHPDIR}"/${lyr}.shp output=${lcaselyr}
	# grass ${BLUEMAPSET_PATH_LL} --exec g.region raster=wdpa_flat@WDPA res=0:00:30
	# grass ${BLUEMAPSET_PATH_LL} --exec v.to.rast --overwrite input=${lcaselyr} output=${lcaselyr} use=val memory=8192
	# echo "Layer ${lyr} completed"
# done

# # IMPORT AND CONVERT TO RASTER REEFS
# echo "------------------------------"
# echo "Importing Reefs ..."
# grass ${BLUEMAPSET_PATH_LL} --exec v.in.ogr --quiet --overwrite -o  input="${BASELAYERS_PATH}"/reef_500_poly_ll.shp output=reefs
# grass ${BLUEMAPSET_PATH_LL} --exec g.region raster=wdpa_flat@WDPA res=0:00:30
# grass ${BLUEMAPSET_PATH_LL} --exec v.to.rast --overwrite input=reefs output=reefs use=val memory=8192

# echo "Layer Reefs completed"


## SECOND PART : ANALYSING MARINE PA

# MAKE LIST OF LAYERS TO BE INCLUDED IN ANALYSIS
analysis_list=`echo ${features,,}|awk -v OFS="," '$1=$1'`",reefs,baselayers"

# RUN R.STATS
for PA in $(cat ${PA_LIST_FILE})
    do
    echo "#!/bin/bash
    ## SET REGION AND MASK
    g.region --quiet vector=${PA}@${PA_MAPSET} align=baselayers
    r.mask --overwrite --quiet vector=${PA}@${PA_MAPSET}
    ## ANALYZE BLUEHABITAT DATASET
    r.stats --q -a -N --overwrite input=${analysis_list} separator=\"|\"${PA}\"|\" null_value=0 >>${RESULTSPATH}/pa_bluehab.csv
    ## UNSET REGION AND MASK
    r.mask -r --q
    g.region -d --quiet
    exit
    "  > ./dyn/process_pa_bluehab_${PA}.sh
    chmod u+x ./dyn/process_pa_bluehab_${PA}.sh
    grass ${TEMPORARY_MAPSET_PATH} --exec ./dyn/process_pa_bluehab_${PA}.sh

done


date

exit


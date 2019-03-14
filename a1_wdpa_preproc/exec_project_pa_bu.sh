#!/bin/bash

echo " "
echo "---------------------------------------------------"
echo "- Script $(basename "$0") started at $(date)"
echo " "

# READ VARIABLES FROM CONFIGURATION FILE
SERVICEDIR="/globes/PROCESSING/WDPA/scripts/a0_servicefiles"
source ${SERVICEDIR}/wdpa_preprocessing.conf

## Derived variables
##((NCORES=${1:-DEFAULTVALUE}))
((NTILES=${NCORES}-1))
LOCATION_LL_PATH=${DATABASE}/${LOCATION_LL}
LOCATION_MO_PATH=${DATABASE}/${LOCATION_MO}
PERMANENT_LL_MAPSET=${DATABASE}/${LOCATION_LL}"/PERMANENT"
PERMANENT_MO_MAPSET=${DATABASE}/${LOCATION_MO}"/PERMANENT"
PA_LL_MAPSET_PATH=${DATABASE}/${LOCATION_LL}/${PA_MAPSET}
PA_MO_MAPSET_PATH=${DATABASE}/${LOCATION_MO}/${PA_MAPSET}
BU_LL_MAPSET_PATH=${DATABASE}/${LOCATION_LL}/${BU_MAPSET}
BU_MO_MAPSET_PATH=${DATABASE}/${LOCATION_MO}/${BU_MAPSET}

# CREATES RELEVANT MAPSETS
grass ${PERMANENT_MO_MAPSET} --exec g.mapset --q -c --overwrite mapset=${PA_MAPSET}
grass ${PERMANENT_MO_MAPSET} --exec g.mapset --q -c --overwrite mapset=${BU_MAPSET}

# CREATE DIRECTORY FOR DYNAMIC SCRIPTS
mkdir -p ${WORKINGDIR}/dyn

# REPROJECTS PA LAYERS IN MOLLWEIDE
for PA in $(echo $(grass ${PA_LL_MAPSET_PATH}  --exec g.list vector mapset=${PA_MAPSET}))
do
	echo "./slave_project_pa_bu.sh ${PA} ${LOCATION_LL} ${PA_MAPSET} ${PA_MO_MAPSET_PATH}"
done | parallel -j 1

# echo "PAs reprojected"

# REPROJECTS BU LAYERS IN MOLLWEIDE
for BU in $(echo $(grass ${BU_LL_MAPSET_PATH}  --exec g.list vector mapset=${BU_MAPSET}))
do
	echo "./slave_project_pa_bu.sh ${BU} ${LOCATION_LL} ${BU_MAPSET} ${BU_MO_MAPSET_PATH}"
done | parallel -j 1

echo "BUs reprojected"
echo " "
echo "Now removing dynamic scripts..."
rm -f ${WORKINGDIR}/dyn/*.sh

finaldate=`date`
echo " "
echo "---------------------------------------------------"
echo "- Script $(basename "$0") completed at $(date)"
echo " "
exit

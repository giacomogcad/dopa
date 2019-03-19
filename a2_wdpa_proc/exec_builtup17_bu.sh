#!/bin/bash
##PROCESS BUILT UP 2017
date

set -o nounset  # Break if a variable is unset

# READ VARIABLES FROM CONFIGURATION FILE
SERVICEDIR="/globes/PROCESSING/WDPA/scripts/a0_servicefiles"
source ${SERVICEDIR}/wdpa_processing.conf

## Derived variables
((NTILES=${NCORES}-1))
LOCATION_MO_PATH=${DATABASE}/${LOCATION_MO}
PERMANENT_MO_MAPSET=${DATABASE}/${LOCATION_MO}"/PERMANENT"
BU_LIST_FILE="list_bu_tc.txt"

## GRASS parallel processing block
((NTILES=$NCORES-1))
((ALLPAS=$(cat ${BU_LIST_FILE} | wc -l)+1))
((TILESIZE=($ALLPAS+($NCORES-1))/$NCORES))   #TILESIZE is rounded up in order to ensure that [last tile + TILESIZE] is always > ALLPAS" 
for TIL in $(for i in $(eval echo {0..$NTILES}); do ((start=${TILESIZE}*$i)); echo -n $start" "; done)
    do
    TIL=${TIL}
    TEMPORARY_MAPSET=tile_${TIL}
    TEMPORARY_MAPSET_PATH=${LOCATION_MO_PATH}/${TEMPORARY_MAPSET}
    #Build temporary Mapset name
    grass ${PERMANENT_MO_MAPSET} --exec g.mapset --q -c --overwrite mapset=${TEMPORARY_MAPSET}
    echo "./slave_builtup17_bu.sh ${TIL} ${TEMPORARY_MAPSET_PATH} ${RESULTSPATH} ${TILESIZE} ${BU_LIST_FILE} ${BU_MAPSET}"
done | parallel -j ${NCORES} --joblog ${LOGPATH}/parallel_builtup17_bu.log

# merge results
cat ${RESULTSPATH}/bu_builtup_totsurface_tile*.csv >> ${RESULTSPATH}/bu_builtup_totsurface.csv
cat ${RESULTSPATH}/bu_builtup_tile*.csv >> ${RESULTSPATH}/bu_builtup.csv

wait

## delete mapsets and intermediate results
for TIL in $(for i in $(eval echo {0..$NTILES}); do ((start=${TILESIZE}*$i)); echo -n $start" "; done)
    do
    rm -rf ${LOCATION_MO_PATH}/tile_${TIL}
    rm -f ${RESULTSPATH}/*_tile${TIL}.csv
done

## SECOND CYCLE: REPEAT PROCESSING of BUILT UP FOR BUs NOT PROCESSED DURING FIRST CYCLE
cat ${RESULTSPATH}/bu_builtup_totsurface.csv | awk '{print $2}' FS="|">./builtup_actually_done.csv # for outputs from r.stats the BU id is in the second field, so we need to use '{print $2}'
comm -23 <(sort ${BU_LIST_FILE}) <(sort ./builtup_actually_done.csv)>./builtup_to_be_repeated.csv
MISSING_BU_LIST="builtup_to_be_repeated.csv"
for BU in $(cat ${MISSING_BU_LIST})
    do
    grass ${PERMANENT_MO_MAPSET} --exec ./dyn/process_bu_builtup_${BU}.sh
done
cat ${RESULTSPATH}/bu_builtup_totsurface_tile*.csv >> ${RESULTSPATH}/bu_builtup_totsurface.csv
cat ${RESULTSPATH}/bu_builtup_tile*.csv >> ${RESULTSPATH}/bu_builtup.csv

## delete intermediate results
for TIL in $(for i in $(eval echo {0..$NTILES}); do ((start=${TILESIZE}*$i)); echo -n $start" "; done)
    do
    rm -f ${RESULTSPATH}/*_tile${TIL}.csv
done
rm -f ./*actually_done.csv
rm -f ./*to_be_repeated.csv

## delete dynamic scripts
rm -f dyn/process_bu_builtup*.sh

date
exit

#!/bin/bash
##PROCESS LAND PRODUCTIVITY DYNAMICS
date

set -o nounset  # Break if a variable is unset

# READ VARIABLES FROM CONFIGURATION FILE
SERVICEDIR="/globes/PROCESSING/WDPA/scripts/a0_servicefiles"
source ${SERVICEDIR}/wdpa_processing.conf

## Derived variables
((NTILES=${NCORES}-1))
LOCATION_MO_PATH=${DATABASE}/${LOCATION_MO}
PERMANENT_MO_MAPSET=${DATABASE}/${LOCATION_MO}"/PERMANENT"
PA_LIST_FILE=${SERVICEDIR}/${pa_tc_list}.txt

## GRASS parallel processing block
((ALLPAS=$(cat ${PA_LIST_FILE} | wc -l)+1))
((TILESIZE=($ALLPAS+($NCORES-1))/$NCORES))   #TILESIZE is rounded up in order to ensure that [last tile + TILESIZE] is always > ALLPAS" 
for TIL in $(for i in $(eval echo {0..$NTILES}); do ((start=${TILESIZE}*$i)); echo -n $start" "; done)
    do
    TIL=${TIL}
    TEMPORARY_MAPSET=tile_${TIL}
    TEMPORARY_MAPSET_PATH=${LOCATION_MO_PATH}/${TEMPORARY_MAPSET}
    #Build temporary Mapset name
    grass ${PERMANENT_MO_MAPSET} --exec g.mapset --q -c --overwrite mapset=${TEMPORARY_MAPSET}
    echo "./slave_lpd_pa.sh ${TIL} ${TEMPORARY_MAPSET_PATH} ${RESULTSPATH} ${TILESIZE} ${PA_LIST_FILE} ${PA_MAPSET}"
done | parallel -j ${NCORES} --joblog ${LOGPATH}/parallel_lpd_pa.log

echo "GRASS Processing completed, now post-processing results..."

# merge results LC
cat ${RESULTSPATH}/pa_lpd_totsurface_tile*.csv >> ${RESULTSPATH}/pa_lpd_totsurface.csv
cat ${RESULTSPATH}/pa_lpd_tile*.csv >> ${RESULTSPATH}/pa_lpd.csv

wait

## delete mapsets and intermediate results
for TIL in $(for i in $(eval echo {0..$NTILES}); do ((start=${TILESIZE}*$i)); echo -n $start" "; done)
    do
    rm -rf ${LOCATION_MO_PATH}/tile_${TIL}
    rm -f ${RESULTSPATH}/*_tile${TIL}.csv
done

## SECOND CYCLE: REPEAT PROCESSING FOR PAs NOT PROCESSED DURING FIRST CYCLE
cat ${RESULTSPATH}/pa_lpd_totsurface.csv | awk '{print $2}' FS="|">./pa_lpd_actually_done.csv # for outputs from r.stats the PA id is in the second field, so we need to use '{print $2}'
comm -23 <(sort ${PA_LIST_FILE}) <(sort ./pa_lpd_actually_done.csv)>./pa_lpd_to_be_repeated.csv
MISSING_PA_LIST="pa_lpd_to_be_repeated.csv"
for PA in $(cat ${MISSING_PA_LIST})
    do
    grass ${PERMANENT_MO_MAPSET} --exec ./dyn/process_pa_lpd_${PA}.sh
done
cat ${RESULTSPATH}/pa_lpd_totsurface_tile*.csv >> ${RESULTSPATH}/pa_lpd_totsurface.csv
cat ${RESULTSPATH}/pa_lpd_tile*.csv >> ${RESULTSPATH}/pa_lpd.csv

## delete intermediate results
for TIL in $(for i in $(eval echo {0..$NTILES}); do ((start=${TILESIZE}*$i)); echo -n $start" "; done)
    do
    rm -f ${RESULTSPATH}/*_tile${TIL}.csv
done
rm -f ./*actually_done.csv
rm -f ./*to_be_repeated.csv

## delete dynamic scripts
rm -f ./dyn/process_pa_lpd_*.sh

date
exit

#!/bin/bash
##PROCESS ESA-CCI AND MSPA_LC
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
    echo "./slave_esa_pa.sh ${TIL} ${TEMPORARY_MAPSET_PATH} ${RESULTSPATH} ${TILESIZE} ${PA_LIST_FILE} ${PA_MAPSET}"
done | parallel -j ${NCORES} --joblog ${LOGPATH}/parallel_esa_pa.log

echo "GRASS Processing completed, now post-processing results..."

# merge results LC
cat ${RESULTSPATH}/pa_lc_totsurface_tile*.csv >> ${RESULTSPATH}/pa_lc_totsurface.csv
cat ${RESULTSPATH}/pa_lc_1995_tile*.csv >> ${RESULTSPATH}/pa_lc_1995.csv
cat ${RESULTSPATH}/pa_lc_2000_tile*.csv >> ${RESULTSPATH}/pa_lc_2000.csv
cat ${RESULTSPATH}/pa_lc_2005_tile*.csv >> ${RESULTSPATH}/pa_lc_2005.csv
cat ${RESULTSPATH}/pa_lc_2010_tile*.csv >> ${RESULTSPATH}/pa_lc_2010.csv
cat ${RESULTSPATH}/pa_lc_2015_tile*.csv >> ${RESULTSPATH}/pa_lc_2015.csv
cat ${RESULTSPATH}/pa_lcc_95_15_tile*.csv >> ${RESULTSPATH}/pa_lcc_95_15.csv
#cat ${RESULTSPATH}/pa_lcc_allyears_tile*.csv >> ${RESULTSPATH}/pa_lcc_allyears.csv

# merge results MSPA_LC
cp ${RESULTSPATH}/pa_lc_totsurface.csv ${RESULTSPATH}/pa_mspa_lc_totsurface.csv #r.stats for totsurface is not run on mspa_lc since it uses the same mask of LC
cat ${RESULTSPATH}/pa_mspa_lc_1995_tile*.csv >> ${RESULTSPATH}/pa_mspa_lc_1995.csv
cat ${RESULTSPATH}/pa_mspa_lc_2000_tile*.csv >> ${RESULTSPATH}/pa_mspa_lc_2000.csv
cat ${RESULTSPATH}/pa_mspa_lc_2005_tile*.csv >> ${RESULTSPATH}/pa_mspa_lc_2005.csv
cat ${RESULTSPATH}/pa_mspa_lc_2010_tile*.csv >> ${RESULTSPATH}/pa_mspa_lc_2010.csv
cat ${RESULTSPATH}/pa_mspa_lc_2015_tile*.csv >> ${RESULTSPATH}/pa_mspa_lc_2015.csv
cat ${RESULTSPATH}/pa_mspa_lcc_95_15_tile*.csv >> ${RESULTSPATH}/pa_mspa_lcc_95_15.csv
#cat ${RESULTSPATH}/pa_mspa_lcc_allyears_tile*.csv >> ${RESULTSPATH}/pa_mspa_lcc_allyears.csv

wait

## delete mapsets and intermediate results
for TIL in $(for i in $(eval echo {0..$NTILES}); do ((start=${TILESIZE}*$i)); echo -n $start" "; done)
    do
    rm -rf ${LOCATION_MO_PATH}/tile_${TIL}
    rm -f ${RESULTSPATH}/*_tile${TIL}.csv
done

## SECOND CYCLE: REPEAT PROCESSING OF ESA-CCI AND MSPA_LC FOR PAs NOT PROCESSED DURING FIRST CYCLE
cat ${RESULTSPATH}/pa_lc_totsurface.csv | awk '{print $2}' FS="|">./pa_lc_actually_done.csv # for outputs from r.stats the PA id is in the second field, so we need to use '{print $2}'
comm -23 <(sort ${PA_LIST_FILE}) <(sort ./pa_lc_actually_done.csv)>./pa_lc_to_be_repeated.csv
MISSING_PA_LIST="pa_lc_to_be_repeated.csv"
for PA in $(cat ${MISSING_PA_LIST})
    do
    grass ${PERMANENT_MO_MAPSET} --exec ./dyn/process_pa_esa_${PA}.sh
done
cat ${RESULTSPATH}/pa_lc_totsurface_tile*.csv >> ${RESULTSPATH}/pa_lc_totsurface.csv
cat ${RESULTSPATH}/pa_lc_1995_tile*.csv >> ${RESULTSPATH}/pa_lc_1995.csv
cat ${RESULTSPATH}/pa_lc_2000_tile*.csv >> ${RESULTSPATH}/pa_lc_2000.csv
cat ${RESULTSPATH}/pa_lc_2005_tile*.csv >> ${RESULTSPATH}/pa_lc_2005.csv
cat ${RESULTSPATH}/pa_lc_2010_tile*.csv >> ${RESULTSPATH}/pa_lc_2010.csv
cat ${RESULTSPATH}/pa_lc_2015_tile*.csv >> ${RESULTSPATH}/pa_lc_2015.csv
cat ${RESULTSPATH}/pa_lcc_95_15_tile*.csv >> ${RESULTSPATH}/pa_lcc_95_15.csv
#cat ${RESULTSPATH}/pa_lcc_allyears_tile*.csv >> ${RESULTSPATH}/pa_lcc_allyears.csv
cp ${RESULTSPATH}/pa_lc_totsurface.csv ${RESULTSPATH}/pa_mspa_lc_totsurface.csv
cat ${RESULTSPATH}/pa_mspa_lc_1995_tile*.csv >> ${RESULTSPATH}/pa_mspa_lc_1995.csv
cat ${RESULTSPATH}/pa_mspa_lc_2000_tile*.csv >> ${RESULTSPATH}/pa_mspa_lc_2000.csv
cat ${RESULTSPATH}/pa_mspa_lc_2005_tile*.csv >> ${RESULTSPATH}/pa_mspa_lc_2005.csv
cat ${RESULTSPATH}/pa_mspa_lc_2010_tile*.csv >> ${RESULTSPATH}/pa_mspa_lc_2010.csv
cat ${RESULTSPATH}/pa_mspa_lc_2015_tile*.csv >> ${RESULTSPATH}/pa_mspa_lc_2015.csv
cat ${RESULTSPATH}/pa_mspa_lcc_95_15_tile*.csv >> ${RESULTSPATH}/pa_mspa_lcc_95_15.csv
#cat ${RESULTSPATH}/pa_mspa_lcc_allyears_tile*.csv >> ${RESULTSPATH}/pa_mspa_lcc_allyears.csv

## delete intermediate results
for TIL in $(for i in $(eval echo {0..$NTILES}); do ((start=${TILESIZE}*$i)); echo -n $start" "; done)
    do
    rm -f ${RESULTSPATH}/*_tile${TIL}.csv
done
rm -f ./*actually_done.csv
rm -f ./*to_be_repeated.csv

## delete dynamic scripts
rm -f ./dyn/process_pa_esa_*.sh

date
exit

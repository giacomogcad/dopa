#!/bin/bash
##ANALYZE LAND PRODUCTIVITY DYNAMICS

TIL=$1
TEMPORARY_MAPSET_PATH=$2
RESULTSPATH=$3
TILESIZE=$4
PA_LIST_FILE=$5
PA_MAPSET=$6

for PA in $(cat ${PA_LIST_FILE}|awk "NR >= (${TIL}+1) && NR <= (${TIL}+${TILESIZE})")
    do
    echo "#!/bin/bash
    ## SET REGION AND MASK
    g.region --quiet vector=${PA}@${PA_MAPSET} align=lpd@CATRASTERS
    r.mask --overwrite --quiet vector=${PA}@${PA_MAPSET}
    ## ANALYZE LAND PRODUCTIVITY DYNAMICS
    r.stats --q -a -n -N --overwrite input=MASK separator=\"|\"${PA}\"|\" null_value=0 >>${RESULTSPATH}/pa_lpd_totsurface_tile$TIL.csv
    r.stats --q -a -n -N --overwrite input=lpd@CATRASTERS separator=\"|\"${PA}\"|\" null_value=0 >>${RESULTSPATH}/pa_lpd_tile$TIL.csv
    ## UNSET REGION AND MASK
    r.mask -r --q
    g.region -d --quiet
    exit
    "  > ./dyn/process_pa_lpd_${PA}.sh
    chmod u+x ./dyn/process_pa_lpd_${PA}.sh
    grass ${TEMPORARY_MAPSET_PATH} --exec ./dyn/process_pa_lpd_${PA}.sh

done
exit

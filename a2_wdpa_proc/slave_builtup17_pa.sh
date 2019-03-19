#!/bin/bash
## ANALYZE BUILTUP LDSMT

TIL=$1
TEMPORARY_MAPSET_PATH=$2
RESULTSPATH=$3
TILESIZE=$4
PA_LIST_FILE=$5
PA_MAPSET=$6

for PA in $(cat ${PA_LIST_FILE}|awk "NR >= (${TIL}+1) && NR <= (${TIL}+${TILESIZE})")
    do
    echo "#!/bin/bash
    ## ANALYZE BUILTUP LDSMT
    g.region --quiet vector=${PA}@${PA_MAPSET} align=ghs_built@CATRASTERS
    r.mask --overwrite --quiet vector=${PA}@${PA_MAPSET}
    r.stats --q -a -n -N --overwrite input=MASK separator=\"|\"${PA}\"|\" null_value=0 >>${RESULTSPATH}/pa_builtup_totsurface_tile${TIL}.csv
    r.stats --q -a -n -N --overwrite input=ghs_built@CATRASTERS separator=\"|\"${PA}\"|\" null_value=0 >>${RESULTSPATH}/pa_builtup_tile${TIL}.csv
    r.mask -r --q
    g.region -d --quiet
    exit
    " > ./dyn/process_pa_builtup_${PA}.sh
    chmod u+x ./dyn/process_pa_builtup_${PA}.sh
    grass ${TEMPORARY_MAPSET_PATH} --exec ./dyn/process_pa_builtup_${PA}.sh

done
exit

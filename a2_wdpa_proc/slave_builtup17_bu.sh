#!/bin/bash
## ANALYZE BUILTUP LDSMT

TIL=$1
TEMPORARY_MAPSET_PATH=$2
RESULTSPATH=$3
TILESIZE=$4
BU_LIST_FILE=$5
BU_MAPSET=$6

for BU in $(cat ${BU_LIST_FILE}|awk "NR >= (${TIL}+1) && NR <= (${TIL}+${TILESIZE})")
    do
    echo "#!/bin/bash
    ## ANALYZE BUILTUP LDSMT
    g.region --quiet vector=${BU}@${BU_MAPSET} align=ghs_built@CATRASTERS
    r.mask --overwrite --quiet vector=${BU}@${BU_MAPSET}
    r.stats --q -a -n -N --overwrite input=MASK separator=\"|\"${BU}\"|\" null_value=0 >>${RESULTSPATH}/bu_builtup_totsurface_tile${TIL}.csv
    r.stats --q -a -n -N --overwrite input=ghs_built@CATRASTERS separator=\"|\"${BU}\"|\" null_value=0 >>${RESULTSPATH}/bu_builtup_tile${TIL}.csv
    r.mask -r --q
    g.region -d --quiet
    exit
    " > ./dyn/process_bu_builtup_${BU}.sh
    chmod u+x ./dyn/process_bu_builtup_${BU}.sh
    grass ${TEMPORARY_MAPSET_PATH} --exec ./dyn/process_bu_builtup_${BU}.sh

done
exit
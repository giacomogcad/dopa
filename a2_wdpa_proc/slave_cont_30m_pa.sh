#!/bin/bash
##PROCESS GLOBAL FOREST CHANGE - TREECOVER

TIL=$1
TEMPORARY_MAPSET_PATH=$2
RESULTSPATH=$3
TILESIZE=$4
PA_LIST_FILE=$5
PA_MAPSET+$6

for PA in $(cat ${PA_LIST_FILE}|awk "NR >= (${TIL}+1) && NR <= (${TIL}+${TILESIZE})")
    do
    echo "#!/bin/bash
    ## ANALYZE GLOBAL FOREST CHANGE - TREECOVER
    g.region --quiet vector=${PA}@${PA_MAPSET} align=gfc_treecover@CONRASTERS
    r.mask --overwrite --quiet vector=${PA}@${PA_MAPSET}
    echo \"${PA}|\$(r.univar --q -e -t map=gfc_treecover@CONRASTERS |tail -1)\" >>${RESULTSPATH}/pa_gfc_treecover_t${TIL}.csv
    r.mask -r --q
    g.region -d --quiet
	exit
	" > ./dyn/process_pa_gfc_${PA}.sh
    chmod u+x  ./dyn/process_pa_gfc_${PA}.sh
    grass ${TEMPORARY_MAPSET_PATH} --exec ./dyn/process_pa_gfc_${PA}.sh

done
exit
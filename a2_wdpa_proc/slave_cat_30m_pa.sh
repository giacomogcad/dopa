#!/bin/bash
##PROCESS GLOBAL FOREST CHANGE (GAIN AND LOSSYEAR) AND GLOBAL SURFACE WATER

TIL=$1
TEMPORARY_MAPSET_PATH=$2
RESULTSPATH=$3
TILESIZE=$4
PA_LIST_FILE=$5
PA_MAPSET=$6

for PA in $(cat ${PA_LIST_FILE}|awk "NR >= (${TIL}+1) && NR <= (${TIL}+${TILESIZE})")
    do
    echo "#!/bin/bash
    ## ANALYZE GLOBAL FOREST CHANGE - GAIN AND LOSSYEAR
    g.region --quiet vector=${PA}@${PA_MAPSET} align=gfc_gain@CATRASTERS
    r.mask --overwrite --quiet vector=${PA}@${PA_MAPSET}
    r.stats --q -a -n -N --overwrite input=MASK separator=\"|\"${PA}\"|\" null_value=0 >>${RESULTSPATH}/results/pa_gfc_totsurface_t${TIL}.csv
    r.stats --q -a -n -N --overwrite input=gfc_gain@CATRASTERS separator=\"|\"${PA}\"|\" null_value=0 >>${RESULTSPATH}/pa_gfc_gain_t${TIL}.csv
    r.stats --q -a -n -N --overwrite input=gfc_lossyear@CATRASTERS separator=\"|\"${PA}\"|\" null_value=0 >>${RESULTSPATH}/pa_gfc_lossyear_t${TIL}.csv
    ## ANALYZE GLOBAL SURFACE WATER
    r.stats --q -a -n -N --overwrite input=gsw_transitions@CATRASTERS separator=\"|\"${PA}\"|\" null_value=0 >>${RESULTSPATH}/pa_gsw_tile$TIL.csv
    ## UNSET REGION AND MASK
    r.mask -r --q
    g.region -d --quiet
    exit
	" > ./dyn/process_cat30m_pa_${PA}.sh
    chmod u+x  ./dyn/process_cat30m_pa_${PA}.sh
    grass ${TEMPORARY_MAPSET_PATH} --exec ./dyn/process_cat30m_pa_${PA}.sh
done

exit

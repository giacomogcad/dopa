#!/bin/bash
##PROCESS ESA-CCI AND MSPA_LC

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
    g.region --quiet vector=${PA}@${PA_MAPSET} align=esalc_1995@CATRASTERS
    r.mask --overwrite --quiet vector=${PA}@${PA_MAPSET}
    ## ANALYZE ESA-CCI LAND COVER
    r.stats --q -a -n -N --overwrite input=MASK separator=\"|\"${PA}\"|\" null_value=0 >>${RESULTSPATH}/pa_lc_totsurface_tile$TIL.csv
    r.stats --q -a -n -N --overwrite input=esalc_1995@CATRASTERS separator=\"|\"${PA}\"|\" null_value=0 >>${RESULTSPATH}/pa_lc_1995_tile$TIL.csv
    r.stats --q -a -n -N --overwrite input=esalc_2000@CATRASTERS separator=\"|\"${PA}\"|\" null_value=0 >>${RESULTSPATH}/pa_lc_2000_tile$TIL.csv
    r.stats --q -a -n -N --overwrite input=esalc_2005@CATRASTERS separator=\"|\"${PA}\"|\" null_value=0 >>${RESULTSPATH}/pa_lc_2005_tile$TIL.csv
    r.stats --q -a -n -N --overwrite input=esalc_2010@CATRASTERS separator=\"|\"${PA}\"|\" null_value=0 >>${RESULTSPATH}/pa_lc_2010_tile$TIL.csv
    r.stats --q -a -n -N --overwrite input=esalc_2015@CATRASTERS separator=\"|\"${PA}\"|\" null_value=0 >>${RESULTSPATH}/pa_lc_2015_tile$TIL.csv
    r.stats --q -a -n -N --overwrite input=esalc_1995@CATRASTERS,esalc_2015@CATRASTERS separator=\"|\"${PA}\"|\" null_value=0 >>${RESULTSPATH}/pa_lcc_95_15_tile$TIL.csv
    #r.stats --q -a -n -N --overwrite input=esalc_1995@CATRASTERS,esalc_2000@CATRASTERS,esalc_2005@CATRASTERS,esalc_2010@CATRASTERS,esalc_2015@CATRASTERS separator=\"|\"${PA}\"|\" null_value=0 >>${RESULTSPATH}/pa_lcc_allyears_tile$TIL.csv
    ## ANALYZE MSPA_LC
    r.stats --q -a -n -N --overwrite input=mspa_lc_1995@CATRASTERS separator=\"|\"${PA}\"|\" null_value=0 >>${RESULTSPATH}/pa_mspa_lc_1995_tile$TIL.csv
    r.stats --q -a -n -N --overwrite input=mspa_lc_2000@CATRASTERS separator=\"|\"${PA}\"|\" null_value=0 >>${RESULTSPATH}/pa_mspa_lc_2000_tile$TIL.csv
    r.stats --q -a -n -N --overwrite input=mspa_lc_2005@CATRASTERS separator=\"|\"${PA}\"|\" null_value=0 >>${RESULTSPATH}/pa_mspa_lc_2005_tile$TIL.csv
    r.stats --q -a -n -N --overwrite input=mspa_lc_2010@CATRASTERS separator=\"|\"${PA}\"|\" null_value=0 >>${RESULTSPATH}/pa_mspa_lc_2010_tile$TIL.csv
    r.stats --q -a -n -N --overwrite input=mspa_lc_2015@CATRASTERS separator=\"|\"${PA}\"|\" null_value=0 >>${RESULTSPATH}/pa_mspa_lc_2015_tile$TIL.csv
    r.stats --q -a -n -N --overwrite input=mspa_lc_1995@CATRASTERS,mspa_lc_2015@CATRASTERS separator=\"|\"${PA}\"|\" null_value=0 >>${RESULTSPATH}/pa_mspa_lcc_95_15_tile$TIL.csv
    #r.stats --q -a -n -N --overwrite input=mspa_lc_1995@CATRASTERS,mspa_lc_2000@CATRASTERS,mspa_lc_2005@CATRASTERS,mspa_lc_2010@CATRASTERS,mspa_lc_2015@CATRASTERS separator=\"|\"${PA}\"|\" null_value=0 >>${RESULTSPATH}/pa_mspa_lcc_allyears_tile$TIL.csv
    ## UNSET REGION AND MASK
    r.mask -r --q
    g.region -d --quiet
    exit
    "  > ./dyn/process_pa_esa_${PA}.sh
    chmod u+x ./dyn/process_pa_esa_${PA}.sh
    grass ${TEMPORARY_MAPSET_PATH} --exec ./dyn/process_pa_esa_${PA}.sh

done
exit

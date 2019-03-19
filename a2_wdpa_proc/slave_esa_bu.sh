#!/bin/bash
##PROCESS ESA-CCI AND MSPA_LC

TIL=$1
TEMPORARY_MAPSET_PATH=$2
RESULTSPATH=$3
TILESIZE=$4
BU_LIST_FILE=$5
BU_MAPSET=$6

for BU in $(cat ${BU_LIST_FILE}|awk "NR >= (${TIL}+1) && NR <= (${TIL}+${TILESIZE})")
    do
    echo "#!/bin/bash
    ## SET REGION AND MASK
    g.region --quiet vector=${BU}@${BU_MAPSET} align=esalc_1995@CATRASTERS
    r.mask --overwrite --quiet vector=${BU}@${BU_MAPSET}
    ## ANALYZE ESA-CCI LAND COVER
    r.stats --q -a -n -N --overwrite input=MASK separator=\"|\"${BU}\"|\" null_value=0 >>${RESULTSPATH}/bu_lc_totsurface_tile$TIL.csv
    r.stats --q -a -n -N --overwrite input=esalc_1995@CATRASTERS separator=\"|\"${BU}\"|\" null_value=0 >>${RESULTSPATH}/bu_lc_1995_tile$TIL.csv
    r.stats --q -a -n -N --overwrite input=esalc_2000@CATRASTERS separator=\"|\"${BU}\"|\" null_value=0 >>${RESULTSPATH}/bu_lc_2000_tile$TIL.csv
    r.stats --q -a -n -N --overwrite input=esalc_2005@CATRASTERS separator=\"|\"${BU}\"|\" null_value=0 >>${RESULTSPATH}/bu_lc_2005_tile$TIL.csv
    r.stats --q -a -n -N --overwrite input=esalc_2010@CATRASTERS separator=\"|\"${BU}\"|\" null_value=0 >>${RESULTSPATH}/bu_lc_2010_tile$TIL.csv
    r.stats --q -a -n -N --overwrite input=esalc_2015@CATRASTERS separator=\"|\"${BU}\"|\" null_value=0 >>${RESULTSPATH}/bu_lc_2015_tile$TIL.csv
    r.stats --q -a -n -N --overwrite input=esalc_1995@CATRASTERS,esalc_2015@CATRASTERS separator=\"|\"${BU}\"|\" null_value=0 >>${RESULTSPATH}/bu_lcc_95_15_tile$TIL.csv
    #r.stats --q -a -n -N --overwrite input=esalc_1995@CATRASTERS,esalc_2000@CATRASTERS,esalc_2005@CATRASTERS,esalc_2010@CATRASTERS,esalc_2015@CATRASTERS separator=\"|\"${BU}\"|\" null_value=0 >>${RESULTSPATH}/bu_lcc_allyears_tile$TIL.csv
    ## ANALYZE MSPA_LC
    r.stats --q -a -n -N --overwrite input=mspa_lc_1995@CATRASTERS separator=\"|\"${BU}\"|\" null_value=0 >>${RESULTSPATH}/bu_mspa_lc_1995_tile$TIL.csv
    r.stats --q -a -n -N --overwrite input=mspa_lc_2000@CATRASTERS separator=\"|\"${BU}\"|\" null_value=0 >>${RESULTSPATH}/bu_mspa_lc_2000_tile$TIL.csv
    r.stats --q -a -n -N --overwrite input=mspa_lc_2005@CATRASTERS separator=\"|\"${BU}\"|\" null_value=0 >>${RESULTSPATH}/bu_mspa_lc_2005_tile$TIL.csv
    r.stats --q -a -n -N --overwrite input=mspa_lc_2010@CATRASTERS separator=\"|\"${BU}\"|\" null_value=0 >>${RESULTSPATH}/bu_mspa_lc_2010_tile$TIL.csv
    r.stats --q -a -n -N --overwrite input=mspa_lc_2015@CATRASTERS separator=\"|\"${BU}\"|\" null_value=0 >>${RESULTSPATH}/bu_mspa_lc_2015_tile$TIL.csv
    r.stats --q -a -n -N --overwrite input=mspa_lc_1995@CATRASTERS,mspa_lc_2015@CATRASTERS separator=\"|\"${BU}\"|\" null_value=0 >>${RESULTSPATH}/bu_mspa_lcc_95_15_tile$TIL.csv
    #r.stats --q -a -n -N --overwrite input=mspa_lc_1995@CATRASTERS,mspa_lc_2000@CATRASTERS,mspa_lc_2005@CATRASTERS,mspa_lc_2010@CATRASTERS,mspa_lc_2015@CATRASTERS separator=\"|\"${BU}\"|\" null_value=0 >>${RESULTSPATH}/bu_mspa_lcc_allyears_tile$TIL.csv
    ## UNSET REGION AND MASK
    r.mask -r --q
    g.region -d --quiet
    exit
    "  > ./dyn/process_bu_esa_${BU}.sh
    chmod u+x ./dyn/process_bu_esa_${BU}.sh
    grass ${TEMPORARY_MAPSET_PATH} --exec ./dyn/process_bu_esa_${BU}.sh

done
exit

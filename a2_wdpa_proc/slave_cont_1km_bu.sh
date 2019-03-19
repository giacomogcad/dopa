#!/bin/bash
## PROCESS WORLDCLIM, GEBCO AND CROPLAND2005

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
    g.region --quiet vector=${BU}@${BU_MAPSET} align=worldclim_prec_01@CONRASTERS
    r.mask --overwrite --quiet vector=${BU}@${BU_MAPSET}
    ## ANALYZE WORLDCLIM prec
    echo \"${BU}|\$(r.univar --q -e -t map=worldclim_prec_01@CONRASTERS |tail -1)\" >>${RESULTSPATH}/bu_prec_01_tile${TIL}.csv
    echo \"${BU}|\$(r.univar --q -e -t map=worldclim_prec_02@CONRASTERS |tail -1)\" >>${RESULTSPATH}/bu_prec_02_tile${TIL}.csv
    echo \"${BU}|\$(r.univar --q -e -t map=worldclim_prec_03@CONRASTERS |tail -1)\" >>${RESULTSPATH}/bu_prec_03_tile${TIL}.csv
    echo \"${BU}|\$(r.univar --q -e -t map=worldclim_prec_04@CONRASTERS |tail -1)\" >>${RESULTSPATH}/bu_prec_04_tile${TIL}.csv
    echo \"${BU}|\$(r.univar --q -e -t map=worldclim_prec_05@CONRASTERS |tail -1)\" >>${RESULTSPATH}/bu_prec_05_tile${TIL}.csv
    echo \"${BU}|\$(r.univar --q -e -t map=worldclim_prec_06@CONRASTERS |tail -1)\" >>${RESULTSPATH}/bu_prec_06_tile${TIL}.csv
    echo \"${BU}|\$(r.univar --q -e -t map=worldclim_prec_07@CONRASTERS |tail -1)\" >>${RESULTSPATH}/bu_prec_07_tile${TIL}.csv
    echo \"${BU}|\$(r.univar --q -e -t map=worldclim_prec_08@CONRASTERS |tail -1)\" >>${RESULTSPATH}/bu_prec_08_tile${TIL}.csv
    echo \"${BU}|\$(r.univar --q -e -t map=worldclim_prec_09@CONRASTERS |tail -1)\" >>${RESULTSPATH}/bu_prec_09_tile${TIL}.csv
    echo \"${BU}|\$(r.univar --q -e -t map=worldclim_prec_10@CONRASTERS |tail -1)\" >>${RESULTSPATH}/bu_prec_10_tile${TIL}.csv
    echo \"${BU}|\$(r.univar --q -e -t map=worldclim_prec_11@CONRASTERS |tail -1)\" >>${RESULTSPATH}/bu_prec_11_tile${TIL}.csv
    echo \"${BU}|\$(r.univar --q -e -t map=worldclim_prec_12@CONRASTERS |tail -1)\" >>${RESULTSPATH}/bu_prec_12_tile${TIL}.csv
    ## ANALYZE WORLDCLIM tavg
    echo \"${BU}|\$(r.univar --q -e -t map=worldclim_tavg_01@CONRASTERS |tail -1)\" >>${RESULTSPATH}/bu_tavg_01_tile${TIL}.csv
    echo \"${BU}|\$(r.univar --q -e -t map=worldclim_tavg_02@CONRASTERS |tail -1)\" >>${RESULTSPATH}/bu_tavg_02_tile${TIL}.csv
    echo \"${BU}|\$(r.univar --q -e -t map=worldclim_tavg_03@CONRASTERS |tail -1)\" >>${RESULTSPATH}/bu_tavg_03_tile${TIL}.csv
    echo \"${BU}|\$(r.univar --q -e -t map=worldclim_tavg_04@CONRASTERS |tail -1)\" >>${RESULTSPATH}/bu_tavg_04_tile${TIL}.csv
    echo \"${BU}|\$(r.univar --q -e -t map=worldclim_tavg_05@CONRASTERS |tail -1)\" >>${RESULTSPATH}/bu_tavg_05_tile${TIL}.csv
    echo \"${BU}|\$(r.univar --q -e -t map=worldclim_tavg_06@CONRASTERS |tail -1)\" >>${RESULTSPATH}/bu_tavg_06_tile${TIL}.csv
    echo \"${BU}|\$(r.univar --q -e -t map=worldclim_tavg_07@CONRASTERS |tail -1)\" >>${RESULTSPATH}/bu_tavg_07_tile${TIL}.csv
    echo \"${BU}|\$(r.univar --q -e -t map=worldclim_tavg_08@CONRASTERS |tail -1)\" >>${RESULTSPATH}/bu_tavg_08_tile${TIL}.csv
    echo \"${BU}|\$(r.univar --q -e -t map=worldclim_tavg_09@CONRASTERS |tail -1)\" >>${RESULTSPATH}/bu_tavg_09_tile${TIL}.csv
    echo \"${BU}|\$(r.univar --q -e -t map=worldclim_tavg_10@CONRASTERS |tail -1)\" >>${RESULTSPATH}/bu_tavg_10_tile${TIL}.csv
    echo \"${BU}|\$(r.univar --q -e -t map=worldclim_tavg_11@CONRASTERS |tail -1)\" >>${RESULTSPATH}/bu_tavg_11_tile${TIL}.csv
    echo \"${BU}|\$(r.univar --q -e -t map=worldclim_tavg_12@CONRASTERS |tail -1)\" >>${RESULTSPATH}/bu_tavg_12_tile${TIL}.csv
    ## ANALYZE WORLDCLIM tmax
    echo \"${BU}|\$(r.univar --q -e -t map=worldclim_tmax_01@CONRASTERS |tail -1)\" >>${RESULTSPATH}/bu_tmax_01_tile${TIL}.csv
    echo \"${BU}|\$(r.univar --q -e -t map=worldclim_tmax_02@CONRASTERS |tail -1)\" >>${RESULTSPATH}/bu_tmax_02_tile${TIL}.csv
    echo \"${BU}|\$(r.univar --q -e -t map=worldclim_tmax_03@CONRASTERS |tail -1)\" >>${RESULTSPATH}/bu_tmax_03_tile${TIL}.csv
    echo \"${BU}|\$(r.univar --q -e -t map=worldclim_tmax_04@CONRASTERS |tail -1)\" >>${RESULTSPATH}/bu_tmax_04_tile${TIL}.csv
    echo \"${BU}|\$(r.univar --q -e -t map=worldclim_tmax_05@CONRASTERS |tail -1)\" >>${RESULTSPATH}/bu_tmax_05_tile${TIL}.csv
    echo \"${BU}|\$(r.univar --q -e -t map=worldclim_tmax_06@CONRASTERS |tail -1)\" >>${RESULTSPATH}/bu_tmax_06_tile${TIL}.csv
    echo \"${BU}|\$(r.univar --q -e -t map=worldclim_tmax_07@CONRASTERS |tail -1)\" >>${RESULTSPATH}/bu_tmax_07_tile${TIL}.csv
    echo \"${BU}|\$(r.univar --q -e -t map=worldclim_tmax_08@CONRASTERS |tail -1)\" >>${RESULTSPATH}/bu_tmax_08_tile${TIL}.csv
    echo \"${BU}|\$(r.univar --q -e -t map=worldclim_tmax_09@CONRASTERS |tail -1)\" >>${RESULTSPATH}/bu_tmax_09_tile${TIL}.csv
    echo \"${BU}|\$(r.univar --q -e -t map=worldclim_tmax_10@CONRASTERS |tail -1)\" >>${RESULTSPATH}/bu_tmax_10_tile${TIL}.csv
    echo \"${BU}|\$(r.univar --q -e -t map=worldclim_tmax_11@CONRASTERS |tail -1)\" >>${RESULTSPATH}/bu_tmax_11_tile${TIL}.csv
    echo \"${BU}|\$(r.univar --q -e -t map=worldclim_tmax_12@CONRASTERS |tail -1)\" >>${RESULTSPATH}/bu_tmax_12_tile${TIL}.csv
    ## ANALYZE WORLDCLIM tmin
    echo \"${BU}|\$(r.univar --q -e -t map=worldclim_tmin_01@CONRASTERS |tail -1)\" >>${RESULTSPATH}/bu_tmin_01_tile${TIL}.csv
    echo \"${BU}|\$(r.univar --q -e -t map=worldclim_tmin_02@CONRASTERS |tail -1)\" >>${RESULTSPATH}/bu_tmin_02_tile${TIL}.csv
    echo \"${BU}|\$(r.univar --q -e -t map=worldclim_tmin_03@CONRASTERS |tail -1)\" >>${RESULTSPATH}/bu_tmin_03_tile${TIL}.csv
    echo \"${BU}|\$(r.univar --q -e -t map=worldclim_tmin_04@CONRASTERS |tail -1)\" >>${RESULTSPATH}/bu_tmin_04_tile${TIL}.csv
    echo \"${BU}|\$(r.univar --q -e -t map=worldclim_tmin_05@CONRASTERS |tail -1)\" >>${RESULTSPATH}/bu_tmin_05_tile${TIL}.csv
    echo \"${BU}|\$(r.univar --q -e -t map=worldclim_tmin_06@CONRASTERS |tail -1)\" >>${RESULTSPATH}/bu_tmin_06_tile${TIL}.csv
    echo \"${BU}|\$(r.univar --q -e -t map=worldclim_tmin_07@CONRASTERS |tail -1)\" >>${RESULTSPATH}/bu_tmin_07_tile${TIL}.csv
    echo \"${BU}|\$(r.univar --q -e -t map=worldclim_tmin_08@CONRASTERS |tail -1)\" >>${RESULTSPATH}/bu_tmin_08_tile${TIL}.csv
    echo \"${BU}|\$(r.univar --q -e -t map=worldclim_tmin_09@CONRASTERS |tail -1)\" >>${RESULTSPATH}/bu_tmin_09_tile${TIL}.csv
    echo \"${BU}|\$(r.univar --q -e -t map=worldclim_tmin_10@CONRASTERS |tail -1)\" >>${RESULTSPATH}/bu_tmin_10_tile${TIL}.csv
    echo \"${BU}|\$(r.univar --q -e -t map=worldclim_tmin_11@CONRASTERS |tail -1)\" >>${RESULTSPATH}/bu_tmin_11_tile${TIL}.csv
    echo \"${BU}|\$(r.univar --q -e -t map=worldclim_tmin_12@CONRASTERS |tail -1)\" >>${RESULTSPATH}/bu_tmin_12_tile${TIL}.csv
    ## ANALYSE GEBCO
    echo \"${BU}|\$(r.univar -e -t map=gebco@CONRASTERS |tail -1)\" >>${RESULTSPATH}/bu_gebco_tile${TIL}.csv
    ## ANALYSE CROPLAND2005
    echo \"${BU}|\$(r.univar --q -e -t map=cropland2005@CONRASTERS |tail -1)\" >>${RESULTSPATH}/bu_cropland2005_tile${TIL}.csv
    ## CLEAN PROCESSING ENVIRONMENT
    r.mask -r --q
    g.region -d --quiet
    exit
    " > ./dyn/process_cont_1km_${BU}.sh
    chmod u+x ./dyn/process_cont_1km_${BU}.sh
    grass ${TEMPORARY_MAPSET_PATH} --exec ./dyn/process_cont_1km_${BU}.sh

done
exit

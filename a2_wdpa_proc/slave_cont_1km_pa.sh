#!/bin/bash
## PROCESS WORLDCLIM, GEBCO AND CROPLAND2005

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
    g.region --quiet vector=${PA}@${PA_MAPSET} align=worldclim_prec_01@CONRASTERS
    r.mask --overwrite --quiet vector=${PA}@${PA_MAPSET}
    ## ANALYZE WORLDCLIM prec
    echo \"${PA}|\$(r.univar --q -e -t map=worldclim_prec_01@CONRASTERS |tail -1)\" >>${RESULTSPATH}/pa_prec_01_tile${TIL}.csv
    echo \"${PA}|\$(r.univar --q -e -t map=worldclim_prec_02@CONRASTERS |tail -1)\" >>${RESULTSPATH}/pa_prec_02_tile${TIL}.csv
    echo \"${PA}|\$(r.univar --q -e -t map=worldclim_prec_03@CONRASTERS |tail -1)\" >>${RESULTSPATH}/pa_prec_03_tile${TIL}.csv
    echo \"${PA}|\$(r.univar --q -e -t map=worldclim_prec_04@CONRASTERS |tail -1)\" >>${RESULTSPATH}/pa_prec_04_tile${TIL}.csv
    echo \"${PA}|\$(r.univar --q -e -t map=worldclim_prec_05@CONRASTERS |tail -1)\" >>${RESULTSPATH}/pa_prec_05_tile${TIL}.csv
    echo \"${PA}|\$(r.univar --q -e -t map=worldclim_prec_06@CONRASTERS |tail -1)\" >>${RESULTSPATH}/pa_prec_06_tile${TIL}.csv
    echo \"${PA}|\$(r.univar --q -e -t map=worldclim_prec_07@CONRASTERS |tail -1)\" >>${RESULTSPATH}/pa_prec_07_tile${TIL}.csv
    echo \"${PA}|\$(r.univar --q -e -t map=worldclim_prec_08@CONRASTERS |tail -1)\" >>${RESULTSPATH}/pa_prec_08_tile${TIL}.csv
    echo \"${PA}|\$(r.univar --q -e -t map=worldclim_prec_09@CONRASTERS |tail -1)\" >>${RESULTSPATH}/pa_prec_09_tile${TIL}.csv
    echo \"${PA}|\$(r.univar --q -e -t map=worldclim_prec_10@CONRASTERS |tail -1)\" >>${RESULTSPATH}/pa_prec_10_tile${TIL}.csv
    echo \"${PA}|\$(r.univar --q -e -t map=worldclim_prec_11@CONRASTERS |tail -1)\" >>${RESULTSPATH}/pa_prec_11_tile${TIL}.csv
    echo \"${PA}|\$(r.univar --q -e -t map=worldclim_prec_12@CONRASTERS |tail -1)\" >>${RESULTSPATH}/pa_prec_12_tile${TIL}.csv
    ## ANALYZE WORLDCLIM tavg
    echo \"${PA}|\$(r.univar --q -e -t map=worldclim_tavg_01@CONRASTERS |tail -1)\" >>${RESULTSPATH}/pa_tavg_01_tile${TIL}.csv
    echo \"${PA}|\$(r.univar --q -e -t map=worldclim_tavg_02@CONRASTERS |tail -1)\" >>${RESULTSPATH}/pa_tavg_02_tile${TIL}.csv
    echo \"${PA}|\$(r.univar --q -e -t map=worldclim_tavg_03@CONRASTERS |tail -1)\" >>${RESULTSPATH}/pa_tavg_03_tile${TIL}.csv
    echo \"${PA}|\$(r.univar --q -e -t map=worldclim_tavg_04@CONRASTERS |tail -1)\" >>${RESULTSPATH}/pa_tavg_04_tile${TIL}.csv
    echo \"${PA}|\$(r.univar --q -e -t map=worldclim_tavg_05@CONRASTERS |tail -1)\" >>${RESULTSPATH}/pa_tavg_05_tile${TIL}.csv
    echo \"${PA}|\$(r.univar --q -e -t map=worldclim_tavg_06@CONRASTERS |tail -1)\" >>${RESULTSPATH}/pa_tavg_06_tile${TIL}.csv
    echo \"${PA}|\$(r.univar --q -e -t map=worldclim_tavg_07@CONRASTERS |tail -1)\" >>${RESULTSPATH}/pa_tavg_07_tile${TIL}.csv
    echo \"${PA}|\$(r.univar --q -e -t map=worldclim_tavg_08@CONRASTERS |tail -1)\" >>${RESULTSPATH}/pa_tavg_08_tile${TIL}.csv
    echo \"${PA}|\$(r.univar --q -e -t map=worldclim_tavg_09@CONRASTERS |tail -1)\" >>${RESULTSPATH}/pa_tavg_09_tile${TIL}.csv
    echo \"${PA}|\$(r.univar --q -e -t map=worldclim_tavg_10@CONRASTERS |tail -1)\" >>${RESULTSPATH}/pa_tavg_10_tile${TIL}.csv
    echo \"${PA}|\$(r.univar --q -e -t map=worldclim_tavg_11@CONRASTERS |tail -1)\" >>${RESULTSPATH}/pa_tavg_11_tile${TIL}.csv
    echo \"${PA}|\$(r.univar --q -e -t map=worldclim_tavg_12@CONRASTERS |tail -1)\" >>${RESULTSPATH}/pa_tavg_12_tile${TIL}.csv
    ## ANALYZE WORLDCLIM tmax
    echo \"${PA}|\$(r.univar --q -e -t map=worldclim_tmax_01@CONRASTERS |tail -1)\" >>${RESULTSPATH}/pa_tmax_01_tile${TIL}.csv
    echo \"${PA}|\$(r.univar --q -e -t map=worldclim_tmax_02@CONRASTERS |tail -1)\" >>${RESULTSPATH}/pa_tmax_02_tile${TIL}.csv
    echo \"${PA}|\$(r.univar --q -e -t map=worldclim_tmax_03@CONRASTERS |tail -1)\" >>${RESULTSPATH}/pa_tmax_03_tile${TIL}.csv
    echo \"${PA}|\$(r.univar --q -e -t map=worldclim_tmax_04@CONRASTERS |tail -1)\" >>${RESULTSPATH}/pa_tmax_04_tile${TIL}.csv
    echo \"${PA}|\$(r.univar --q -e -t map=worldclim_tmax_05@CONRASTERS |tail -1)\" >>${RESULTSPATH}/pa_tmax_05_tile${TIL}.csv
    echo \"${PA}|\$(r.univar --q -e -t map=worldclim_tmax_06@CONRASTERS |tail -1)\" >>${RESULTSPATH}/pa_tmax_06_tile${TIL}.csv
    echo \"${PA}|\$(r.univar --q -e -t map=worldclim_tmax_07@CONRASTERS |tail -1)\" >>${RESULTSPATH}/pa_tmax_07_tile${TIL}.csv
    echo \"${PA}|\$(r.univar --q -e -t map=worldclim_tmax_08@CONRASTERS |tail -1)\" >>${RESULTSPATH}/pa_tmax_08_tile${TIL}.csv
    echo \"${PA}|\$(r.univar --q -e -t map=worldclim_tmax_09@CONRASTERS |tail -1)\" >>${RESULTSPATH}/pa_tmax_09_tile${TIL}.csv
    echo \"${PA}|\$(r.univar --q -e -t map=worldclim_tmax_10@CONRASTERS |tail -1)\" >>${RESULTSPATH}/pa_tmax_10_tile${TIL}.csv
    echo \"${PA}|\$(r.univar --q -e -t map=worldclim_tmax_11@CONRASTERS |tail -1)\" >>${RESULTSPATH}/pa_tmax_11_tile${TIL}.csv
    echo \"${PA}|\$(r.univar --q -e -t map=worldclim_tmax_12@CONRASTERS |tail -1)\" >>${RESULTSPATH}/pa_tmax_12_tile${TIL}.csv
    ## ANALYZE WORLDCLIM tmin
    echo \"${PA}|\$(r.univar --q -e -t map=worldclim_tmin_01@CONRASTERS |tail -1)\" >>${RESULTSPATH}/pa_tmin_01_tile${TIL}.csv
    echo \"${PA}|\$(r.univar --q -e -t map=worldclim_tmin_02@CONRASTERS |tail -1)\" >>${RESULTSPATH}/pa_tmin_02_tile${TIL}.csv
    echo \"${PA}|\$(r.univar --q -e -t map=worldclim_tmin_03@CONRASTERS |tail -1)\" >>${RESULTSPATH}/pa_tmin_03_tile${TIL}.csv
    echo \"${PA}|\$(r.univar --q -e -t map=worldclim_tmin_04@CONRASTERS |tail -1)\" >>${RESULTSPATH}/pa_tmin_04_tile${TIL}.csv
    echo \"${PA}|\$(r.univar --q -e -t map=worldclim_tmin_05@CONRASTERS |tail -1)\" >>${RESULTSPATH}/pa_tmin_05_tile${TIL}.csv
    echo \"${PA}|\$(r.univar --q -e -t map=worldclim_tmin_06@CONRASTERS |tail -1)\" >>${RESULTSPATH}/pa_tmin_06_tile${TIL}.csv
    echo \"${PA}|\$(r.univar --q -e -t map=worldclim_tmin_07@CONRASTERS |tail -1)\" >>${RESULTSPATH}/pa_tmin_07_tile${TIL}.csv
    echo \"${PA}|\$(r.univar --q -e -t map=worldclim_tmin_08@CONRASTERS |tail -1)\" >>${RESULTSPATH}/pa_tmin_08_tile${TIL}.csv
    echo \"${PA}|\$(r.univar --q -e -t map=worldclim_tmin_09@CONRASTERS |tail -1)\" >>${RESULTSPATH}/pa_tmin_09_tile${TIL}.csv
    echo \"${PA}|\$(r.univar --q -e -t map=worldclim_tmin_10@CONRASTERS |tail -1)\" >>${RESULTSPATH}/pa_tmin_10_tile${TIL}.csv
    echo \"${PA}|\$(r.univar --q -e -t map=worldclim_tmin_11@CONRASTERS |tail -1)\" >>${RESULTSPATH}/pa_tmin_11_tile${TIL}.csv
    echo \"${PA}|\$(r.univar --q -e -t map=worldclim_tmin_12@CONRASTERS |tail -1)\" >>${RESULTSPATH}/pa_tmin_12_tile${TIL}.csv
    ## ANALYSE GEBCO
    echo \"${PA}|\$(r.univar -e -t map=gebco@CONRASTERS |tail -1)\" >>${RESULTSPATH}/pa_gebco_tile${TIL}.csv
    ## ANALYSE CROPLAND2005
    echo \"${PA}|\$(r.univar --q -e -t map=cropland2005@CONRASTERS |tail -1)\" >>${RESULTSPATH}/pa_cropland2005_tile${TIL}.csv
    ## CLEAN PROCESSING ENVIRONMENT
    r.mask -r --q
    g.region -d --quiet
    exit
    " > ./dyn/process_cont_1km_${PA}.sh
    chmod u+x ./dyn/process_cont_1km_${PA}.sh
    grass ${TEMPORARY_MAPSET_PATH} --exec ./dyn/process_cont_1km_${PA}.sh

done
exit

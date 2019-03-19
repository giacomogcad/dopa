#!/bin/bash
## ANALYZE GROADS

TIL=$1
TEMPORARY_MAPSET_PATH=$2
RESULTSPATH=$3
TILESIZE=$4
BU_LIST_FILE=$5
BU_MAPSET=$6

for BU in $(cat ${BU_LIST_FILE}|awk "NR >= (${TIL}+1) && NR <= (${TIL}+${TILESIZE})")
	do
	echo "#!/bin/bash
	## ANALYZE gROADS
	g.region --quiet vector=${BU}@${BU_MAPSET} align=groads@CONRASTERS
	r.mask --overwrite --quiet vector=${BU}@${BU_MAPSET}
	echo \"${BU}|\$(r.univar --q -e -t map=groads@CONRASTERS |tail -1)\" >>${RESULTSPATH}/bu_groads_tile$TIL.csv
	r.mask -r --q
	g.region -d --quiet
	exit
	" > ./dyn/process_pa_groads_${BU}.sh
	chmod u+x ./dyn/process_pa_groads_${BU}.sh
	grass ${TEMPORARY_MAPSET_PATH} --exec ./dyn/process_pa_groads_${BU}.sh

done
exit

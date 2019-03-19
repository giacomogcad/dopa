#!/bin/bash
## ANALYZE GROADS

TIL=$1
TEMPORARY_MAPSET_PATH=$2
RESULTSPATH=$3
TILESIZE=$4
PA_LIST_FILE=$5
PA_MAPSET=$6

for PA in $(cat ${PA_LIST_FILE}|awk "NR >= (${TIL}+1) && NR <= (${TIL}+${TILESIZE})")
	do
	echo "#!/bin/bash
	## ANALYZE gROADS
	g.region --quiet vector=${PA}@${PA_MAPSET} align=groads@CONRASTERS
	r.mask --overwrite --quiet vector=${PA}@${PA_MAPSET}
	echo \"${PA}|\$(r.univar --q -e -t map=groads@CONRASTERS |tail -1)\" >>${RESULTSPATH}/pa_groads_tile$TIL.csv
	r.mask -r --q
	g.region -d --quiet
	exit
	" > ./dyn/process_pa_groads_${PA}.sh
	chmod u+x ./dyn/process_pa_groads_${PA}.sh
	grass ${TEMPORARY_MAPSET_PATH} --exec ./dyn/process_pa_groads_${PA}.sh

done
exit

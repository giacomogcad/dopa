#!/bin/bash
## ANALYZE GHS POPULATION

TIL=$1
TEMPORARY_MAPSET_PATH=$2
RESULTSPATH=$3
TILESIZE=$4
PA_LIST_FILE=$5
PA_MAPSET=$6

for PA in $(cat ${PA_LIST_FILE}|awk "NR >= (${TIL}+1) && NR <= (${TIL}+${TILESIZE})")
	do
	echo "#!/bin/bash
	## ANALYZE GHS POPULATION
	g.region --quiet vector=${PA}@${PA_MAPSET} align=ghs_pop_2015@CONRASTERS
	r.mask --overwrite --quiet vector=${PA}@${PA_MAPSET}
	echo \"${PA}|\$(r.univar --q -e -t map=ghs_pop_1975@CONRASTERS |tail -1)\" >>${RESULTSPATH}/pa_pop1975_tile$TIL.csv
	echo \"${PA}|\$(r.univar --q -e -t map=ghs_pop_1990@CONRASTERS |tail -1)\" >>${RESULTSPATH}/pa_pop1990_tile$TIL.csv
	echo \"${PA}|\$(r.univar --q -e -t map=ghs_pop_2000@CONRASTERS |tail -1)\" >>${RESULTSPATH}/pa_pop2000_tile$TIL.csv
	echo \"${PA}|\$(r.univar --q -e -t map=ghs_pop_2015@CONRASTERS |tail -1)\" >>${RESULTSPATH}/pa_pop2015_tile$TIL.csv
	r.mask -r --q
	g.region -d --quiet
	exit
	" > ./dyn/process_pa_ghspop_${PA}.sh
	chmod u+x ./dyn/process_pa_ghspop_${PA}.sh
	grass ${TEMPORARY_MAPSET_PATH} --exec ./dyn/process_pa_ghspop_${PA}.sh

done
exit

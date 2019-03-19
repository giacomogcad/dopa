#!/bin/bash
## ANALYZE GHS POPULATION

TIL=$1
TEMPORARY_MAPSET_PATH=$2
RESULTSPATH=$3
TILESIZE=$4
BU_LIST_FILE=$5
BU_MAPSET=$6

for BU in $(cat ${BU_LIST_FILE}|awk "NR >= (${TIL}+1) && NR <= (${TIL}+${TILESIZE})")
	do
	echo "#!/bin/bash
	## ANALYZE GHS POPULATION
	g.region --quiet vector=${BU}@${BU_MAPSET} align=ghs_pop_2015@CONRASTERS
	r.mask --overwrite --quiet vector=${BU}@${BU_MAPSET}
	echo \"${BU}|\$(r.univar --q -e -t map=ghs_pop_1975@CONRASTERS |tail -1)\" >>${RESULTSPATH}/bu_pop1975_tile$TIL.csv
	echo \"${BU}|\$(r.univar --q -e -t map=ghs_pop_1990@CONRASTERS |tail -1)\" >>${RESULTSPATH}/bu_pop1990_tile$TIL.csv
	echo \"${BU}|\$(r.univar --q -e -t map=ghs_pop_2000@CONRASTERS |tail -1)\" >>${RESULTSPATH}/bu_pop2000_tile$TIL.csv
	echo \"${BU}|\$(r.univar --q -e -t map=ghs_pop_2015@CONRASTERS |tail -1)\" >>${RESULTSPATH}/bu_pop2015_tile$TIL.csv
	r.mask -r --q
	g.region -d --quiet
	exit
	" > ./dyn/process_bu_ghspop_${BU}.sh
	chmod u+x ./dyn/process_bu_ghspop_${BU}.sh
	grass ${TEMPORARY_MAPSET_PATH} --exec ./dyn/process_bu_ghspop_${BU}.sh

done
exit

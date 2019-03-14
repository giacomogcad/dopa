#!/bin/bash
# IMPORT VARIABLES

SHPDIR=$1
schema=$2
LIST_FILE=$3
TIL=$4
TILESIZE=$5
host=$6
user=$7
pw=$8
db=$9

dbpars="-h ${host} -u ${user} -P ${pw}"

mkdir -p ${SHPDIR}
for PA in $(cat ${LIST_FILE}|awk "NR >= (${TIL}+1) && NR <= (${TIL}+${TILESIZE})")
	do
	pgsql2shp -f ${SHPDIR}/${PA} ${dbpars} ${db} "SELECT * FROM ${schema}.${PA}"
done
exit

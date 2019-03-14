#!/bin/bash

echo " "
echo "---------------------------------------------------"
echo "- Script $(basename "$0") started at $(date)"
echo " "

# READ VARIABLES FROM CONFIGURATION FILE
SERVICEDIR="/globes/PROCESSING/WDPA/scripts/a0_servicefiles"
source ${SERVICEDIR}/wdpa_preprocessing.conf

# set local
LC_TIME=en_US.utf8

# SET DYNAMIC VARIABLES
y1=`date -d $wdpadate"01" +%Y`
m1=`date -d $wdpadate"01" +%m`

# SET DERIVED VARIABLES
dbpar="-h ${host} -U ${user} -d ${db}"
PA_LIST_FILE=${SERVICEDIR}/${pa_list}".txt"
PA_TC_LIST_FILE=${SERVICEDIR}/${pa_tc_list}".txt"
PA_MA_LIST_FILE=${SERVICEDIR}/${pa_ma_list}".txt"
BU_LIST_FILE=${SERVICEDIR}/${bu_list}".txt"
BU_TC_LIST_FILE=${SERVICEDIR}/${bu_tc_list}".txt"
BU_MA_LIST_FILE=${SERVICEDIR}/${bu_ma_list}".txt"

# CREATE SCHEMAS AND LISTS. EXPORTS LISTS IN .txt FILE
psql ${dbpar} -v paschema=${pa_schema} -v buschema=${bu_schema} -v wdpaschema=${wdpa_schema} -v vDATE=${y1}${m1} -f prepare_data_x_grass.sql

# psql ${dbpar} -c '\copy (SELECT * FROM '${pa_schema}'.list_pa) to '${PA_LIST_FILE}' with csv'
# psql ${dbpar} -c '\copy (SELECT * FROM '${pa_schema}'.list_pa_tc) to '${PA_TC_LIST_FILE}' with csv'
# psql ${dbpar} -c '\copy (SELECT * FROM '${pa_schema}'.list_pa_ma) to '${PA_MA_LIST_FILE}' with csv'
# psql ${dbpar} -c '\copy (SELECT * FROM '${bu_schema}'.list_bu) to '${BU_LIST_FILE}' with csv'
# psql ${dbpar} -c '\copy (SELECT * FROM '${bu_schema}'.list_bu_tc) to '${BU_TC_LIST_FILE}' with csv'
# psql ${dbpar} -c '\copy (SELECT * FROM '${bu_schema}'.list_bu_ma) to '${BU_MA_LIST_FILE}' with csv'

echo " "
echo "Schemas and lists for PAs and buffers created"
echo " "

# CREATE INDIVIDUAL VIEWS FOR PAs
for PA in $(cat ${PA_LIST_FILE})
    do
    echo "DROP VIEW IF EXISTS ${pa_schema}.${PA};
    CREATE VIEW ${pa_schema}.${PA} AS
            SELECT a.wdpaid,a.gname,a.geom
            FROM (SELECT wdpaid,'pa_'||wdpaid::text gname,geom FROM ${wdpa_schema}.wdpa_o20_${y1}${m1}) a
            WHERE a.gname='${PA}'
	"|psql ${dbpar} 
done

echo " "
echo "Individual views for PAs created"
echo " "

for BU in $(cat ${BU_LIST_FILE})
    do
    echo "DROP VIEW IF EXISTS ${bu_schema}.${BU};
    CREATE VIEW ${bu_schema}.${BU} AS
            SELECT a.wdpaid,a.gname,a.geom
            FROM (SELECT wdpaid,'bu_'||wdpaid::text gname,geom FROM ${wdpa_schema}.wdpa_o20_buffers_${y1}${m1}) a
            WHERE a.gname='${BU}'
	"|psql ${dbpar} 
done

echo " "
echo "Individual views for BUs created"
echo " "

finaldate=`date`
echo " "
echo "---------------------------------------------------"
echo "Data preparation chain completed at ${finaldate}"
echo " "




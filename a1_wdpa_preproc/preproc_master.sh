#!/bin/bash
# Runs sequence of scripts for pre-processing of WDPA data

SERVICEDIR="/globes/PROCESSING/WDPA/scripts/a0_servicefiles/"

echo " "
echo "This is the master script that will run a sequence of four different scripts aimed to:"
echo "	- import in PG database relevant WDPA data, clean and repair invalid geometries, create final wdpa and wdpa_o20 tables"
echo "	- create buffers on wdpa_o20"
echo "	- prepare data for grass: create schemas and individual views for PAs and buffers"
echo "	- export individual views in shapefiles and import shapefiles to GRASS database"
echo "	- project in Mollweide both Pas and BUs individual layers"
echo "	- if needed, import as external links all rasters required for analysis. "
echo "    		(N.B. This step is needed only the first time, or when one or more rasters are changed)"
echo " "
echo "$(tput setaf 3)CAUTION: All variables and settings are controlled by wdpa_preprocessing.conf. Check/Edit it before running this script."
echo "$(tput setaf 7) "

read -p "Do you want to run the script now? (y/n) " -n 1 -r
echo " "
if [[ $REPLY =~ ^[Yy]$ ]]
then
	source ${SERVICEDIR}wdpa_preprocessing.conf
	echo " "
	echo "-----------------------------------------------------"
	echo "Master Script started at $(date)"
    echo " "
	echo "Now running exec_wdpa_preprocessing.sh..."
	#./exec_wdpa_preprocessing.sh >${LOGPATH}/log1_wdpa_preprocessing.log 2>&1
	wait
	echo " "
	echo "...completed"
    echo " "
	echo "Now running exec_buffers_processing.sh..."
	#./exec_buffers_processing.sh >${LOGPATH}/log2_buffers_processing.log 2>&1
	wait
	echo " "
	echo "...completed"
    echo " "
	echo "Now running exec_prepare_data_x_grass.sh..."
	#./exec_prepare_data_x_grass.sh >${LOGPATH}/log3_prepare_data_x_grass.log 2>&1
	wait
	echo " "
	echo "...completed"
    echo " "
	echo "Now running exec_make_flat.sh..."
	#./exec_make_flat.sh >${LOGPATH}/log4_make_flat.log 2>&1
	wait
	echo " "
	echo "...completed"
    echo " "
	echo "Now running exec_pg_to_grass.sh..."
	./exec_pg_to_grass.sh >${LOGPATH}/log5_pg_to_grass.log 2>&1
	wait
	echo " "
	echo "...completed"
    echo " "
	echo "Now running exec_project_pa_bu.sh..."
	./exec_project_pa_bu.sh >${LOGPATH}/log6_project_pa_bu.log 2>&1
	wait
	echo " "
	echo "...completed"
    echo " "
	echo "Now running exec_link_rasters.sh..."
	#./exec_link_rasters.sh >${LOGPATH}/log7_link_rasters.log 2>&1
	echo "...completed"
	echo " "
	echo " "
	echo "-----------------------------------------------------"
	echo "Master Script ended at $(date)"
else 
	echo " "
	echo "Ok, see you soon (macchitesen...)"
	echo " "
fi

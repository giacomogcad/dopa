# dopa


a1_wdpa_preproc: execute scripts respecting the following sequence:

	exec_wdpa_preprocessing.sh
	exec_buffers_processing.sh
	exec_prepare_data_x_grass.sh
	exec_make_flat.sh
	exec_pg_to_grass.sh
	exec_project_pa_bu.sh
	exec_link_rasters.sh (to be run only on new GRASS Databases)

a2_wdpa_proc: execute scripts in free sequence to perform raster analysis, as needed
	
a3_wdpa_postproc:	execute scripts respecting the following sequence:

	exec_step0_creates_schemas.sh
	all other scripts in free sequence, as needed

	

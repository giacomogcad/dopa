# WDPA processing workflow

The scripts included in this folder runb the analysis of thematic rasters for most of the DOAP indicators.
The script name describe which dataset is analyzed. When possible (i.e. when resolution and bounding coordinates are the same), rasters have been grouped in order to optimize the processing.

For each dataset, the analysis is performed in parallel using the n. of cores specified in the configuration file  **wdpa_postprocessing.conf**.
For each dataset, the master script (exec_xxxxxxxxxxx.sh) executes the corresponding slave script (slave_xxxxxxxxx.sh)


## Prerequisites
In order to run successfully, the workflow requires the followings:

1. a GRASS database with two locations (one in latlong and one in Mollweide) must exist.

2. all the steps of the workflow included in the folder a1_wdpa_preproc must be run.


## Notes
- All parameters used by scripts are stored in the configuration file **wdpa_postprocessing.conf**. It has to be checked/edited before running the scripts.



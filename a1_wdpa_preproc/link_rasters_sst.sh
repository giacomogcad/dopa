#!/bin/bash

# set variables
ORIGDATA=$1

## CREATE AND ACCESS MAPSET
g.mapset --q -c --overwrite mapset=SST

##SET REGION AND RESOLUTION
g.region e=180 w=-180 s=-90 n=90 res=0:15:00

## IMPORT netCDF file in GRASS 
## N.B. pixel values are in Celsius degrees x 100 (as integer)
r.in.gdal -o --quiet --overwrite input=NETCDF:${ORIGDATA}"/MARINE_SST/archives/METOFFICE-GLO-SST-L4-NRT-OBS-SST-MON-V2_1512550516396.nc":analysed_sst output=sst num_digits=3

## CREATE TEMPORAL DATABASE 
t.create --quiet --overwrite temporaltype=absolute output=sst_mean semantictype=mean title="Mean Monthly Sea Surface temperature" description="Dataset with monthly SST"

##REGISTER RASTERS IN TEMPORAL DATABASE
t.register --quiet -i type=raster input=sst_mean@SST maps=`g.list raster pattern="sst*" sep=comma` start=2007-01-15 increment="1 months"

## LIST TEMPORAL DB ENTRIES
t.rast.list input=sst_mean@SST

##COMPUTE MONTHLY AVERAGES
for MONTH in $(eval echo {01..12})
	do
	t.rast.series --o input=sst_mean method=average output="sst_avg_${MONTH}" where="strftime('%m', start_time)='${MONTH}'"
	t.rast.series --o input=sst_mean method=maximum output="sst_max_${MONTH}" where="strftime('%m', start_time)='${MONTH}'"
	t.rast.series --o input=sst_mean method=minimum output="sst_min_${MONTH}" where="strftime('%m', start_time)='${MONTH}'"
done


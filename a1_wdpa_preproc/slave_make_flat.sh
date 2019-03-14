#!/bin/bash

## Set variables
wdpa=$1

# ## SET AND SAVE REGIONS

# g.region -u --overwrite e=-135 w=-180 s=45 n=90 res=0:00:03 save=region1
# wait
# g.region -u --overwrite e=-90 w=-135 s=45 n=90 res=0:00:03 save=region2
# wait
# g.region -u --overwrite e=-45 w=-90 s=45 n=90 res=0:00:03 save=region3
# wait
# g.region -u --overwrite e=0 w=-45 s=45 n=90 res=0:00:03 save=region4
# wait
# g.region -u --overwrite e=45 w=0 s=45 n=90 res=0:00:03 save=region5
# wait
# g.region -u --overwrite e=90 w=45 s=45 n=90 res=0:00:03 save=region6
# wait
# g.region -u --overwrite e=135 w=90 s=45 n=90 res=0:00:03 save=region7
# wait
# g.region -u --overwrite e=180 w=135 s=45 n=90 res=0:00:03 save=region8
# wait
# g.region -u --overwrite e=-135 w=-180 s=0 n=45 res=0:00:03 save=region9
# wait
# g.region -u --overwrite e=-90 w=-135 s=0 n=45 res=0:00:03 save=region10
# wait
# g.region -u --overwrite e=-45 w=-90 s=0 n=45 res=0:00:03 save=region11
# wait
# g.region -u --overwrite e=0 w=-45 s=0 n=45 res=0:00:03 save=region12
# wait
# g.region -u --overwrite e=45 w=0 s=0 n=45 res=0:00:03 save=region13
# wait
# g.region -u --overwrite e=90 w=45 s=0 n=45 res=0:00:03 save=region14
# wait
# g.region -u --overwrite e=135 w=90 s=0 n=45 res=0:00:03 save=region15
# wait
# g.region -u --overwrite e=180 w=135 s=0 n=45 res=0:00:03 save=region16
# wait
# g.region -u --overwrite e=-135 w=-180 s=-45 n=0 res=0:00:03 save=region17
# wait
# g.region -u --overwrite e=-90 w=-135 s=-45 n=0 res=0:00:03 save=region18
# wait
# g.region -u --overwrite e=-45 w=-90 s=-45 n=0 res=0:00:03 save=region19
# wait
# g.region -u --overwrite e=0 w=-45 s=-45 n=0 res=0:00:03 save=region20
# wait
# g.region -u --overwrite e=45 w=0 s=-45 n=0 res=0:00:03 save=region21
# wait
# g.region -u --overwrite e=90 w=45 s=-45 n=0 res=0:00:03 save=region22
# wait
# g.region -u --overwrite e=135 w=90 s=-45 n=0 res=0:00:03 save=region23
# wait
# g.region -u --overwrite e=180 w=135 s=-45 n=0 res=0:00:03 save=region24
# wait
# g.region -u --overwrite e=-135 w=-180 s=-90 n=-45 res=0:00:03 save=region25
# wait
# g.region -u --overwrite e=-90 w=-135 s=-90 n=-45 res=0:00:03 save=region26
# wait
# g.region -u --overwrite e=-45 w=-90 s=-90 n=-45 res=0:00:03 save=region27
# wait
# g.region -u --overwrite e=0 w=-45 s=-90 n=-45 res=0:00:03 save=region28
# wait
# g.region -u --overwrite e=45 w=0 s=-90 n=-45 res=0:00:03 save=region29
# wait
# g.region -u --overwrite e=90 w=45 s=-90 n=-45 res=0:00:03 save=region30
# wait
# g.region -u --overwrite e=135 w=90 s=-90 n=-45 res=0:00:03 save=region31
# wait
# g.region -u --overwrite e=180 w=135 s=-90 n=-45 res=0:00:03 save=region32
# wait

echo "Regions created"

## CONVERT WDPA TO RASTER TILES

WIND_OVERRIDE=region1 v.to.rast --overwrite input=${wdpa} output=wdpa_tile_1 use=val memory=1024 &
sleep 2s
WIND_OVERRIDE=region2 v.to.rast --overwrite input=${wdpa} output=wdpa_tile_2 use=val memory=1024 &
sleep 2s
WIND_OVERRIDE=region3 v.to.rast --overwrite input=${wdpa} output=wdpa_tile_3 use=val memory=1024 &
sleep 2s
WIND_OVERRIDE=region4 v.to.rast --overwrite input=${wdpa} output=wdpa_tile_4 use=val memory=1024 &
sleep 2s
WIND_OVERRIDE=region5 v.to.rast --overwrite input=${wdpa} output=wdpa_tile_5 use=val memory=1024 &
sleep 2s
WIND_OVERRIDE=region6 v.to.rast --overwrite input=${wdpa} output=wdpa_tile_6 use=val memory=1024 &
sleep 2s
WIND_OVERRIDE=region7 v.to.rast --overwrite input=${wdpa} output=wdpa_tile_7 use=val memory=1024 &
sleep 2s
WIND_OVERRIDE=region8 v.to.rast --overwrite input=${wdpa} output=wdpa_tile_8 use=val memory=1024 &
sleep 2s
WIND_OVERRIDE=region9 v.to.rast --overwrite input=${wdpa} output=wdpa_tile_9 use=val memory=1024 &
sleep 2s
WIND_OVERRIDE=region10 v.to.rast --overwrite input=${wdpa} output=wdpa_tile_10 use=val memory=1024 &
sleep 2s
WIND_OVERRIDE=region11 v.to.rast --overwrite input=${wdpa} output=wdpa_tile_11 use=val memory=1024 &
sleep 2s
WIND_OVERRIDE=region12 v.to.rast --overwrite input=${wdpa} output=wdpa_tile_12 use=val memory=1024 &
sleep 2s
WIND_OVERRIDE=region13 v.to.rast --overwrite input=${wdpa} output=wdpa_tile_13 use=val memory=1024 &
sleep 2s
WIND_OVERRIDE=region14 v.to.rast --overwrite input=${wdpa} output=wdpa_tile_14 use=val memory=1024 &
sleep 2s
WIND_OVERRIDE=region15 v.to.rast --overwrite input=${wdpa} output=wdpa_tile_15 use=val memory=1024 &
sleep 2s
WIND_OVERRIDE=region16 v.to.rast --overwrite input=${wdpa} output=wdpa_tile_16 use=val memory=1024 &
sleep 2s
WIND_OVERRIDE=region17 v.to.rast --overwrite input=${wdpa} output=wdpa_tile_17 use=val memory=1024 &
sleep 2s
WIND_OVERRIDE=region18 v.to.rast --overwrite input=${wdpa} output=wdpa_tile_18 use=val memory=1024 &
sleep 2s
WIND_OVERRIDE=region19 v.to.rast --overwrite input=${wdpa} output=wdpa_tile_19 use=val memory=1024 &
sleep 2s
WIND_OVERRIDE=region20 v.to.rast --overwrite input=${wdpa} output=wdpa_tile_20 use=val memory=1024 &
sleep 2s
WIND_OVERRIDE=region21 v.to.rast --overwrite input=${wdpa} output=wdpa_tile_21 use=val memory=1024 &
sleep 2s
WIND_OVERRIDE=region22 v.to.rast --overwrite input=${wdpa} output=wdpa_tile_22 use=val memory=1024 &
sleep 2s
WIND_OVERRIDE=region23 v.to.rast --overwrite input=${wdpa} output=wdpa_tile_23 use=val memory=1024 &
sleep 2s
WIND_OVERRIDE=region24 v.to.rast --overwrite input=${wdpa} output=wdpa_tile_24 use=val memory=1024 &
sleep 2s
WIND_OVERRIDE=region25 v.to.rast --overwrite input=${wdpa} output=wdpa_tile_25 use=val memory=1024 &
sleep 2s
WIND_OVERRIDE=region26 v.to.rast --overwrite input=${wdpa} output=wdpa_tile_26 use=val memory=1024 &
sleep 2s
WIND_OVERRIDE=region27 v.to.rast --overwrite input=${wdpa} output=wdpa_tile_27 use=val memory=1024 &
sleep 2s
WIND_OVERRIDE=region28 v.to.rast --overwrite input=${wdpa} output=wdpa_tile_28 use=val memory=1024 &
sleep 2s
WIND_OVERRIDE=region29 v.to.rast --overwrite input=${wdpa} output=wdpa_tile_29 use=val memory=1024 &
sleep 2s
WIND_OVERRIDE=region30 v.to.rast --overwrite input=${wdpa} output=wdpa_tile_30 use=val memory=1024 &
sleep 2s
WIND_OVERRIDE=region31 v.to.rast --overwrite input=${wdpa} output=wdpa_tile_31 use=val memory=1024 &
sleep 2s
WIND_OVERRIDE=region32 v.to.rast --overwrite input=${wdpa} output=wdpa_tile_32 use=val memory=1024 

wait

echo "WDPA tiles rasterized"

## PATCHES WDPA TILES
echo "now patching tiles..."
g.region e=180 w=-180 s=-90 n=90 res=0:00:03
r.patch -z --overwrite input=wdpa_tile_1,wdpa_tile_2,wdpa_tile_3,wdpa_tile_4,wdpa_tile_5,wdpa_tile_6,wdpa_tile_7,wdpa_tile_8,wdpa_tile_9,wdpa_tile_10,wdpa_tile_11,wdpa_tile_12,wdpa_tile_13,wdpa_tile_14,wdpa_tile_15,wdpa_tile_16,wdpa_tile_17,wdpa_tile_18,wdpa_tile_19,wdpa_tile_20,wdpa_tile_21,wdpa_tile_22,wdpa_tile_23,wdpa_tile_24,wdpa_tile_25,wdpa_tile_26,wdpa_tile_27,wdpa_tile_28,wdpa_tile_29,wdpa_tile_30,wdpa_tile_31,wdpa_tile_32, output=wdpa_flat
echo "WDPA flat created"
date
exit

#!/bin/bash
##IMPORT BUFFERS AND ERASE PROTECTED PART 

BU=$1
SHPDIR_BU=$2
BU_MAPSET_PATH=$3
FLAT=$4

echo "#!/bin/bash
#Processing BU $BU
v.in.ogr --quiet --overwrite -o -t input=${SHPDIR_BU}/${BU}.shp output=${BU%} key=wdpaid
g.region --quiet vector=${BU} align=${FLAT} res=0:00:03
r.mask --overwrite vector=${BU}
r.mapcalc expression=\"be_${BU}=(if(isnull(${FLAT}),1,null()))*MASK\" --overwrite
#g.remove type=vector name=${BU} -f
r.to.vect --overwrite -t input=be_${BU} output=${BU} type=area
g.remove type=raster name=be_${BU} -f
r.mask -r
"  > ./dyn/unprot_buffer.sh
chmod u+x ./dyn/unprot_buffer.sh
grass ${BU_MAPSET_PATH} --exec ./dyn/unprot_buffer.sh
exit

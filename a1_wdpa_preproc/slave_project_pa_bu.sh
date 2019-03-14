#!/bin/bash
# set variables
PA=$1
LOCATION_LL=$2
MAPSET=$3
MAPSET_PATH=$4

## PROJECT INDIVIDUAL PROTECTED AREAS IN MOLLWEIDE
echo "#!/bin/bash
## REPROJECT IN MOLLWEIDE INDIVIDUAL PAs
v.proj --overwrite --quiet location=${LOCATION_LL} mapset=${MAPSET} input=${PA} output=${PA}
exit
"  > ./dyn/project_mo.sh
chmod u+x ./dyn/project_mo.sh
grass ${MAPSET_PATH} --exec ./dyn/project_mo.sh
exit

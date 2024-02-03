#!/bin/bash

###-----------------------This is for using condor without passing to a /tmp folder-------------###

for d in $(cat label.txt)
do
cd $d

cp ../file.input .
cp ../pressures.csv .

cp file.input simulation.input

# Name of MOF
for f in *.cif
do
  mof=${f%%.*}
done

# first read the unit cell parameters from the corresponding cif file
python3 unitcell.py

cella=$(awk '{print $1}' cif_output.txt)
cellb=$(awk '{print $2}' cif_output.txt)
cellc=$(awk '{print $3}' cif_output.txt)

# Replacing the place holders
sed -i 's/FFF/'${mof}'/' simulation.input
sed -i 's/UCA/'${cella}'/' simulation.input
sed -i 's/UCB/'${cellb}'/' simulation.input
sed -i 's/UCC/'${cellc}'/' simulation.input


one=1
FILE='pressures.csv'

for ((i=1;i<=19;i++))
do
Row=$[ $i + $one ]
Pres=$(awk 'FNR=='$Row' {print $1}' pressures.csv)
mkdir $i
cd $i
#echo $Pres
cp ../../condor.sh ../../raspa.sh ../*.cif ../simulation.input .
sed -i 's/INDEX/'${i}'/' condor-sh
sed -i 's/INDEX/'${i}'/' raspa.sh
sed -i 's/FFF/'${mof}'/' raspa.sh
sed -i 's/FFF/'${mof}'/' condor-sh
sed -i 's/CCC/'${mof}'/' condor-sh
sed -i 's/XXX/'${Pres}'/' simulation.input

condor_submit condor-sh
cd ..
done
cd ..
done

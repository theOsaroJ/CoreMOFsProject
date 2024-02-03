#!/bin/bash
#$ -q hpc@@colon
#$ -N Extracts
#$ -pe smp 32

for k in $(cat label.txt)
do
cd $k

#Removing the folder
if [[ -d Results ]]; then
rm -rf Results
fi

#Creating a folder to store all output files
mkdir Results

#Entering into each folder to take the output file out
for ((i=1;i<=19;i++))
do
cd $i
if [[ -d Output ]]; then
cd Output/System_0
cp output* ../../../Results
else
cd ..
continue
fi
cd ../../../
done

#Using my famous extracting script haha!
cd Results
grep -F 'Average loading absolute [cm^3 (STP)/gr framework]' *.data > sampleAd.txt
grep -F 'Partial pressure' *.data> samplePr.txt


#Awking the pipe to get values
awk -F' ' '{print $4}' samplePr.txt > Pres
awk -F' ' '{print $8}' sampleAd.txt > upt
awk -F' ' '{print $10}' sampleAd.txt > err


#Pasting to a new csv file
echo -e "Pressure,Uptake,Error" > Finaldata.csv
paste Pres upt err -d"," >> Finaldata.csv

sort -n Finaldata.csv > CompleteData.csv

#Removing some unwanted files and the created folder.
rm sampleAd.txt samplePr.txt Pres upt err Finaldata.csv
mv *CompleteData.csv ../
cd ..
mv CompleteData.csv $k.csv

rm -rf Results
cd ../
done

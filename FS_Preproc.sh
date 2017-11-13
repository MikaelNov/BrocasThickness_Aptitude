#!/bin/bash
#Takes data directory and subject identifier as  and produces T1/PD-images.
DATA_DIR=$1
subj=$2
cd $DATA_DIR

fslmaths ${subj}_PDGRE1.nii.gz -thr 1000 ${subj}_PDGRE1.nii.gz
flirt -in ${subj}_PDGRE1.nii.gz -ref ${subj}_T1MPRAGE1.nii.gz -omat PD2T1.mat -dof 6  -out ${subj}_PDGRE1.nii.gz
fslmaths ${subj}_T1MPRAGE1.nii.gz -div ${subj}_PDGRE1.nii.gz ${subj}_T1divPD.nii.gz
fslmaths ${subj}_T1divPD.nii.gz -mul 100000 ${subj}_T1divPD.nii.gz
#Run Matlab script setMaxVoxelIntensity
mystring="matlab -nodisplay -r \"setMaxVoxelIntensity('${DATA_DIR}','${subj}'); exit;\""
eval $mystring 
bet ${subj}_T1MPRAGE1.nii.gz ${subj}_T1MPRAGE1_brain -f 0.25 -g 0.2 -m
fslmaths ${subj}_T1divPD_imp.nii.gz -mul ${subj}_T1MPRAGE1_brain_mask.nii.gz ${subj}_T1divPD_brain
echo "Check brainmask output in separate terminal. Modify if needed."

#!/bin/sh
#Freesurfer analysis script for SLURM based computer cluster.
#Input is already brain extracted using FSL BET.

# document this script to stdout (assumes redirection from caller)
cat $0

# receive my worker number
export WRK_NB=$((100+$1))

# create worker-private subdirectory in $SNIC_TMP
export WRK_DIR=$SNIC_TMP/WRK_${WRK_NB}
mkdir $WRK_DIR

# create a variable to address the "job directory"
export JOB_DIR=${SLURM_SUBMIT_DIR}
cd $JOB_DIR

# now copy the input data and program from there
cp -pr ${WRK_NB}* $WRK_DIR
cd $WRK_DIR
module add FreeSurfer

subj=${WRK_NB}

export SUBJECTS_DIR=$WRK_DIR

recon-all -autorecon1 -noskullstrip -i ${WRK_NB}_T1divPD_brain.nii.gz -s ${subj}
cp ${WRK_DIR}/${subj}/mri/T1.mgz ${WRK_DIR}/${subj}/mri/brainmask.auto.mgz
cp ${WRK_DIR}/${subj}/mri/T1.mgz ${WRK_DIR}/${subj}/mri/brainmask.mgz
recon-all -autorecon2 -autorecon3 -s ${subj}

cp -pfr ${WRK_NB} ${JOB_DIR}
cd $SNIC_TMP
rm -rf WRK_${WRK_NB}

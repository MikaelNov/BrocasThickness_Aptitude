function setMaxVoxelIntensity(subj)
%Set all voxels with higher intensity than maxInten to maxInten
%Designed to fix intensity of T1 divided by PD MRI images. 
%Assumes a software for reading and writing NIfTI files such as
#https://se.mathworks.com/matlabcentral/fileexchange/8797-tools-for-nifti-and-analyze-image

datadir=strcat('/Users/ling-men/Documents/MRData/HT17_7T018/',subj);
addpath('NIfTI_20140122')
maxInten=10000000;
inImage=strcat(datadir,'/',subj,'_T1divPD.nii.gz');
brain=load_untouch_nii(inImage);
imSize=size(brain.img);
for i = 1:imSize(1)
    for j = 1:imSize(2)
        for k = 1:imSize(3)
            if brain.img(i,j,k)>maxInten
                brain.img(i,j,k)=maxInten;
            end
        end
    end
end
save_untouch_nii(brain, strcat(datadir,'/',subj,'_T1divPD_imp.nii.gz'))
end
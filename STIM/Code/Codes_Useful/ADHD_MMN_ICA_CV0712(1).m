
%%%�زο�&ica
eeglab;




filename='NAME_TD_MMN3.txt';
fidid = fopen(filename,'r');
NN=8;%���Ը���
for i=1:NN
name = fgetl(fidid);
filepath='F:\��Ժ\ADHD\TD_data_analysis\';
file=[name,'_sd.set'];
savename=[name,'_ica.set'];
savepath='F:\��Ժ\ADHD\TD_data_analysis\';
save=[savepath,savename];

EEG = pop_loadset('filename',file,'filepath',filepath);
EEG = eeg_checkset( EEG );
EEG = pop_reref( EEG, [52 88] );
EEG = eeg_checkset( EEG );
EEG = pop_runica(EEG,'pca',30,'interupt','on');
EEG = eeg_checkset( EEG );
EEG = pop_saveset( EEG, 'filename',savename,'filepath',savepath);
EEG = eeg_checkset( EEG );
end



filename='NAME_TD_EXP1.txt';
fidid = fopen(filename,'r');
NN=8;%���Ը���
for i=1:NN
name = fgetl(fidid);
filepath='F:\��Ժ\ADHD\TD_data_analysis\';
file=[name,'_sd.set'];
savename=[name,'_ica.set'];
savepath='F:\��Ժ\ADHD\TD_data_analysis\';
save=[savepath,savename];

EEG = pop_loadset('filename',file,'filepath',filepath);
EEG = eeg_checkset( EEG );
EEG = pop_reref( EEG, [52 88] );
EEG = eeg_checkset( EEG );
EEG = pop_runica(EEG,'pca',30,'interupt','on');  % ica��30���ɷ־Ϳ�����
EEG = eeg_checkset( EEG );
EEG = pop_saveset( EEG, 'filename',savename,'filepath',savepath);
EEG = eeg_checkset( EEG );
end


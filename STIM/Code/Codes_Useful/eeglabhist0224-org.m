


EEG = pop_loadset('filename','sub1_mmn3_ica.set','filepath','D:\\认知神经\\毕设\\eeglab\\');
EEG = eeg_checkset( EEG );
pop_topoplot(EEG, 0, [1:30] ,'sub1_mmn3_marker resampled',[5 6] ,0,'electrodes','off');
EEG = pop_subcomp( EEG, [16], 0);
EEG = eeg_checkset( EEG );
EEG = pop_saveset( EEG, 'filename','sub1_mmn3_pre.set','filepath','D:\\认知神经\\毕设\\eeglab\\');
EEG = eeg_checkset( EEG );

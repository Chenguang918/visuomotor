%% 手动去伪迹前
%

%%
%%%EXP1
%clear all
eeglab;

filename='NAME_TD_EXP1.txt';
fidid = fopen(filename,'r');
NN=2;%被试个数
for i=1:NN
name = fgetl(fidid);
filepath='F:\六院\ADHD\TD_MMN_withmarker\';
file=[name,'_marker.set'];
savename=[name,'_before_sd.set'];
savepath='F:\六院\ADHD\TD_data_analysis\';
save=[savepath,savename];
EEG = pop_loadset('filename',file,'filepath',filepath);
%%%加一个电极（Cz)
z=zeros(1,size((EEG.data),2));
EEG.data=[EEG.data;z];
EEG.nbchan=EEG.nbchan+1;
EEG.chanlocs(129)= EEG.chanlocs(1);
EEG.urchanlocs(129)=EEG.urchanlocs(1);

%%%
EEG = pop_resample( EEG, 250);
EEG = eeg_checkset( EEG );
EEG = pop_eegfiltnew(EEG, 0.5,30,1650,0,[],0);
EEG = eeg_checkset( EEG );
EEG=pop_chanedit(EEG, 'load',{'F:\\GSN-HydroCel-129.sfp' 'filetype' 'autodetect'});
EEG = eeg_checkset( EEG );
EEG = pop_select( EEG,'nochannel',{'E17' 'E43' 'E48' 'E49' 'E56' 'E63' 'E68' 'E73' 'E81' 'E88' 'E94' 'E99' 'E107' 'E113' 'E119' 'E120' 'E125' 'E126' 'E127' 'E128'});
EEG = eeg_checkset( EEG );
EEG = pop_saveset( EEG, 'filename',savename,'filepath',savepath);
end

%%
%%%MMN3
clear all
eeglab;

filename='NAME_TD_MMN3.txt';
fidid = fopen(filename,'r');
NN=8;%被试个数
for i=1:NN
name = fgetl(fidid);
filepath='F:\六院\ADHD\TD_MMN_withmarker\';
file=[name,'_marker.set'];
savename=[name,'_before_sd.set'];
savepath='F:\六院\ADHD\TD_data_analysis\';
save=[savepath,savename];
EEG = pop_loadset('filename',file,'filepath',filepath);
%%%加一个电极（Cz)
z=zeros(1,size((EEG.data),2));
EEG.data=[EEG.data;z];
EEG.nbchan=EEG.nbchan+1;
EEG.chanlocs(129)= EEG.chanlocs(1);
EEG.urchanlocs(129)=EEG.urchanlocs(1);

%%%
EEG = pop_resample( EEG, 250);
EEG = eeg_checkset( EEG );
EEG = pop_eegfiltnew(EEG, 0.5,30,1650,0,[],0);
EEG = eeg_checkset( EEG );
EEG=pop_chanedit(EEG, 'load',{'F:\\GSN-HydroCel-129.sfp' 'filetype' 'autodetect'});
EEG = eeg_checkset( EEG );
EEG = pop_select( EEG,'nochannel',{'E17' 'E43' 'E48' 'E49' 'E56' 'E63' 'E68' 'E73' 'E81' 'E88' 'E94' 'E99' 'E107' 'E113' 'E119' 'E120' 'E125' 'E126' 'E127' 'E128'});
EEG = eeg_checkset( EEG );
EEG = pop_saveset( EEG, 'filename',savename,'filepath',savepath);
end


%%%手动去伪迹&补导



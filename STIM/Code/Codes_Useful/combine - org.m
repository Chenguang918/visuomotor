Subject = 'sub210_exp1';
in_data=textread([Subject,'.evt'],'%s','whitespace','\n');
    j=0;
    out_data=9.*ones((size(in_data,1)-3),1);
    for i=4:size(in_data)
        EventType=strread(cell2mat(in_data(i)),'%s','whitespace','\t');
        j=j+1;
        switch cell2mat(EventType(1))
            case 'Fix+'%%%%exp1
                out_data(j)=8;
            case 'Sti+'%%%%exp1
                out_data(j)=str2num(cell2mat(EventType(6)));
            case 'TRSP'
                out_data(j)=str2num(cell2mat(EventType(12)))+99;
        end
        
    end
    dlmwrite([Subject,'.txt'],out_data,'precision','%10.0f','delimiter','\n');
    %% Edit event to .raw
    EEG = pop_readegi([Subject '.raw'], [],[],'auto');
    EEG.setname=Subject;
    EEG=pop_chanedit(EEG, 'load',{[Parameterfolder '\GSN-HydroCel-128.sfp'] 'filetype' 'autodetect'},'delete',1,'delete',1,'delete',1);
    EEG = eeg_checkset( EEG );
    clear markEvent
    markEvent=load([Subject,'.txt']);
    j=1;
    EpocEvent=struct('type',[],'latency',[],'urevent',[]);
    for i=1:length(EEG.event)
        if strcmp(EEG.event(1,i).type, 'epoc')
            EventType='boundary';
            %j=j+1;
        else
            EventType=num2str(markEvent(j));
            j=j+1;
        end
        latency=EEG.event(1,i).latency;
        urevent=EEG.event(1,i).urevent;
        EpocEvent(1,i)=struct('type',EventType,'latency',latency,'urevent',urevent);
    end
    EEG.event=EpocEvent;
    EEG = eeg_checkset( EEG );
    EEG = pop_saveset( EEG, 'filename',[Subject '.set']);
    EEG = eeg_checkset( EEG );
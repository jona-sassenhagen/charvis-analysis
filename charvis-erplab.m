eeglab;

subjects = {'01' '02' '03' '04' '05' '07' '08' '09' '10' '11' '12' '13' '14' '16' '17' '18' '19' '20' '21' '22'};

% initiate main loop
for subject = 1:length(subjects)

% set variables

% set current subj number
	subj = subjects{subject};

% set file to steal ICA from (output of preproc script)
	language = ['charvis_',subj,'.set'];
	face = ['charvisp3_',subj,'.set'];


% target .erp file
	erpname = ['~/Desktop/charvis/erplab/charvis_',num2str(subject),'.erp']

% raw file input
	%sourcefile = ['~/Desktop/charvis/charvis_',subj,'.vhdr']

% binlist
    binlist = '~/Desktop/charvis/scripts/analysis/charvis-binlist_2.txt'

%clear memory
STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];

% load preproc'd file to steal ICA
EEG = pop_loadset(  'filename',language,'filepath','~/Desktop/charvis/pre3');
EEG=pop_subcomp(EEG,[EEG.blinks EEG.saccades]);

%EEG2 = pop_loadset(  'filename',face,'filepath','~/Desktop/charvis/pre3');
%EEG2=pop_subcomp(EEG2,[EEG2.blinks EEG2.saccades]);

%EEG = pop_mergeset( EEG, EEG2, 0);
%clear EEG2;

% ERPLAB standard preproc
EEG  = pop_creabasiceventlist( EEG , 'AlphanumericCleaning', 'on', 'Eventlist', '/tmp/tmp.txt', 'Newboundary', { -999 }, 'Stringboundary', { 'boundary' } );
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'overwrite','on','gui','off'); 

% read in bin list and create bin structure
% the bin file tells the script to create 3 bins, containing trials after syntactic, semantic and control noun onsets, if they are followed by a correct response within 2.5 s
% make sure binlist-rt is in the right place!
EEG  = pop_binlister( EEG , 'BDF', binlist, 'ExportEL', '/tmp/tmp.txt', 'ImportEL', 'no',  'SendEL2', 'EEG&Text' );
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);

% epoch bins
EEG = pop_epochbin( EEG , [-500.0  2000.0],  'pre');
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'overwrite','on','gui','off'); 


% rough artefact correction
EEG  = pop_artextval( EEG , 'Channel',  1:62, 'Flag',  1, 'Review', 'off', 'Threshold', [ -100 100], 'Twindow', [ 0 1500] );

% create ERP files and save
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'overwrite','on','gui','off'); 
ERP = pop_averager( EEG , 'Criterion', 'good', 'DSindex',1, 'Stdev', 'on', 'Warning', 'on' );

ERP = pop_binoperator( ERP, {'nb1= (b1+b4+b7)/3 label Syntax' 'nb2= (b2+b5+b8)/3 label Semantics' 'nb3= (b3+b6+b9)/3 label Control'}); 


ERP = pop_savemyerp(ERP, 'erpname', subj, 'filename', erpname);

end;

exit;


% 7 38 27 8 22 23 11 52 21 13 12 18
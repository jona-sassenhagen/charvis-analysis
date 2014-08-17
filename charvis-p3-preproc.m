eeglab;

% Preprocessing Charvis

subjects = {'01' '02' '03' '04' '05' '06' '07' '08' '09' '10' '11' '12' '13' '14' '15' '16' '17' '18' '19' '20' '21' '22' };	% might change if and only if any subjects have to be excluded

subjects = {'01' '02' '03' '22'}

for subject = 1:length(subjects)

 % set variables
 % set # of current subj
	subj = subjects{subject};
amicadir = ['/home/jona/amicaouttmp/'];
 % set filename of output file
	set = ['~/Desktop/charvis/pre2/charvisp3_',num2str(subj),'.set'];
 % set filename for raw input file; point to appropriate location of raw files
	sourcefile = ['~/Desktop/charvis/charvisp3',subj,'.vhdr']

	% load raw file
	EEG = pop_fileio(sourcefile);

	EEG = pop_select(EEG,'nochannel',[65 66]);

	% Set up channel config
%	% EEG=pop_chanedit(    ); 	% depends on channel configuration! Cannot be decided before we know the exact output of ActiCHamp.
					% but generally, consists of adding the reference electrode and loading channel locations from EEGLAB defaults
%	EEG=pop_chanedit(EEG, 'append',EEG.nbchan,'changefield',{EEG.nbchan+1 'labels' 'A2'},'setref',{'1:EEG.nbchan' 'A2'},'lookup','/home/jona/eeglab/plugins/dipfit2.2/standard_BESA/standard-10-5-cap385.elp');

%	EEG = pop_reref( EEG, [],'refloc',struct('labels',{'A2'},'type',{''},'theta',{90},'radius',{0.75},'X',{3.6803e-15},'Y',{-60.1041},'Z',{-60.1041},'sph_theta',{-90},'sph_phi',{-45},'sph_radius',{85},'urchan',{17},'ref',{''},'datachan',{0})); % reref to average and reconstruct old ref; depends on chan config!

	EEG = pop_eegfiltnew(EEG, 0,40);
	EEG = pop_resample( EEG, 100);

	% filter (low pass to increase stationarity for ICA ... is high pass necessary?)
	EEG = pop_eegfiltnew(EEG, 1,0);
	EEG = pop_reref( EEG, [10 21]);


	% resample to save space

	% EEG = pop_epoch( EEG, {  'S210'  'S211'  'S212'  'S220'  'S221'  'S222'  'S223'  'S224'  'S230'  'S231'  'S232'  'S233'  'S234' 'S196' }, [-0.5  1.5], 'newname', 'charvis-01 resampled epochs', 'epochinfo', 'yes');


	% run AMICA; reject data 5 times for the purpose of analysis only
	[ EEG.icaweights, EEG.icasphere, mods ] = runamica12( EEG.data(:,:), 'do_reject',1,'numrej',5,'outdir',amicadir,'numprocs',8);

	% AMICA was applied to filtered data to speed up the process, now we load raw data again and apply the weights
	EEG = pop_fileio(sourcefile);
	EEG = pop_select(EEG,'nochannel',[65 66]);
	EEG = pop_eegfiltnew(EEG, 0,40);
	EEG = pop_resample( EEG, 100);
	EEG = pop_eegfiltnew(EEG, 0.1,0);


	% Set up channel config
	EEG=pop_chanedit(EEG, 'lookup','/home/jona/eeglab/plugins/dipfit2.2/standard_BESA/standard-10-5-cap385.elp');


	EEG = pop_reref( EEG, [10 21]);

	% mods = loadmodout12(amicadir);
	EEG.icasphere = mods.S(1:mods.num_pcs,:); EEG.icaweights = mods.W(:,:,1); EEG.icawinv = mods.A(:,:,1);
%pop_runica(EEG,'icatype','acsobiro')

	% labels
	EEG.badcomps = [];EEG.clusters.saccade=[];EEG.clusters.blink=[];
	EEG = pop_editset(EEG, 'subject', subj, 'condition', 'rt', 'session', [1]); 
    EEG.saccades=[];EEG.blinks=[]
	
	% save preprocessed file
	EEG = pop_saveset(EEG,'filename',set);

end;




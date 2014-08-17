function [	P3RT,	P3amp, P3lat, P6RT, P6amp, P6lat, P6sRT, P6samp, P6slat, N4amp, N4lat] = get_values_for_corrgram()

eeglab;
% empty containers
ALLEEG=[];EEG=[];targetdata=[];targetvar=[];

n = 22

% triggers
target =  {  'S 88'  }
nontarget = {'S 10' 'S 11' 'S 12' 'S 13' 'S 14' 'S 15' 'S 16' 'S 17' 'S 20' 'S 21' 'S 22' 'S 23' 'S 24' 'S 25' 'S 26' 'S 27' 'S 30' 'S 31' 'S 32' 'S 33' 'S 34' 'S 35' 'S 36' 'S 37' 'S 40' 'S 41' 'S 42' 'S 43' 'S 44' 'S 45' 'S 46' 'S 47'  }

% select channel


% main data collection loop

for S = 1:n

filename = ['/home/jona/Desktop/charvis/pre3/charvisp3_',num2str((S),'%02i'),'.set'];



% collect control trials for all 3 positions

EEG = pop_loadset('filename',filename);
EEG = pop_eegfiltnew(EEG, [],10);

chan = 'Pz';
for Z = 1:length(EEG.chanlocs);if strcmp(EEG.chanlocs(Z).labels,chan) == 1;channel = Z;end;end;


EEG2 = pop_epoch( EEG, target, [-1 3], 'epochinfo', 'yes');
[EEG2, locthresh, globthresh, nrej] = pop_rejkurt(EEG2, 1, [1:EEG.nbchan], 5, 5, 1, 1, 0);
EEG2 = pop_eegthresh(EEG2,1,12,-100,100,0.5,1.25,0,1);

dat = squeeze(eeg_getdatact(EEG2,'channel',channel,'rmcomps',[EEG.saccades EEG.blinks]));
var = eeg_getepochevent( EEG2,{'S196'},[],'latency');

EEG3 = pop_epoch( EEG, nontarget, [-1 3], 'epochinfo', 'yes');
[EEG3, locthresh, globthresh, nrej] = pop_rejkurt(EEG3, 1, [1:EEG.nbchan], 5, 5, 1, 1, 0);
EEG3 = pop_eegthresh(EEG3,1,12,-100,100,0.5,1.25,0,1);

dat2 = squeeze(eeg_getdatact(EEG3,'channel',channel,'rmcomps',[EEG.saccades EEG.blinks]));

controlerp = mean(dat2,2);

for ii=1:length(dat(1,:))
 dat(:,ii)=dat(:,ii)-controlerp;
end

datas{S}=dat;
rts{S}=var;

ntrials = length(var);

var(isnan(var))=0;

corrate_p3(S) = length(find(var))/ntrials;


end

%figure;[syntrials1,synlats1] = erpimage(targetdata, targetvar, linspace(EEG2.xmin*1000, EEG2.xmax*1000, EEG2.pnts), '', 30, 1 , 'avg_type','Gaussian','NoShow','off','baseline',[-1000 0],'erp',4);


rts(15)=[];
datas(15)=[];
rts(6)=[];
datas(6)=[];

n=length(rts)
N=length(rts)

rts_p3 = rts
datas_p3 = datas
n_p3 = n





eeglab;

ALLEEG=[];EEG=[];alldat=[];allrtvar=[];rts=[];dats=[];allrtvar2=[];alldat2=[];data=[];syndat=[];synvar=[];semdat=[];semvar=[];

%%%%%%%%%%%%%%%%%%%%%
%%% Retrieve data %%%
%%%%%%%%%%%%%%%%%%%%%

%% this part of the script simply fetches 
%% single-trial difference data

n = 22
N = 22
% triggers
syn1 = {'S211'  'S213'}
syn2 = {'S221' }
syn3 = { 'S231'  }



sem1 = {  'S212' 'S214'}
sem2 = { 'S222'  }
sem3 = {  'S232' }
control1={'S210' }
control2={ 'S220'}
control3={ 'S230'}

% select channel


% main data collection loop

for S = 1:n

filename = ['/home/jona/Desktop/charvis/pre3/charvis_',num2str((S),'%02i'),'.set'];



% collect control trials for all 3 positions

EEG = pop_loadset('filename',filename);
EEG = pop_eegfiltnew(EEG, [],10);

chan = 'Pz';
for Z = 1:length(EEG.chanlocs);if strcmp(EEG.chanlocs(Z).labels,chan) == 1;channel = Z;end;end;


EEG = pop_epoch( EEG, control1, [-1 3], 'epochinfo', 'yes');
[EEG, locthresh, globthresh, nrej] = pop_rejkurt(EEG, 1, [1:EEG.nbchan], 5, 5, 1, 1, 0);
EEG = pop_eegthresh(EEG,1,12,-100,100,0.5,1.25,0,1);
dat = squeeze(eeg_getdatact(EEG,'channel',channel,'rmcomps',[EEG.clusters.saccade EEG.clusters.blink]));
controlerp1=mean(dat,2);

EEG = pop_loadset('filename',filename);
EEG = pop_eegfiltnew(EEG, [],10);

EEG = pop_epoch( EEG, control2, [-1 3], 'epochinfo', 'yes');
[EEG, locthresh, globthresh, nrej] = pop_rejkurt(EEG, 1, [1:EEG.nbchan], 5, 5, 1, 1, 0);
EEG = pop_eegthresh(EEG,1,12,-100,100,0.5,1.25,0,1);
dat = squeeze(eeg_getdatact(EEG,'channel',channel,'rmcomps',[EEG.clusters.saccade EEG.clusters.blink]));
controlerp2=mean(dat,2);

EEG = pop_loadset('filename',filename);
EEG = pop_eegfiltnew(EEG, [],10);


EEG = pop_epoch( EEG, control3, [-1 3], 'epochinfo', 'yes');
[EEG, locthresh, globthresh, nrej] = pop_rejkurt(EEG, 1, [1:EEG.nbchan], 5, 5, 1, 1, 0);
EEG = pop_eegthresh(EEG,1,12,-100,100,0.5,1.25,0,1);
dat = squeeze(eeg_getdatact(EEG,'channel',channel,'rmcomps',[EEG.clusters.saccade EEG.clusters.blink]));
controlerp3=mean(dat,2);


% collect morphsyn trials for all 3 positions, and subtract equivalent control mean

EEG = pop_loadset('filename',filename);
EEG = pop_eegfiltnew(EEG, [],10);


EEG = pop_epoch( EEG, syn1, [-1 3], 'epochinfo', 'yes');
[EEG, locthresh, globthresh, nrej] = pop_rejkurt(EEG, 1, [1:EEG.nbchan], 5, 5, 1, 1, 0);
EEG = pop_eegthresh(EEG,1,12,-100,100,0.5,1.25,0,1);
dat = squeeze(eeg_getdatact(EEG,'channel',channel,'rmcomps',[EEG.clusters.saccade EEG.clusters.blink]));
var = eeg_getepochevent( EEG,{'S196'},[],'latency');


for ii=1:length(dat(1,:))
 dat(:,ii)=dat(:,ii)-controlerp1;
end

synvar = [var,synvar];
syndat=[dat,syndat];

EEG = pop_loadset('filename',filename);
EEG = pop_eegfiltnew(EEG, [],10);


EEG = pop_epoch( EEG, syn2, [-1 3], 'epochinfo', 'yes');
[EEG, locthresh, globthresh, nrej] = pop_rejkurt(EEG, 1, [1:EEG.nbchan], 5, 5, 1, 1, 0);
EEG = pop_eegthresh(EEG,1,12,-100,100,0.5,1.25,0,1);
dat = squeeze(eeg_getdatact(EEG,'channel',channel,'rmcomps',[EEG.clusters.saccade EEG.clusters.blink]));
var = eeg_getepochevent( EEG,{'S196'},[],'latency');


for ii=1:length(dat(1,:))
 dat(:,ii)=dat(:,ii)-controlerp2;
end

synvar = [var,synvar];
syndat=[dat,syndat];

EEG = pop_loadset('filename',filename);
EEG = pop_eegfiltnew(EEG, [],10);


EEG = pop_epoch( EEG, syn3, [-1 3], 'epochinfo', 'yes');
[EEG, locthresh, globthresh, nrej] = pop_rejkurt(EEG, 1, [1:EEG.nbchan], 5, 5, 1, 1, 0);
EEG = pop_eegthresh(EEG,1,12,-100,100,0.5,1.25,0,1);
dat = squeeze(eeg_getdatact(EEG,'channel',channel,'rmcomps',[EEG.clusters.saccade EEG.clusters.blink]));
var = eeg_getepochevent( EEG,{'S196'},[],'latency');


for ii=1:length(dat(1,:))
 dat(:,ii)=dat(:,ii)-controlerp3;
end

synvar = [var,synvar];
syndat=[dat,syndat];



% collect sem trials for all 3 positions, and subtract equivalent control mean

EEG = pop_loadset('filename',filename);
EEG = pop_eegfiltnew(EEG, [],10);


EEG = pop_epoch( EEG, sem1, [-1 3], 'epochinfo', 'yes');
[EEG, locthresh, globthresh, nrej] = pop_rejkurt(EEG, 1, [1:EEG.nbchan], 5, 5, 1, 1, 0);
EEG = pop_eegthresh(EEG,1,12,-100,100,0.5,1.25,0,1);
dat = squeeze(eeg_getdatact(EEG,'channel',channel,'rmcomps',[EEG.clusters.saccade EEG.clusters.blink]));
var = eeg_getepochevent( EEG,{'S196'},[],'latency');


for ii=1:length(dat(1,:))
 dat(:,ii)=dat(:,ii)-controlerp1;
end

semvar = [var,semvar];
semdat=[dat,semdat];

EEG = pop_loadset('filename',filename);
EEG = pop_eegfiltnew(EEG, [],10);


EEG = pop_epoch( EEG, sem2, [-1 3], 'epochinfo', 'yes');
[EEG, locthresh, globthresh, nrej] = pop_rejkurt(EEG, 1, [1:EEG.nbchan], 5, 5, 1, 1, 0);
EEG = pop_eegthresh(EEG,1,12,-100,100,0.5,1.25,0,1);
dat = squeeze(eeg_getdatact(EEG,'channel',channel,'rmcomps',[EEG.clusters.saccade EEG.clusters.blink]));
var = eeg_getepochevent( EEG,{'S196'},[],'latency');


for ii=1:length(dat(1,:))
 dat(:,ii)=dat(:,ii)-controlerp2;
end

semvar = [var,semvar];
semdat=[dat,semdat];

EEG = pop_loadset('filename',filename);



EEG = pop_epoch( EEG, sem3, [-1 3], 'epochinfo', 'yes');
[EEG, locthresh, globthresh, nrej] = pop_rejkurt(EEG, 1, [1:EEG.nbchan], 5, 5, 1, 1, 0);
EEG = pop_eegthresh(EEG,1,12,-100,100,0.5,1.25,0,1);
dat = squeeze(eeg_getdatact(EEG,'channel',channel,'rmcomps',[EEG.clusters.saccade EEG.clusters.blink]));
var = eeg_getepochevent( EEG,{'S196'},[],'latency');


for ii=1:length(dat(1,:))
 dat(:,ii)=dat(:,ii)-controlerp3;
end

semvar = [var,semvar];
semdat=[dat,semdat];


	rts{S} = synvar;
	datas{S} = syndat;
	rts2{S} = semvar;
	datas2{S} = semdat;
	
	ntrials = length(synvar);
	synvar(isnan(synvar))=0;
	corrate_p6(S) = length(find(synvar))/ntrials;

	ntrials = length(semvar);
	semvar(isnan(semvar))=0;
	corrate_p6s(S) = length(find(synvar))/ntrials;

	var=[];semvar=[];synvar=[];semdat=[];syndat=[];
end;

% this must be commented out for syn data
%rts = rts2;
%datas = datas2;

%% kick out bad participants

rts(15)=[];
datas(15)=[];
rts(6)=[];
datas(6)=[];
n=length(rts)
N=length(rts)


rts2(15)=[];
datas2(15)=[];
rts2(6)=[];
datas2(6)=[];

corrate_p6(15)=[];
corrate_p6(6)=[];
corrate_p6s(15)=[];
corrate_p6s(6)=[];
corrate_p3(15)=[];
corrate_p3(6)=[];

%rts_p3 <- {subj}(trials)
%datas_p3 <- {subj}(samples * trials)
%n_p3 <- n subj



for x = 1:n
	P3 = datas_p3{x};
	P3RT(x) = nanmean(rts_p3{x});
	ERP = mean(P3,2);
	P3amp(x) = mean( ERP(find(EEG.times>P3RT(x),1)-5:find(EEG.times>P3RT(x),1)+5) );

	[v,i] = max(ERP(find(EEG.times>0,1):find(EEG.times>2000)));
	P3lat(x) = EEG.times(find(EEG.times>0,1)+i);

	P6 = datas{x};
	P6RT(x) = nanmean(rts{x});
	ERP = mean(P6,2);
	P6amp(x) = mean( ERP(find(EEG.times>P6RT(x),1)-5:find(EEG.times>P6RT(x),1)+5) );

	[v,i] = max(ERP(find(EEG.times>0,1):find(EEG.times>2000)));
	P6lat(x) = EEG.times(find(EEG.times>0,1)+i);

	P6s = datas2{x};
	P6sRT(x) = nanmean(rts2{x});
	ERP = mean(P6s,2);
	P6samp(x) = mean( ERP(find(EEG.times>P6sRT(x),1)-5:find(EEG.times>P6sRT(x),1)+5) );

	[v,i] = max(ERP(find(EEG.times>0,1):find(EEG.times>2000)));
	P6slat(x) = EEG.times(find(EEG.times>0,1)+i);

	N4 = datas2{x};
	ERP = mean(N4,2);
	N4amp(x) = mean( ERP(find(EEG.times>350,1):find(EEG.times>450,1)+5) );

	[v,i] = min(ERP(find(EEG.times>200,1):find(EEG.times>700)));
	N4lat(x) = EEG.times(find(EEG.times>200,1)+i);
	
end



%RT (P600 task), RT (P3 task), accuracy (P600 task), accuracy (P3 task), P600 latency, P3 latency, P600 amplitude, P3 amplitude, P600/RT correlation, P3/RT correlation, N4 amplitude, N4/RT correlation



z = [P3RT; P3amp; P3lat; corrate_p3; P6RT; P6amp; P6lat; corrate_p6; P6sRT; P6samp; P6slat; corrate_p6s; N4amp; N4lat];

csvwrite('~/experiments/charvis/csv/Charvis-to_correlogram.csv',z.');

end

eeglab;
ALLEEG=[];EEG=[];alldat=[];allrtvar=[];rts=[];dats=[];allrtvar2=[];alldat2=[];data=[];syndat=[];synvar=[];semdat=[];semvar=[];rts=[];datas=[];

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

chan = 'Pz';
for Z = 1:length(EEG.chanlocs);if strcmp(EEG.chanlocs(Z).labels,chan) == 1;channel = Z;end;end;


EEG = pop_epoch( EEG, control1, [-4 5], 'epochinfo', 'yes');
[EEG, locthresh, globthresh, nrej] = pop_rejkurt(EEG, 1, [1:EEG.nbchan], 5, 5, 1, 1, 0);
EEG = pop_eegthresh(EEG,1,12,-100,100,0.5,1.25,0,1);

dat = squeeze(eeg_getdatact(EEG,'channel',channel,'rmcomps',[EEG.saccades EEG.blinks]));
controlerp1=mean(dat,2);

EEG = pop_loadset('filename',filename);


EEG = pop_epoch( EEG, control2, [-4 5], 'epochinfo', 'yes');
[EEG, locthresh, globthresh, nrej] = pop_rejkurt(EEG, 1, [1:EEG.nbchan], 5, 5, 1, 1, 0);
EEG = pop_eegthresh(EEG,1,12,-100,100,0.5,1.25,0,1);

dat = squeeze(eeg_getdatact(EEG,'channel',channel,'rmcomps',[EEG.saccades EEG.blinks]));
controlerp2=mean(dat,2);

EEG = pop_loadset('filename',filename);



EEG = pop_epoch( EEG, control3, [-4 5], 'epochinfo', 'yes');
[EEG, locthresh, globthresh, nrej] = pop_rejkurt(EEG, 1, [1:EEG.nbchan], 5, 5, 1, 1, 0);
EEG = pop_eegthresh(EEG,1,12,-100,100,0.5,1.25,0,1);

dat = squeeze(eeg_getdatact(EEG,'channel',channel,'rmcomps',[EEG.saccades EEG.blinks]));
controlerp3=mean(dat,2);



% collect sem trials for all 3 positions, and subtract equivalent control mean

EEG = pop_loadset('filename',filename);



EEG = pop_epoch( EEG, sem1, [-4 5], 'epochinfo', 'yes');
[EEG, locthresh, globthresh, nrej] = pop_rejkurt(EEG, 1, [1:EEG.nbchan], 5, 5, 1, 1, 0);
EEG = pop_eegthresh(EEG,1,12,-100,100,0.5,1.25,0,1);

dat = squeeze(eeg_getdatact(EEG,'channel',channel,'rmcomps',[EEG.saccades EEG.blinks]));
var = eeg_getepochevent( EEG,{'S196'},[],'latency');


for ii=1:length(dat(1,:))
 dat(:,ii)=dat(:,ii)-controlerp1;
end

semvar = [var,semvar];
semdat=[dat,semdat];

EEG = pop_loadset('filename',filename);



EEG = pop_epoch( EEG, sem2, [-4 5], 'epochinfo', 'yes');
[EEG, locthresh, globthresh, nrej] = pop_rejkurt(EEG, 1, [1:EEG.nbchan], 5, 5, 1, 1, 0);
EEG = pop_eegthresh(EEG,1,12,-100,100,0.5,1.25,0,1);

dat = squeeze(eeg_getdatact(EEG,'channel',channel,'rmcomps',[EEG.saccades EEG.blinks]));
var = eeg_getepochevent( EEG,{'S196'},[],'latency');


for ii=1:length(dat(1,:))
 dat(:,ii)=dat(:,ii)-controlerp2;
end

semvar = [var,semvar];
semdat=[dat,semdat];

EEG = pop_loadset('filename',filename);



EEG = pop_epoch( EEG, sem3, [-4 5], 'epochinfo', 'yes');
[EEG, locthresh, globthresh, nrej] = pop_rejkurt(EEG, 1, [1:EEG.nbchan], 5, 5, 1, 1, 0);
EEG = pop_eegthresh(EEG,1,12,-100,100,0.5,1.25,0,1);

dat = squeeze(eeg_getdatact(EEG,'channel',channel,'rmcomps',[EEG.saccades EEG.blinks]));
var = eeg_getepochevent( EEG,{'S196'},[],'latency');


for ii=1:length(dat(1,:))
 dat(:,ii)=dat(:,ii)-controlerp3;
end

semvar = [var,semvar];
semdat=[dat,semdat];

	rts2{S} = semvar;
	datas2{S} = semdat;
	var=[];semvar=[];synvar=[];semdat=[];syndat=[];
end;

% this must be commented out for syn data
rts = rts2;
datas = datas2;

%% kick out bad participants

rts(15)=[];
datas(15)=[];
rts(6)=[];
datas(6)=[];
n=length(rts)
N=length(rts)





%%%%%%%%%%%%%%%%%%%%%
%%% Calculate ITC %%%
%%%%%%%%%%%%%%%%%%%%%

%% this part of the script
%% finds the peak and
%% calculates ITC

% comment in for simple ERPimage 
% (for basic validation)

% figure;[outdata5,outrtvar5,outtrials5,limits,axhndls,erp,amps,cohers,cohsig,ampsig,outamps,phsangls,phsamp,sortidx,erpsig]  = erpimage(eegdata, rtdata, linspace(EEG.xmin*1000, EEG.xmax*1000, EEG.pnts), 'PZ ERP sorted by reaction time', 6, 1 ,'erp',1,'avg_type','Gaussian','cbar','on','cbar_title','\muV','vert',[890]);

% this calculates ITC
for X = 1:N

% create unaligned data
[outdata5,outrtvar5,outtrials5,limits,axhndls,erp,amps,cohers,cohsig,ampsig,outamps,phsangls,phsamp,sortidx,erpsig] = erpimage(datas{X}, rts{X}, linspace(EEG.xmin*1000, EEG.xmax*1000, EEG.pnts), 'PZ ERP sorted by reaction time', 1, 1 ,'erp',1,'cbar','on','cbar_title','\muV','NoShow','on');

%[Y(X),I(X)]=max(erp(1:525));

% create aligned data
[outdata6,outrtvar6,outtrials6] = erpimage(datas{X}, rts{X}, linspace(EEG.xmin*1000, EEG.xmax*1000, EEG.pnts), 'PZ ERP sorted by reaction time', 1, 1 ,'erp',1,'cbar','on','cbar_title','\muV','NoShow','on','align',inf);

% calculate difference ITC
X
[ersp,itc,powbase,times,freqs,erspboot,itcboot,itcphase]  = newtimef( {outdata6 outdata5}  ,EEG.pnts,[EEG.xmin EEG.xmax]*1000,EEG.srate,[2 0.5], 'freqs', [0.5 8], 'plotphase', 'off', 'plotersp','off', 'plotitc','off','trialbase','full','timesout',1000,'nfreqs',30,'verbose','on','freqscale', 'linear','verbose','off'); 

itcs1{X} = itc{1};itcs2{X} = itc{2};itcs{X} = itc{3};ersps{X} = ersp{3};tics(:,:,X) = itcs{X};tics1(:,:,X) = itcs1{X};tics2(:,:,X) = itcs2{X};

X
end;


% find P6 peak in stim-locked data
[outdata,outrtvar,outtrials,limits,axhndls,erp,amps,cohers,cohsig,ampsig,outamps,phsangls,phsamp,sortidx,erpsig] = erpimage(eegdata,rtdata, linspace(EEG.xmin*1000, EEG.xmax*1000, EEG.pnts), 'PZ ERP sorted by reaction time', 1, 1 ,'erp',1,'cbar','on','cbar_title','\muV','NoShow','on','filt',[0 20]);

[Ys,maxp6]=min(erp(1:450))
[c index] = min(abs(times-EEG.times(maxp6)))

% width for ITC
S = 3;

% also check RT for the heck of it
for X = 1:N
rtallss(X) = nanmean(rts{X});
end;
mean(rtallss)

% find mean PLI and
% calculate statistical significance

for X = 1:N
a(X) = mean(mean(tics(:,index-S:index+S,X),1),2);
end;
a
stats = mes(a.',0,{'md','hedgesg'},'nBoot',10000)
[BF01, probH0] = bayesTtestOneSample(a)




% plot ITCs both as 2d and 3d pics
% (adjust sbplot based on subject #)

figure; 
for X = 1:N
sbplot(4,5,X)
tftopo(itcs{X},times,freqs,'limits', [nan nan nan nan nan nan], 'smooth',2,'logfreq','off','vert',[ 0 times(index)],'title',num2str(X));
end;

figure; 
for X = 1:N
sbplot(4,5,X)
plotcurve(times,itcs{X}(:,:),'plotmean','on','vert',[times(index)-S times(index)+S]);
end;

stats.mdCi

%[H,P,CI]=ttest(a);


csvwrite('Charvis-N4-ITC-Pz.csv',a);
exit;


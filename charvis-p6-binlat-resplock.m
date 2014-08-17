ALLEEG=[];EEG=[];alldat=[];allrtvar=[];rts=[];dats=[];allrtvar2=[];alldat2=[];
% empty containers
ALLEEG=[];EEG=[];data=[];syndat=[];synvar=[];semdat=[];semvar=[];

n = 22

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


EEG = pop_epoch( EEG, control1, [-1 3], 'epochinfo', 'yes');
[EEG, locthresh, globthresh, nrej] = pop_rejkurt(EEG, 1, [1:EEG.nbchan], 5, 5, 1, 1, 0);
EEG = pop_eegthresh(EEG,1,12,-100,100,0.5,1.25,0,1);

dat = squeeze(eeg_getdatact(EEG,'channel',channel,'rmcomps',[EEG.clusters.saccade EEG.clusters.blink]));
controlerp1=mean(dat,2);

EEG = pop_loadset('filename',filename);


EEG = pop_epoch( EEG, control2, [-1 3], 'epochinfo', 'yes');
[EEG, locthresh, globthresh, nrej] = pop_rejkurt(EEG, 1, [1:EEG.nbchan], 5, 5, 1, 1, 0);
EEG = pop_eegthresh(EEG,1,12,-100,100,0.5,1.25,0,1);

dat = squeeze(eeg_getdatact(EEG,'channel',channel,'rmcomps',[EEG.clusters.saccade EEG.clusters.blink]));
controlerp2=mean(dat,2);

EEG = pop_loadset('filename',filename);



EEG = pop_epoch( EEG, control3, [-1 3], 'epochinfo', 'yes');
[EEG, locthresh, globthresh, nrej] = pop_rejkurt(EEG, 1, [1:EEG.nbchan], 5, 5, 1, 1, 0);
EEG = pop_eegthresh(EEG,1,12,-100,100,0.5,1.25,0,1);

dat = squeeze(eeg_getdatact(EEG,'channel',channel,'rmcomps',[EEG.clusters.saccade EEG.clusters.blink]));
controlerp3=mean(dat,2);


% collect morphsyn trials for all 3 positions, and subtract equivalent control mean

EEG = pop_loadset('filename',filename);



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
% must be rts2 and datas2 for syntax
	rts2{S} = semvar;
	datas2{S} = semdat;
	var=[];semvar=[];synvar=[];semdat=[];syndat=[];
end;

rts(15)=[];
datas(15)=[];
rts(6)=[];
datas(6)=[];

n=length(rts)


figure;



for x = 1:n

	%[outdata,outrtvar] = erpimage(datas{x}, rts{x}, linspace(EEG.xmin*1000, EEG.xmax*1000, EEG.pnts), '', 1, 1 ,'NoShow','on','baseline',[-500 0]);

	[outdata,outrtvar] = erpimage(datas{x}, rts{x}, linspace(EEG.xmin*1000, EEG.xmax*1000, EEG.pnts), '', 1, 1 ,'NoShow','on','align',inf);


	ntrials = length(outrtvar);
	outdata = outdata(:,ntrials*.05:ntrials*.95);
	outrtvar = outrtvar(ntrials*.05:ntrials*.95);
	ntrials = length(outrtvar);

	sbplot(4,5,x);
	plotcurve ( EEG.times, [ mean(outdata(:,1:ntrials*1/4),2)  ; mean(outdata(:,ntrials*1/4:ntrials*2/4),2) ; mean(outdata(:,ntrials*2/4:ntrials*3/4),2) ;  mean(outdata(:,ntrials*3/4:end),2)])

%,'xlabel','Time (msec)','ylabel','\mu V','legend',{'fastest','second fastest','slow','slowest'},'title','Syntax','vert',0

	fasterp(x,:) = mean(outdata(:,1:ntrials*1/4),2);
	mod1erp(x,:) = mean(outdata(:,ntrials*1/4:ntrials*2/4),2);
	mod2erp(x,:) = mean(outdata(:,ntrials*2/4:ntrials*3/4),2);
	slowerp(x,:) = mean(outdata(:,ntrials*3/4:end),2);
	
	fastrt(x,:) = mean(outrtvar(1:ntrials*1/4));
	mod1rt(x,:) = mean(outrtvar(ntrials*1/4:ntrials*2/4));
	mod2rt(x,:) = mean(outrtvar(ntrials*2/4:ntrials*3/4));
	slowrt(x,:) = mean(outrtvar(ntrials*3/4:end));

end;

figure;
for x = 1:n

	a = 1:n; a(x) = [];

	jackfast(x,:) = mean(fasterp(a,:),1);
	jackmod1(x,:) = mean(mod1erp(a,:),1);
	jackmod2(x,:) = mean(mod2erp(a,:),1);
	jackslow(x,:) = mean(slowerp(a,:),1);

	jackfastrt(x) = mean(fastrt(a,:),1);
	jackmod1rt(x) = mean(mod1rt(a,:),1);
	jackmod2rt(x) = mean(mod2rt(a,:),1);
	jackslowrt(x) = mean(slowrt(a,:),1);


	sbplot(4,5,x);
	plotcurve ( EEG.times, [ jackfast(x,:) ; jackmod1(x,:) ; jackmod2(x,:) ; jackslow(x,:) ] );

%,'xlabel','Time (msec)','ylabel','\mu V','legend',{'fastest','second fastest','slow','slowest'},'title','Syntax','vert',0

end;

jackfast2=jackfast;jackmod12=jackmod1;jackmod22=jackmod2; jackslow2=jackslow;


for y = 1:n
	for x = 1:EEG.pnts
		if jackfast(y,x) < 0
			jackfast2(y,x) = 0;
		end;
		if jackmod1(y,x) < 0
			jackmod12(y,x) = 0;
		end;
		if jackmod2(y,x) < 0
			jackmod22(y,x) = 0;
		end;
		if jackslow(y,x) < 0
			jackslow2(y,x) = 0;
		end;
	end;
end;

for x = 1:n
	
	% deprecated: peak latency

	erp = jackfast2(x,100:250);
	[~,fastlat(x)] = min(abs(cumsum(erp)-sum(erp)/3));
%	[~,fastlat(x)]  = max(erp);
	erp = jackmod12(x,100:250);
	[~,mod1lat(x)] = min(abs(cumsum(erp)-sum(erp)/3));
%	[~,mod1lat(x)]  = max(erp);
	erp = jackmod22(x,100:250);
	[~,mod2lat(x)] = min(abs(cumsum(erp)-sum(erp)/3));
%	[~,mod2lat(x)]  = max(erp);
	erp = jackslow2(x,100:250);
	[~,slowlat(x)] = min(abs(cumsum(erp)-sum(erp)/3));
%	[~,slowlat(x)]  = max(erp);
	
	
	
end;



a = [mean(jackfastrt), mean(jackmod1rt), mean(jackmod2rt), mean(jackslowrt)]
b = [mean(fastlat) mean(mod1lat) mean(mod2lat) mean(slowlat)]
[r,p] =corr(a.',b.')


statmatrix2 = [fastlat.' mod1lat.' mod2lat.' slowlat.']
[stats,table]=mes1way(statmatrix2,'partialeta2','isdep',1);
anovaf = (cell2mat(table(2,5))) / (stats.n(1) -1)^2;


[stats,table]=mes1way(statmatrix2(:,1:2),'partialeta2','isdep',1);
firstbinf = (cell2mat(table(2,5))) / (stats.n(1) -1)^2;

[stats,table]=mes1way(statmatrix2(:,2:3),'partialeta2','isdep',1);
secondbinf = (cell2mat(table(2,5))) / (stats.n(1) -1)^2;

[stats,table]=mes1way(statmatrix2(:,3:4),'partialeta2','isdep',1);
thirdbinf = (cell2mat(table(2,5))) / (stats.n(1) -1)^2;

anovaf
firstbinf
secondbinf
thirdbinf

% in R: result <- oneWayAOV.Fstat(17.479, 20, 4, rscale = 1)
% exp(result[[’bf’]])

%alt. way to make the script more concise
%erp_adjusted = bsxfun(@minus,erp_matrix(samples,:),min(erp_matrix(samples,:)));
%[~,latency_indicies] = min(abs(bsxfun(@minus,cumsum(erp_adjusted),sum(erp_adjusted)/2)));
%latencies = (EEG.xmin + (samples(1)+latency_indicies)/EEG.srate)*1000;


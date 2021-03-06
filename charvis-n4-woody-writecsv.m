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


EEG = pop_epoch( EEG, control1, [-1 3], 'epochinfo', 'yes');
[EEG, locthresh, globthresh, nrej] = pop_rejkurt(EEG, 1, [1:EEG.nbchan], 5, 5, 1, 1, 0);
EEG = pop_eegthresh(EEG,1,12,-100,100,0.5,1.25,0,1);

dat = squeeze(eeg_getdatact(EEG,'channel',channel,'rmcomps',[EEG.saccades EEG.blinks]));
controlerp1=mean(dat,2);

EEG = pop_loadset('filename',filename);


EEG = pop_epoch( EEG, control2, [-1 3], 'epochinfo', 'yes');
[EEG, locthresh, globthresh, nrej] = pop_rejkurt(EEG, 1, [1:EEG.nbchan], 5, 5, 1, 1, 0);
EEG = pop_eegthresh(EEG,1,12,-100,100,0.5,1.25,0,1);

dat = squeeze(eeg_getdatact(EEG,'channel',channel,'rmcomps',[EEG.saccades EEG.blinks]));
controlerp2=mean(dat,2);

EEG = pop_loadset('filename',filename);



EEG = pop_epoch( EEG, control3, [-1 3], 'epochinfo', 'yes');
[EEG, locthresh, globthresh, nrej] = pop_rejkurt(EEG, 1, [1:EEG.nbchan], 5, 5, 1, 1, 0);
EEG = pop_eegthresh(EEG,1,12,-100,100,0.5,1.25,0,1);

dat = squeeze(eeg_getdatact(EEG,'channel',channel,'rmcomps',[EEG.saccades EEG.blinks]));
controlerp3=mean(dat,2);



% collect sem trials for all 3 positions, and subtract equivalent control mean

EEG = pop_loadset('filename',filename);



EEG = pop_epoch( EEG, sem1, [-1 3], 'epochinfo', 'yes');
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



EEG = pop_epoch( EEG, sem2, [-1 3], 'epochinfo', 'yes');
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



EEG = pop_epoch( EEG, sem3, [-1 3], 'epochinfo', 'yes');
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


pre = 100;		% time points before 0
p6onset = 20;	% time points from 0 to P6 template onset
p6length = 50;		% template length in data points

wrts = rts; weeg = datas;

for S = 1:n

	rtmean(S) = nanmedian(wrts{S});

	for X = 1:length(wrts{S})
		if 1250 < wrts{S}(X)
		wrts{S}(X) = NaN;
	end;end;

	for X = 1:length(wrts{S})
		if 500 > wrts{S}(X)
		wrts{S}(X) = NaN;
	end;end;

	data = weeg{S};rtvar = wrts{S};

	[outdata,outvar] = erpimage(data,rtvar, linspace(EEG.xmin*1000, EEG.xmax*1000, EEG.pnts), '', 1, 1, 'filt',[0 6],'NoShow','on');
	[q,w,e,r,t,erp] = erpimage(data,rtvar, linspace(EEG.xmin*1000, EEG.xmax*1000, EEG.pnts), '', 1, 1, 'filt',[0 6],'NoShow','on','align',inf,'erp','on');

	dasyn{S} = outdata;
	vasyn{S} = outvar;

	% fliplr for sanity check
	% everything that's still there when this line is not commented out is a false positive!
%	vasyn{S} = randsample(outvar,length(outvar)); 

	vasyn2{S} = outvar;


	erps{S} = erp;

end;


eegdata=[];rtdata=[];
for x = 1:n
	eegdata=[eegdata,dasyn{x}];
	rtdata=[rtdata,vasyn{x}];
end;

% figure;[outdata5,outrtvar5,outtrials5] = erpimage(eegdata, rtdata, linspace(EEG.xmin*1000, EEG.xmax*1000, EEG.pnts), 'PZ ERP sorted by reaction time', 6, 1 ,'erp',1,'avg_type','Gaussian','cbar','on','cbar_title','\muV');


collects=[];means=[];vars=[]; corrvals=[];
for S = 1:n;

	erp = erps{S};
	collect=[];corvall=[];
	data = dasyn{S};
	% the following step either nulls every data point 300 msec after the response
	% or subtracts the mean response-locked ERP at that timepoint
	% this might sound problematic, but 1. we still get a strong correlation without this step, 2. it’s used to null the ERP time-locked to the feedback, which in turn is perfectly time-locked to the response!! so I wouldn't feel comfortable without it
	for L = 1:length(vasyn{S})
%		data((vasyn{S}(L)/10)+pre+30:600,L) = 0;
		data((vasyn2{S}(L)/10)+pre+40:end,L) = 		data((vasyn2{S}(L)/10)+pre+40:end,L)- 		erp((vasyn2{S}(L)/10)+pre+40:end).';
	end;
	datarm{S} = data;
	
% figure;[outdata5,outrtvar5,outtrials5] = erpimage(data, vasyn{S}, linspace(EEG.xmin*1000, EEG.xmax*1000, EEG.pnts), 'PZ ERP sorted by reaction time', 2, 1 ,'erp',1,'avg_type','Gaussian','cbar','on','cbar_title','\muV');


	datamean = mean(data(pre+p6onset:pre+p6onset+p6length,:),2);

	for N = 1:100
		trials=[];
		for X = 1:length(vasyn{S})

			out = xcorr(data(pre+p6onset:pre+p6onset+p6length,X),datamean);

			[Y,I]=sort(out);

			thepoint=I(end)-p6length;

			trialpoint = data(pre+p6onset+thepoint:pre+p6onset+p6length+thepoint,X); 
			trials = [trials,trialpoint];

			datamean = mean(trials,2);

		end;
	end;

	for X = 1:length(vasyn{S})

		out = xcorr(data(pre+p6onset:pre+p6onset+p6length,X),mean(trials,2));

		[Y,I]=sort(out);

		thepoint=I(end)-p6length;

		collect = [collect,thepoint];

	end;

	means = [means,mean(trials,2)];
	vars = [vars,collect];
	collects{S} = collect;

end;


vars=[];lats=[];dats=[];
for S = 1:n

	dat =dasyn{S};
	varf = vasyn{S};
	lat = (collects{S}+p6onset)*10;
	rtmean = nanmedian(vasyn{S});

	dats=[dats,dat];
	vars=[vars,varf];

	lats=[lats,lat];

end;


a = [(lats).'; (lats).'-vars.'];
b = [ones(length(vars),1); ones(length(vars),1)*2];



% calculate individual correlation coefficients using the robust corr toolbox 
for S = 1:n

%	sbplot(4,5,S);
	x = vasyn{S};
	y = (collects{S}+p6onset)*10;

	[r,t,h,outid] = skipped_correlation(x,y,0);
	rvals(S) = squeeze(r.Pearson);

end;
rvals

z=0.5*log((1+rvals)./(1-rvals));

%calculate CI
[H,P,CI95]=ttest(z,0,1-.95);
%[H,P,CI68]=ttest(z,0,1-.68);


zci =CI95;
zmean = mean(z);

% inverse fisher
r=(exp(2*zci)-1)./(exp(2*zci)+1)
r=(exp(2*zmean)-1)./(exp(2*zmean)+1)




r


csvwrite('Charvis-Woody-zscores-N4-Pz.csv',z);
exit;


% empty containers
ALLEEG=[];EEG=[];targetdata=[];targetvar=[];

n = 22

% triggers
target =  {  'S 88'  }
nontarget = {'S 10' 'S 11' 'S 12' 'S 13' 'S 14' 'S 15' 'S 16' 'S 17' 'S 20' 'S 21' 'S 22' 'S 23' 'S 24' 'S 25' 'S 26' 'S 27' 'S 30' 'S 31' 'S 32' 'S 33' 'S 34' 'S 35' 'S 36' 'S 37' 'S 40' 'S 41' 'S 42' 'S 43' 'S 44' 'S 45' 'S 46' 'S 47'  }

% select channel


% main data collection loop

for S = 1:n

filename = ['/home/jona/Desktop/charvis/pre2/charvisp3_',num2str((S),'%02i'),'.set'];



% collect control trials for all 3 positions

EEG = pop_loadset('filename',filename);

chan = 'Pz';
for Z = 1:length(EEG.chanlocs);if strcmp(EEG.chanlocs(Z).labels,chan) == 1;channel = Z;end;end;


EEG2 = pop_epoch( EEG, target, [-1 3], 'epochinfo', 'yes');
[EEG2, locthresh, globthresh, nrej] = pop_rejkurt(EEG2, 1, [1:EEG.nbchan], 5, 5, 1, 1, 0);

dat = squeeze(eeg_getdatact(EEG2,'channel',channel,'rmcomps',[EEG.saccades EEG.blinks]));
var = eeg_getepochevent( EEG2,{'S196'},[],'latency');

EEG3 = pop_epoch( EEG, nontarget, [-1 3], 'epochinfo', 'yes');
[EEG3, locthresh, globthresh, nrej] = pop_rejkurt(EEG3, 1, [1:EEG.nbchan], 5, 5, 1, 1, 0);

dat2 = squeeze(eeg_getdatact(EEG3,'channel',channel,'rmcomps',[EEG.saccades EEG.blinks]));

controlerp = mean(dat2,2);

for ii=1:length(dat(1,:))
 dat(:,ii)=dat(:,ii)-controlerp;
end

targetvar = [var,targetvar];
targetdata=[dat,targetdata];
datas{S}=dat;
rts{S}=var;


end

figure;[syntrials1,synlats1] = erpimage(targetdata, targetvar, linspace(EEG2.xmin*1000, EEG2.xmax*1000, EEG2.pnts), '', 16, 1 , 'avg_type','Gaussian','NoShow','off','baseline',[-1000 0],'erp',4);


rts(15)=[];
datas(15)=[];
rts(6)=[];
datas(6)=[];

n=length(rts)


figure;



for x = 1:n

	[outdata,outrtvar] = erpimage(datas{x}, rts{x}, linspace(EEG2.xmin*1000, EEG2.xmax*1000, EEG2.pnts), '', 1, 1 ,'NoShow','on');

	ntrials = length(outrtvar);
	outdata = outdata(:,ntrials*.05:ntrials*.95);
	outrtvar = outrtvar(ntrials*.05:ntrials*.95);
	ntrials = length(outrtvar);

	sbplot(4,5,x);
	plotcurve ( EEG2.times, [ mean(outdata(:,1:ntrials*1/4),2)  ; mean(outdata(:,ntrials*1/4:ntrials*2/4),2) ; mean(outdata(:,ntrials*2/4:ntrials*3/4),2) ;  mean(outdata(:,ntrials*3/4:end),2)])

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
	plotcurve ( EEG2.times, [ jackfast(x,:) ; jackmod1(x,:) ; jackmod2(x,:) ; jackslow(x,:) ] );

end;

jackfast2=jackfast;jackmod12=jackmod1;jackmod22=jackmod2; jackslow2=jackslow;


for y = 1:n
	for x = 1:EEG2.pnts
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

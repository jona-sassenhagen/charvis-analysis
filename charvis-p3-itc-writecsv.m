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

chan = 'Pz';
for Z = 1:length(EEG.chanlocs);if strcmp(EEG.chanlocs(Z).labels,chan) == 1;channel = Z;end;end;


EEG2 = pop_epoch( EEG, target, [-4 5], 'epochinfo', 'yes');
[EEG2, locthresh, globthresh, nrej] = pop_rejkurt(EEG2, 1, [1:EEG.nbchan], 5, 5, 1, 1, 0);
EEG2 = pop_eegthresh(EEG2,1,12,-100,100,0.5,1.25,0,1);

dat = squeeze(eeg_getdatact(EEG2,'channel',channel,'rmcomps',[EEG.saccades EEG.blinks]));
var = eeg_getepochevent( EEG2,{'S196'},[],'latency');

EEG3 = pop_epoch( EEG, nontarget, [-4 5], 'epochinfo', 'yes');
[EEG3, locthresh, globthresh, nrej] = pop_rejkurt(EEG3, 1, [1:EEG.nbchan], 5, 5, 1, 1, 0);
EEG3 = pop_eegthresh(EEG3,1,12,-100,100,0.5,1.25,0,1);

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

%figure;[syntrials1,synlats1] = erpimage(targetdata, targetvar, linspace(EEG2.xmin*1000, EEG2.xmax*1000, EEG2.pnts), '', 30, 1 , 'avg_type','Gaussian','NoShow','off','baseline',[-1000 0],'erp',4);


rts(15)=[];
datas(15)=[];
rts(6)=[];
datas(6)=[];

n=length(rts)
N=length(rts)



eegdata=[];rtdata=[];
for x = 1:N
eegdata=[eegdata,datas{x}];
rtdata=[rtdata,rts{x}];
end;



%%%%%%%%%%%%%%%%%%%%%
%%% Calculate ITC %%%
%%%%%%%%%%%%%%%%%%%%%

%% this part of the script
%% finds the peak and
%% calculates ITC

% comment in for simple ERPimage 
% (for basic validation)

% figure;[outdata5,outrtvar5,outtrials5,limits,axhndls,erp,amps,cohers,cohsig,ampsig,outamps,phsangls,phsamp,sortidx,erpsig]  = erpimage(eegdata, rtdata, linspace(EEG2.xmin*1000, EEG2.xmax*1000, EEG2.pnts), 'PZ ERP sorted by reaction time', 6, 1 ,'erp',1,'avg_type','Gaussian','cbar','on','cbar_title','\muV','vert',[890]);

% this calculates ITC
for X = 1:N

% create unaligned data
[outdata5,outrtvar5,outtrials5,limits,axhndls,erp,amps,cohers,cohsig,ampsig,outamps,phsangls,phsamp,sortidx,erpsig] = erpimage(datas{X}, rts{X}, linspace(EEG2.xmin*1000, EEG2.xmax*1000, EEG2.pnts), 'PZ ERP sorted by reaction time', 1, 1 ,'erp',1,'cbar','on','cbar_title','\muV','NoShow','on');

%[Y(X),I(X)]=max(erp(1:525));

% create aligned data
[outdata6,outrtvar6,outtrials6] = erpimage(datas{X}, rts{X}, linspace(EEG2.xmin*1000, EEG2.xmax*1000, EEG2.pnts), 'PZ ERP sorted by reaction time', 1, 1 ,'erp',1,'cbar','on','cbar_title','\muV','NoShow','on','align',inf);

% calculate difference ITC
X
[ersp,itc,powbase,times,freqs,erspboot,itcboot,itcphase]  = newtimef( {outdata6 outdata5}  ,EEG2.pnts,[EEG2.xmin EEG2.xmax]*1000,EEG2.srate,[2 0.5], 'freqs', [0.5 8], 'plotphase', 'off', 'plotersp','off', 'plotitc','off','trialbase','full','timesout',1000,'nfreqs',30,'verbose','on','freqscale', 'linear','verbose','off'); 

itcs1{X} = itc{1};itcs2{X} = itc{2};itcs{X} = itc{3};ersps{X} = ersp{3};tics(:,:,X) = itcs{X};tics1(:,:,X) = itcs1{X};tics2(:,:,X) = itcs2{X};

X
end;


% find P6 peak in stim-locked data
[outdata,outrtvar,outtrials,limits,axhndls,erp,amps,cohers,cohsig,ampsig,outamps,phsangls,phsamp,sortidx,erpsig] = erpimage(eegdata,rtdata, linspace(EEG2.xmin*1000, EEG2.xmax*1000, EEG2.pnts), 'PZ ERP sorted by reaction time', 1, 1 ,'erp',1,'cbar','on','cbar_title','\muV','NoShow','on','filt',[0 20]);

[Ys,maxp6]=max(erp)
[c index] = min(abs(times-EEG2.times(maxp6)))

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


csvwrite('Charvis-P3-ITC.csv',a);
exit;


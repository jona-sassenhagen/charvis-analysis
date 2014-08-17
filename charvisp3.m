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

%for ii=1:length(dat(1,:))
% dat(:,ii)=dat(:,ii)-controlerp;
%end

targetvar = [var,targetvar];
targetdata=[dat,targetdata];



end

figure;[syntrials1,synlats1] = erpimage(targetdata, targetvar, linspace(EEG2.xmin*1000, EEG2.xmax*1000, EEG2.pnts), '', 30, 1 , 'avg_type','Gaussian','NoShow','off','baseline',[-1000 0],'erp',4);

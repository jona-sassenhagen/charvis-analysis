eeglab;
% empty containers
ALLEEG=[];EEG=[];
clear synerp3 synerp2 synerp1 controlerp1 controlerp2 controlerp3 semerp1 semerp2 semerp3;
n = 22

% triggers
syn1 = {'S211' 'S213'}
syn2 = {'S221' }
syn3 = { 'S231'  }

sem1 = {  'S212' 'S214'}
sem2 = { 'S222'  }
sem3 = {  'S232' }
control1={'S210' }
control2={ 'S220'}
control3={ 'S230'}


target =  {  'S 88'  }
nontarget = {'S 10' 'S 11' 'S 12' 'S 13' 'S 14' 'S 15' 'S 16' 'S 17' 'S 20' 'S 21' 'S 22' 'S 23' 'S 24' 'S 25' 'S 26' 'S 27' 'S 30' 'S 31' 'S 32' 'S 33' 'S 34' 'S 35' 'S 36' 'S 37' 'S 40' 'S 41' 'S 42' 'S 43' 'S 44' 'S 45' 'S 46' 'S 47'  }



subjects2 = {'01' '02' '03' '04' '05' '07' '08' '09' '10' '11' '12' '13' '14' '16' '17' '18' '19' '20' '21' '22'};	% subjects w/ exclusions, double


subjects = {'1' '2' '3' '4' '5' '7' '8' '9' '10' '11' '12' '13' '14' '16' '17' '18' '19' '20' '21' '22'};	% subjects w/ exclusions


% main data collection loop

for X = 1:length(subjects)

S = subjects2{X};

filename = ['/home/jona/Desktop/charvis/pre3/charvis_',num2str((S),'%02i'),'.set'];

% collect control trials for all 3 positions

EEG = pop_loadset('filename',filename);
%EEG = pop_resample( EEG, 1000);
%[EEG, com, b] = pop_eegfiltnew(EEG, 0, 40);
%EEG = pop_resample( EEG, 100);
EEG = pop_subcomp(EEG,[EEG.blinks EEG.saccades]);


EEG1 = pop_epoch( EEG, control1, [-2 3], 'epochinfo', 'yes');
EEG1 = pop_rmbase( EEG1, [-1000 0]);
[EEG1, locthresh, globthresh, nrej] = pop_rejkurt(EEG1, 1, [1:EEG.nbchan], 5, 5, 1, 1, 0);
EEG1 = pop_eegthresh(EEG1,1,1:62,-100,100,0.5,1.25,0,1);

for elec = 1:EEG1.nbchan
	outdata = squeeze(EEG1.data(elec,:,:));
	controlerp1(elec,:,X) = mean(outdata,2);
end;


EEG1 = pop_epoch( EEG, control2, [-2 3], 'epochinfo', 'yes');
EEG1 = pop_rmbase( EEG1, [-1000 0]);
[EEG1, locthresh, globthresh, nrej] = pop_rejkurt(EEG1, 1, [1:EEG.nbchan], 5, 5, 1, 1, 0);
EEG1 = pop_eegthresh(EEG1,1,1:62,-100,100,0.5,1.25,0,1);

for elec = 1:EEG1.nbchan
	outdata = squeeze(EEG1.data(elec,:,:));
	controlerp2(elec,:,X) = mean(outdata,2);
end;

EEG1 = pop_epoch( EEG, control3, [-2 3], 'epochinfo', 'yes');
EEG1 = pop_rmbase( EEG1, [-1000 0]);
[EEG1, locthresh, globthresh, nrej] = pop_rejkurt(EEG1, 1, [1:EEG.nbchan], 5, 5, 1, 1, 0);
EEG1 = pop_eegthresh(EEG1,1,1:62,-100,100,0.5,1.25,0,1);

for elec = 1:EEG1.nbchan
	outdata = squeeze(EEG1.data(elec,:,:));
	controlerp3(elec,:,X) = mean(outdata,2);
end;






EEG1 = pop_epoch( EEG, sem1, [-2 3], 'epochinfo', 'yes');
EEG1 = pop_rmbase( EEG1, [-1000 0]);
[EEG1, locthresh, globthresh, nrej] = pop_rejkurt(EEG1, 1, [1:EEG.nbchan], 5, 5, 1, 1, 0);
EEG1 = pop_eegthresh(EEG1,1,1:62,-100,100,0.5,1.25,0,1);

for elec = 1:EEG1.nbchan
	outdata = squeeze(EEG1.data(elec,:,:));
	semerp1(elec,:,X) = mean(outdata,2);
end;


EEG1 = pop_epoch( EEG, sem2, [-2 3], 'epochinfo', 'yes');
EEG1 = pop_rmbase( EEG1, [-1000 0]);
[EEG1, locthresh, globthresh, nrej] = pop_rejkurt(EEG1, 1, [1:EEG.nbchan], 5, 5, 1, 1, 0);
EEG1 = pop_eegthresh(EEG1,1,1:62,-100,100,0.5,1.25,0,1);

for elec = 1:EEG1.nbchan
	outdata = squeeze(EEG1.data(elec,:,:));
	semerp2(elec,:,X) = mean(outdata,2);
end;

EEG1 = pop_epoch( EEG, sem3, [-2 3], 'epochinfo', 'yes');
EEG1 = pop_rmbase( EEG1, [-1000 0]);
[EEG1, locthresh, globthresh, nrej] = pop_rejkurt(EEG1, 1, [1:EEG.nbchan], 5, 5, 1, 1, 0);
EEG1 = pop_eegthresh(EEG1,1,1:62,-100,100,0.5,1.25,0,1);

for elec = 1:EEG1.nbchan
	outdata = squeeze(EEG1.data(elec,:,:));
	semerp3(elec,:,X) = mean(outdata,2);
end;





EEG1 = pop_epoch( EEG, syn1, [-2 3], 'epochinfo', 'yes');
EEG1 = pop_rmbase( EEG1, [-1000 0]);
[EEG1, locthresh, globthresh, nrej] = pop_rejkurt(EEG1, 1, [1:EEG.nbchan], 5, 5, 1, 1, 0);
EEG1 = pop_eegthresh(EEG1,1,1:62,-100,100,0.5,1.25,0,1);

for elec = 1:EEG1.nbchan
	outdata = squeeze(EEG1.data(elec,:,:));
	synerp1(elec,:,X) = mean(outdata,2);
end;


EEG1 = pop_epoch( EEG, syn2, [-2 3], 'epochinfo', 'yes');
EEG1 = pop_rmbase( EEG1, [-1000 0]);
[EEG1, locthresh, globthresh, nrej] = pop_rejkurt(EEG1, 1, [1:EEG.nbchan], 5, 5, 1, 1, 0);
EEG1 = pop_eegthresh(EEG1,1,1:62,-100,100,0.5,1.25,0,1);

for elec = 1:EEG1.nbchan
	outdata = squeeze(EEG1.data(elec,:,:));
	synerp2(elec,:,X) = mean(outdata,2);
end;

EEG1 = pop_epoch( EEG, syn3, [-2 3], 'epochinfo', 'yes');
EEG1 = pop_rmbase( EEG1, [-1000 0]);
[EEG1, locthresh, globthresh, nrej] = pop_rejkurt(EEG1, 1, [1:EEG.nbchan], 5, 5, 1, 1, 0);
EEG1 = pop_eegthresh(EEG1,1,1:62,-100,100,0.5,1.25,0,1);

for elec = 1:EEG1.nbchan
	outdata = squeeze(EEG1.data(elec,:,:));
	synerp3(elec,:,X) = mean(outdata,2);
end;



filename = ['/home/jona/Desktop/charvis/pre3/charvisp3_',num2str((S),'%02i'),'.set'];


% collect control trials for all 3 positions

EEG = pop_loadset('filename',filename);
[EEG, com, b] = pop_eegfiltnew(EEG, 0, 40);
EEG = pop_subcomp(EEG,[EEG.blinks EEG.saccades]);


EEG1 = pop_epoch( EEG, nontarget, [-2 3], 'epochinfo', 'yes');
EEG1 = pop_rmbase( EEG1, [-1000 0]);
[EEG1, locthresh, globthresh, nrej] = pop_rejkurt(EEG1, 1, [1:EEG.nbchan], 5, 5, 1, 1, 0);
EEG1 = pop_eegthresh(EEG1,1,1:62,-100,100,0.5,1.25,0,1);

for elec = 1:EEG1.nbchan
	outdata = squeeze(EEG1.data(elec,:,:));
	nontargeterp(elec,:,X) = mean(outdata,2);
end;


EEG1 = pop_epoch( EEG, target, [-2 3], 'epochinfo', 'yes');
EEG1 = pop_rmbase( EEG1, [-1000 0]);
[EEG1, locthresh, globthresh, nrej] = pop_rejkurt(EEG1, 1, [1:EEG.nbchan], 5, 5, 1, 1, 0);
EEG1 = pop_eegthresh(EEG1,1,1:62,-100,100,0.5,1.25,0,1);

for elec = 1:EEG1.nbchan
	outdata = squeeze(EEG1.data(elec,:,:));
	targeterp(elec,:,X) = mean(outdata,2);
end;

end


% calculate  difference ERPs
synerp1 = mean((synerp1-controlerp1),3);
synerp2 = mean((synerp2-controlerp2),3);
synerp3 = mean((synerp3-controlerp3),3);

synerp = synerp3/3+synerp2/3+synerp1/3;

semerp1 = mean((semerp1-controlerp1),3);
semerp2 = mean((semerp2-controlerp2),3);
semerp3 = mean((semerp3-controlerp3),3);


semerp = semerp3/3+semerp2/3+semerp1/3;

targeterp = mean(targeterp,3);
nontargeterp = mean(nontargeterp,3);

targerp = targeterp-nontargeterp;

% plot butterfly ERPs
figure;
sbplot(3,1,1);
timtopo( semerp, EEG.chanlocs, [-2000 3000 -7 12],[450], '', 0, 0, 'chaninfo', EEG.chaninfo,'style','map','title','Semantic Violation ','shading','interp');

sbplot(3,1,2);
timtopo( synerp, EEG.chanlocs, [-2000 3000 -7 12],[850], '', 0, 0, 'chaninfo', EEG.chaninfo,'style','map','title','Syntactic Violation ','shading','interp');

sbplot(3,1,3);
timtopo( targerp, EEG.chanlocs, [-2000 3000 -7 12], [550], '', 0, 0, 'chaninfo', EEG.chaninfo,'style','map','title','Face targets','shading','interp');


% per-participant P3
%figure;
%for x = 1:20

%    theerp = (targeterp(:,:,x)-nontargeterp(:,:,x));
%    sbplot(4,5,x);
%    timtopo( theerp, EEG.chanlocs, [-1000 3000 -15 15],[], '', 0, 0, 'chaninfo', EEG.chaninfo,'style','map','title','P3','shading','interp');
%end

set(gcf, 'paperpositionmode', 'auto');
print -depsc charvis-butterfly.eps;

exit;

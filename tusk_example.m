%% Examples of TUSK
% Please see the following reference in the details of TUSK.
% M. Morise and H. Kawahara:
% TUSK: A framework for overviewing the performance of F0 estimators,
% Proc. INTERSPEECH 2016, pp. 1790-1794, San Francisco, Sept. 8-12, 2016.

% This script uses Dio() in WORLD for test.
% Please download WORLD from the following.
% http://ml.cs.yamanashi.ac.jp/world/english/index.html

% Please set the frame shift to 1 ms. Since the test signal is 1.2 s,
% the estiamted result should be 1,200 (or 1201) samples.
% Note: TUSK uses the result from 0.1 to 1.1 s (101 : 1100).
%       It may be possible to evaluate the estimator even if it does not
%       return the sequences consisting of 1,200 sample.
%       In case that the difference is large, the result may be unreliable.

% The file "commandlist.txt" is used to set the commands for obtaining the
% estimated F0 contour. 
% You can use not only the MATLAB script but also other scripts.
% Function system() would be useful to write the script.

%% Setting
% If you have Parallel Computing Toolbox (PCT), you can select using it
parallel_flag = 1; % You want to use PCT.
% parallel_flag = 0; % You don't want to use PCT.

% In ACT 3, 4, 5 and 6, they use a random sequence. To remove the
% its dependency, you should average the results of multiple test.
% N is the number of repeats (N > 1).
N = 5;

%% ACT 1: Relationship between basic F0 and estimation performance
clearvars -except parallel_flag
% In Act 1, you can set the frequency range.
f0_list = 55 * 2 .^ ((0 : 48) / 12);

[result1, method_list] = act1('commandlist.txt', f0_list, parallel_flag);
save result_act1.mat
plot_figure(result1, freq2cent(f0_list), 'F0 (cent)', method_list);

%% ACT 2: Influence of temporal fluctuation in F0 contour
clearvars -except parallel_flag
% In Act 2, you can set the range of alpha.
alpha_list = 0 : 0.1 : 25; % vibrato intensity

[result2, method_list]  = act2('commandlist.txt', alpha_list, parallel_flag);
save result_act2.mat
plot_figure(result2, alpha_list, 'Vibrato intensity \alpha', method_list);

%% ACT 3: Influence of amplitudes of each harmonic component
clearvars -except parallel_flag N
% In Act 3, you can set the dynamic range of amplitude.
amp_list = 0 : 0.5 : 60;

% ç≈èâÇ…1âÒé¿çs
[tmp, method_list] = act3('commandlist.txt', amp_list, parallel_flag);
result3 = zeros(size(tmp, 1), size(tmp, 2), N);
for i = 2 : N
  tmp = act3('commandlist.txt', amp_list, parallel_flag);
  result3(:, :, i) = tmp;
  fprintf('--------------------------------------------------------------\n');
  fprintf('i : %d completed.\n', i);
  fprintf('--------------------------------------------------------------\n');
end;
save result_act3.mat
plot_figure(median(result3, 3), amp_list, 'Amplitude randomization (dB)', method_list);

%% ACT 4: Influence of phases of each harmonic component
clearvars -except parallel_flag N
% In Act 4, you can set the dynamic range of phase.
phase_list = 0 : 0.05 : 2 * pi;

% ç≈èâÇ…1âÒé¿çs
[tmp, method_list] = act4('commandlist.txt', phase_list, parallel_flag);
result4 = zeros(size(tmp, 1), size(tmp, 2), N);
for i = 2 : N
  tmp = act4('commandlist.txt', phase_list, parallel_flag);
  result4(:, :, i) = tmp;
  fprintf('--------------------------------------------------------------\n');
  fprintf('i : %d completed.\n', i);
  fprintf('--------------------------------------------------------------\n');
end;
save result_act4.mat
plot_figure(median(result4, 3), phase_list, 'Phase randomization (rad)', method_list);

%% ACT 5: Noise robustness (whitenoise)
clearvars -except parallel_flag N
% In Act 5, you can set the SNR.
SNR_list = 0 : 0.5 : 60;

[tmp, method_list] = act5('commandlist.txt', SNR_list, parallel_flag, 0);
result5_1 = zeros(size(tmp, 1), size(tmp, 2), N);
for i = 2 : N
  tmp = act5('commandlist.txt', SNR_list, parallel_flag, 0);
  result5_1(:, :, i) = tmp;
  fprintf('--------------------------------------------------------------\n');
  fprintf('i : %d completed.\n', i);
  fprintf('--------------------------------------------------------------\n');
end;
save result_act5_1.mat
plot_figure(median(result5_1, 3), SNR_list, 'SNR (dB)', method_list);

%% ACT 5: Noise robustness (pinknoise)
clearvars -except parallel_flag N
% In Act 5, you can set the SNR.
SNR_list = 0 : 0.5 : 60;

[tmp, method_list] = act5('commandlist.txt', SNR_list, parallel_flag, 1);
result5_2 = zeros(size(tmp, 1), size(tmp, 2), N);
for i = 2 : N
  tmp = act5('commandlist.txt', SNR_list, parallel_flag, 1);
  result5_2(:, :, i) = tmp;
  fprintf('--------------------------------------------------------------\n');
  fprintf('i : %d completed.\n', i);
  fprintf('--------------------------------------------------------------\n');
end;
save result_act5_2.mat
plot_figure(median(result5_2, 3), SNR_list, 'SNR (dB)', method_list);

%% ACT 6: Influence of the reverberation
clearvars -except parallel_flag N
% In Act 6, you can set the reverberation.
reverb_list = 10 : 10 : 1000;

[tmp, method_list] = act6('commandlist.txt', reverb_list, parallel_flag);
result6 = zeros(size(tmp, 1), size(tmp, 2), N);
for i = 2 : N
  tmp = act6('commandlist.txt', reverb_list, parallel_flag);
  result6(:, :, i) = tmp;
  fprintf('--------------------------------------------------------------\n');
  fprintf('i : %d completed.\n', i);
  fprintf('--------------------------------------------------------------\n');
end;
save result_act6.mat
plot_figure(median(result6, 3), reverb_list, 'Reverberation (ms)', method_list);

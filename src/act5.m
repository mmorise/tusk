function [result, method_list] =...
  act5(filename_list, SNR_list, parallel_flag, flag)

fs = 48000;
[command_list, number_of_methods, method_list] =...
  extract_commands(filename_list);

% Function loop_parallel() requires parallel computing toolbox.
if parallel_flag == 1 && check_toolbox == 1
  result = loop_parallel(fs, SNR_list, command_list, number_of_methods, flag);
else
  result = loop_normal(fs, SNR_list, command_list, number_of_methods, flag);
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function result =...
  loop_parallel(fs, SNR_list, command_list, number_of_methods, flag)

basic_f0 = 440;
result = zeros(length(SNR_list), number_of_methods);

parfor i = 1 : length(SNR_list)
  SNR = SNR_list(i);
  f0_contour = generate_f0_contour(basic_f0, 0);
  x = generate_signal_from_f0_contour(f0_contour, fs, 0, 0);
  if flag == 0
    n = randn(length(x), 1);
  else
    n = generate_pinknoise(length(x), fs);
  end;
  amp = 10 ^ (SNR / 20);
  n = n ./ sqrt(sum(n .^ 2)) / amp;
  x = x + n;

  tmp = estimate_f0(x, fs, f0_contour, number_of_methods, command_list, i);
  result(i, :) = tmp(:)';
  
  fprintf('ACT 5: %.1f dB\n', SNR);
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function result =...
  loop_normal(fs, SNR_list, command_list, number_of_methods, flag)

basic_f0 = 440;
result = zeros(length(SNR_list), number_of_methods);

for i = 1 : length(SNR_list)
  SNR = SNR_list(i);
  f0_contour = generate_f0_contour(basic_f0, 0);
  x = generate_signal_from_f0_contour(f0_contour, fs, 0, 0);
  if flag == 0
    n = randn(length(x), 1);
  else
    n = generate_pinknoise(length(x), fs);
  end;
  amp = 10 ^ (SNR / 20);
  n = n ./ sqrt(sum(n .^ 2)) / amp;
  x = x + n;

  tmp = estimate_f0(x, fs, f0_contour, number_of_methods, command_list, i);
  result(i, :) = tmp(:)';
  
  fprintf('ACT 5: %.1f dB\n', SNR);
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pink_noise = generate_pinknoise(N, fs)

filter_size = 8192; % Filter length to manipulate the spectrum

w = (0:filter_size-1) * fs / filter_size;
w = w(:);
% Frequency of under 20 Hz is ignored.
w(w < 20) = w(find(w > 20, 1));
half_spectrum = 1 ./ sqrt(w);
spectrum = [half_spectrum(1:filter_size / 2);...
    conj(half_spectrum(filter_size / 2 - 1:-1:2))];
impulse_response = fftshift(real(ifft(spectrum)));
[~, impulse_response] = rceps(impulse_response);

y = fftfilt(impulse_response, randn(N + filter_size * 2, 1));

pink_noise = y(filter_size + 1:end - filter_size);

function [result, method_list] =...
  act6(filename_list, reverb_list, parallel_flag)

fs = 48000;
[command_list, number_of_methods, method_list] =...
  extract_commands(filename_list);

% Function loop_parallel() requires parallel computing toolbox.
if parallel_flag == 1 && check_toolbox == 1
  result = loop_parallel(fs, reverb_list, command_list, number_of_methods);
else
  result = loop_normal(fs, reverb_list, command_list, number_of_methods);
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function result =...
  loop_parallel(fs, reverb_list, command_list, number_of_methods)

t = (0 : fs - 1) / fs;
basic_f0 = 440;
result = zeros(length(reverb_list), number_of_methods);

parfor i = 1 : length(reverb_list)
  reverb = reverb_list(i) / 1000;
  damping = -log(0.001) / reverb;
  envelope = exp(-damping * t) / sqrt(10);
  impulse_response = envelope(:) .* ((rand(length(envelope), 1) - 0.5) * 2);
  impulse_response(1) = 1;
  
  f0_contour = generate_f0_contour(basic_f0, 0);
  x = generate_signal_from_f0_contour(f0_contour, fs, 0, 0);
  x_len = length(x);
  x = fftfilt(impulse_response, [x(:); zeros(fs, 1)]);
  x = x(1 : x_len);

  tmp = estimate_f0(x, fs, f0_contour, number_of_methods, command_list, i);
  result(i, :) = tmp(:)';
  
  fprintf('ACT 6: %.1f ms\n', reverb * 1000);
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function result = loop_normal(fs, reverb_list, command_list, number_of_methods)

t = (0 : fs - 1) / fs;
basic_f0 = 440;
result = zeros(length(reverb_list), number_of_methods);

for i = 1 : length(reverb_list)
  reverb = reverb_list(i) / 1000;
  damping = -log(0.001) / reverb;
  envelope = exp(-damping * t) / sqrt(10);
  impulse_response = envelope(:) .* ((rand(length(envelope), 1) - 0.5) * 2);
  impulse_response(1) = 1;
  
  f0_contour = generate_f0_contour(basic_f0, 0);
  x = generate_signal_from_f0_contour(f0_contour, fs, 0, 0);
  x_len = length(x);
  x = fftfilt(impulse_response, [x(:); zeros(fs, 1)]);
  x = x(1 : x_len);

  tmp = estimate_f0(x, fs, f0_contour, number_of_methods, command_list, i);
  result(i, :) = tmp(:)';
  
  fprintf('ACT 6: %.1f ms\n', reverb * 1000);
end;

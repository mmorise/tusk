function [result, method_list] = act3(filename_list, amp_list, parallel_flag)

fs = 48000;
[command_list, number_of_methods, method_list] =...
  extract_commands(filename_list);

% Function loop_parallel() requires parallel computing toolbox.
if parallel_flag == 1 && check_toolbox == 1
  result = loop_parallel(fs, amp_list, command_list, number_of_methods);
else
  result = loop_normal(fs, amp_list, command_list, number_of_methods);
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function result = loop_parallel(fs, amp_list, command_list, number_of_methods)

basic_f0 = 440;
result = zeros(length(amp_list), number_of_methods);

parfor i = 1 : length(amp_list)
  amp = amp_list(i);
  f0_contour = generate_f0_contour(basic_f0, 0);
  x = generate_signal_from_f0_contour(f0_contour, fs, amp, 0);

  tmp = estimate_f0(x, fs, f0_contour, number_of_methods, command_list, i);
  result(i, :) = tmp(:)';
  
  fprintf('ACT 3: %.1f dB\n', amp);
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function result = loop_normal(fs, amp_list, command_list, number_of_methods)

basic_f0 = 440;
result = zeros(length(amp_list), number_of_methods);

for i = 1 : length(amp_list)
  amp = amp_list(i);
  f0_contour = generate_f0_contour(basic_f0, 0);
  x = generate_signal_from_f0_contour(f0_contour, fs, amp, 0);

  tmp = estimate_f0(x, fs, f0_contour, number_of_methods, command_list, i);
  result(i, :) = tmp(:)';
  
  fprintf('ACT 3: %.1f dB\n', amp);
end;

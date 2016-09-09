function [result, method_list] = act4(filename_list, phase_list, parallel_flag)

fs = 48000;
[command_list, number_of_methods, method_list] =...
  extract_commands(filename_list);

% Function loop_parallel() requires parallel computing toolbox.
if parallel_flag == 1 && check_toolbox == 1
  result = loop_parallel(fs, phase_list, command_list, number_of_methods);
else
  result = loop_normal(fs, phase_list, command_list, number_of_methods);
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function result =...
  loop_parallel(fs, phase_list, command_list, number_of_methods)

basic_f0 = 440;
result = zeros(length(phase_list), number_of_methods);

parfor i = 1 : length(phase_list)
  phase = phase_list(i);
  f0_contour = generate_f0_contour(basic_f0, 0);
  x = generate_signal_from_f0_contour(f0_contour, fs, 0, phase);

  tmp = estimate_f0(x, fs, f0_contour, number_of_methods, command_list, i);
  result(i, :) = tmp(:)';
  
  fprintf('ACT 4: %.1f\n', phase);
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function result = loop_normal(fs, phase_list, command_list, number_of_methods)

basic_f0 = 440;
result = zeros(length(phase_list), number_of_methods);

for i = 1 : length(phase_list)
  phase = phase_list(i);
  f0_contour = generate_f0_contour(basic_f0, 0);
  x = generate_signal_from_f0_contour(f0_contour, fs, 0, phase);

  tmp = estimate_f0(x, fs, f0_contour, number_of_methods, command_list, i);
  result(i, :) = tmp(:)';
  
  fprintf('ACT 4: %.1f\n', phase);
end;

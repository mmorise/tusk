function [result, method_list] = act1(filename_list, f0_list, parallel_flag)

fs = 48000;
[command_list, number_of_methods, method_list] =...
  extract_commands(filename_list);

% Function loop_parallel() requires parallel computing toolbox.
if parallel_flag == 1 && check_toolbox == 1
  result = loop_parallel(fs, f0_list, command_list, number_of_methods);
else
  result = loop_normal(fs, f0_list, command_list, number_of_methods);
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function result = loop_parallel(fs, f0_list, command_list, number_of_methods)

result = zeros(length(f0_list), number_of_methods);

parfor i = 1 : length(f0_list)
  basic_f0 = f0_list(i);
  
  f0_contour = generate_f0_contour(basic_f0, 0);
  x = generate_signal_from_f0_contour(f0_contour, fs, 0, 0);

  tmp = estimate_f0(x, fs, f0_contour, number_of_methods, command_list, i);
  result(i, :) = tmp(:)';
  
  fprintf('ACT 1: %d cent\n', round(freq2cent(basic_f0)));
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function result = loop_normal(fs, f0_list, command_list, number_of_methods)

result = zeros(length(f0_list), number_of_methods);

for i = 1 : length(f0_list)
  basic_f0 = f0_list(i);
  
  f0_contour = generate_f0_contour(basic_f0, 0);
  x = generate_signal_from_f0_contour(f0_contour, fs, 0, 0);

  tmp = estimate_f0(x, fs, f0_contour, number_of_methods, command_list, i);
  result(i, :) = tmp(:)';
  
  fprintf('ACT 1: %d cent\n', round(freq2cent(basic_f0)));
end;

function [result, method_list] = act2(filename_list, alpha_list, parallel_flag)

fs = 48000;
[command_list, number_of_methods, method_list] =...
  extract_commands(filename_list);

% Function loop_parallel() requires parallel computing toolbox.
if parallel_flag == 1 && check_toolbox == 1
  result = loop_parallel(fs, alpha_list, command_list, number_of_methods);
else
  result = loop_normal(fs, alpha_list, command_list, number_of_methods);
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function result =...
  loop_parallel(fs, alpha_list, command_list, number_of_methods)

result = zeros(length(alpha_list), number_of_methods);
basic_f0 = 440;

parfor i = 1 : length(alpha_list)
  alpha = alpha_list(i);
  
  f0_contour = generate_f0_contour(basic_f0, alpha);
  x = generate_signal_from_f0_contour(f0_contour, fs, 0, 0);

  tmp = estimate_f0(x, fs, f0_contour, number_of_methods, command_list, i);
  result(i, :) = tmp(:)';
  
  fprintf('ACT 2: %.1f\n', alpha);
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function result = loop_normal(fs, alpha_list, command_list, number_of_methods)

result = zeros(length(alpha_list), number_of_methods);
basic_f0 = 440;

for i = 1 : length(alpha_list)
  alpha = alpha_list(i);
  
  f0_contour = generate_f0_contour(basic_f0, alpha);
  x = generate_signal_from_f0_contour(f0_contour, fs, 0, 0);

  tmp = estimate_f0(x, fs, f0_contour, number_of_methods, command_list, i);
  result(i, :) = tmp(:)';
  
  fprintf('ACT 2: %.1f\n', alpha);
end;

function result = estimate_f0(x, fs, f0_contour, number_of_methods, command_list, option)
result = zeros(number_of_methods, 1);

for j = 1 : number_of_methods
  for k = 1 : length(command_list{j})
    eval(command_list{j}{k});
  end;
  if isempty(f0)
    f0 = f0_contour * 0;
  end;
  tmp1 = f0(101 : 1100);
  tmp1(isnan(tmp1)) = 0;
  tmp2 = f0_contour(101 : 1100);
  error_sequence = tmp1(:) - tmp2(:);
  result(j) = sqrt(mean(error_sequence .^ 2));
end;

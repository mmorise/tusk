function result = check_toolbox

result = 0;
toolbox_list = ver;
for i = 1 : length(toolbox_list)
  if strcmp(toolbox_list(i).Name, 'Parallel Computing Toolbox') == 1
    result = 1;
  end;
end;

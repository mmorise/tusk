function [command_list, number_of_methods, method_list] = extract_commands(filename)
fid = fopen(filename, 'r');

number_of_methods = str2num(fgets(fid));
fgets(fid);

for i = 1 : number_of_methods
  j = 1;
  method_list{i} = fgets(fid);
  while 1
    tmp = fgets(fid);
    if  tmp == -1 break; end;
    if (tmp(1) == 13 && tmp(2) == 10)
      break;
    end;
    command_list{i}{j} = tmp;
    j = j + 1;
  end;
end;

fclose(fid);
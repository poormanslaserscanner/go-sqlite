function status = runsqlscript(obj, sqlscript)
  if nargin == 2 && exist(sqlscript, 'file') == 2
    [status, ~] = system(sprintf('sqlite3 %s < %s', obj.file, sqlscript));
  else
    error('Wrong input arguments')
    print_help
  end
end

function status = sqldump(obj, outputfile)
  if nargin == 2 && exist(outputfile, 'file') ~= 2
    [status, ~] = system(sprintf('sqlite3 %s .dump > %s', obj.file, outputfile));
  else
    error('Wrong input arguments')
    print_help
  end
end

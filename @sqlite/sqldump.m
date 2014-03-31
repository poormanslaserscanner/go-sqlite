function status = sqldump(obj, outputfile)
  if nargin == 2 && exist(outputfile, 'file') ~= 2
    [status, ~] = system(sprintf('%s %s .dump > %s', obj.path, obj.file, outputfile));
  else
    error('Wrong input arguments')
    print_help
  end
end

function status=fwrite(obj, string)
  switch nargin
    case {0,1}
      print_help
      return
    case 2
      [status,~]=system(sprintf('sqlite3 %s "%s"', obj.file, string));
    case 3
      command=sqlite_parse_new_command(string, value);
      [status,~]=system(sprintf('sqlite3 %s "%s"', obj.file, command));
    otherwise
      print_help
      return
    end
end

function output=tables(obj)

  switch nargin
    case {0}
      print_help
      return
    case 1
      [~,output]=system(sprintf('%s %s ".tables"', obj.path, obj.file));
    otherwise
      print_help
      return
    end

end

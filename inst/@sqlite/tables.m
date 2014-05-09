function [parsed, unparsed]=tables(obj)

  switch nargin
    case {0}
      print_help
      return
    case 1
      [~,unparsed]=system(sprintf('%s %s ".tables"', obj.path, obj.file));
      % parse output into a cell...
      parsed=regexp(unparsed,'[\w.-_:]+ ','match');
    otherwise
      print_help
      return
    end

end

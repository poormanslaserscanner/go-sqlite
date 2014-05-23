function [parsed, unparsed]=tables(obj)

  switch nargin
    case {0}
      print_help
      return
    case 1
      [~,unparsed]=system(sprintf('%s %s ".tables"', obj.path, obj.file));
      % parse output into a cell...
      parsed=regexp(unparsed,'(  )+','split'); %% separated with 2xchar(32)
      parsed=cellfun(@strtrim,parsed,'UniformOutput',false);
    otherwise
      print_help
      return
    end

end

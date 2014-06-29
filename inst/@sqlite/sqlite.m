function obj = sqlite(varargin)
  if nargin==0
    error('nothing to do here')
    return
  end

  if nargin == 1
      obj = init_fields;
      obj = class(obj, 'sqlite');
      obj.file = sqlite_check(varargin{1});
      obj.prec = 16;
  elseif nargin == 2
      obj = init_fields;
      obj = class(obj, 'sqlite');
      obj.file = sqlite_check(varargin{1});
      if isnumeric(varargin{2})
          obj.prec = varargin{2};
      else
          error('Precision have to be an integer value >=0')
          return
          
      end
  end
end

function obj = init_fields()
  obj.file = [];
  obj.prec = [];
end

function file=sqlite_check(dbfile)
  [status,~] = system('sqlite3 --version');
  if (0<status)
    error('please install sqlite3 or set binary file path as second argument')
    return
  end
  if ~ischar(dbfile)
    error('dbfile and command have to be strings')
    return
  end

  if ~exist(dbfile, 'file') == 2
    sprintf('File %s don''t exist and will be created', dbfile)
  end
  file=dbfile;
end

function obj = sqlite(varargin)
  if nargin==0
    error('nothing to do here')
    return
  end

  if nargin == 1
    obj = init_fields;
    obj = class(obj, 'sqlite');
    obj.file = sqlite_check(varargin{1});
    obj.path = 'sqlite3';
  elseif nargin == 2
    obj = init_fields;
    obj = class(obj, 'sqlite');
    obj.file = sqlite_check_extended(varargin{1},varargin{2});
    if ispc == 1
      obj.path = [varargin{2} '\\sqlite3'];
    else
      obj.path = [varargin{2} '/sqlite3'];
    end
  end
end

function obj = init_fields()
  obj.file = [];
  obj.path = [];
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

function file=sqlite_check_extended(dbfile, path)
  if ispc == 1
    [status,~] = system(sprintf('%s\\sqlite3 --version',path));
  else
    [status,~] = system(sprintf('%s/sqlite3 --version',path));
  end
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


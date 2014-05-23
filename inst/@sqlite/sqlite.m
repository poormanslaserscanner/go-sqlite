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
    obj.mode = 'ego';
    obj.prec = 16;
  elseif nargin == 2
		obj = init_fields;
		obj = class(obj, 'sqlite');    
    %% is argument 2 sqlite3 path?
		if exist(varargin{2},'dir')==7
      obj.file = sqlite_check_extended(varargin{1},varargin{2});
      if ispc == 1
        obj.path = [varargin{2} '\\sqlite3'];
      else
        obj.path = [varargin{2} '/sqlite3'];
      end
      obj.mode = 'ego';
    elseif strcmp(varargin{2},'coop')
    	obj.file= sqlite_check(varargin{1});
    	obj.mode = 'coop';
    	obj.path = 'sqlite3';
		elseif strcmp(vararagin{2},'ego')
			obj.file= sqlite_check(varargin{1});
			obj.mode = 'ego';
			obj.path = 'sqlite3';
    else
    	error('Unknown 2nd input argument')
    end
    obj.prec = 16;
  end
end

function obj = init_fields()
  obj.file = [];
  obj.path = [];
  obj.mode = [];
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


function status = get_sqlite_binary()
  install_dir = [fileparts(mfilename ('fullpath')) '/private'];
  if ispc == 1
    % urlwrite nach tmp oder install_dir
    % unzip nach install_dir oder binary nach install_dir verschiebe
  elseif ismac == 1
    % ??
  else
    % parse /etc/os-release
  end


end

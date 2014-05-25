function save(obj, varargin)
	%% parsing input arguments
  if nargin == 2
    data=varargin{1};
    tablename=inputname(2);
    if numel(tablename)==0
      error('single struct as variablenames are sadly not supported')
      return
    end
  elseif nargin == 3
    tablename=varargin{1};
    data=varargin{2};
  end


	if strcmp(obj.mode,'coop')
		status = save_coop(obj, data, tablename);
	else
		status = save_ego(obj, data, tablename);
	end
end

function status = save_ego(obj, data, tablename);
	path=obj.path;
	dbfile=obj.file;
	% create table
	cct=sprintf('create table [%s] (id INTEGER PRIMARY KEY, ser_val TEXT)', tablename);
	system(sprintf('%s %s "%s"', path, dbfile, cct));

	% save values 
	value = serialize(data);
	cct=sprintf('insert into [%s] (ser_val) values (''%s'')',tablename, value);
	system(sprintf('%s %s "%s"', path, dbfile, cct));

	status = 1;
end


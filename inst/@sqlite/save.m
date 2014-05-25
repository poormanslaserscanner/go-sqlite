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
		disp('todo')
		% status = ego_sqlite(obj, data, tablename);
	end
end



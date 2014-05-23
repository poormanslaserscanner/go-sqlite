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
		status = coop_sqlite(obj, data, tablename);
	else
		disp('todo')
		% status = ego_sqlite(obj, data, tablename);
	end
end

function status = coop_sqlite(obj, data, tablename);
	%% is data == struct
  if isstruct(data)
    f=fieldnames(data);
    for n = 1:numel(f)
      %% FIXME
      %% serialize matrix for multidimension matrix
      if ismatrix(data.(f{n})) && numel(size(data.(f{n})))<=2 && ischar([tablename '.' f{n}])
        out=sqlite_save_matrix(obj.path, obj.file, data.(f{n}), [tablename '.' f{n}]);
      end
    end
  end

	%% is data == matrix
	%% FIXME: matlab: ismatrix(rand(3,3,3)) = false !!!!
  if ismatrix(data) && numel(size(data))<=2 && ischar(tablename)
    out=sqlite_save_matrix(obj.path, obj.file, data, tablename);
  end
  
  if iscell(data)
  	%% check for nested cells
  	%% FIXME: if table already exist!!
  	tmp=cellfun(@iscell, data);
  	if sum(tmp(:))~=0
  		error('nested cells are not supported in this mode')
		else
			out=sqlite_save_cell(obj.path, obj.file, data, tablename);
  	end
  end
end

function status = sqlite_save_cell(path, dbfile, data, tablename);
	%% FIX ME
	%% disable or fix warning
	%% warning: sqlite_save_cell: some elements in list of return values are undefined	

	%% command_create_table
	cct=sprintf('create table [%s] (id INTEGER PRIMARY KEY', tablename);
	cols=sprintf(' ''');
	for c=1:size(data,2)
		cct=[cct sprintf(', c%d TEXT', c)];
		cols=[cols sprintf('c%d'', ''',c)];
	end
	cct=[cct ')'];
	cols(end-2:end)=[];
	system(sprintf('%s %s "%s"', path, dbfile, cct));
	
	%% write rows to table
	data=cellfun (@num2str,data,'UniformOutput', false);
	data=cellfun(@fv, data, 'UniformOutput', false);
	for r=1:size(data,1)
		d=[data{r,:}];
		cct=sprintf('insert into [%s] (%s) values (%s)',tablename, cols, d(1:end-1));
		system(sprintf('%s %s "%s"', path, dbfile, cct));
	end
end

function a = fv(a)
	a =[' ''' a ''','];
end


function save_name = sqlite_save_matrix(path, dbfile, matrix, save_name)
  reshape_info=size(matrix,1);
  newmatrix=[reshape(matrix,[],1)];
  % create table
  command_create_table=sprintf('create table [%s] (id INTEGER PRIMARY KEY,  go_sqlite REAL)', save_name);
  system(sprintf('%s %s "%s"', path, dbfile, command_create_table));
  % write reshape info to id=1
  command=sprintf('insert into [%s] (go_sqlite) values (''%d'')', save_name, reshape_info);
  system(sprintf('%s %s "%s"', path, dbfile, command));
  % sqlite is limited at one point, so let's write max. 100 values at ones.
  if size(newmatrix,1) > 100
    for n = 0:(floor(size(newmatrix,1)/100)-1)
      values_string=sprintf('(''%.8f''),',newmatrix((1:100)+(n*100)));
      values_string=values_string(1:end-1);
      insert_string=sprintf('insert into [%s] (go_sqlite) values ', save_name);
      command = [insert_string values_string];
      system(sprintf('%s %s "%s"', path, dbfile, command));
    end
    if ((n+1)*100)~=size(newmatrix,1)
      from=(((n+1)*100)+1);
      to=size(newmatrix,1);
      values_string=sprintf('(''%.8f''),',newmatrix(from:to));
      values_string=values_string(1:end-1);
      insert_string=sprintf('insert into [%s] (go_sqlite) values ', save_name);
      command = [insert_string values_string];
      system(sprintf('%s %s "%s"', path, dbfile, command));
    end
      save_name = ['Matrix written to table  ' save_name];
  else
    values_string=sprintf('(''%.8f''),',newmatrix);
    values_string=values_string(1:end-1);
    insert_string=sprintf('insert into [%s] (go_sqlite) values ', save_name);
    command = [insert_string values_string];
    system(sprintf('%s %s "%s"', path, dbfile, command)); 
  end
end

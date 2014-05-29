function status = save_coop(obj, data, tablename);
	%% is data == struct
  if isstruct(data)
    f=fieldnames(data);
    for n = 1:numel(f)
      %% FIXME
      %% serialize matrix for multidimension matrix
      if is_matrix(data.(f{n})) && ischar([tablename '.' f{n}])
        out=sqlite_save_matrix(obj.path, obj.file, data.(f{n}), [tablename '.' f{n}], obj.prec);
      end
    end
  end

  if is_matrix(data) && ischar(tablename)
    out=sqlite_save_matrix(obj.path, obj.file, data, tablename, obj.prec);
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


function save_name = sqlite_save_matrix(path, dbfile, matrix, save_name, prec)
  reshape_info=size(matrix);
  nm=[reshape(matrix,[],1)];
%%  newmatrix=num2str(newmatrix, prec);
  % create table
  command_create_table=sprintf('create table [%s] (id INTEGER PRIMARY KEY,  go_sqlite TEXT)', save_name);
  system(sprintf('%s %s "%s"', path, dbfile, command_create_table));
  % write reshape info to id=1
  command=sprintf('insert into [%s] (go_sqlite) values (''%s'')', save_name, num2str(reshape_info));
  system(sprintf('%s %s "%s"', path, dbfile, command));
  % sqlite is limited at one point, so let's write max. 100 values at ones.
 	vs = [];
 	insert_string=sprintf('insert into [%s] (go_sqlite) values ', save_name);
	nm=arrayfun(@fv,nm,prec,'UniformOutput',false);
	if size(nm,1)>100
    for n = 0:(floor(size(nm,1)/100)-1)
    	vs=[nm{((1:100)+(n*100))}];
    	vs=vs(1:end-1);
    	command = [insert_string vs];
      system(sprintf('%s %s "%s"', path, dbfile, command));
    end
    if ((n+1)*100)~=size(nm,1)
      from=(((n+1)*100)+1);
      to=size(nm,1);
			vs=[nm{(from:to)}];
			vs=vs(1:end-1);
      command = [insert_string vs];
      system(sprintf('%s %s "%s"', path, dbfile, command));
    end
      save_name = ['Matrix written to table  ' save_name];
  else
		vs=[nm{:}];
		vs=vs(1:end-1);
    command = [insert_string vs];
    system(sprintf('%s %s "%s"', path, dbfile, command)); 
  end
end

function ret = is_matrix(in)
    %% let's guess! Thank you mathworks!
    if ~iscell(in) && ndims(in)>2
        ret = 1;
    elseif ismatrix(in)
        ret = 1;
    else
        ret = 0;
    end
end

function a=fv(a,prec)
	a=['(''' num2str(a,prec) '''),']; 
end

function out=load(obj, tablename)

	if strcmp(obj.mode,'coop') 
		switch (nargin)
			case 0
				error('More input arguments needed')
			case 1
				if nargout == 0
					load_coop(obj);
				end
			case 2
				if nargout == 0
					load_coop(obj,tablename);
				else
					out = load_coop(obj, tablename);
				end
		end
	else % ego mode
		switch (nargin)
			case 0
				error('More input	arguments needed') 
			case 1
				if nargout == 0
					load_ego_all(obj);
				else
					out = load_ego_all(obj);
				end
			case 2
				if nargout == 0
					load_ego(obj, tablename);
				else
					out = load_ego(obj, tablename);
				end
		end
	end

end

function out = load_ego(obj, tablename)
  [~,available_table]=system(sprintf('%s %s "pragma table_info([%s])"', obj.path, obj.file, tablename));
  known_go_sqlite_default_matrix=[48,124,105,100,124,73,78,84,69,71,69,82,124,48,124,124,49,10,49,124,103,111,95,115,113,108,105,116,101 ,95,115,101,114,105,97,108,105,122,101,100,124,84,69,88,84,124,48,124,124,48,10];

  if isequal(known_go_sqlite_default_matrix, int8(available_table))
    command=sprintf('select go_sqlite_serialized from [%s]', tablename);
  	[~,varout]=system(sprintf('%s %s "%s"', obj.path, obj.file, command));
		varout = eval(varout);
  else
    % try read table1 into a cell
    varout = sqlite_table2cell(obj.path, obj.file,tablename);
  end

	if nargout == 1
		out = varout;
	else
		assignin('base','dasistdochkeinnamefuereinevariable',varout);
		evalin('base',sprintf('%s = dasistdochkeinnamefuereinevariable;',tablename));
		evalin('base','clear dasistdochkeinnamefuereinevariable');
	end
end

function out = load_coop(obj, tablename)

	if nargin == 1
    %% load all tables in database to the workspace
    [~,tablenames]=system(sprintf('%s %s ".tables"', obj.path, obj.file));
    tablenames=regexp(tablenames,'(  )+','split');
    tablenames=cellfun(@strtrim,tablenames,'UniformOutput',false);
    for n=1:size(tablenames,2)
      varout = read_table(obj, tablenames{n});

      %% assignin can't save structs...ugly workaround
      if numel(strfind (tablenames{1,n},'.')) > 0
        assignin('base','dasistdochkeinnamefuereinevariable',varout);
        evalin('base',sprintf('%s = dasistdochkeinnamefuereinevariable;',tablenames{n}));
        evalin('base','clear dasistdochkeinnamefuereinevariable');
      else
        assignin('base', strtrim(tablenames{n}), varout); 
      end
    end

  elseif nargin == 2
    % just load named table
    varout = read_table(obj, tablename);

    if nargout == 0
      % load table to the workspace
      assignin('base', tablename, varout);
    else
      out = varout;
    end
  end

end

function varout = read_table(obj, tablename)
  [~,available_table]=system(sprintf('%s %s "pragma table_info([%s])"', obj.path, obj.file, tablename));
%  known_go_sqlite_default_matrix=[48,124,105,100,124,73,78,84,69,71,69,82,124,48,124,124,49,10,49,124,103,111,95,115,113,108,105,116,101,124,82,69,65,76,124,48,124,124,48,10];
	known_go_sqlite_default_matrix=[48,124,105,100,124,73,78,84,69,71,69,82,124,48,124,124,49,10,49,124,103,111,95,115,113,108,105,116,101,124,84,69,88,84,124,48,124,124,48,10];
  if isequal(known_go_sqlite_default_matrix, int8(available_table))
    varout = sqlite_get_matrix(obj.path, obj.file, tablename);
  else
    % try read table1 into a cell
    varout = sqlite_table2cell(obj.path, obj.file,tablename);
  end
end

function matrix = sqlite_get_matrix(path, dbfile, table)
  command=sprintf('select go_sqlite from [%s]', table);
  [~,matrix]=system(sprintf('%s %s "%s"', path, dbfile, command));
	matrix=regexp(matrix,'\n','split');
	ri=matrix(1,1);
	if exist('isoctave')
		ri=cellfun(@str2double,cell2mat(regexp(ri,'(\d+)','tokens')));
	else
		ri=regexp(ri,'(\d+)','tokens');
		ri=cell2mat(cellfun(@str2double,ri{1,1},'UniformOutput',false));
	end
	matrix=cellfun (@str2double, matrix(1,2:end-1));
	matrix=reshape(matrix,ri);
end

function cell = sqlite_table2cell(path, dbfile, table)
  [~,col_string]=system(sprintf('%s %s "select * from ([%s]) where id=1"', path, dbfile, table));
  col_num=numel(strfind(col_string,'|'));
  [~,raw_data]=system(sprintf('%s %s "select * from ([%s])"', path, dbfile,table));
  first_pattern='(\w+)'; % let's hope the first column is ID
  rest_pattern=repmat('\|(.*?)',1,col_num);
  pattern=[first_pattern rest_pattern '\n'];
  cell = (regexp(raw_data,pattern,'tokens'));
  if exist ('OCTAVE_VERSION')~=0
    cell = cell2mat(cell);
    cell = reshape(cell,col_num+1,[])';
  else
    % eh? don't know how to make it better in matlab....
    d = cell{1,1}';
    for n = 2:size(cell,2)
      d = [d; cell{1,n}'];
    end
    cell=reshape(d,col_num+1,[])';
  end
end


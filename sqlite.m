function output_cell = sqlite(varargin)

  switch nargin
    case {0,1}
      print_help
      return
    case 2
      dbfile=varargin{1};
      command=varargin{2};
      sqlite_check(dbfile, command);
      output_cell = sqlite_action(dbfile, command);
    case 3
      dbfile=varargin{1};
      command=varargin{2};
      value=varargin{3};
      sqlite_check(dbfile, command);
      if strcmp(command,'save') && ismatrix(value)
        output_cell = sqlite_save_matrix(dbfile, value);
      elseif strcmp(command, 'get') && ischar(value)
        output_cell = sqlite_get_matrix(dbfile, value);
      else
        command=sqlite_parse_new_command(command, value);
        sqlite_action(dbfile, command);
      end
      
    otherwise
      print_help
      return
  end

end


function sqlite_check(dbfile, command)
  [status,~] = system('sqlite3 --version');
  if (0<status)
    error('please install sqlite3');
    return
  end
        
  if ~ischar(dbfile) && ~ischar(command)
    error('dbfile and command have to be strings')
    return
  end

  if ~exist(dbfile, 'file') == 2
    sprintf('File %s don''t exist and will be created', dbfile)
  end
end

function output = sqlite_action(dbfile, command)
  [status, out] = system(sprintf('sqlite3 %s "%s"', dbfile, command));
  if status~=0
    out='ERROR';
  else
    output = {out};
  end
end

function new_command = sqlite_parse_new_command(command, value);
  if isnumeric(value)
    new_command=regexprep(command,'(%s)',['''' num2str(value, '%.8f') '''']);
  else
    error('value should be double')
    return
  end
end

function save_name = sqlite_save_matrix(dbfile, matrix);
  newmatrix=[size(matrix,1); reshape(matrix,[],1)];
  table_exist=sqlite_action(dbfile,'.tables');
  for n = 1:99
    save_name=sprintf('go-sqlite-%d',n);
    a=strfind (table_exist, save_name);
    if numel(a{1,1}) == 0
      break
    elseif n == 99
      error('There are alread 99 go-sqlite databases stored')
      return
    end
  end
  command_create_table=sprintf('create table ''%s'' (id INTEGER PRIMARY KEY, Value REAL)', save_name);
  sqlite_action(dbfile, command_create_table);
  values_string=sprintf('(''%.8f''),',newmatrix);
  values_string=values_string(1:end-1);
  insert_string=sprintf('insert into ''%s'' (Value) values ', save_name);
  command = [insert_string values_string];
  sqlite_action(dbfile, command);  
  save_name = ['Matrix written to table  ' save_name];
end

function matrix = sqlite_get_matrix(dbfile, table);
  command_get_rows = sprintf('select Value from ''%s'' where id=1', table);
  r = str2double(sqlite_action(dbfile ,command_get_rows));
  command_get_allrows = sprintf('SELECT COALESCE(MAX(id)+1, 0) FROM ''%s''', table);
  n = str2double(sqlite_action(dbfile ,command_get_allrows));
  matrix=zeros(n-2,1);
  for k = 2:n-1
    command_read_value=sprintf('select Value from ''%s'' where id=%d', table, k);
    matrix(k-1,1)=str2double(sqlite_action(dbfile ,command_read_value));
  end
  matrix=reshape(matrix,r,[]);
end


function print_help()
  fprintf('Write me!\nIn the meantime take a look at https://github.com/markuman/go-sqlite/ :)\n')
end

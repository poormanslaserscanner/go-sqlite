function out=save(obj, table, matrix)
  if ismatrix(matrix) && numel(size(matrix))<=2 && ischar(table)
    out=sqlite_save_matrix(obj.file, matrix, table);
  end
end


function save_name = sqlite_save_matrix(dbfile, matrix, save_name);
  reshape_info=size(matrix,1);
  newmatrix=[reshape(matrix,[],1)];
  % create table
  command_create_table=sprintf('create table "%s" (id INTEGER PRIMARY KEY, Value REAL)', save_name);
  system(sprintf('sqlite3 %s "%s"', dbfile, command_create_table));
  % write reshape info to id=1
  command=sprintf('insert into ''%s'' (Value) values (''%d'')', save_name, reshape_info);
  system(sprintf('sqlite3 %s "%s"', dbfile, command));
  % sqlite is limited at one point, so let's write max. 100 values at ones.
  if size(newmatrix,1) > 100
    for n = 0:(floor(size(newmatrix,1)/100)-1)
      values_string=sprintf('(''%.8f''),',newmatrix((1:100)+(n*100)));
      values_string=values_string(1:end-1);
      insert_string=sprintf('insert into ''%s'' (Value) values ', save_name);
      command = [insert_string values_string];
      system(sprintf('sqlite3 %s "%s"', dbfile, command));
    end
    if ((n+1)*100)~=size(newmatrix,1)
      from=(((n+1)*100)+1);
      to=size(newmatrix,1);
      values_string=sprintf('(''%.8f''),',newmatrix(from:to));
      values_string=values_string(1:end-1);
      insert_string=sprintf('insert into ''%s'' (Value) values ', save_name);
      command = [insert_string values_string];
      system(sprintf('sqlite3 %s "%s"', dbfile, command));
    end
      save_name = ['Matrix written to table  ' save_name];
  else
    values_string=sprintf('(''%.8f''),',newmatrix);
    values_string=values_string(1:end-1);
    insert_string=sprintf('insert into ''%s'' (Value) values ', save_name);
    command = [insert_string values_string];
    system(sprintf('sqlite3 %s "%s"', dbfile, command)); 
  end
end

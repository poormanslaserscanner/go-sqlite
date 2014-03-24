function status = insert(obj, table, column, data)

  if ischar(table) && ischar(column)
    if ~ischar(data)
      data=num2str(data);
    end
    [status,~] = system(sprintf('sqlite3 %s "insert into %s (%s) values (''%s'')"', obj.file, table, column, data));
  else
    error('Wrong usage')
    print_help
  end

end

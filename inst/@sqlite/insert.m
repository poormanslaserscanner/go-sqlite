function status = insert(obj, tablename, column, data)

    if ischar(table) && ischar(column)
        if isnumeric(data)
            data=num2str(data);
        end
        cct = sprintf('insert into %s (%s) values (''%s'')', tablename, column, data);
        status = sqlite(obj.file, cct);

    else
        error('Wrong usage')
        print_help
    end

end

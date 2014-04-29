function out=sqtest(file,query)
    if ischar(file) && ischar(query)
        sqlite3(file,query)
    else
        error('input arguments have to be queries')
    end
end
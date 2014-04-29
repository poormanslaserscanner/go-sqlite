function out=sqtest(obj,query)
    if ischar(obj.file) && ischar(query)
	if length(query) <= 2147483647 % default str length limit in sqlite3 ...afaik...
	        sqlite3(obj.file,query)
	end
    else
        error('input arguments have to be queries')
    end
end

function status=tables(obj)

    switch nargin
        case {0}
            print_help
            return
        case 1
            status = sqlite(obj.file,'SELECT name FROM sqlite_master WHERE type = "table";');
        otherwise
            print_help
            return
    end

end

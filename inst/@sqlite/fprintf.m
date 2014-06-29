function status = fprintf(obj, string, value)
    switch nargin
        case {0,1}
            print_help
            return
        case 2
            status = sqlite(obj.file, string);
        case 3
            status = sqlite(obj.file, string, value);
        otherwise
            print_help
            return
    end
end




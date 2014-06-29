function save(obj, varargin)
    % parsing input arguments
    if nargin == 2
        data=varargin{1};
        tablename=inputname(2);
        if numel(tablename)==0
            error('single struct as variablenames are sadly not supported')
            return
        end
    elseif nargin == 3
        tablename=varargin{1};
        data=varargin{2};
    end

    status = save_(obj, data, tablename);
end

function status = save_(obj, data, tablename)
    % --- is data == struct
    if isstruct(data)
        f=fieldnames(data);
        for n = 1:numel(f)
            % differentiate between ndims <=2 and >2
            if ndims(data.(f{n})) <= 2
                % check for nested cell
                if iscell(data)
                    tmp=cellfun(@iscell, data);
                    if sum(tmp(:))~=0
                        status = save_serialized(obj.file, data.(f{n}), [tablename '.' f{n}], obj.prec);
                    else
                        status = save_2d(obj.file, data.(f{n}), [tablename '.' f{n}], obj.prec);
                    end
                else
                    status = save_2d(obj.file, data.(f{n}), [tablename '.' f{n}], obj.prec);
                end
            else
                status = save_serialized(obj.file, data.(f{n}), [tablename '.' f{n}], obj.prec);
            end
        end
    % --- any 2 dimension 
    elseif ndims(data) <= 2
        % if it's cell, check for nested cells
        if iscell(data)
            tmp=cellfun(@iscell, data);
            if sum(tmp(:))~=0
                status = save_serialized(obj.file, data, tablename, obj.prec);
            else
                status = save_2d(obj.file, data, tablename, obj.prec);
            end
        else
            status = save_2d(obj.file, data, tablename, obj.prec);
        end
    % --- any other object
    else
        status = save_serialized(obj.file, data, tablename, obj.prec);
    end

end

function status = save_serialized(dbfile, data, tablename, prec)
    % create table
    cct=sprintf('create table [%s] (id INTEGER PRIMARY KEY, go_sqlite_serialized TEXT);', tablename);
    sqlite3(dbfile, cct)

    % save values
    value = serialize(data);
    % escape single quotas ' due regexrep to ''
    value = regexprep(value,'''','''''');
    cct=sprintf('insert into [%s] (go_sqlite_serialized) values (''%s'');',tablename, value);
    sqlite(dbfile, cct)

    % % FIX ME
    status = 1;
end


function status = save_2d(dbfile, data, tablename, prec)

	cct=sprintf('create table [%s] (id INTEGER PRIMARY KEY', tablename);
	cols=sprintf(' ''');
	for c=1:size(data,2)
		cct=[cct sprintf(', c%d TEXT', c)];
		cols=[cols sprintf('c%d'', ''',c)];
	end
	cct=[cct ');']
	cols(end-2:end)=[];
    sqlite(dbfile, cct)
	
	% --- write rows to table
    if isnumeric(data)
        data = arrayfun (@(x) fv(x,prec),data,'UniformOutput',false);
    elseif iscell(data)
        data = cellfun (@(x) fv(x,prec),data,'UniformOutput',false);
    elseif ischar(data)
        data = ['(''' data '''),'];
    elseif isbool(data)
        data = ['(''' num2str(data) '''),'];
    end

	for r=1:size(data,1)
		d=[data{r,:}];
		cct=sprintf('insert into [%s] (%s) values (%s);',tablename, cols, d(1:end-1));
        sqlite(dbfile, cct);
	end

end

function a=fv(a,prec)
	a=['(''' num2str(a,prec) '''),']; 
end


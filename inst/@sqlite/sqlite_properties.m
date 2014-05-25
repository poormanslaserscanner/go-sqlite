function s=sqlite_properties(varargin)
	switch (nargin)
		case 0
			error('object class is needed')
		case 1
			print_info(varargin{1})
		otherwise
			if mod(numel(varargin),2)==0
				error('Unbalanced input arguments')
			else
				s=varargin{1};
				for n=2:2:numel(varargin)
					if strcmp(varargin{n}, 'path')
						s.path=varargin{n+1};
					elseif strcmp(varargin{n}, 'file')
						s.file=varargin{n+1};
					elseif strcmp(varargin{n}, 'mode')
						s.mode=varargin{n+1};
					elseif strcmp(varargin{n}, 'prec')
						s.prec=varargin{n+1};
					else
						error('Unkown option')
					end
				end
			end
	end
end


function print_info(obj)
	fprintf('sqlite path: %s\n',obj.path)
	fprintf('sqlite file: %s\n',obj.file)
	fprintf('go-sqlite mode: %s\n',obj.mode)
	fprintf('go-sqlite prec: %d\n',obj.prec)
end


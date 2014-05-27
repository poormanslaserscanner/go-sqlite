%% Copyright (C) 2014 Andreas Weber <andy.weber.aw@gmail.com>
%% Matlab branch Copyright (C) 2014 Markus Bergholz <markuman+gnupowered@gmail.com>
%%
%% This program is free software; you can redistribute it and/or modify it under
%% the terms of the GNU General Public License as published by the Free Software
%% Foundation; either version 3 of the License, or (at your option) any later
%% version.
%%
%% This program is distributed in the hope that it will be useful, but WITHOUT
%% ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
%% FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
%% details.
%%
%% You should have received a copy of the GNU General Public License along with
%% this program; if not, see <http://www.gnu.org/licenses/>.

function ret = serialize(obj)
  %% TODO:
  %% * add documentation
  %% * Have a look at all functions with malicious code injection in mind.
  if (isstruct (obj))
    ret = serialize_struct(obj);
  elseif (iscell (obj))
    ret = serialize_cell_array(obj);
  elseif (is_matrix (obj))
    if (ischar (obj))
      ret = ['char(', serialize_matrix(uint8(obj)), ')'];
    else
      ret = serialize_matrix(obj);
    end
  else
    error('Unsupported object! :(');
  end
end

function ret = is_matrix(in)
	%% let's guess!
	if ~iscell(in) && numel(size(in))>2
		ret = 1;
	elseif ismatrix(in)
		ret = 1;
	else
		ret = 0;
	end
end

function ret = serialize_2d_cell(in)
  assert (ndims (in) == 2);
  if (isempty (in))
    ret = '{}';
  else
    ret = '{';
    for (r = 1:size (in,1))
      for (c = 1:size (in,2))
        tmp = in{r,c};
        if (iscell (tmp))
          ret = [ret serialize_cell_array(tmp) ','];
        else
          ret = [ret serialize(tmp) ','];
        end
      end
      ret(end) = ';';
    end
    ret(end) = '}';
  end
end

function ret = serialize_cell_array (in)
  if(ndims (in) == 2)
    ret = serialize_2d_cell (in);
  else
    s = size (in);
    n = ndims (in);
    ret = sprintf ('cat(%i,', n);
    for (k = 1:size (in, n))
      idx.type = '()';
      idx.subs = cell(n,1);
      idx.subs(:) = ':';
      idx.subs(n) = k;
      tmp = subsref (in, idx);
      ret = [ret, serialize_2d_cell(tmp)];
      if (k < s(n))
        ret = [ret, ','];
      else
        ret = [ret, ')'];
      end
    end
  end
end

function ret = serialize_matrix(m)
  if (ndims (m) == 2)
    ret = mat2str (m);
  else
    s = size (m);
    n = ndims (m);
    ret = sprintf ('cat(%i,', n);
    for (k = 1:size (m, n))
      idx.type = '()';
      % idx.subs = cell(n,1);
      % idx.subs(:) = ':';
      idx.subs = repmat({':'},n,1);
      % idx.subs(n) = k;
      idx.subs{n,1} = k;
      tmp = subsref (m, idx);
      ret = [ret, serialize_matrix(tmp)];
      if (k < s(n))
        ret = [ret, ','];
      else
        ret = [ret, ')'];
      end
    end
  end
end

function ret = serialize_struct(in)
  assert (isstruct(in));
  ret = 'struct(';
  f = fieldnames(in);
  for n = 1:numel(f)
    val=in.(f{n});
    key=[char(39) f(n) char(39)];
    if (iscell(val) && isscalar(in))
      tmp = ['{' serialize(val) '}'];
    else
      tmp = serialize(val);
    end
    ret = [ ret key ',' tmp ','];
  end
  ret = [ ret(1:end-1) ')'];
	ret = [ret{:}];
end

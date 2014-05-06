function new_command = sqlite_parse_new_command(command, value);
  if isnumeric(value)
    new_command=regexprep(command,'(%s)',['''' num2str(value, '%.8f') '''']);
  elseif ischar(value)
    new_command=regexprep(command,'(%s)',value);
  else
    error('value should be double')
    return
  end
end
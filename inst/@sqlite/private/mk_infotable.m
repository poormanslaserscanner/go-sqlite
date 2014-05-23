function mk_infotable(obj,varname,vardim)

	command_create_table=sprintf('create table [%s] (id INTEGER PRIMARY KEY,  go_sqlite REAL)', save_name);
	system(sprintf('%s %s "%s"', path, dbfile, command_create_table));

end

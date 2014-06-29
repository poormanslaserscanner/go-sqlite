Functions
=========

## Available functions

* sqlite
* sqlite_properties
* save
* load
* fprintf
* fread
* fwrite
* runsqlscript
* sqldump
* insert
* tables

## Open a sqlite session

It doesn't matter if the file exist or not.

    >> s=sqlite('new.db');

## fprintf

`status=fprintf(obj, query, value)`

The output will be a structured array.


## save

`save(obj, data)`  
`save(obj, 'table_name', data)`

`save` stores the most of your workspace automatically for you.
  
## load

`load(obj, tablename)`  
`out=load(obj, tablename)`

`load` can read a table which is written by `save`. It's more or less auto deteced. 

    >> load(s,'m'); % will assign table 'm' as variablename 'm' to the workspace
    >> n=load(s,'m'); 
    >> load(s) % this will load all tables from the database to the workspace

#### runsqlscript

`runsqlscript(obj, inputfile)`

You can simply apply sql scripts to your database like that

    >> status = runsqlscript(s,'../sqlitescript.sql' );

## sqldump

`sqldump(obj, outputfile)`

You can simply dump (export) your sqlite database as sql file.

    >> status = sqldump(s,'dump.sql');


## insert

`insert(obj, table, column, data)`

Simple insert function as find in matlab database toolbox.  
table and column should be strings. data can be a string or double.


## tables

`status=tables(obj)`

List all available talbes in the database. Output will be a structured array (ready to loop over each table).





go-sqlite
=========

a simple sqlite 3 toolbox for GNU Octave and Matlab.  

# Versions

* Version 1.140523 - Stable [EOL]
 * `git checkout 46f82e3956`
 * 2.xxxxxx will have complete different table/column structure!
* Version 2.xxxxxx 
 * `git checkout dev`
 * currently under developement


# KEYFEATURES

* easily save 2-dimensional matrix
* automatic variablename as table name _(optional: name your tablename)_
* save supports struct arrays _(depth 1.  m.meter=rand(2,3); ✔  m.kg.g=r(2,3); ✘ )_

# DEPENDENCIES

* MATLAB or GNU Octave
* sqlite3 binary

# INSTALLATION

Download master.zip and extract or clone from github.  
Simple add the go-sqlite/inst folder to the search path.

    >> ls
    go-sqlite
    >> ls go-sqlite
    README.md  inst src doc @sqlite
    >> addpath('go-sqlite/inst')

Using Linux? `apt-get install sqlite3` or `pacman -S sqlite`  
If you're using Windows and Matlab, you probably have to use the sqlite-shell binary from sqlite.org.

    >> path_to_binary=[pwd 'sqlite-shell-win32-x86-3080402']; % absolute path. Should work with relative path too.
    >> s=sqlite('new.db', path_to_binary);

# Documentation

#### Open a sqlite session

It doesn't matter if the file exist or not.

    >> s=sqlite('new.db');

#### fprintf

`[status, output]=fprintf(obj, string, value)`

Add a new table called `table1` with 3 TEXT columns

fprintf has always two output arguments. If the first output is 0, everything is fine.

    >> [status,output]=fprintf(s,'create table table1 (id INTEGER PRIMARY KEY, Name TEXT, Animal TEXT, Job TEXT)')
    status =                    0
    output =
    
    >> [status,output]=fprintf(s,'.tables')
    status =                    0
    output = table1

Add some values to `table1`

    >> fprintf(s,'insert into table1 (Name, Animal, Job) values (''Chris'',''Cat'',''Clown'')');

You can use one variable for parsing into your string. The variable can be a string or a double number. But it's important that you mark the place in both case 
with **%s**.

    >> str='(''Alf'',''Ape'',''Astronaut'')'
    str = ('Alf','Ape','Astronaut')
    >> fprintf(s,'insert into table1 (Name, Animal, Job) values %s',str);

`table1` looks now like that.

    >> [~,out]=fprintf (s,'select * from table1')
    out = 1|Chris|Cat|Clown
    2|Alf|Ape|Astronaut


#### fread,fwrite,fprintf

This three functions do the same, except for the number of outputs.

`[status,output]=fprintf(...)` answer is status and output.  
`[output]=fread(...)` answer is only the output.  
`[status]=fwrite(...)` answer is only the status.

Example:

    >> [status,output]=fprintf(s,'pragma table_info(table1)')
    status =                    0
    output = 0|id|INTEGER|0||1
    1|Name|TEXT|0||0
    2|Animal|TEXT|0||0
    3|Job|TEXT|0||0
    
    >> fread(s,'pragma table_info(table1)')
    ans = 0|id|INTEGER|0||1
    1|Name|TEXT|0||0
    2|Animal|TEXT|0||0
    3|Job|TEXT|0||0
    
    >> fwrite(s,'pragma table_info(table1)')
    ans =                    0


#### save

`save(obj, data)`  
`save(obj, 'table_name', data)`

`save` allows you to store a 2D double matrix. **(%.8f) persicion)** or a struct full of matrices.      
The matrix will be reshaped to a one column matrix. The reshape information _(number of rows)_ is stored at the first place _(id=1)_.  
The column Name for the matrix value is `go_sqlite`, the datatype is `REAL`. 

    >> m=rand(5,5);
    >> save(s,'mytable',m)
    >> save(s,m) % will be stored as tablename 'm'


    >> fread(s,'pragma table_info(mytable)')
    ans = 0|id|INTEGER|0||1
    1|Value|REAL|0||0

#### load

`load(obj, tablename)`  
`out=load(obj, tablename)`

`load` can read a table which is written by `save`. It's more or less auto deteced. 

    >> load(s,'m'); % will assign table 'm' as variablename 'm' to the workspace
    >> n=load(s,'m'); 
    >> load(s) % this will load all tables from the database to the workspace


If the typical table structure is not found, it will read the table into one cell.

    >> cell=load(s,'table1')
    cell =
    {
      [1,1] = 1
      [2,1] = 2
      [1,2] = Chris
      [2,2] = Alf
      [1,3] = Cat
      [2,3] = Ape
      [1,4] = Clown
      [2,4] = Astronaut
    }

Happy parsing :)

#### runsqlscript

`runsqlscript(obj, inputfile)`

You can simply apply sql scripts to your database like that

    >> status = runsqlscript(s,'../sqlitescript.sql' );

#### sqldump

`sqldump(obj, outputfile)`

You can simply dump (export) your sqlite database as sql file.

    >> status = sqldump(s,'dump.sql');


#### insert

`insert(obj, table, column, data)`

Simple insert function as find in matlab database toolbox.  
table and column should be strings. data can be a string or double.


#### tables

`[parsed, unparsed]=tables(obj)`

List all available talbes in the database.

    octave:3> tables(s)
    ans = 
    {
      [1,1] = m.km 
      [1,2] = m.points 
      [1,3] = matrix 
      [1,4] = table1 
    }
    octave:4> [~,raw]=tables(s)
    raw = m.km       m.points   matrix     table1     usernames



# Performance

Writing is slow if your database file is located on a hard disk (hdd). Furthermore, if you're using `save` commands, go-sqlite can write max. 100 values at 
ones _(e.g. it do 3 writes for a 15x10 matrx. 1st write is the dimension, 2nd write the first 100 values and the 3rd write are the last 50 values)_. This is 
the disadvantage of using the sqlite3 binary.    
Reading is much faster than writing.  

On Linux, you can locate your database file to tmpfs. It's probably the fastest methode.  
How ever, on modern hosts with SSD storage, if's fairly fast too.

If it's even to slow for your needs, try another database, e.g. redis with [go-redis](https://github.com/markuman/go-redis).





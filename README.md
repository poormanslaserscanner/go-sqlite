go-sqlite
=========

A simple sqlite wrapper for GNU Octave and Matlab.  

# dependencies

* MATLAB or GNU Octave
* sqlite3 binary

# usage/installation.

Download .zip and extract or clone from github.  
Simple add the go-sqlite folder to the search path.

    >> ls
    go-sqlite
    >> ls go-sqlite
    README.md  @sqlite
    >> addpath('go-sqlite/')



## todo

* add write support for multidimensional matrix?!
* add write support for complex matrix?!
* write documentation into the .m file :)

# Documentation

#### Open a sqlite session

It doesn't matter if the file exist or not.

    >> s=sqlite('new.db');
    obj = <class sqlite>


#### fprintf

_fprintf(obj, string, value)_

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

You can use one variable for parsing into your string. The variable can be a string or a double number. But it's important that you mark the place in both case with **%s**.

    >> str='(''Alf'',''Ape'',''Astronaut'')'
    str = ('Alf','Ape','Astronaut')
    >> fprintf(s,'insert into table1 (Name, Animal, Job) values %s',str);

`table1` looks now like that.

    >> [~,out]=fprintf (s,'select * from table1')
    out = 1|Chris|Cat|Clown
    2|Alf|Ape|Astronaut


#### fread,fwrite,fprintf

This three functions do the same, except for the number of outputs.

`[status,output]=fprintf(...)` reply with status and output.  
`[output]=fread(...)` reply only with the output.  
`[status]=fwrite(...)` answeres only with the status.

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

_save(obj, table, matrix)_

`save` allows you to store a 2D double matrix. **(%.8f) persicion)**.    
The matrix will be reshaped to a one column matrix. The reshape information is stored at the first place _(id=1)_.

    >> m=rand(5,5);
    >> save(s,'m',m)
    ans = m

It replies with just with the name of the written table.  

    >> fread(s,'pragma table_info(m)')
    ans = 0|id|INTEGER|0||1
    1|Value|REAL|0||0

#### load

_load(obj, table)_

`load` can read a table which is written by `save`. It's more or less auto deteced. 

    >> n=load(s,'m');

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


# Performance

Writing is slow if your database file is located on a hard disk (hdd). Furthermore, if you're using `save` commands, go-sqlite can write max. 100 values at ones _(e.g. it do 3 writes for a 15x10 matrx. 1st write is the dimension, 2nd write the first 100 values and the 3rd write are the last 50 values)_. This is the disadvantage of using the sqlite3 binary.    
Reading is much faster than writing.  

On Linux, you can locate your database file to tmpfs. It's probably the fastest methode.  
How ever, on modern hosts with SSD storage, if's fairly fast too.

If it's even to slow for your needs, try another database, e.g. redis with [go-redis](https://github.com/markuman/go-redis).



go-sqlite
=========

A simple sqlite wrapper for GNU Octave and Matlab.  

`sqlite(dbfile,command,value)`

If you let go-sqlite save the value or a matrix _(when you said the 3rd input argument)_, it currently writes values as `%.8f`. See examples below.

# dependencies

* MATLAB or GNU Octave
* sqlite3 binary


## Examples
**NOTE:** the output should always be a cell with strings!

Create `table1` in `new.db`  

    >> sqlite('new.db','create table table1 (id INTEGER PRIMARY KEY, Name TEXT, Animal TEXT, Job TEXT)');

Insert values in `table1`

    >> sqlite('new.db','insert into table1 (Name, Animal, Job) values (''Chris'',''Cat'',''Clown'')');

Select everything in `table1`

    >> sqlite('new.db','select * from table1')
    ans = 1|Chris|Cat|Clown

Create `matrix` in `new.db` with column-name `value` and datatype `REAL`

    >> sqlite('new.db','create table matrix (id INTEGER PRIMARY KEY, value REAL)');

Insert pi into table `matrix`  
**Yes, always user `%s` for you variable you want to put into the command string!!**

    >> sqlite('new.db','insert into matrix (value) values (%s)',pi);

Display all tables in `new.db` 

    >> sqlite('new.db','.tables')
    ans = table1  matrix

List columns in table `matrix`

	>> a=sqlite('new.db','pragma table_info(matrix)')
	
	a = 
	
    	[1x36 char]
	
	>> a{1,1}
	
	ans =
	
	0|id|INTEGER|0||1
	1|Value|REAL|0||0
	Select everything in `table2`
	
    >> sqlite('new.db','select * from matrix')
	ans =
	{
	  [1,1] = 1|3.14159265

	}
    

Get/read variable id1 from `matrix`


	>> sqlite('new.db','select Value from matrix where id=1')
	ans =
	{
	  [1,1] = 3.141593

	}


## Write a matrix to a database.
**NOTE:** Input and output is always a 2D double matrix!

go-sqlite helps to write a matrix into a sqlite database. It will create automaticaly a table called `go-sqlite-XX`.  
The number of rows is saved in id=1 **(this is an important information for reshape)**.  
It saves in 100 value steps. That means, a 10x10 matrix is safed in one step.  

	>> m=rand(6,7)
	
	m =
	
	    0.9058    0.5469    0.4854    0.9595    0.7577    0.0318    0.3171
	    0.1270    0.9575    0.8003    0.6557    0.7431    0.2769    0.9502
	    0.9134    0.9649    0.1419    0.0357    0.3922    0.0462    0.0344
	    0.6324    0.1576    0.4218    0.8491    0.6555    0.0971    0.4387
	    0.0975    0.9706    0.9157    0.9340    0.1712    0.8235    0.3816
	    0.2785    0.9572    0.7922    0.6787    0.7060    0.6948    0.7655
	
	>> sqlite('m.db','save',m)
	
	ans =
	
	Matrix written to table go-sqlite-1
	
	>> n=sqlite('m.db','get','go-sqlite-1')
	
	n =
	
	   0.9058    0.5469    0.4854    0.9595    0.7577    0.0318    0.3171
 	   0.1270    0.9575    0.8003    0.6557    0.7431    0.2769    0.9502
 	   0.9134    0.9649    0.1419    0.0357    0.3922    0.0462    0.0344
 	   0.6324    0.1576    0.4218    0.8491    0.6555    0.0971    0.4387
 	   0.0975    0.9706    0.9157    0.9340    0.1712    0.8235    0.3816
 	   0.2785    0.9572    0.7922    0.6787    0.7060    0.6948    0.7655



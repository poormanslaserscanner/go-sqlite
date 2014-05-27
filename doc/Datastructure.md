Datastructure
=============

This page may be only interessted to you if you want to use the database written by `go-sqlite` with other programming languages or applications.


# EGO

This mode is pretty easy, every table has two columns.

The tablename is taken from the variablename itself if no other name was given.

Column-structure:

1. id INTEGER PRIMARY KEY
2. go\_sqlite\_serialized TEXT

All data is stored in id=1. It's one single string which can be simple run with `eval()` in GNU Octave/Matlab.

# coop

This mode differentiate between the different datatypes.

## struct

Every structname can be another datatype _(see Matrix, Cell and Char)_.

The tablenames are equal to the fieldnames.

## Matrix

**TODO - not implemented yet!**

1. id INTEGER PRIMARY KEY
2. 

## Cell

A 2D cell is saved as you see. For example:

    >> c={1 2 3; "one" "two" "three"}
	c = 
	{
	  [1,1] =                    1
	  [2,1] = one
	  [1,2] =                    2
	  [2,2] = two
	  [1,3] =                    3
	  [2,3] = three
	}            
    >> save(s,c);

Table 'c' will have 4 columns.

1. id INTEGER PRIMARY KEY
2. c1 TEXT
3. c2 TEXT
4. c3 TEXT

Table 'c' will have 2 rows.

1. id=1
2. id=2

This is what this cell would look like in sqlite3

    sqlite> select * from c;
    1|1|2|3
    2|one|two|three
    sqlite> 


## char

A char/string will be have two columns

** TODO!!**

1. id INTEGER PRIMARY KEY
2. go\_sqlite\_string TEXT


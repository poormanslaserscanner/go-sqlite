# Install

`go-sqlite` uses both, the sqlite shell binary and a mex file (C written). So you need at least to compile the .mex file.  

So minimum setup:

1. compile mex file
2. `>> addpath('go-sqlite/inst')`

Full featured setup:

1. compile sqlite shell
2. compile mex file
3. `>> addpath('go-sqlite/inst')`



## sqlite shell

The sqlite shell is needed for `runsqlitescript`, `sqlitedump` and `csvimport`.   
You have currently 4 options

1. You don't need this 3 functions.
2. You're using Linux.
  * simply install sqlite3 with your package manager and link the `sqlite3` shell into private folder. E.g: `ln -s /usr/bin/sqlite3 
~/go-sqlite/inst/@sqlite/private/sqlite3`
3. You can download it precompiled for most operating systems from [sqlite.org](http://sqlite.org/download.html). Extract it directly in 
`~/go-sqlite/inst/@sqlite/private/`. Ensure that the file is named sqlite3.
4. Compile the sqlite shell by yourself from source (E.g. with tcc).


#### Compile sqlite shell with tcc
 
`cd` into `go-sqlite/src` dir

    $ tcc -ldl -pthread -rdynamic sqlite-amalgamation-3080500/shell.c sqlite-amalgamation-3080500/sqlite3.c -o ../inst/\@sqlite/private/sqlite3

## compile mex file

#### With TCC (software independent)

`cd` into `go-sqlite/src` dir

Using octave mex.h

    $ tcc -lsqlite3 -I ./sqlite-amalgamation-3080500/ -I /usr/include/octave-3.8.1/octave/ -shared mex-sqlite3/sqlite.c -o ../inst/\@sqlite/private/sqlite.mex

Using matlab mex.h

    $ tcc -lsqlite3 -I ./sqlite-amalgamation-3080500/ -I ~/R2013b/extern/include/ -shared mex-sqlite3/sqlite.c -o ../inst/\@sqlite/private/sqlite.mexa64


Ensure to have the correct file extension (depends on target OS and software). 

* octave: **.mex**
* matlab linux: **.mexa64**
* matlab windows: **.mexw64**
* matlab mac: **.mexmaci64**



#### With Matlab (just for Matlab)

In this example, Matlab is running on Linux using gcc compiler.

    >> mex -lsqlite3 CFLAGS='-Wall -Wextra -shared -fPIC -O0 -std=c99 -pedantic -g' mex-sqlite/sqlite.c

You have to copy the created .mex* file to `go-sqlite/inst/@sqlite/private/


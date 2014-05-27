README
======

# DEPENDENCIES

* MATLAB or GNU Octave
* sqlite3 binary

# INSTALLATION

Download master.zip and extract or clone from github.  
Simple add the folder `go-sqlite/inst` to the search path.

    >> ls
    go-sqlite
    >> ls go-sqlite
    README.md  inst src doc @sqlite
    >> addpath('go-sqlite/inst')

Using Linux?  

* `apt-get install sqlite3` or `pacman -S sqlite`  

If you're using Windows and Matlab, you probably have to use the sqlite-shell binary from sqlite.org.

    >> path_to_binary=[pwd 'sqlite-shell-win32-x86-3080402']; % absolute path. Should work with relative path too.
    >> s=sqlite('new.db', path_to_binary);
	%% or
	>> storage=sqlite('another.db', 'C:\sqlite-shell\');

# MODES

go-sqlite has two modes

## coop 

`coop` _(cooperative)_: is the nearly the save format from version 1.xxxxxx.    

* It's fairly easy to use the tables in other programming languages too. 
	* A Matrix for exmaple is simply reshaped to a one column matrix. The reshape information _(number of rows)_ is stored at the first place _(id=1)_.  
	* cells _(nested cells are not supported in this mode!)_ are simply equal stored to the number of rows and columns in a table.  

However, the `coop` mode is more limited than the `ego` mode

supports full automatic save and load:

* structs:
    * s.name ✔
    * s.name.more ✘
* cells:
    * 2D ✔
    * higher than 2D ✘
    * nested cells ✘
* multi-dimensional matrix _(real and complex)_ ✔
* chars ✔    

                
## ego

`ego` _(egoistic)_: is the new save format since version 2.xxxxxx. 

It's designed for best usage in GNU Octave/Matlab. All datatypes are serialized to a json style format. 

* The benifits are:
    * multi-dimensional matrix _(real and complex)_ ✔
    * 2D cells ✔
    * 3D and higher cells ✔
    * nested cells ✔
    * struct arrays ✔
        * `s.name` ✔, `s.name.more` ✔, ...
    * chars ✔

Howevery, it could be very hard to use those dataformats with other programming languages too _(for someone more, for someone less)_.
  
__NOTE:__ The serialize function is taken from https://github.com/octave-de/serialize and licened under the GPLv3.



Datastructure
=============

This page may be only interessted to you if you want to use the database written by `go-sqlite` with other programming languages or applications.

# ndims <= 2

All objects with ndims()<=2 are simply stored as you would see it in Excel.  
The column names are c1, c2, c3 ...

# ndims > 2 or nested cells

Nested cells or objects with ndims > 2 are simply serialized and saved in one long string.  
On basis of this design you can't access single values from those objects! But you're able to save nearly every dataformat in a sqlite database.

# serialize matrix
http://stackoverflow.com/questions/7857308/easiest-way-to-serialize-multi-dimensional-array-in-matlab-for-database-insertio

Every change at the class itself _(or at the default table structure)_ will be a major release.

roadmap:  
* version 2.xxxxxx
 * add ego_sqlite function in save.m
 * some changes in load.m for the modes
 * save complex matrix, save- ndimensional matrix - for COOP mode!
  * new table structure? _(new major release)_: ID, info, real-values, complex-values
  * info ID=1: size(matrix); ID=2: isreal(matrix)
 * "ego" + "coop" mode - better usability for changing the modes
  * "coop" is the save format from version 1 - fairly easy to use the tables in other programming languages
  * "ego" - radical serialize every datatype. very hard to use the tables in other programming languages
 * set default precision to %.16f _(define in class)_
* version 3.xxxxxx
 * opional c written mex file

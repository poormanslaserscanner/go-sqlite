# serialize matrix
http://stackoverflow.com/questions/7857308/easiest-way-to-serialize-multi-dimensional-array-in-matlab-for-database-insertio

Every change at the class itself _(or at the default table structure)_ will be a major release.

roadmap: 
* version 2.xxxxxx
 * load.m
  * write load_ego_all
	* update signature for coop mode
 * save 
  * complex matrix, save- ndimensional matrix - for COOP mode!
  * new table structure? _(new major release)_: ID, info, real-values, complex-values
  * info ID=1: size(matrix); ID=2: isreal(matrix)
  * set default precision to %.16f _(define in class)_???
   * how to handle this?
* version 3.xxxxxx
 * opional c written mex file
 * improve fread, fwrite and fprintf functions

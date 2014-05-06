/*
 * sqlite3(file, query)
 *
 * TODO:
 *  output
 *  error messages with zErrMsg
 *
 * input checks have to be done in the .m file
 * example:
 *
 * function sqtest(obj,query)
 *  if ischar(obj.file) && ischar(query)
 *      sqlite3(obj.file,query)
 *  else
 *      error('input arguments have to be queries')
 *  end
 * end
 */
#include "mex.h"
#include <stdio.h>
#include <sqlite3.h>

/* begin example from sqlite.org */
typedef int (*sqlite3_callback)(
        void*,    /* Data provided in the 4th argument of sqlite3_exec() */
        int,      /* The number of columns in row */
        char**,   /* An array of strings representing fields in the row */
        char**    /* An array of strings representing column names */
        );

static int callback(void *data, int argc, char **argv, char **azColName){
    int i;
    fprintf(stderr, "%s: ", (const char*)data);
    for(i=0; i<argc; i++){
        printf("%s = %s\n", azColName[i], argv[i] ? argv[i] : "NULL");
    }
    printf("\n");
    return 0;
}
/* end example from sqlite.org */

/* MEX function */
void mexFunction( int nlhs, mxArray *plhs[],
        int nrhs, const mxArray *prhs[])
{
    
    if(nrhs!=2) {
        mexErrMsgIdAndTxt("MyToolbox:arrayProduct:nrhs", "Two input arguments needed.");
        /* no more input checks...have to be done in the .m file */
        /* first argument is the file name (char) */
        /* second argument is the sqlite query (char) */
    }  else {
        
        /* get sqlite query */
        char *query;
        query = (char *) mxCalloc(mxGetN(prhs[1])+1, sizeof(char));
        mxGetString(prhs[1], query, mxGetN(prhs[1])+1);
        /* mexPrintf("%s\n",query); */
        
        /* get sqlite filename */
        char *file;
        file = (char *) mxCalloc(mxGetN(prhs[0])+1, sizeof(char));
        mxGetString(prhs[0], file, mxGetN(prhs[0])+1);
        /* mexPrintf("%s\n",file); */
        
        /* sqlite stuff */
        sqlite3 *db;
        char *zErrMsg = 0;
        int rc;
        /* zErrMsg to Matlab */
        char str[256]; /* ??? hardcoded is weak ... */
        
        rc = sqlite3_open(file, &db);
        if( rc ){
            /* mexErrMsgIdAndTxt("MyToolbox:arrayProduct:nrhs", "Can't open database\n.", sqlite3_errmsg(db)); */
            mexErrMsgIdAndTxt("MyToolbox:arrayProduct:nrhs", "Can't open database\n.");
            sqlite3_close(db);
            exit(0);
        }else{
            /* for debugging */
            mexPrintf("Opened database successfully\n");
            
            /* query action here */
            rc = sqlite3_exec(db, query, callback, 0, &zErrMsg);
            if( rc!=SQLITE_OK ){
                /* testing output and feedback when failing.... */
                mexPrintf("SQL error\n");
                plhs[0]=mxCreateString(zErrMsg);
                fprintf(stderr, "SQL error: %s\n", zErrMsg);
                sqlite3_free(zErrMsg);
            }
            sqlite3_close(db);
        }
    }
}
    

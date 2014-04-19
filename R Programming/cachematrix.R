## Matrix inversion is usually a costly computation and there may be some
## benefit to caching the inverse of a matrix rather than compute it repeatedly.
## These functions provide the functionality for caching the inverse of a matrix.

## This function creates a special "matrix" object that can cache its inverse.
## makeVector used as a model.
## m is the matrix
## i is the inverse matrix

makeCacheMatrix <- function( m = matrix() )
{
   ## initialize starting values to NULL
   i <- NULL
   
   ## set will assign the matrix and reset the inverse to NULL
   set <- function( y )
   {
      m <<- y
      i <<- NULL
   }
   
   ## get returns the current matrix
   get <- function() m
   
   ## setinverse will assign the inverse value
   setinverse <- function( inverse ) i <<- inverse
   
   ## getinverse will return the inverse value
   getinverse <- function() i
   
   ## create the vector for the functions.
   list( set = set, get = get,
         setinverse = setinverse,
         getinverse = getinverse )
}


## This function computes the inverse of the special "matrix" returned by
## makeCacheMatrix above. If the inverse has already been calculated (and the
## matrix has not changed), then the cachesolve should retrieve the inverse from
## the cache.
## m is the matrix we want to provide the inverse for
## i is the inverse solution

cacheSolve <- function(m, ...)
{
   ## first, check to see if we have it already
   i <- m$getinverse()
   
   ## if i isn't null, then we have it cached, so just return it
   if( !is.null( i ) )
   {
      message( "getting cached data"  )
      return( i )
   }
   
   # we don't have it, so call setInverse and it will return 'i' for us
   m$setinverse( solve( m$get(), ... ) )
}

## Test function, builds two simple 2x2 invertible matrices.  Outputs the
## starting matrices then computes their inverses.  Then checks the caching
## by outputting the inverses again, and then validates the inverse by 
## multiplying the starting and inverse matrices to get an identity matrix.
doTest <- function()
{
   cm1 <- makeCacheMatrix();
   m1  <- matrix( c( 4, 2, 7, 6 ), nrow = 2 )
   cm1$set( m1 )
   
   cm2 <- makeCacheMatrix();
   m2 <- matrix( c( 4, 3, 3, 2 ), nrow = 2 )
   cm2$set( m2 )

   print(m1)
   print(m2)
   print( cacheSolve( cm1 ) )
   print( cacheSolve( cm2 ) )
   print( "check for caching" )
   print( cacheSolve( cm1 ) )
   print( m1 %*% cacheSolve( cm1 ) )
   print( cacheSolve( cm2 ) )
   print( m2 %*% cacheSolve( cm2 ) )
}

# doTest()
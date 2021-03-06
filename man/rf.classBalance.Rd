% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rf.classBalance.R
\name{rf.classBalance}
\alias{rf.classBalance}
\title{Random Forest Class Balance (Zero Inflation Correction) Model}
\usage{
rf.classBalance(ydata, xdata, p = 0.005, cbf = 3, sf = 2, seed = NULL, ...)
}
\arguments{
\item{ydata}{Response variable using index (i.e., [,2] or [,"SPP"] )}

\item{xdata}{Independent variables using index (i.e., [,3:14] or 
[3:ncol(data)] )}

\item{p}{p-value of covariance convergence (do not recommend changing)}

\item{cbf}{Scaling factor to test if problem is imbalanced, default is 
size of majority class * 3}

\item{sf}{Majority subsampling factor. If sf=1 then random sample would 
be perfectly balanced with smallest class [s|0=n|1] whereas; 
sf=2 provides [s|0=(n|1*2)]}

\item{seed}{Sets random seed in R global environment}

\item{...}{Additional arguments passed to randomForest}
}
\value{
A rf.balanced object with the following components:
  \itemize{ 
  \item model = [Final Combined Random Forests ensemble (randomForest object)]
  \item OOB.error = [averaged out-of-bag error for each model]
  \item confusion = [averaged confusion matrix for each model]
  }
}
\description{
Implements Evans & Cushman (2008) Random Forests class-balance 
             (zero inflation) modeling approach.
}
\details{
This approach runs independent Random Forest models using random subsets of 
the majority class until covariance convergences on full data. The final model 
is obtained by combining independent ensembles.
}
\examples{
require(randomForest)
data(iris)
  iris$Species <- as.character(iris$Species)
    iris$Species <- ifelse(iris$Species == "setosa", "virginica", iris$Species)
      iris$Species <- as.factor(iris$Species)	
	
# Percent of "virginica" observations
length( iris$Species[iris$Species == "virginica"] ) / dim(iris)[1]*100

# Balanced model	
( cb <- rf.classBalance( ydata=iris[,"Species"], xdata=iris[,1:4], cbf=1 ) )

# Calculate Kappa for each balanced model in ensemble 
for(i in 1:length(cb$confusion) ) { 
  print( accuracy(cb$confusion[[i]][,1:2])[5] ) 
}

# Evaluate cumulative and mean confusion matrix
accuracy( round((cb$confusion[[1]] + cb$confusion[[2]] + cb$confusion[[3]]))[,1:2] )
accuracy( round((cb$confusion[[1]] + cb$confusion[[2]] + cb$confusion[[3]])/3)[,1:2])

}
\references{
Evans, J.S. and S.A. Cushman (2009) Gradient Modeling of Conifer Species 
  Using Random Forest. Landscape Ecology 5:673-683.

Evans J.S., M.A. Murphy, Z.A. Holden, S.A. Cushman (2011). Modeling species 
  distribution and change using Random Forests CH.8 in Predictive Modeling in 
  Landscape Ecology eds Drew, CA, Huettmann F, Wiersma Y. Springer
}
\seealso{
\code{\link[randomForest]{randomForest}} for randomForest ... model options
}
\author{
Jeffrey S. Evans   <jeffrey_evans<at>tnc.org>
}

\name{bin-methods}
\alias{bin-methods}
\alias{Bin}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Bin methods for discretizing variables
}
\description{
Bin is a generic function that works differently depending on the inputs.
}
\usage{
Bin(x, y, w, seg)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{
    A numeric or factor variable or a \code{data.frame}.
    }
  \item{y}{
    A binary, numeric variable with values of 0 and 1 only.
  }
  \item{w}{
    An optional numeric vector of positive weights.
  }
  \item{seg}{
    An optional segment \code{factor}
  }
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (x)
{
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
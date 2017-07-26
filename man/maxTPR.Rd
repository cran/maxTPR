\name{maxTPR}
\alias{maxTPR}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Maximizing the TPR for a Specified FPR
}
\description{
Often in the risk prediction setting, there is interest in combining several predictors (e.g., biomarkers) into a single tool for prognosis, diagnosis or screening. One way to accomplish this is by targeting a measure of predictive capacity. In many cases, there is interest in the true positive rate (TPR; sensitivity) for a clinically meaningful false positive rate (FPR; 1-specificity). This function estimates a linear combination of predictors by maximizing a smooth approximation to the empirical TPR (sTPR) while constraining a smooth approximation to the empirical FPR (sFPR). Furthermore, since the TPR and FPR are determined both by the linear combination and the threshold (i.e., TPR is the proportion of diseased individuals whose linear combination value exceeds some threshold), this function estimates the combination and the threshold simultaneously. Estimates from robust logistic regression, specifically the method of Bianco and Yohai (implemented via the \code{aucm} package), are used as starting values for the linear combination.
}
\usage{
maxTPR(data, tval, initialval="rGLM", alpha = 0.5, approxh = 0.5,
tolval = 1e-4, stepsz = 1e-5, multiplier = 2)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{data}{
    An object of class `data.frame' where the first column contains the outcome (disease) indicator (1 for diseased, 0 for non-diseased), and the subsequent columns are the predictors. Note that missing observations are allowed, but they will be automatically removed. All columns of \code{data} must be numeric. The columns of \code{data} will be (re)named "D" for the first column and "V1", "V2", ... for the subsequent (predictor) columns.
  }
  \item{tval}{
    The acceptable FPR value. The method constrains the smooth approximation to the FPR to be less than or equal to \code{tval}; see \code{alpha} below.
  }
  \item{initialval}{
  Starting values of the predictor combination for the smooth TPR maximization algorithm. Default value is \code{"rGLM"}, which means that estimates from robust logistic regression, specifically the method of Bianco and Yohai (implemented via the \code{aucm} package), are used as starting values. If any other value of \code{initialval} is given, or if robust logistic regression fails to converge, estimates from standard logistic regression are used as starting values.
  }
  \item{alpha}{
    To improve performance, a small buffer may be added to \code{tval}. The parameter \code{alpha} controls the size of this buffer, relative to the number of controls (individuals without the disease). The default value is \code{alpha}=0.5, meaning that the default buffer is 0.5/(number of controls) so the sFPR is constrained to be less than or equal to \code{tval} + 0.5/(number of controls).
  }
  \item{approxh}{
    The tuning parameter for the smooth approximations is the ratio of the standard deviation of the linear combination (based on the starting values) to \eqn{n^{approxh}}, where \eqn{n} is the sample size. In particular, larger values of \code{approxh} will provide a better approximation to the TPR and FPR, though estimation may become unstable if \code{approxh} is too large. Default 0.5.
  }
  \item{tolval}{
    Controls the tolerance on feasibility and optimality for the optimization procedure (performed by \code{solnp} in the \code{Rsolnp} package). Default 1e-4.
  }
  \item{stepsz}{
    Controls the step size for the optimization procedure (performed by \code{solnp} in the \code{Rsolnp} package). Default 1e-5.
  }
  \item{multiplier}{
  Used to provide an initial value for the threshold to the optimization procedure. Using the starting values for the linear combination (based on robust logistic regression), a reasonable choice for this initial value is the threshold such that sFPR = \code{tval}. This value can found by using the \code{uniroot} function, which requires a range over which to search. The \code{multiplier} parameter controls the size of this range; if the range is not wide enough, the error `f() values at end points not of opposite sign' will be seen, and \code{multiplier} should be increased. The size of \code{multiplier} will not generally have a large impact on results, though narrower (but valid) ranges may offer slightly better precision in the results from \code{uniroot}. Default 2.
  }
}
%% \details{
%%  ~~ If necessary, more details than the description above ~~
%% }
\value{
A list with the following components:
\item{sTPRrslt}{ The results from the smooth TPR maximization procedure, including 'delta' (the threshold estimated by the maximization procedure), 'deltaRE' (the threshold estimated based on quantiles of the combination estimated by the maximization procedure), the estimated combination coefficients, and an indicator of convergence for the optimization procedure.}
\item{rGLMrslt}{ The results from the robust logistic regression model (fit using \code{rlogit}), including 'delta' (the threshold estimated based on quantiles of the combination estimated by robust logistic regression), the estimated combination coefficients, and an indicator of convergence for \code{rlogit}. Note that if \code{rlogit} fails to converge, these results will be identical to \code{GLMrslt}, since in this case, the estimates from standard logistic regression are used in place of those from robust logistic regression. Since the smooth TPR maximization procedure involves constraining the norm of the combination coefficients to be 1 for identifiability, this constraint was also applied to the robust logistic regression results.}
\item{GLMrslt}{ The results from the (standard) logistic regression model, including 'delta' (the threshold estimated based on quantiles of the combination estimated by (standard) logistic regression), the estimated combination coefficients, and an indicator of convergence for \code{glm}. Since the smooth TPR maximization procedure involves constraining the norm of the combination coefficients to be 1 for identifiability, this constraint was also applied to the logistic regression results. }
\item{Nobs}{ The number of observations remaining after observations with missing values were removed. }
For all three methods, the combination coefficients are reported in the same order as the columns of \code{data}.
}
\references{
Meisner, A., Carone, M., Pepe, M., and Kerr, K.F. (2017). Combining biomarkers by maximizing the true positive rate for a fixed false positive rate. UW Biostatistics Working Paper Series, Working Paper 420.

Bianco, A.M. and Yohai, V.J. (1996) Robust estimation in the logistic regression model. In Robust statistics, data analysis, and computer intensive methods (ed H. Rieder), pp 17-34. Springer.
}
%% \author{
%%  ~~who you are~~
%% }
%% \note{
%%  ~~further notes~~
%% }

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
 \code{\link[aucm]{rlogit}}, \code{\link[Rsolnp]{solnp}}
}
\examples{
set.seed(4)
x1 <- rnorm(400)
x2 <- rnorm(400)
y <- rbinom(400,1,exp(x1+x2)/(1+exp(x1+x2)))
data <- data.frame(y,x1,x2)
maxTPR(data,0.2)
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
% \keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
% \keyword{ ~kwd2 }% __ONLY ONE__ keyword per line

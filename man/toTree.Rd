% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/toTree.R
\name{toTree}
\alias{toTree}
\title{Translate a data frame to a phylo object}
\usage{
toTree(data, cache = FALSE)
}
\arguments{
\item{data}{A data frame or matrix.}

\item{cache}{A logical value, TRUE or FALSE. The default is FALSE. If TRUE,
the output `phylo` has 6 elements (edge, tip.label, edge.length, Nnode,
node.label, and cache). The \strong{cache} is a list that has the length
equals to the number of internal node, and each of its element stores the
descendant leaves.}
}
\value{
a phylo object
}
\description{
\code{toTree} translates a data frame to a phylo object
}
\details{
The last column is used as the leaf nodes
}
\examples{

taxTab <- data.frame(R1 = rep("A", 5),
R2 = c("B1", rep("B2", 4)),
R3 = c("C1", "C2", "C3", "C3", "C4"))

taxTab <- data.frame(R1 = rep("A", 5),
R2 = c("B1", rep("B2", 2), NA, "B2"),
R3 = c("C1", "C2", "C3", NA, "C4"))

tree <- toTree(data = taxTab)

}
\author{
Ruizhu HUANG
}

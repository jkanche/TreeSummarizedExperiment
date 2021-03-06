% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tree_distNode.R
\name{distNode}
\alias{distNode}
\title{Calculate the distance between any two nodes on the tree}
\usage{
distNode(tree, node)
}
\arguments{
\item{tree}{A phylo object.}

\item{node}{A numeric or character vector of length two.}
}
\value{
A numeric value.
}
\description{
\code{distNode} is to calculate the distance between any two nodes on
a \code{phylo} tree
}
\examples{
library(ggtree)
data(tinyTree)
ggtree(tinyTree) +
    geom_text2(aes(label = node), color = "darkorange",
           hjust = -0.1, vjust = -0.7) +
    geom_text2(aes(label = branch.length), color = "darkblue",
               vjust = 0.7)

# remove the blue branch
distNode(tree = tinyTree, node = c(10, 11))

}

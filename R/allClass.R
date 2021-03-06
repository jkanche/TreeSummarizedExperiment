
# ======================
### class
# ======================

#-------------------------------------------------------------------------------
#' phylo: A S3 class for the phylogenetic tree
#-------------------------------------------------------------------------------
#'
#' The \pkg{ape} package does not export its phylo class, probably because it
#' is not really defined formally anywhere. Technically, it is an S3 class
#' extended from the class list. Any exported definitions from the \pkg{ape}
#' package would be preferred to use if available.
#' @importFrom methods setOldClass
#' @keywords internal
phylo <- structure(list(), class = "phylo")
setOldClass("phylo")


#-------------------------------------------------------------------------------
#' LinkDataFrame: A S4 class extended from DataFrame
#-------------------------------------------------------------------------------
#' An S4 class LinkDataFrame
#'
#' The \strong{LinkDataFrame} is extended from the class \strong{DataFrame} by
#' adding one new slot \code{LinkData}
#'
#' @slot LinkData A \link[S4Vectors]{DataFrame-class}. It will be shown in the
#'   left side of the vertical line when print out the generated
#'   \code{LinkDataFrame}.
#' @slot ... Other slots from \link[S4Vectors]{DataFrame-class}.
#'
#' @importClassesFrom S4Vectors DataFrame
#' @exportClass LinkDataFrame
#'
#' @section Constructor:
#' See \code{\link{LinkDataFrame-constructor}} for constructor
#' functions.
#'
#' @section Accessor:
#' See \code{\link{LinkDataFrame-accessor}} for accessor functions.
#'
#' @seealso \code{\link{LinkDataFrame-accessor}}
#'   \code{\link{LinkDataFrame-constructor}} \link[S4Vectors]{DataFrame-class}
#' @name LinkDataFrame-class
setClass("LinkDataFrame",
         representation(LinkData = "DataFrame"),
         contains = "DataFrame")

#-------------------------------------------------------------------------------
#' Construct a LinkDataFrame
#-------------------------------------------------------------------------------
#' Construct a LinkDataFrame object
#'
#' @param LinkData A \code{\link[S4Vectors]{DataFrame-class}}.
#' @param ... All arguments accepted by \code{\link[S4Vectors]{DataFrame}}.
#'
#' @importFrom S4Vectors DataFrame
#' @name LinkDataFrame-constructor
#' @export
#' @return A LinkDataFrame object
#' @seealso \code{\link{LinkDataFrame-accessor}}
#'   \code{\link{LinkDataFrame-class}} \code{\link[S4Vectors]{DataFrame-class}}
#' @examples
#'
#' left <- DataFrame(left1 = 1:5, left2 = letters[1:5])
#' right <- DataFrame(right1 = sample(letters[1:3], 5, replace = TRUE),
#'                   right2 = sample(c(TRUE, FALSE), 5, replace = TRUE),
#'                   right3 = 11:15)
#'
#' (ld <- LinkDataFrame(LinkData = left, right))
LinkDataFrame <- function(LinkData = NULL, ...) {
    df <- DataFrame(...)
    new("LinkDataFrame", df, LinkData = LinkData)
}

#-------------------------------------------------------------------------------
# TreeSummarizedExperiment
#-------------------------------------------------------------------------------
#' An S4 class TreeSummarizedExperiment
#'
#' The class \strong{TreeSummarizedExperiment} is an extension class of standard
#' \code{\link[SummarizedExperiment]{SummarizedExperiment-class}} class. It has
#' five slots. Four of them are traditional slots from
#' \code{\link[SummarizedExperiment]{SummarizedExperiment-class}} class:
#' \code{assays}, \code{rowData} \code{colData} and \code{metadata}. The new
#' slot is \code{treeData} that is to store the hiearchical information of rows
#' (or columns or both) of \code{assays} tables.
#'
#' @slot treeData A list of phylo objects. It gives information about the
#'   hiearchical structure of rows or columns of \code{assay} tables.
#' @slot ... Other slots from
#'   \code{\link[SummarizedExperiment]{SummarizedExperiment-class}}
#'
#' @section Constructor:
#' See \code{\link{TreeSummarizedExperiment-constructor}} for constructor
#' functions.
#'
#' @section Accessor:
#' See \code{\link{TreeSummarizedExperiment-accessor}} for accessor functions.
#'
#' @details The class \strong{TreeSummarizedExperiment} is designed to store
#'   rectangular data for entities (e.g., microbes or cell types)
#'   (\code{assays}), information about the hiearchical structure
#'   (\code{treeData}), and the mapping information between the rows (or
#'   columns, or both) of the rectangular data and the tree nodes
#'   (\code{linkData}). Users could provide hiearchical information on the rows
#'   or columns (or both) of the \code{assay} tables, and the \code{linkData}
#'   will be automatically integrated as one part of the \code{rowData} or
#'   \code{colData} or both, respectively. When the \code{linkData} is added to
#'   \code{rowData} or \code{colData}, a class \code{LinkDataFrame} is used to
#'   store data instead of \code{DataFrame}. Please see the page
#'   \code{\link{LinkDataFrame}} for more details.
#'
#' @importFrom methods setClass
#' @importClassesFrom SummarizedExperiment SummarizedExperiment
#' @importClassesFrom S4Vectors DataFrame
#' @name TreeSummarizedExperiment-class
#' @exportClass TreeSummarizedExperiment
#' @seealso \code{\link{TreeSummarizedExperiment}}
#'   \code{\link{TreeSummarizedExperiment-accessor}}
#'   \code{\link[SummarizedExperiment]{SummarizedExperiment-class}}
setClass("TreeSummarizedExperiment",
         representation(treeData = "list"),
         contains = "SummarizedExperiment",
         validity = checkTSE)




# ==========================================================================
### Constructor
# ==========================================================================

#' Construct a TreeSummarizedExperiment object
#'
#' \code{TreeSummarizedExperiment} constructs a TreeSummarizedExperiment object.
#'
#' @param rowTree A phylo object that provides hiearchical information of rows
#'   of assay tables.
#' @param colTree A phylo object that provides hiearchical information of
#'   columns of assay tables.
#' @inheritParams SummarizedExperiment::SummarizedExperiment
#'
#' @details The output TreeSummarizedExperiment object has very similar
#'   structure as the
#'   \code{\link[SummarizedExperiment]{SummarizedExperiment-class}}. The
#'   differences are summarized be as below.
#'   \itemize{
#'   \item \strong{treeData} A slot exists in \code{TreeSummarizedExperiment}
#'   but not in \code{SummarizedExperiment}. It stores the tree structure(s)
#'   that provide(s) hierarchical information of \code{assays} rows or columns
#'   or both.
#'   \item \strong{rowData} If a \code{phylo} object is available in the slot
#'   \code{treeData} to provide the hiearchical information about the rows of
#'   the \code{assays} table, the \code{rowData} would be a
#'   \code{\link{LinkDataFrame-class}} instead of
#'   \code{\link[S4Vectors]{DataFrame-class}}. The data on the right side of the
#'   vertical line provides the link information between the \code{assays} rows
#'   and the tree \code{phylo} object, and could be accessed via
#'   \code{linkData}; The data on the left side is the original \code{rowData}
#'   like \code{SummarizedExperiment} object.
#'   \item \strong{colData} Similar to the explanaition for \strong{rowData} as
#'   above.
#'  }
#'  More details about the \code{LinkDataFrame} in the \code{rowData} or
#'  \code{colData}.
#'  \itemize{
#'  \item nodeLab The labels of nodes on the tree.
#'  \item nodeLab\_alias The alias of node labels on the tree.
#'  \item nodeNum The numbers of nodes on the tree.
#'  \item isLeaf It indicates whether the node is a leaf node or internal node.
#'  }
#'
#' @importFrom SummarizedExperiment SummarizedExperiment rowData
#' @importFrom S4Vectors DataFrame
#' @importFrom methods new is
#' @export
#' @include classValid.R
#' @return a TreeSummarizedExperiment object
#' @name TreeSummarizedExperiment-constructor
#' @author Ruizhu HUANG
#' @seealso \code{\link{TreeSummarizedExperiment-class}}
#'   \code{\link{TreeSummarizedExperiment-accessor}}
#'   \code{\link[SummarizedExperiment]{SummarizedExperiment-class}}
#' @examples
#'
#' data("tinyTree")
#'
#' # the count table
#' count <- matrix(rpois(100, 50), nrow = 10)
#' rownames(count) <- c(tinyTree$tip.label)
#' colnames(count) <- paste("C_", 1:10, sep = "_")
#'
#' # The sample information
#' sampC <- data.frame(condition = rep(c("control", "trt"), each = 5),
#'                     gender = sample(x = 1:2, size = 10, replace = TRUE))
#' rownames(sampC) <- colnames(count)
#'
#' # build a TreeSummarizedExperiment object
#' tse <- TreeSummarizedExperiment(rowTree = tinyTree,
#'                                 assays = list(count),
#'                                 colData = sampC)
#'
TreeSummarizedExperiment <- function(rowTree = NULL, colTree = NULL,
                                     ...){

    # -------------------------------------------------------------------------
    ## create a SummarizedExperiment object
    se <- SummarizedExperiment(...)

    # -------------------------------------------------------------------------
    ## Indicate whether hiearchical information is available for rows and
    ## columns of assay tables
    isRow <- !is.null(rowTree)
    isCol <- !is.null(colTree)

    # -------------------------------------------------------------------------
    ## check whether the input tree has the correct form
    if (isRow) {
        # the tree should be a phylo object
        if(!is(rowTree, "phylo")) {
            stop("A phylo object is required for the rowTree", "\n")
        }

        # the tree should have unique leaf labels
        tipLab <- rowTree$tip.label
        anyDp <- any(duplicated(tipLab))
        if (anyDp) {
            stop("rowTree should have unique leaf labels. \n")
        }
    }

    if (isCol) {
        # the tree should be a phylo object
        if(!is(colTree, "phylo")) {
            stop("A phylo object is required for the colTree", "\n")
        }

        # the tree should have unique leaf labels
        tipLab <- colTree$tip.label
        anyDp <- any(duplicated(tipLab))
        if (anyDp) {
            stop("colTree should have unique leaf labels. \n")
        }
    }

    # -------------------------------------------------------------------------
    ## create the link data
    # the rows:
    if (isRow) {
        se <- .linkFun(tree = rowTree, se = se, onRow = TRUE)
    }


    # the columns:
    if (isCol) {
        se <- .linkFun(tree = colTree, se = se, onRow = FALSE)
    }


    # -------------------------------------------------------------------------
    # create TreeSummarizedExperiment
    tse <- new("TreeSummarizedExperiment", se,
               treeData = list(rowTree = rowTree,
                               colTree = colTree))

    return(tse)
}

# An internal function to create the link data and added to the rowData or
# colData
.linkFun <- function(tree, se, onRow = TRUE){

    if (onRow) {
        annDat <- rowData(se)
    } else {
        annDat <- colData(se)
    }

    kw <- ifelse(onRow, "row", "column")

    # ------------------ labels from the tree ---------------------------------
    # the labels and the alias of the labels
    treeLab <- c(tree$tip.label, tree$node.label)
    nodeA <- unique(as.vector(tree$edge))
    treeLab_alias <- transNode(tree = tree, node = nodeA,
                               use.alias = TRUE, message = FALSE)



    # ------------------ labels from the assays table -------------------------
    # The order to be used: nodeLab_alias > nodeLab > the row names
    # nodeLab_alias
    lab <- as.data.frame(annDat)$nodeLab_alias

    # if nodeLab_alias is not available, use nodeLab
    if (is.null(lab)) {
        lab <- as.data.frame(annDat)$nodeLab
    }

    # if nodeLab_alias and nodeLab are not available, use the row names
    if (is.null(lab)) {
        lab <- rownames(annDat)
        if (is.null(lab)) {
            stop("Either a nodeLab column or the row names should be
                 provided for ", kw ," data. \n")}
        }

    # decide whether treeLab or treeLab_alias should be used
    sw1 <- startsWith(lab, "Node_")
    sw2 <- startsWith(lab, "Leaf_")
    sw <- all(sw1 | sw2)

    # Match lab with the alias of the node labels on the tree
    if (sw) {
        isIn <- lab %in% treeLab_alias
    } else {
        isIn <- lab %in% treeLab
    }

    # Those with labels that don't match with the node labels of the tree are
    # excluded
    isOut <- !isIn
    if (sum(isOut) > 0) {
        message(sum(isOut), " ", kw,
                "(s) couldn't be matched to the tree and are/is removed. \n")}

    if (onRow) {
        se <- se[isIn, ]
    } else {
        se <- se[, isIn]
    }


    # create the link data
    labN <- lab[isIn]
    nd <- transNode(tree = tree, node = labN, use.alias = FALSE,
                    message = FALSE)
    fLab <- transNode(tree = tree, node = nd, use.alias = FALSE,
                      message = FALSE)
    faLab <- transNode(tree = tree, node = nd, use.alias = TRUE,
                       message = FALSE)
    leaf <- unique(setdiff(tree$edge[, 2], tree$edge[, 1]))

    linkD <- DataFrame(nodeLab = fLab,
                       nodeLab_alias = faLab,
                       nodeNum = nd,
                       isLeaf = nd %in% leaf)


    # create the rowData
    rd <- annDat[isIn, ]
    rd <- rd[, colnames(rd) != "nodeLab", drop = FALSE]

    if (onRow) {
        rowData(se) <- LinkDataFrame(LinkData = linkD, rd)
    } else {
        colData(se) <- LinkDataFrame(LinkData = linkD, rd)
    }

    return(se)
    }

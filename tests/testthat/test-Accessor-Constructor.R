context("accessor_constructor")

# assays data
toyTable <- matrix(1:40, nrow = 10)
colnames(toyTable) <- paste(rep(LETTERS[1:2], each = 2), rep(1:2, 2), sep = "_")
rownames(toyTable) <- paste("entity", seq_len(10), sep = "")

data("tinyTree")

# row data
rowInf <- DataFrame(var1 = sample(letters[1:2], 10, replace = TRUE),
                    var2 = sample(c(TRUE, FALSE), 10, replace = TRUE),
                    nodeLab = tinyTree$tip.label,
                    row.names = rownames(toyTable))
# column data
colInf <- DataFrame(gg = c(1, 2, 3, 3),
                    group = rep(LETTERS[1:2], each = 2),
                    row.names = colnames(toyTable))
tse <- TreeSummarizedExperiment(assays = list(toyTable),
                                rowData = rowInf,
                                colData = colInf,
                                rowTree = tinyTree)
test_that("TreeSummarizedExperiment constuctor works", {
    # TreeSummarizedExperiment
    expect_is(tse,
              "TreeSummarizedExperiment")

    # without tree
    expect_is(TreeSummarizedExperiment(assays = list(toyTable),
                                       rowData = rowInf,
                                       colData = colInf),
              "TreeSummarizedExperiment")

    expect_message(TreeSummarizedExperiment(assays = list(toyTable),
                                          rowData = rowInf,
                                          colData = colInf,
                                          colTree = tinyTree))
})



test_that("assays could extract table successfully", {
    expect_equal(assays(tse)[[1]], toyTable)
})

test_that("assays could be written successfully", {
    assays(tse)[[2]] <- 2*toyTable
    expect_equal(assays(tse)[[2]], 2*toyTable)
})

test_that("row data could be extracted successfully", {
    expect_equal(colnames(rowData(tse)), setdiff(colnames(rowInf), "nodeLab"))
    expect_setequal(colnames(linkData(tse)), c("nodeLab", "nodeLab_alias",
                                         "nodeNum", "isLeaf"))
    expect_equal(treeData(tse, onRow = TRUE), tinyTree)
    expect_equal(metaCol(tse, onRow = TRUE), rowInf[, !colnames(rowInf) %in% "nodeLab"])
})

test_that("row data could be written successfully", {
    tse1 <- tse
    rowData(tse1)$test <- rep(1, nrow(tse))
    expect_equal(rowData(tse1)$test, rep(1, nrow(tse)))
})


test_that("column data could be extracted successfully", {
    expect_equal(colData(tse), colInf)
})

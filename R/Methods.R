#' @include allGenerics.R
#' @include Scorecard.class.R

setMethod("as.data.frame", signature = c("Bin", "missing", "missing"),
  function(x, row.names = NULL, optional = FALSE, ...) {
    binned <- collapse(x)
    f <- !is.na(x@x)

    ## get the bivariate matrix
    out <- tapply(x@y, binned, .bv, Y=x@y, f=f, simplify = TRUE)
    out[sapply(out, is.null)] <- 0

    out <- do.call(rbind, out)
    out[is.infinite(out)] <- 0
    out <- cbind(out, Pred=x@pred[row.names(out)])
    row.names(out) <- paste(sprintf("%02d", 1:nrow(out)), row.names(out), sep = ". ")

    ## calculate totals
    Total <- apply(out, 2, sum, na.rm=T)
    Total[c(5:8,10)] <- 0
    Total[7] <- Total[2]/Total[1]

    out <- data.frame(rbind(out, Total=Total))
    colnames(out) <- c("N", "#1", "#0", "%N","%1","%0","P(1)","WoE","IV", "Pred")
    out
})

setMethod("as.data.frame", signature = c("Classing", "missing", "missing"),
 function(x, row.names = NULL, optional = FALSE, ...) {
   data <- lapply(x@classing, function(bin) bin@x)
   data.frame(data)
 })

setMethod("collapse", signature = c("Bin", "missing"),
  function(object, x, ...) callGeneric(object, object@x))

setMethod("collapse", signature = c("Continuous", "numeric"),
  function(object, x, ...) {
    f <- !is.na(x) & !(x %in% object@exceptions)
    bins <- cut(x[f], object@cuts, include.lowest = T, dig.lab=3)
    out <- factor(x, exclude=NULL,
                  levels=c(levels(bins),object@exceptions, NA))
    levels(out)[is.na(levels(out))] <- "Missing"
    out[f] <- bins
    out
  })

setMethod("collapse", signature = c("Discrete", "factor"),
  function(object, x, ...) {
    out <- factor(x, exclude=NULL, levels=c(unique(unlist(object@map), NA)))
    levels(out)[is.na(levels(out))] <- "Missing"
    out[] <- object@map[as.character(x)]
    out
  })

## set the pred slot in Bin using the WoE if values aren't passed
setMethod("Update", signature = c("Bin", "missing"),
  function(object, keep = TRUE) {
    old <- object@pred

    pred <- head(as.data.frame(object)$WoE, -1)
    names(pred) <- levels(collapse(object, if(is(object, "Discrete"))
      factor() else numeric()))

    if (keep) pred[names(old)] <- old
    pred["Missing"] <- 0
    initialize(object, pred=pred)
  })

#' extract parts of a Classing
#'
#' @name [
#' @aliases [,Classing-method
#' @docType methods
#' @rdname extract-methods
#' @export
setMethod("[", c(x = "Classing", i = "ANY", j = "missing", drop = "ANY"),
  function(x, i, j, ..., drop = TRUE) {
    initialize(x, classing=x@classing[i])
  })

#' extract element of a Classing
#'
#' @name [[
#' @aliases [[,Classing-method
#' @docType methods
#' @rdname extract-methods
#' @export
setMethod("[[", signature = c(x="Classing", i="ANY", j="missing"),
  function(x, i, j, ...) {
    x@classing[[i]]
  })

#' @export
setMethod("[[<-", signature = c(x="Classing", i="ANY", j="missing", value="Bin"),
  function(x, i, j, ..., value) {
    x@classing[[i]] <- value
    x
  })


setClassUnion("Combinable", c("Bin", "Classing"))

#' @export
setMethod("c", signature = c("Combinable"),
  function(x, ..., recursive = FALSE) {
    ## loop over items and process
    items <- lapply(list(x, ...), function(item) {
      if (is(item, "Bin")) {
        return(item)
      } else if(is(item, "Classing")) {
        return(item@classing)
      } else {
        stop("All items must be Bin or Classing objects")
      }
    })

    new("Classing", classing = unlist(items))
  })

#' @export
setMethod("length", "Classing", function(x) length(x@classing))
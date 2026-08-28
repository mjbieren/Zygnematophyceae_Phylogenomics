library("phytools")

#Set your working directory
setwd("~/24_ACSR/NewTry")

#tree<-read.newick("TimeTree1_Zygnematophyceae.tre")
tree<-read.newick("Zygnematophyceae_nwk.txt")
plotTree(tree,fsize=0.5,ftype="i")

# read data (saving first column as row names) aka the table with your setup
x<-read.table("5phase_unimulti.txt", row.names = 1)
# change this into a vector
x<-as.matrix(x)


cols<-setNames(palette()[1:length(unique(x))],sort(unique(x))) # set automatic colors

cols<-c("#ffb3ba", "#ffdfba", "#ffffba", "#baffc0", "#bae1ff")
# match tips with states
tiplabels(pie=to.matrix(x,sort(unique(x))),piecol=cols,cex=0.2)

#Equal Rates
transitions <- matrix(c(0,1,1,1,1,1,0,1,1,1,1,1,0,1,1,1,1,1,0,1,1,1,1,1,0), nrow=5)

fitORDERED <- ace(x, tree, type="discrete", model=transitions)

#It is fairly straightforward to overlay these posterior probabilities on the tree:
plotTree(tree,fsize=0.5,ftype="i")

nodelabels(node=1:tree$Nnode+Ntip(tree),
           pie=fitORDERED$lik.anc,piecol=cols,cex=0.3)
tiplabels(pie=to.matrix(x,sort(unique(x))),piecol=cols,cex=0.15)

print(fitORDERED$lik.anc)

#Which node is what
plotTree(tree,fsize=0.8,ftype="i",node.numbers=TRUE)


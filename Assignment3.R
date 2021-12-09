# Assignment 3: Predictive Models
# By: Aaron Upchurch
# Performs clustering and statistical analysis on genomic data based on gene expression


#========================= Libraries ======================#
library(ComplexHeatmap)
library(ggplot2)
library(ggalluvial)
library(dendextend)
library(gridExtra)
library(grid)
library(lattice)

#================== Part 1 =========================#
# Loads in data

expressionMatrix = data.frame(as.matrix(read.table("Series_Matrix_Just_Data.txt", header = TRUE, row.names=1, sep="\t"))) # loads expression data
metadata = data.frame(t(as.matrix(read.table("SampleInformation.txt", header = TRUE, row.names=1,sep="\t")))) # loads metatdata

samplesBefore <- rownames(metadata[metadata$Sample_intervention_status == "intervention status: before",]) # gets samples taken before intervention
samplesAfter <- rownames(metadata[metadata$Sample_intervention_status == "intervention status: after",]) # gets samples taken after intervention



#================= Part 2 ===========================#
# Performs unsupervised analysis

# a. subset data to 5,000 most variable genes
expressionMatrix$Max <- (apply(expressionMatrix,1,max,na.rm=TRUE))
expressionMatrix$Min <- (apply(expressionMatrix,1,min,na.rm=TRUE))

expressionMatrix$Range <- expressionMatrix$Max - expressionMatrix$Min

expressionMatrix <- t(expressionMatrix[order(expressionMatrix$Range,decreasing=TRUE),]) # Reorders expression matrix based on ranges

expressionMatrix <- expressionMatrix[1:44,] # Removes min, max, range columns



# b. Hierarchical clustering
colorGroups <- c()
for (i in 1:44){
    if(samples[i] %in% samplesBefore){
        colorGroups <- c(colorGroups,'blue')
    }
    else{
        colorGroups <- c(colorGroups,'red')
        
    }
}

expressionMatrix[is.na(expressionMatrix)] <- 0 # Cant have na values apparently, replaced them with 0


hc5000 <- hclust(dist(expressionMatrix[,1:5000]),method="complete") # Clusters the samples together based on expression data for top 5000 genes

dend <- as.dendrogram(hc5000)
labels_colors(dend) <- colorGroups

Dendrogram5000Genes <- plot(hang.dendrogram(dend),main="Hierachical Dendogram for 5,000 Genes",xlab = "Samples",ylab="Clusters")
legend('bottomleft', legend=c("Before", "After"),
       fil=c("blue", "red"),border="black")


# d. how many clusters were found

# Hierarchical clustering by default creates n-1 total clusters
# The true samples come either before or after the red meat intervention
# Cutting the tree before the final merge creates two clusters which be the most applicable



# e. Rerunning clustering analysis with different number of genes

hc10 <- hclust(dist(expressionMatrix[,1:10]),method="complete") # Top 10 genes
dend <- as.dendrogram(hc10)
labels_colors(dend) <- colorGroups

Dendrogram10Genes <- plot(hang.dendrogram(dend),main="Hierachical Dendogram for 10 Genes",ylab="Clusters")
legend('topright', legend=c("Before", "After"),
       fil=c("blue", "red"),border="black")



hc100 <- hclust(dist(expressionMatrix[,1:100]),method="complete") # Top 100 genes

dend <- as.dendrogram(hc100)
labels_colors(dend) <- colorGroups

Dendrogram100Genes <- plot(hang.dendrogram(dend),main="Hierachical Dendogram for 100 Genes",xlab = "Samples",ylab="Clusters")
legend('topleft', legend=c("Before", "After"),
       fil=c("blue", "red"),border="black")



hc1000 <- hclust(dist(expressionMatrix[,1:1000]),method="complete") # Top 1000 genes

dend <- as.dendrogram(hc1000)
labels_colors(dend) <- colorGroups

Dendrogram1000Genes <- plot(hang.dendrogram(dend),main="Hierachical Dendogram for 1,000 Genes",xlab = "Samples",ylab="Clusters")
legend('topright', legend=c("Before", "After"),
       fil=c("blue", "red"),border="black")


hc10000 <- hclust(dist(expressionMatrix[,1:10000]),method="complete") # Top 10,000 genes

dend <- as.dendrogram(hc1000)
labels_colors(dend) <- colorGroups

Dendrogram10000Genes <- plot(hang.dendrogram(dend),main="Hierachical Dendogram for 10,000 Genes",xlab = "Samples",ylab="Clusters")
legend('topright', legend=c("Before", "After"),
       fil=c("blue", "red"),border="black")


# Running the clustering algorithm with different numbers of genes
# significantly changed the clusters that were created.
# As more genes were analyzed, the highest two clusters became
# less similair in terms of size

#==================== Coloring method ===========================
# n = length(row.names(expressionMatrixReduced))
# 
# for (i in 1:n){
#     
#         if(row.names(expressionMatrixReduced)[i] %in% samplesBefore){
#                 row.names(expressionMatrixReduced)[i] <- paste('B',row.names(expressionMatrixReduced)[i] ,sep='')
# 
#                 
#         }
#         else{
#                 row.names(expressionMatrixReduced)[i]  <- paste('A',row.names(expressionMatrixReduced)[i] ,sep='')
#         }
#        
# }
# 
# 
# hc <- hclust(dist(expressionMatrixReduced[,1:10]),method="complete")
# 
# drg1 <- dendrapply(as.dendrogram(hc, hang=.1), function(n){
#         if(is.leaf(n)){
#                 labelCol <- c( A="red",B='blue')[substr(attr(n,"label"),1,1)];
#                 attr(n, "nodePar") <- list(pch = NA, lab.col = labelCol);
#         }
#         n;
# 
# });
# plot(drg1)
#=======================================================

Intervention_Group <- metadata$Sample_intervention_status
for (i in 1:44){
    if(Intervention_Group[i]=="intervention status: after"){
        Intervention_Group[i] = "After"
    }
    else{
        Intervention_Group[i] = "Before"
    }
}
# e.2 Alluvial diagram
Freq <- c(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)

for (i in 2:5){ # Creates an alluvial diagram for 2,3,4,5 clusters

    
    Genes_10 <- cutree(hc10,k=i)
    Genes_100 <- cutree(hc100,k=i)
    Genes_1000 <- cutree(hc1000,k=i)
    Genes_5000 <- cutree(hc5000,k=i)
    Genes_10000 <- cutree(hc10000,k=i)

    alluvialDF <- data.frame(interventionGroupCol,Genes_10,Genes_100,Genes_1000,Genes_5000,Genes_10000,Freq)
    colnames(alluvialDF) <- c("Intervention Group, 10 Genes,","100 Genes","1000 Genes","5,000 Genes","10,000 Genes","freq")

    alluvialDF <- alluvialDF[,1:6] # gets rid of weird NA collumn
   

 
    alluvial <- ggplot(as.data.frame(alluvialDF),
       aes(y = Freq, axis1 = Intervention_Group, axis2 = Genes_10,axis3=Genes_100,axis4=Genes_1000,axis5=Genes_5000,axis6=Genes_10000)) +
        geom_alluvium(aes(fill = Intervention_Group), width = 1/12) +
        geom_stratum(width = 1/3, fill = "grey76", color = "black") +
        geom_label(stat = "stratum", aes(label = after_stat(stratum))) +
        scale_x_discrete(limits = c("Intervention Group", "Genes_10","Genes_100","Genes_1000","Genes_5000","Genes_10000"), expand = c(.05, .05)) +
        scale_fill_brewer(type = "qual", palette = "Set1") +
        ggtitle( paste("Intervention Status Hierachical Clustering for K = ",i))

    par(mar=c(4,6,4,1))
    plot(alluvial)
}

# 3 a Heat Map

rowSideColors <- c()
for (i in 1:44){
    if(samples[i] %in% samplesBefore){
        rowSideColors <- c(rowSideColors,'blue')
    }
    else{
        rowSideColors <- c(rowSideColors,'red')
        
    }
}


#expressionMatrix[is.infinite(expressionMatrix)] <-0
diff_gene_map <- heatmap(as.matrix(expressionMatrix[,1:5000]),na.rm=TRUE, main="Heatmap for Top 5,000 Genes", xlab="Genes",ylab="Samples",RowSideColors = rowSideColors,margins=c(5,7))
legend('topright', legend=c("Before", "After"),
       fil=c("blue", "red"),border="black")


#======================== Part 4 =====================#
# Statistical analyis

# 4.a Chi^2 test of independence between two groups


Genes_10 <- cutree(hc10,k=2) # have to set it back after k loop
Genes_100 <- cutree(hc100,k=2)
Genes_1000 <- cutree(hc1000,k=2)
Genes_5000 <- cutree(hc5000,k=2)
Genes_10000 <- cutree(hc10000,k=2)

trueGroupCounts <- c(length(samplesBefore),length(samplesAfter))
Genes_10GroupCounts <- c(sum(Genes_10==1),sum(Genes_10==2))
Genes_100GroupCounts <- c(sum(Genes_100==1),sum(Genes_100==2))
Genes_1000GroupCounts <- c(sum(Genes_1000==1),sum(Genes_1000==2))
Genes_5000GroupCounts <- c(sum(Genes_5000==1),sum(Genes_5000==2))
Genes_10000GroupCounts <- c(sum(Genes_10000==1),sum(Genes_10000==2))

groupTables <- data.frame(trueGroupCounts,Genes_10GroupCounts,Genes_100GroupCounts,Genes_1000GroupCounts,Genes_5000GroupCounts,Genes_10000GroupCounts)


pValueResults <- matrix(c(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),ncol=2,nrow=10)
colnames(pValueResults) <- c("Unadjusted","Adjusted")
rownames(pValueResults) <- c("Hierachical 10 Genes - Groups","Hierachical 100 Genes - Groups","Hierachical 1,000 Genes - Groups","Hierachical 5,000 Genes - Groups","Hierachical 10,000 Genes - Groups","___ 10 Genes","___ 100 Genes","___ 1,000 Genes","___ 5,000 Genes","___ 10,000 Genes")


for (i in 2:6){
  
    
    chisq <- chisq.test(data.frame(groupTables[,1],groupTables[,i]))
    print(data.frame(groupTables[,1],groupTables[,i]))
    pValueResults[i-1,1] <- chisq$p.value
}



pValueResults[,2] <- p.adjust(pValueResults[,1])# ,result from other clustering, result from comparing them together

grid.newpage()
grid.table(pValueResults)



#====================== Enrichment Plot ==================#





function [StatisticalPathway,SpectralDepthTable]=SCALES_V2(ProteinOfInterest,V_protein_matrix,Uniprot_by_GeneList,threshold)



% Calculate correlation coefficient for entire E coli
window=100;
 

R_21_121=corr((V_protein_matrix(:,34:134))');



i_StatisticalPathway=find(abs(R_21_121(:,(strcmp(Uniprot_by_GeneList(:,1),ProteinOfInterest))))>threshold);
StatisticalPathway=Uniprot_by_GeneList(i_StatisticalPathway,1);


% centers=[51 71 100 125 150 200 250 300 350 400 500 600 700 800 900 1000 1250 1500 1750 2000 2250 2500 3000 3500 4000 4500 5000 6000];
centers=[51:1:3000];
R_StatisticalPathway=[];
% R_rand=[];
for i=1:1:length(centers)
    R_StatisticalPathway(:,:,i)=corr((V_protein_matrix(i_StatisticalPathway,centers(i)-window/2:centers(i)+window/2))');
%     R_rand(:,:,i)=corr((TTh_EigGenes(Rand_rows,centers(i)-window/2:centers(i)+window/2))');
end

SpectralDepthMatrix=zeros(size(squeeze(R_StatisticalPathway(:,:,1)))); 

% threshold=0.4;
for i=1:1:length(i_StatisticalPathway)
    for j=i:1:length(i_StatisticalPathway)
        d=find(R_StatisticalPathway(i,j,:)<threshold,1);
        if sum(isnan(d))
            SpectralDepthMatrix(i,j)=0;
        else
            if(sum(isempty(d)))
                SpectralDepthMatrix(i,j)=centers(length(centers));
            else
                SpectralDepthMatrix(i,j)=centers(d);
            end
        end
        SpectralDepthMatrix(j,i)=SpectralDepthMatrix(i,j);        
    end
end
 


figure('NumberTitle', 'off', 'Name',['SCALES of ' ProteinOfInterest]);set(gcf,'color','white');set(gcf,'position',[100 100 1000 800]);
ds_depth=pdist(log10(SpectralDepthMatrix));  %Can cluster by Covariance
Z_depth=linkage(ds_depth,'average');

% outperm_depth=outperm_top;
% ds_depth(isnan(SpectralDepthMatrix))=0;
subplot(1,4,1);
[H_depth,T_depth,outperm_depth]=dendrogram(Z_depth,length(SpectralDepthMatrix(1,:)),'Orientation','left');
set(gca,'xcolor','none');
set(gca,'ycolor','none');
set(H_depth,'color',[0 0 0]);
 
subplot(1,4,2:4);
imagesc(log10(SpectralDepthMatrix(fliplr(outperm_depth),fliplr(outperm_depth))));
colormap(jet);
c=colorbar;
c.Label.String="Log_1_0(Spectral Depth)";
c.Label.FontSize=12;
caxis([1 log10(centers(end))]);
%  
xticks(1:1:length(i_StatisticalPathway));
yticks(1:1:length(i_StatisticalPathway));
yticklabels(Uniprot_by_GeneList(i_StatisticalPathway(fliplr(outperm_depth)),1));
xticklabels(Uniprot_by_GeneList(i_StatisticalPathway(fliplr(outperm_depth)),1));
% xticklabels(StatisticalPathway(fliplr(outperm_depth)));
% yticklabels(StatisticalPathway(fliplr(outperm_depth)));
 
xtickangle(90);
set(gca,'TickLength',[0 0]);
% set(gca,'xcolor','none');
% set(gca,'ycolor','none');
title(['Hierarchically clustered spectral depth matrix for ' ProteinOfInterest]);%    Proteomes.Ecoli.Genes.GeneNames(strcmp(Proteomes.Ecoli.Genes.UniprotIDs,ProteinOfInterest)) ' (' OrganismOfInterest ')']);
    
% SpectralDepthTable=table;
% for i=1:1:length(outperm_depth)
%    SpectralDepthTable.(StatisticalPathway{i})= 
% end
RowColNames={};
for i=1:1:length(i_StatisticalPathway)
    RowColNames{i}=[Uniprot_by_GeneList{i_StatisticalPathway(i),1}];
end
SpectralDepthTable=array2table(SpectralDepthMatrix(outperm_depth,outperm_depth),'VariableNames',RowColNames(outperm_depth),'RowNames',RowColNames(outperm_depth));
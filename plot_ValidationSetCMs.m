function [] = plot_ValidationSetCMs(DataSets,Features,RF_Models)

f_size=8;
cmap=flipud(gray(200));
s_TrainingSet=[sum(DataSets.TrainingSet.Labels==0);sum(DataSets.TrainingSet.Labels==1);sum(DataSets.TrainingSet.Labels==2)];
s_ValidationSet=[sum(DataSets.ValidationSet.Labels==0);sum(DataSets.ValidationSet.Labels==1);sum(DataSets.ValidationSet.Labels==2)];
 
fns=fieldnames(Features);
% fns=fns([1 2 3 7 8 10 9 5 4 6]); 
titles=fns;%{'Raw','\rho_{2-20}','MI windows','Epistasis','APMS1','APMS2','Y2H','GF','GC','GN'};
 
figure('NumberTitle', 'off', 'Name', 'Confusion matrix for model trained on MIWSC_{OGG}');set(gcf,'color','white');set(gcf,'Position',[100 100 500 600]);
for f=1:1:length(fns)
    subplot(length(fns),10,(f-1)*10+[2:9]);
%     subplot(length(fns),1,f);
    C_ValidationSet=confusionmat(RF_Models.(fns{f}).Y_ValidationSet,DataSets.ValidationSet.Labels,'order',[0 1 2]);
    Norm_C_ValidationSet=C_ValidationSet./sum(C_ValidationSet,2);
    imagesc(Norm_C_ValidationSet);
    for i=1:1:length(C_ValidationSet(:,1))
        for j=1:1:length(C_ValidationSet(1,:))
            text(i,j,num2str(C_ValidationSet(j,i)),'horizontalalignment','center','FontSize',f_size);
        end
        text(i,0.15,num2str(C_ValidationSet(i,i)/sum(C_ValidationSet(:,i)),2),'horizontalalignment','center','FontSize',f_size);
        text(3.9,i,num2str(C_ValidationSet(i,i)/sum(C_ValidationSet(i,:)),2),'horizontalalignment','center','FontSize',f_size);
    end
    colormap(cmap);
    caxis([0 2]);
    xticks([1 2 3]);
    xticklabels({'Not-interacting','Indirect','Direct'});
    xtickangle(60);
    yticks([1 2 3]);
    yticklabels({'Not-interacting','Indirect','Direct'});
    set(gca,'TickLength',[0 0]);
    ylabel('Predicted class');
    if f~=length(fns)
       xticklabels({}); 
    end
    if f==length(fns)
       xlabel('True class'); 
    end
    set(gca,'FontSize',8);
end

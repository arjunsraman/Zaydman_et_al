function []=plot_thresholdedSpectralDepth(SpectralDepthTable,ProteinOfInterest,SD_threshold)

    cmap=[1 1 1;
    1 0 0];
    figure;set(gcf,'position',[500 100 700 800]);set(gcf,'color','white');
    A=table2array(SpectralDepthTable);
    A(A<SD_threshold)=0;
    A(A~=0)=1;
    A=fliplr(A);
    A=flipud(A);
    imagesc(A);
    colormap(cmap);
    xticks(1:1:length(A(:,1)));
    yticks(1:1:length(A(1,:)));
    yticklabels(fliplr(SpectralDepthTable.Properties.VariableNames));
    xticklabels(fliplr(SpectralDepthTable.Properties.VariableNames));
    xtickangle(90);
    set(gca,'TickLength',[0 0]);
    title(['Statistical network of ' ProteinOfInterest ' at spectral depth ' num2str(SD_threshold)]);

   
function []=plotPPIMIExample(quant_bins,Neg_bs_indices,Pos_bs_indices,V_protein,V_protein_shuffled,Dij,fn)

win_width=5;
win_centers=[34 100 500 1000 2998];
PPI_to_plot=[1 6];





set(0,'DefaultAxesTitleFontWeight','normal');
for benchmark=1:1:length(PPI_to_plot)
    figure('NumberTitle', 'off', 'Name', [fn{PPI_to_plot(benchmark)} ' MI']);set(gcf,'color','white');set(gcf,'position',[100 800-benchmark*350 800 250]);
    for c=1:1:length(win_centers)
        subplot(2,length(win_centers),c);
        R=corr((V_protein(:,win_centers(c)-floor(win_width/2):win_centers(c)+floor(win_width/2)))');
        histogram(R(Neg_bs_indices{PPI_to_plot(benchmark)}(1,:)),quant_bins,'FaceColor',[1 1 1]);hold on;
        histogram(R(Pos_bs_indices{PPI_to_plot(benchmark)}(1,:)),quant_bins,'FaceColor',[0 0 0]);hold on;
        title(['MI = ' num2str(empirical_differential_MI(R(Neg_bs_indices{PPI_to_plot(benchmark)}(1,:)),R(Pos_bs_indices{PPI_to_plot(benchmark)}(1,:)),quant_bins),2)]);
        set(gca,'ytick',[]);set(gca,'xtick',[]);box off;set(gca,'xlim',[-1 1]);
        if c==1
            ylabel('V_{protein}');
            leg=legend({'Non-interacting','Interacting'},'Location','northwest');set(leg,'Position',[0.025 0.925 0.1 0.025]);legend boxoff;

        end
        set(gca,'xcolor','none');  xlabel({['SV' num2str(win_centers(c)-floor(win_width/2)) '-' num2str(win_centers(c)+floor(win_width/2))]});
        xticks([-1 0 1]); 
    end

        
    for c=1:1:length(win_centers)
        subplot(2,length(win_centers),c+length(win_centers));
        R=corr((V_protein_shuffled(:,win_centers(c)-floor(win_width/2):win_centers(c)+floor(win_width/2)))');
        histogram(R(Neg_bs_indices{PPI_to_plot(benchmark)}(1,:)),quant_bins,'FaceColor',[1 1 1]);hold on;
        histogram(R(Pos_bs_indices{PPI_to_plot(benchmark)}(1,:)),quant_bins,'FaceColor',[0 0 0]);hold on;
        title(['MI = ' num2str(empirical_differential_MI(R(Neg_bs_indices{PPI_to_plot(benchmark)}(1,:)),R(Pos_bs_indices{PPI_to_plot(benchmark)}(1,:)),quant_bins),2)]);
        set(gca,'ytick',[]);set(gca,'xtick',[]);box off;set(gca,'xlim',[-1 1]);
        if c==1
            ylabel('V_{protein shuffled}');
        end
        set(gca,'xcolor',[0 0 0]);  xlabel({['SV' num2str(win_centers(c)-floor(win_width/2)) '-' num2str(win_centers(c)+floor(win_width/2))]});
        xticks([-1 0 1]);        
    end
end

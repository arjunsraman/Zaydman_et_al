function []=plotPPICorrelationsExample(V_protein,V_protein_shuffled,Examples)

f_size=8;

win_width=10;win_starts=[3;20;50;100;200;500;1000;2000;4000];
xlims=[win_starts win_starts+win_width];ylims=([-0.08 0.08]);

fn=fieldnames(Examples);

figure('NumberTitle', 'off', 'Name', 'Protein spectral correlations examples');set(gcf,'color','white');set(gcf,'position',[100 100 600 400]);

% for f=1:2

    for i=1:1:length(xlims(:,1))

        subplot(3,2*length(xlims(:,1)),2*(i-1)+[1 2]);
        plot(V_protein(Examples.(fn{1}).indices,:)','color',Examples.(fn{1}).color);hold on;
        xlim(xlims(i,:));xticks([xlims(i,:)]);xtickangle(90);ylim(ylims);yticks([ylims(1) 0 ylims(2)]);
        set(gca,'xcolor','none');set(gca,'FontSize',f_size);box off;ylabel('|V>');set(gca,'ycolor','none');
        if i==1
           set(gca,'ycolor',[0 0 0]);ylabel('|V_{protein}>');
        end
        if i==length(xlims(:,1))
            title(Examples.(fn{1}).label);
        end
        subplot(3,2*length(xlims(:,1)),2*(i-1)+[1 2]+2*length(xlims(:,1)));
        plot(V_protein(Examples.(fn{2}).indices,:)','color',Examples.(fn{2}).color);hold on;
        xlim(xlims(i,:));xticks([xlims(i,:)]);xtickangle(90);ylim(ylims);yticks([ylims(1) 0 ylims(2)]);
        set(gca,'xcolor','none');set(gca,'FontSize',f_size);box off;ylabel('|V>');set(gca,'ycolor','none');
        if i==1
           set(gca,'ycolor',[0 0 0]);ylabel('|V_{protein}>');
        end
        if i==length(xlims(:,1))
            title(Examples.(fn{2}).label);
        end
        subplot(3,2*length(xlims(:,1)),2*(i-1)+[1 2]+4*length(xlims(:,1)));
        for j=xlims(i,1):1:xlims(i,2)
            rho=corr(V_protein(Examples.(fn{1}).indices,j-2:j+2)');rho(isnan(rho))=0;rho=rho(triu(rho,1)~=0);
            plot(j,mean(rho),'.','color',Examples.(fn{1}).color,'MarkerSize',9);hold on;
            rho=corr(V_protein(Examples.(fn{2}).indices,j-2:j+2)');rho(isnan(rho))=0;rho=rho(triu(rho,1)~=0);
            plot(j,mean(rho),'.','color',Examples.(fn{2}).color,'MarkerSize',9);hold on;
        end
        set(gca,'ycolor','none');ylim([-0.2 1]);box off;xtickangle(90);xlim(xlims(i,:));xticks(xlims(i,:));
        if i==1
           set(gca,'ycolor',[0 0 0]);ylabel('\rho');xlabel('SV');
        end
    end
% end
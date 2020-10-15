function [] = plot_MIWSCogg(MI_Windows,DataSets,Windows)

c=[[0.75 0.75 0.75];[0 1 1];[1 0 0]];
m={'.','.','.'};
M_size=10;
 
dn=fieldnames(DataSets);
wn=Windows.Properties.VariableNames;
 
figure;set(gcf,'color','white');set(gcf,'Position',[100 100 750 275]);
for d=1:1:length(dn)
    subplot(1,2,d);
    for i=0:1:2
        h=plot3(MI_Windows.(wn{1})(DataSets.(dn{d}).indices(DataSets.(dn{d}).Labels==i)),MI_Windows.(wn{2})(DataSets.(dn{d}).indices(DataSets.(dn{d}).Labels==i)),MI_Windows.(wn{3})(DataSets.(dn{d}).indices(DataSets.(dn{d}).Labels==i)),m{i+1},'color',c(i+1,:),'MarkerSize',M_size);hold on;
    end
    title(dn{d});
    view(76,18);
    xlabel(['\rho_{' num2str(Windows.(wn{1})(1)) '-' num2str(Windows.(wn{1})(2)) '}']);
    ylabel(['\rho_{' num2str(Windows.(wn{2})(1)) '-' num2str(Windows.(wn{2})(2)) '}']);
    zlabel(['\rho_{' num2str(Windows.(wn{3})(1)) '-' num2str(Windows.(wn{3})(2)) '}']);
    xlim([-1 1]);
    ylim([-0.3 1]);
    zlim([-0.5 1]);
end
legend({'non-interacting','indirect','direct'});
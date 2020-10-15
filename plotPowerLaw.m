function plotPowerLaw(fractionalvar,X,Y,m)


% Create figure
figure4 = figure('NumberTitle','off','Name','Power-law distribution in SVD spectrum of DOGG','Color',[1 1 1]);
set(gcf,'position',[200 200 350 300]);

% Create axes
axes1 = axes('Parent',figure4);

% Plot Data and gamma fit on same axis
loglog(100*fractionalvar,'-k','LineWidth',2);hold on;
loglog(X,Y,':r','LineWidth',1.5);
box off;

% Add labels
ylabel('Fractional variance (%)');
xlabel('Component');

% Adjust axis limits
xlim([0.5 10000]);
ylim([0.0000001 100]);

% Adjust ticks
set(axes1,'XMinorTick','on','XScale','log','XTick',[1 10 100 1000 10000],...
    'XTickLabel',{'1','10','100','1000','10000'},'YMinorTick','on','YScale',...
    'log','YTick',[0.0000001 0.000001 0.00001 0.0001 0.001 0.01 0.1 1 10 100],'YTickLabel',...
    {'0.0001','0.001','0.01','0.1','1','10','100'});

% Add gamma exponent to the graph
text(100,1,['\gamma=' num2str(m,2)])

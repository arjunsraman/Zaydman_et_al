    function [PhylogenyBenchmarks] = GeneratePhylogenyBenchmarks(DOGG)    
    
    Tax_levels={'Phylum','Class','Order','Family','Genus'};
        PhylogenyBenchmarks={};
        thisTaxa={};
        for f=1:1:length(Tax_levels)
            PhylogenyBenchmarks.(Tax_levels{f})=zeros(length(DOGG.Data.RawCounts(:,1)),length(DOGG.Data.RawCounts(:,1)));
            [unique_Taxa,a_unique_Taxa,i_unique_Taxa]=unique(DOGG.Data.RowLabels.(Tax_levels{f}));
            for t=1:1:length(unique_Taxa)
                thisTaxa.Vector=(i_unique_Taxa==t);
                thisTaxa.Matrix=thisTaxa.Vector.*thisTaxa.Vector';
                PhylogenyBenchmarks.(Tax_levels{f})(thisTaxa.Matrix~=0)=1;
            end
        end

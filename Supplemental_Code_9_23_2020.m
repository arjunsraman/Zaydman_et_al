%% Code Supplement "Revealing biological emergence through spectral analysis of genomic variation"

% Mark Zaydman (zaydmanm@wustl.edu)
% Arjun Raman (arjun.raman@wustl.edu)

% 9/23/2020

% This code will go through the major methodological components of the
% manuscript.

% Dependencies: to run this code, please download the all files from the
% folowing link and include them in the working directory
% github.com/arjunsraman/Zaydman_et_al
% https://doi.org/10.6084/m9.figshare.12093438.v1




%%%%%%%%%%%%%%%%%%%

clear all;
close all;

tic;
f_size=8;

%% Define non-standard colormaps
    [cmaps]=Nonstandard_Colormaps(100);
    
%% Load raw OGG counts matrix (DOGG)
% This code chunk will load the structured array DOGG into the workspace.
% This array contains two fields: DOGG.Data and DOGG.Taxonomy.

% DOGG.Data: Within DOGG.Data, DOGG.Data.RawCounts contains the raw OGG
% count matrix that was generated by adding the number of annotations of
% OGG j appearing in bacterial proteome i. There are 7047 rows in this
% matrix reflecting all the bacterial proteomes in the UniProt reference
% proteome database (release 02_2020 downloaded 6/1/2020). There are 10177
% columns in this matrix corresponding to all OGGs that are present in at
% least 1% of the proteomes. Row and column labels and metadata can be
% found in DOGG.Data.RowLabels and DOGG.Data.ColLabels, respectively.

    load('DOGG.mat'); 


%% Section 1: Performing SVD on Dij

    %Preprocessing
        [ZOGG]=ZscoreMatrix(DOGG.Data.RawCounts); %Center and standardize DOGG
        plotDOGGZOGG(DOGG.Data.RawCounts,ZOGG,cmaps); %Plot DOGG and ZOGG

    %Perform SVD
        [U,S,V]=svd(ZOGG,'econ'); %Performing SVD on ZOGG
        plotUSV(U,S,V,cmaps); %Plots of U,S,V matrices 

    %Plot SVD spectrum    
        FractionalVariance=(diag(S).^2)./sum(diag(S).^2); % Compute fractional variance per component
        plotSVDSpectrum(FractionalVariance); %Plot SVD spectrum

    %Fit power law relationship to SVD spectrum
        p = polyfit(log((1:1:3000)'),log(FractionalVariance(1:3000)),1); %Fit power-law distribution to components 1 to 3000 
        m = p(1);
        b = exp(p(2));
        plotPowerLaw(FractionalVariance,(1:1:6815),100*b*(1:1:6815).^m,m); %Plot Power-law distribution (Fig. 1b)

    
%% Section 2:Computing mutual information (MI) shared between SVD components and benchmarks of phylogeny
    
    %The correlations between proteomes (rows of DOGG) over components of
    %the SVD spectrum are defined as the correlations between their
    %contributions, or 'projections', onto sets of left singular vectors
    %(SVs). This code will generate a set of plots. The projections for a
    %set of 40 proteomes onto the first 50 left singular vectors are shown
    %(top five panels), where these proteomes were randomly selected from
    %the same phylum, class, order, family or genus. The bottom panel shows
    %the projections for a set of 40 randomly selected proteomes. The
    %pearson correlations of projections over 5 component-windows are
    %shown (dots). Note that the projections of proteomes sampled from the
    %same phylum are highly correlated across the first windows while the
    %projections of protomes that are sampled from lower levels of the
    %phylogenetic tree remain correlated across deeper windows.
    
        plotProteomeCorrelationsExample(U,DOGG);
    
 
    %Benchmarks were assembled to represent all pairs of proteomes that
    %share the same clade at the level of phylum, class, order, family, or
    %genus. 
    
        load('PhylogenyBenchmarks.mat'); %Load pre-computed phylogenetic benchmarks

    %Each benchmark was bootstrapped to generate an equal set of randomly
    %selected proteome pairs that either belong to the 'same clade' or
    %'different clade' at each level. In the manuscript this bootstrapping
    %procedure was repeated many time to produce confidence intervals
    %surrounding MI estimates
    
        fn=fieldnames(PhylogenyBenchmarks);
    
        Neg_bs_indices={};
        Pos_bs_indices={};
        for f=1:1:length(fn)
            Neg_tmp = [];
            Pos_tmp = [];
            for bs=1
                [Neg_tmp(bs,:),Pos_tmp(bs,:)]=make_bootstrap(PhylogenyBenchmarks.(fn{f})); 
            end
            Neg_bs_indices.(fn{f})=Neg_tmp;
            Pos_bs_indices.(fn{f})=Pos_tmp;
        end
            
    %The mutual information (MI) shared between the spectrally windowed
    %proteome correlations and the bootstrapped NCBI phylogeny benchmarks
    %was computed. In the plots below, the distributions of correlations
    %for pairs of proteomes in the bootstrapped benchmarks are shown for
    %several different 5-component spectral withdows along with the
    %associated MI values. The distribution of correlations for proteomes
    %occupying the same clade in the benchmark are shown in gray while
    %those occupying different clades are shown in white. Note that as the
    %window is shifted deeper into the SVD spectrum the white and gray
    %histograms start to overlap and the MI value tends toward zero. Also
    %note that the MI decays faster as a function of spectral depth for
    %benchmarks of higher levels of the phylogenetic tree compared to the
    %lower levels.

        quant_bins=-1:0.25:1; %Bins used for discretization of distributions of correlations

        plotProteomeMIExample(quant_bins,Neg_bs_indices,Pos_bs_indices,U,PhylogenyBenchmarks);


%% Section 3: Computing MI shared between SVD components and benchmarks of protein interactions in E coli K12

    Ecoli_ProteomeID='UP000000625'; %E.coli K12 proteome accession number
    Ecoli_TaxID='83333'; %E.coli K12 NCBI taxonomy ID

    % Approximate protein right SV projections by averaging OGG projections
        [UniprotIDs,Uniprot_by_OGG_Matrix,V_protein] = approxProteinProjections(DOGG,V,Ecoli_ProteomeID,Ecoli_TaxID); 

    % Create row shuffled protein right protein projections matrix
        V_protein_shuffled=zeros(size(V_protein));
        for row=1:1:length(V_protein(:,1))
            V_protein_shuffled(row,1:length(V_protein(1,:)))=V_protein(row,randperm(length(V_protein(1,:))));
        end
        
    % Protein correlations within sets of SVD components are computed using
    % the pearson correlation between the approximated projections in
    % V_protein. 
    
    % To illustrate the process we will plot the protein
    % projections (|V_protein>) and the average pairwise spectral
    % correlations (rho) in various spectral windows for two sets of
    % proteins: 1) proteins in the protein translation pathway identified
    % by the GO annotation "Translation" (GO:0006412, green) and 2)
    % proteins in the F1F0 ATPase complex (F1F0 ATPase, purple).
    % Note that the average correlation for the sets of proteins
    % interacting at the pathway level (green) diminish more quickly as a
    % function of spectral depth compared to those between proteins
    % interacting within a protein complex (purple).
    
    %Read in Ecoli_metadata table downloaded from UniProt
    Ecoli_metadata=readtable('Ecoli_metadata.txt');
    
    %Define example sets to plot
        Examples={};

        %Translation pathway
        Examples.Translation_Genes.UniprotIDs=Ecoli_metadata.Entry(find(contains(Ecoli_metadata.GeneOntology_biologicalProcess_,'GO:0006412')));
        Examples.Translation_Genes.label='[GO:0006412] Translation pathway';
        Examples.Translation_Genes.color=[0 1 0.4];
        Examples.Translation_Genes.indices=find(ismember(UniprotIDs,Examples.Translation_Genes.UniprotIDs));

        %F1F0 ATPase complex
        Examples.F1F0ATPase.UniprotIDs=Ecoli_metadata.Entry(find(contains(Ecoli_metadata.ProteinNames,'F-ATPase')));
        Examples.F1F0ATPase.label='F1F0 ATPase protein complex';
        Examples.F1F0ATPase.color=[0.4 0 1];
        Examples.F1F0ATPase.indices=find(ismember(UniprotIDs,Examples.F1F0ATPase.UniprotIDs));

    %Plot projections and correlations for the example sets
    plotPPICorrelationsExample(V_protein,V_protein_shuffled,Examples);
    
  
    %The benchmarks of protein-protein interactions in E. coli K12 are
    %loaded, reordered to match V_protein, and bootstrapped to generate an
    %equal sets of interacting and non-interacting protein pairs.

    load('Benchmarks.mat');
    load('Proteomes.mat');

    %Reorder the benchmark
    [U,ia,ib]=intersect(Proteomes.Ecoli.Genes.UniprotIDs,UniprotIDs);
    
    fn=fieldnames(Benchmarks);
    for f=1:1:length(fn)
        Data=zeros(size(Benchmarks.(fn{f}).Data));
        Data(ib,ib)=Benchmarks.(fn{f}).Data(ia,ia);
        Benchmarks.(fn{f}).Data=Data;
    end

    %Bootstrap the benchmark
    fn = fieldnames(Benchmarks);
    Neg_bs_indices={};
    Pos_bs_indices={};
    for benchmark_type=1:1:length(fn)
        for bs=1
            [Neg_bs_indices{benchmark_type}(bs,:),Pos_bs_indices{benchmark_type}(bs,:)]=make_bootstrap(Benchmarks.(fn{benchmark_type}).Data,1,Uniprot_by_OGG_Matrix); 
        end
    end

    
    %The biological information contained within a 5-component windows of
    %the SVD spectrum is computed by i) calulating the spectrally windowed
    %protein-protein correlations and ii) computing the mutual information
    %shared between these correlations and the annotations within a
    %benchmark. To illustrate this process we will plot histograms of
    %spectrally windowed protein correlations over several windows for
    %pairs of proteins that do ('interacting', gray bars) or do not
    %('non-interacting', white bars) interact within the STRING nonbinding
    %or PDB benchmarks (shown in two separate windows). The 'random'
    %information is estimated by computing MI in the same way for the
    %randomized protein projection matrix (V_protein_shuffled). For each
    %set of histograms the MI value is shown. Note how windows positioned
    %thousands of components deep within the spectrum still share more MI
    %with the PDB benchmark than expected by the random model. This finding
    %was found to be robust by bootstrapping the benchmark 1000 times (Fig.
    %S5). In contrast, these deep windows share a similar amount of MI with
    %the STRING nonbinding benchmark as observed for the random model.
    %These differences indicate that the indirect interaction information
    %is more compressible into the shallow components of the SVD spectrum
    %while the direct interaction information is poorly compressible and
    %distributed across thousands of components.

        quant_bins=-1:0.125:1; %Bins used for discretization of distributions of correlations

        plotPPIMIExample(quant_bins,Neg_bs_indices,Pos_bs_indices,V_protein,V_protein_shuffled,DOGG,fn);


%% Section 4: Predicting classes of protein-protein interactions in E. coli K12 using MIWSC_OGG
   %Define 'gold-standard' benchmark (see methods for details)
   
   % Define filter to remove pairs with overlapping OGGs
    Filter=ones(size(Benchmarks.PDB.Data));
    Filter=~(Uniprot_by_OGG_Matrix*Uniprot_by_OGG_Matrix'); %don't include genes with overlapping EggNOGs
    Filter=triu(Filter,1); %Define composite filter

    %Generate gold-standard pairs
    [GS_Pairs]=make_GoldStandardSet(Filter,Benchmarks);
    
    %Randomly partition GS dataset into training and validations sets    
    Percent_training=0.6; %Percentage of gold-standard dataset meant for training
    Oversample_negatives=1000; %Fold oversampling of non-interacting pairs
    rng(1); % for reproducibility of partitioning dataset

    % Partition dataset
    [DataSets]=partition_GSPairs(GS_Pairs,Percent_training,Oversample_negatives);
    
    %Define and plot MIWSC_OGG using the 25th (component 34) and 75th
    %(component 223) percentile points of the STRING nonbinding MI cdf.
    Windows=table; %MI Windows variable
    Windows.Phylogeny=[1;33];
    Windows.Functional=[34; 223];
    Windows.Physical=[224; 3000];

    % Calculating the MI Windows Feature
    fn=Windows.Properties.VariableNames;
    M={}; %Variable 
    for f=1:1:length(fn)
        MI_Windows.(fn{f})=corr((V_protein(:,Windows.(fn{f})(1):Windows.(fn{f})(2)))');
    end
    Features.MI_Windows=MI_Windows;

    % Plot MIWSCogg features for the examples in the training and validation
    % datasets. Note how the non-interacting (gray), indirectly interacting
    % (cyan), and directly interacting (red) pairs occupy different
    % subspaces in this three dimensional space.
    plot_MIWSCogg(MI_Windows,DataSets,Windows);
    
    
    %Train and validate a single RF model using the MIWSCogg feature.
    %In the manuscript the process of partitioning the gold standard
    %set, training, and validating RF models was repeated 50 times to
    %assess the reproducibility of the resultant model's performance.

    num_trees=100; %Number of classification trees in each random forest

    %%% Train Models on training dataset and validate against validation
    feature_names=fieldnames(Features);
    disp('Training models...');
    for f=1:1:length(feature_names)
        RF_Models.(feature_names{f})=train_RFModels(Features,DataSets,num_trees,feature_names{f}); 
    end
    disp('Complete');

    %We will plot a confusion matrix to illustrate the RF model's skill
    %at predicting examples in the validation dataset. Not that the RF
    %model trained on MIWSCogg produces precise predictions across all
    %three classes. In the manuscript the skill of RF models trained on
    %MIWSCogg was compared to many other models trained on existing and
    %conventional features of protein coevolution.
    plot_ValidationSetCMs(DataSets,Features,RF_Models);

%% Section 5: Characterizing hierarchical biological organization using Spectral Correlation Analysis of Layered Evolutionary Signals (SCALES)
% Finally, we will demonstrate using SCALES to identify pathway
% organization for a protein of interest within an organism of interest.

% A null model was developed to determine a threshold of significant
% protein-protein correlation across a 100 component SVD window (see Fig. S10). 
    Correlation_threshold=0.29;

    %Next all proteins that are significantly correlated over the window
    %spanning 34-134 are identified as the 'statistical pathway'. The
    %structure of the pathway is illucidated by computing the 
    %spectral depth of correlation for all pairs within this set. The
    %following code will illustrate the process of generating a pairwise
    %spectral depth table.

    ProteinOfInterest = 'P0AF06'; %E.coli motB
    
    [StatisticalPathway,SpectralDepthTable]=SCALES_V2(ProteinOfInterest,V_protein,UniprotIDs,Correlation_threshold);

    %Applying a spectral depth threshold yields an adjacency matrix
    %corresponding to the network structure at a given spectral depth.
    
    %Plot threholded spectral depth matrices
    SD_threshold=250;
    plot_thresholdedSpectralDepth(SpectralDepthTable,ProteinOfInterest,SD_threshold);




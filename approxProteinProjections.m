function [thisProteomeUniprotIDs,Uniprot_by_EggNOG_Matrix,V_protein]=approxProteinProjections(DOGG,V,ProteomeID,TaxID)

%Generate list of unique Uniprot IDs
thisFastaFile=strcat(ProteomeID,'_',TaxID,'.fasta');
thisEggNogFile=strcat(thisFastaFile,'.maNog.emapper.annotations');

% Get UniprotIDs
getUnipdotIDs=['grep ">" ' thisFastaFile ' | cut -d "|" -f 2'];
[status,thisProteomeUniprotIDs]=system(getUnipdotIDs);
thisProteomeUniprotIDs=regexp(thisProteomeUniprotIDs,'\n','split')';
thisProteomeUniprotIDs(cellfun('isempty',thisProteomeUniprotIDs))=[];

clear status getUnipdotIDs thisFasta


%Generate list of unique EggNOG IDs that appear within Cij and this Proteome
% Get COGs
getCOGs=['grep -o "COG....@2" ' thisEggNogFile];
[status,thisGenomeCOGs]=system(getCOGs);
thisGenomeCOGs=strsplit(thisGenomeCOGs,'\n')';


% Get EggNOGs
getEggNOGs=['grep -o ",.....@2" ' thisEggNogFile];
getEggNOGs=['grep -o ",.....@2" ' thisEggNogFile ' | grep -o .....@2'];

[status,thisGenomeEggNOGs]=system(getEggNOGs);
thisGenomeEggNOGs=strsplit(thisGenomeEggNOGs,'\n')';
 
% Make list of OGs to consider and mapping to the columns in Cij
thisGenomeOGs=categorical([thisGenomeCOGs;thisGenomeEggNOGs]);
counts=countcats(thisGenomeOGs);
thisGenomeOGs_categories=categories(thisGenomeOGs);
[OGs_to_Consider,ia,ib]=intersect(thisGenomeOGs_categories,DOGG.Data.ColLabels.OG_ID);
    
clear thisGenomeOGs_categories status thisGenomeCOGs getEggNOGs thisGenomeEggNOGs counts thisGenomeOGs_categories getCOGs thisGenomeOGs;

%Generate Uniprot by filtered OGs_to_Consider matrix
Uniprot_by_EggNOG_Matrix=zeros(length(thisProteomeUniprotIDs),length(OGs_to_Consider));

for i=1:1:length(OGs_to_Consider)
    
    % Get UniprotIDs for proteins with thisEggNOG
    getUnipdotIDs_thisEggNOG=['grep "' OGs_to_Consider{i} '" ' thisEggNogFile];
    [status,thisProteomeUniprotIDs_thisEggNOG]=system(getUnipdotIDs_thisEggNOG);
    if ~isempty(thisProteomeUniprotIDs_thisEggNOG)
        thisProteomeUniprotIDs_thisEggNOG=strsplit(thisProteomeUniprotIDs_thisEggNOG,'\n')';
        thisProteomeUniprotIDs_thisEggNOG(cellfun(@isempty,thisProteomeUniprotIDs_thisEggNOG))=[];
        thisProteomeUniprotIDs_thisEggNOG=split(thisProteomeUniprotIDs_thisEggNOG,'|',2);
        thisProteomeUniprotIDs_thisEggNOG=thisProteomeUniprotIDs_thisEggNOG(:,2);
        find(ismember(thisProteomeUniprotIDs,thisProteomeUniprotIDs_thisEggNOG));
        Uniprot_by_EggNOG_Matrix(ismember(thisProteomeUniprotIDs,thisProteomeUniprotIDs_thisEggNOG),i)=1;        
    end
end

clear thisEggNOGFile status getUniprotIDs_thisEggNOG;
disp(sum(sum(Uniprot_by_EggNOG_Matrix)))

%Generate V_protein matrix
V_OG_thisProteome=V(ib,:);

V_protein=zeros(length(thisProteomeUniprotIDs),length(V_OG_thisProteome(1,:)));
for i=1:1:length(thisProteomeUniprotIDs)
    thisProtein={};
    thisProtein.rows=find(Uniprot_by_EggNOG_Matrix(i,:)); 
    V_protein(i,:)=mean(V_OG_thisProteome(thisProtein.rows,:),1);    
end

clear V_OG_thisProteome thisProtein;

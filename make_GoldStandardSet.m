function [GS_Pairs]=make_GoldStandardSet(Filter,Benchmarks)

GS_Pairs={};

%Identify physical pairs (in all three: PDB, ECOCYC, Coev+)
GS_Pairs.Physical.Matrix=Filter.*(~Benchmarks.CoevPlus.Data==0).*(~Benchmarks.PDB.Data==0).*(~Benchmarks.ECOCYC_Small.Data==0);

%Identify functional pairs (in STRING_NB and GO, not in PDB, ECOCYC, or COEV+)
GS_Pairs.Functional.Matrix=Filter.*(~Benchmarks.STRING_Nonbinding.Data==0).*(~Benchmarks.GO.Data==0).*(Benchmarks.CoevPlus.Data==0).*(Benchmarks.PDB.Data==0).*(Benchmarks.ECOCYC_Small.Data==0);

%Identify non-interacting pairs (not in any of:STRING_Nonbinding,GO,STRING_All, Coev+, PDB, ECOCYC)
GS_Pairs.Negative.Matrix=Filter.*(Benchmarks.STRING_Nonbinding.Data==0).*(Benchmarks.GO.Data==0).*(Benchmarks.STRING_All.Data==0).*(Benchmarks.CoevPlus.Data==0).*(Benchmarks.PDB.Data==0).*(Benchmarks.ECOCYC_Small.Data==0);

clear Filter_DomOverlap Filter_Nan Filter;
%%%%% TP2_exo_1.m %%%%%

addpath('matlab_bgl');      %load graph libraries
addpath('matlab_tpgraphe'); %load tp ressources

load TPgraphe.mat;          %load data

%%%%%%%%%%%%%%%%%%%%%% INIT %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%D(:,14) = 0;
%D(14,:) = 0;

G=sparse(D);
%G(:,14) = 0;
%G(14,:) = 0;
%%%%%%%%%%%%%%%%%%%%%% EXO SPT %%%%%%%%%%%%%%%%%%%%%%%%%%%%

%0)Choose arbitrary src node for spt
src=14;
%1)Compute SPT rooted in src node
[wp spt_]=shortest_paths(G,src); %wp=weight path, spt_=shortsetpathtree structure
%2)Vizualize
%viz_spt(G,spt_,pos,cities);
%
%%%%%%%%%%%%%%%%%%%%%% EXO MST %%%%%%%%%%%%%%%%%%%%%%%%%%%%

%1)Compute MSXXX Filtrage des liens non exploitable a faiT by PRIM 
%changer les valeurs initiales pour obtenir deux arbres differents entre PRIM et KRUSKAL
sommet = 3;
mst_=prim_mst(G,struct('root',sommet));
%2)Vizualize
%viz_mst(G,mst_,pos,cities);

%1)Compute MST by KRUSKAL
mst_=kruskal_mst(G);
%2)Vizualize
%viz_mst(G,mst_,pos,cities);

%%%%%%%%%%%%%%%%%%%%%% EXO FLOW/CUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%

%0)Choose arbitrary srcs, dsts and virtual capacities for these nodes

srcs=[18, 8]; %for europe
dsts=[26, 6];  %for europe
virtual_capacity=100;%for europe

%1)create bandwdth graph from distance graph
n=size(D,1);
%add virtual src & dst (so create graph with two extra nodes)
bw=zeros(n+2,n+2);
%n+1th node is for virtual src;virtual src connected to srcs cities
bw(n+1,srcs)=virtual_capacity; 
bw(srcs,n+1)=virtual_capacity; 
%n+2th node is for virtual dst;virtual dst connected to dsts cities
bw(n+2,dsts)=virtual_capacity; 
bw(dsts,n+2)=virtual_capacity; 

%bandwidth is invertly proportinal to distance
bw(1:n,1:n)=10000./D;
%Inf is on the diagonal, so change it to 0
bw(bw==Inf)=0;
%links with too less bw are not interesting for operators
%XXX Filtrage des liens non exploitable a faire;
bw(bw<11)=0 ;%for europe

% %2)Compute Max flow bw virtual src & dst nodes
Gbw=sparse(bw);
[max_val cut_ R F]=max_flow(Gbw,n+1,n+2);
% 
% %3)Vizualize
%viz_cut(Gbw,cut_,pos,cities,srcs,dsts)
% 
% 
%%%%%%%%%%%%%%%%%%%%%% EXO 4 %%%%%%%%%%%%%%%%%%%%%%%%%%%%
 dataGermany ();

%0)Choose arbitrary srcs, dsts and virtual capacities for these nodes

srcs=[2, 14]; %for germany
dsts=[11, 21];  %for germany
virtual_capacity=800; %for germany

%1)create bandwdth graph from distance graph
n=size(D,1);
%add virtual src & dst (so create graph with two extra nodes)
bw=zeros(n+2,n+2);
%n+1th node is for virtual src;virtual src connected to srcs cities
bw(n+1,srcs)=virtual_capacity; 
bw(srcs,n+1)=virtual_capacity; 
%n+2th node is for virtual dst;virtual dst connected to dsts cities
bw(n+2,dsts)=virtual_capacity; 
bw(dsts,n+2)=virtual_capacity; 

%bandwidth is invertly proportinal to distance
bw(1:n,1:n)=10000./D;
%Inf is on the diagonal, so change it to 0
bw(bw==Inf)=0;
%links with too less bw are not interesting for operators
%XXX Filtrage des liens non exploitable a faire;
bw(bw<120)=0 ;%for europe
%1000000000
bw(10,3) = 430;
bw(3,10) = 430;

bw(11,3) = 400;
bw(3,11) = 400;

bw(4,20) = 400;
bw(20,4) = 400;

% %2)Compute Max flow bw virtual src & dst nodes
Gbw=sparse(bw);
[max_val cut_ R F]=max_flow(Gbw,n+1,n+2);


% 
% %3)Vizualize
viz_cut(Gbw,cut_,pos,cities,srcs,dsts)
%%%%% SET ENV %%%%%

addpath('matlab_bgl');      %load graph libraries
addpath('matlab_tpgraphe'); %load tp ressources

load TPgraphe.mat;          %load data

%%%%%% DISPLAY INPUT DATA ON TERMINAL %%%%%

cities %names of cities
D      %distance matrix bw cities
pos    %x-y pos of the cities

%%%%%%EXO 1 (modeliser et afficher le graphe) %%%%%
A = D;
viz_adj(D,A,pos,cities);
A(A>500) = 0;
viz_adj(D,A,pos,cities);
for n = [2 3 10 12]
    P = graphPower(A,n);
    %viz_adj(D,P,pos,cities);
end

%%%%%% EXO 2 %%%%%

%Q1 - existence d'un chemin de longueur 3
A_carre_bool = bmul(A,A);
%A_carre_bool(1:1+size(A_carre_bool,1):end) = 0; % Mettre des zeros dans le diagonal parce qu'on a pas de chemin dans le meme sommet
A_cube_bool = bmul(A_carre_bool,A);
%A_cube_bool(1:1+size(A_cube_bool,1):end) = 0; % On a pas besoin pour ici car on veut prendre en compte le fait qu'on peut aller d'un sommet
%et revenir au meme sommet aprè trois sauts exacte
%viz_adj(D,A_cube_bool,pos,cities);

%Q2 - nb de chemins de 3 sauts
% Puisque A cube est symetrique donc on prend juste ce qui est en haut
C = triu(A_cube_bool, 1);
nb_chemins_3_exact = sum(C,"all")

%Q3 - nb de chemins <=3
A_inf_3 = graphPower(A,3);
C_inf_3 = triu(A_inf_3, 1);
nb_chemins_inf_3 = sum(C_inf_3,"all")

%%%%%%%% EXO 3 %%%%%
c=[18 13 9]; %la chaine 18 13 9 est t dans le graphe?
possedechaine(A,c)
c=[18 6 3]; %la chaine 18 6 3 est t dans le graphe?
possedechaine(A,c)
c=[26 5 17]; %la chaine 26 5 17 est t dans le graphe?
possedechaine(A,c)

%%%%%%%% EXO 4%%%%%
isEulerien(A)

%%%%%%%% EXO 5%%%%%
porteeEulerien(D)

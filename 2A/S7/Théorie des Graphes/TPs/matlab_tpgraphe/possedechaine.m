function appartient = possedechaine(Graphe, chaine)
    appartient = true;
    n = length(chaine);
    for i = 1:(n-1)
        x = chaine(i);
        y = chaine(i+1);
        if Graphe(x,y) == 0
            appartient = false;
        end
    end
end
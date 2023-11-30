using LinearAlgebra
"""
Approximation de la solution du problème 

    min qₖ(s) = s'gₖ + 1/2 s' Hₖ s

        sous les contraintes s = -t gₖ, t > 0, ‖s‖ ≤ Δₖ

# Syntaxe

    s = cauchy(g, H, Δ; kwargs...)

# Entrées

    - g : (Vector{<:Real}) le vecteur gₖ
    - H : (Matrix{<:Real}) la matrice Hₖ
    - Δ : (Real) le scalaire Δₖ
    - kwargs  : les options sous formes d'arguments "keywords", c'est-à-dire des arguments nommés
        • tol_abs  : la tolérence absolue (optionnel, par défaut 1e-10)

# Sorties

    - s : (Vector{<:Real}) la solution du problème

# Exemple d'appel

    g = [0; 0]
    H = [7 0 ; 0 2]
    Δ = 1
    s = cauchy(g, H, Δ)

"""
function cauchy(g::Vector{<:Real}, H::Matrix{<:Real}, Δ::Real; tol_abs::Real = 1e-10)

    ##########################################################
    # Explication de du traitement de la contrainte ‖s‖ ≤ Δₖ:
    # s = -t gₖ
    # ‖s‖ = t ‖gₖ‖
    # et puisque ‖s‖ ≤ Δₖ
    # donc t ‖gₖ‖ < Δₖ
    # alors t_max < Δₖ/‖gₖ‖
    ##########################################################

    s = zeros(length(g))
    norm_g = norm(g)
    if norm_g > tol_abs # => à partir de quel seuil on fait le pas de Cauchy, donc si g est presque nul, ça sert à rien de faire le pas de cauchy
        t_max = Δ/norm_g
        a = g' * H * g
        b = - norm_g ^ 2
        if (a > 0) 
            t_opt = -b ./ a
            t_opt = min(t_opt, t_max)
        else
            t_opt = t_max
        end
    else
        t_opt = 0
    end
    s = - t_opt * g
    return s
end

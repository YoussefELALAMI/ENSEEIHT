using LinearAlgebra
"""
Approximation de la solution du problème 

    min qₖ(s) = s'gₖ + 1/2 s' Hₖ s, sous la contrainte ‖s‖ ≤ Δₖ

# Syntaxe

    s = gct(g, H, Δ; kwargs...)

# Entrées

    - g : (Vector{<:Real}) le vecteur gₖ
    - H : (Matrix{<:Real}) la matrice Hₖ
    - Δ : (Real) le scalaire Δₖ
    - kwargs  : les options sous formes d'arguments "keywords", c'est-à-dire des arguments nommés
        • max_iter : le nombre maximal d'iterations (optionnel, par défaut 100)
        • tol_abs  : la tolérence absolue (optionnel, par défaut 1e-10)
        • tol_rel  : la tolérence relative (optionnel, par défaut 1e-8)

# Sorties

    - s : (Vector{<:Real}) une approximation de la solution du problème

# Exemple d'appel

    g = [0; 0]
    H = [7 0 ; 0 2]
    Δ = 1
    s = gct(g, H, Δ)

"""
function gct(g::Vector{<:Real}, H::Matrix{<:Real}, Δ::Real; 
    max_iter::Integer = 100, 
    tol_abs::Real = 1e-10, 
    tol_rel::Real = 1e-8)

    sj = zeros(length(g))

    j = 0
    g0 = g
    p0 = -g
    gj = g0
    kj = 0
    pj = p0
    s0 = sj

    q(sj) = sj' * g + 1/2 * sj' * H * sj 

    while (j < max_iter) && (norm(gj) > max(norm(g0)*tol_rel, tol_abs)) && (j < 2*length(g))

        kj = pj' * H * pj

        # Coeficients de σ² * pj² + 2 sj*σ*pj + sj² - Δ² = 0
        a = norm(pj)^2
        b = 2 * sj' * pj
        c = norm(sj)^2 - Δ^2
        # Discriminant
        delta = (b^2) - 4*a*c
        #if delta < 0 
            #error("Le discriminant est Négatif !!!!!")
        #end
        # Calcul de des racine de Δ² = ∥sj + σpj∥² => σ² * pj² + 2 sj*σ*pj + sj² - Δ² = 0
        σ1 = ((- b) + sqrt(delta)) / (2*a)
        σ2 = ((- b) - sqrt(delta)) / (2*a)

        if (kj <= 0)
            # Minimiser q(sj + σpj)
            if (q(sj + σ1*pj) < q(sj + σ2*pj))
                σj = σ1
            else
                σj = σ2
            end

            return (sj + σj * pj)
        end

        αj = (gj' * gj)/kj

        if norm(sj + αj * pj) >= Δ
            if σ1 > 0
                σj = σ1
            else
                σj = σ2
            end

            return (sj + σj * pj)
        end

        sj += αj * pj
        gj_ancien = gj
        gj += αj * H * pj
        βj = (gj' * gj) / (gj_ancien' * gj_ancien)
        pj = -gj + βj * pj
        j+=1
    end

   return sj
end

using LinearAlgebra
include("../src/cauchy.jl")
include("../src/gct.jl")
"""
Approximation de la solution du problème min f(x), x ∈ Rⁿ.

L'algorithme des régions de confiance résout à chaque itération, un modèle quadratique
de la fonction f dans une boule (appelée la région de confiance) de centre l'itéré 
courant. Cette minimisation se fait soit par un pas de Cauchy ou par l'algorithme 
du gradient conjugué tronqué.

# Syntaxe

    x_sol, f_sol, flag, nb_iters, xs = regions_de_confiance(f, gradf, hessf, x0; kwargs...)

# Entrées

    - f       : (Function) la fonction à minimiser
    - gradf   : (Function) le gradient de la fonction f
    - hessf   : (Function) la hessienne de la fonction f
    - x0      : (Vector{<:Real}) itéré initial
    - kwargs  : les options sous formes d'arguments "keywords"
        • max_iter      : (Integer) le nombre maximal d'iterations (optionnel, par défaut 5000)
        • tol_abs       : (Real) la tolérence absolue (optionnel, par défaut 1e-10)
        • tol_rel       : (Real) la tolérence relative (optionnel, par défaut 1e-8)
        • epsilon       : (Real) le epsilon pour les tests de stagnation (optionnel, par défaut 1)
        • Δ0            : (Real) le rayon initial de la région de confiance (optionnel, par défaut 2)
        • Δmax          : (Real) le rayon maximal de la région de confiance (optionnel, par défaut 10)
        • γ1, γ2        : (Real) les facteurs de mise à jour de la région de confiance (optionnel, par défaut 0.5 et 2)
        • η1, η2        : (Real) les seuils pour la mise à jour de la région de confiance (optionnel, par défaut 0.25 et 0.75)
        • algo_pas      : (String) l'algorithme de calcul du pas - "cauchy" ou "gct" (optionnel, par défaut "gct")
        • max_iter_gct  : (Integer) le nombre maximal d'iterations du GCT (optionnel, par défaut 2*length(x0))

# Sorties

    - x_sol : (Vector{<:Real}) une approximation de la solution du problème
    - f_sol : (Real) f(x_sol)
    - flag  : (Integer) indique le critère sur lequel le programme s'est arrêté
        • 0  : convergence
        • 1  : stagnation du xk
        • 2  : stagnation du f
        • 3  : nombre maximal d'itération dépassé
    - nb_iters : (Integer) le nombre d'itérations faites par le programme
    - xs    : (Vector{Vector{<:Real}}) les itérés

# Exemple d'appel

    f(x)=100*(x[2]-x[1]^2)^2+(1-x[1])^2
    gradf(x)=[-400*x[1]*(x[2]-x[1]^2)-2*(1-x[1]) ; 200*(x[2]-x[1]^2)]
    hessf(x)=[-400*(x[2]-3*x[1]^2)+2  -400*x[1];-400*x[1]  200]
    x0 = [1; 0]
    x_sol, f_sol, flag, nb_iters, xs = regions_de_confiance(f, gradf, hessf, x0, algo_pas="gct")

"""
function regions_de_confiance(f::Function, gradf::Function, hessf::Function, x0::Vector{<:Real};
    max_iter::Integer=5000, tol_abs::Real=1e-10, tol_rel::Real=1e-8, epsilon::Real=1, 
    Δ0::Real=2, Δmax::Real=10, γ1::Real=0.5, γ2::Real=2, η1::Real=0.25, η2::Real=0.75, algo_pas::String="gct",
    max_iter_gct::Integer = 2*length(x0))

    # Paramètres
    x_sol = x0
    f_sol = f(x_sol)
    flag  = -1
    nb_iters = 0
    xs = [x0] # vous pouvez faire xs = vcat(xs, [xk]) pour concaténer les valeurs
    Δ = Δ0
    ρ = 0
    g0 = gradf(x0)
    g = g0
    H = hessf(x_sol)
    s = zeros(length(g0))
    xk = zeros(length(x0))  
    
    # Algorithme
    if norm(g0) <= tol_abs
        flag = 0
    end
    
    while (flag == -1)

        xk = x_sol
        f_xk = f(x_sol)
        g = gradf(xk)
        H = hessf(xk)
        m(s) = f_sol + g' * s + (1/2) * s' * H * s

        # Calcul du pas sk pour minimiser mk
        if (algo_pas == "cauchy")
            s = cauchy(g, H, Δ);
        elseif (algo_pas == "gct")
            s = gct(g, H, Δ, max_iter = max_iter_gct);
        else
            error("Mauvaise algorithme !")
        end

        # Definir ρ
        ρ = (f_xk- f(xk + s)) / (m(zeros(length(x0))) - m(s))

        # Mise à jour de l'itéré
        if (ρ > η1)
            x_sol += s
            xs = vcat(xs,[x_sol])
            ###################
            # Critere d'arret #
            ###################
            if norm(gradf(x_sol)) <= max(tol_rel*norm(g0),tol_abs)
                # Convergence (CN1) (On test juste qu'on incrémente le pas)
                flag = 0
            elseif norm(x_sol - xk) <= epsilon*max(tol_rel*norm(xk),tol_abs)
                #Stagnation de l'itéré (On test juste qu'on incrémente le pas)
                flag = 1
            elseif abs(f(x_sol)- f_xk) <= epsilon*max(tol_rel*abs(f_xk), tol_abs)
                # Stagnation de la fonction (On test juste qu'on incrémente le pas)
                flag = 2
            end
            ###################
        end

        if (ρ >= η2)
            # On augmente la région de confiance (On est content car il y une différence entre f(xk) et f(xk + s))
            Δ = min(γ2 * Δ, Δmax)

        elseif (ρ >= η1)
            Δ = Δ
        else
            # On diminue la région de confiance
            Δ = Δ * γ1
        end

        # Incrémenter le nombre d'itération 
        nb_iters += 1

        if nb_iters == max_iter
            # Nb d’itérations max
            flag = 3
        end

    end

    return x_sol, f_sol, flag, nb_iters, xs
end

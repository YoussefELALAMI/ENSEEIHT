# Ecrire les tests de l'algorithme du pas de Cauchy
using Test

function tester_cauchy(cauchy::Function)

    tol_erreur = sqrt(eps())
    
    tol_abs = sqrt(eps())
    tol_rel = 1e-15
    epsilon = 1.0


	@testset "Pas de Cauchy" begin
       @testset "test aNegatif" begin
            println("Test a < 0 et b ")
            g = [5; 2]
            H = [-1 0 ; 0 -1]
            Δ = 1
            println("La valeur du gradient : ", g)
            println("La valeur de la Hessienne : ", H)
            println("La valeur de Δ (région de confiance) : ", Δ)
            s = cauchy(g, H, Δ)
            println("La valeur du pas s : ", s)
            @test s ≈[ -0.9284766908852593 ; -0.3713906763541037]  atol = tol_erreur
        end

        @testset "test b = 0" begin
        end
    end

end
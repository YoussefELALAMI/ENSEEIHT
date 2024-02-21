# Ecrire les tests de l'algorithme du pas de Cauchy
using Test

function tester_cauchy(cauchy::Function)

    tol_erreur = sqrt(eps())
    
    tol_abs = sqrt(eps())
    tol_rel = 1e-15
    epsilon = 1.0


	@testset "Pas de Cauchy" begin
       @testset "Test a < 0 et b <> 0" begin
            g = [5; 2]
            H = [-1 0 ; 0 -1]
            Δ = 1
            s = cauchy(g, H, Δ)
            @test s ≈[ -0.9284766908852593 ; -0.3713906763541037]  atol = tol_erreur
        end

        @testset "Test b = 0" begin
            g = [0; 0]
            H = [-1 0 ; 0 -1]
            Δ = 1
            s = cauchy(g, H, Δ)
            @test s ≈[ 0 ; 0]  atol = tol_erreur
        end

        @testset "Test a = 0 et b <> 0" begin
            g = [2; 3]
            H = [0 0 ; 0 0]
            Δ = 1
            s = cauchy(g, H, Δ)
            @test s ≈[ -0.5547001962252291
            ; -0.8320502943378437]  atol = tol_erreur
        end

        @testset "Test a > 0 et b <> 0 et Δ < Δ_lim" begin
            g = [1; 2]
            H = [1 0 ; 0 1]
            Δ = 1
            s = cauchy(g, H, Δ)
            @test s ≈[ -0.447213595499958; -0.894427190999916]  atol = tol_erreur
        end

        @testset "Test a > 0 et b <> 0 et Δ > Δ_lim" begin
            g = [1; 2]
            H = [1 0 ; 0 1]
            Δ = 5
            s = cauchy(g, H, Δ)
            @test s ≈[ -1.0; -2.0]  atol = tol_erreur
        end

        @testset "Test a > 0 et b <> 0 et Δ = Δ_lim" begin
            g = [1; 2]
            H = [1 0 ; 0 1]
            Δ = 2.2360679774997902
            s = cauchy(g, H, Δ)
            @test s ≈[ -1.0; -2.0]  atol = tol_erreur
        end
    end

end
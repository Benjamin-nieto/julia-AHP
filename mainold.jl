using LinearAlgebra

# Función para calcular los pesos de una matriz de comparación
function calcular_pesos(matriz::Matrix)
    n = size(matriz, 1)
    λ, v = eigen(matriz)
    max_eigenvalor = maximum(λ)
    índice_max_eigenvalor = argmax(λ)
    w = v[:, índice_max_eigenvalor]
    w = w / sum(w)
    return max_eigenvalor, w
end

# Función para leer una matriz de comparación
function leer_matriz(nombre::String)
    println("Leyendo matriz de comparación $nombre...")
    println("Ingrese los valores de la matriz de comparación $nombre:")
    matriz = Matrix{Float64}(undef, 0, 0)
    for i in 1:5
        fila = []
        for j in 1:5
            if j > i
                valor = parse(Float64, readline())
                push!(fila, valor)
            
            end
        end
        matriz = vcat(matriz, [fila])
    end
    return matriz
end

# Función para pedir el número de jerarquías, criterios y alternativas
function pedir_datos()
    println("Ingrese el número de jerarquías:")
    num_jerarquias = parse(Int, readline())
    criterios_por_jerarquia = []
    for i in 1:num_jerarquias
        println("Ingrese el número de criterios para la jerarquía $i:")
        num_criterios = parse(Int, readline())
        push!(criterios_por_jerarquia, num_criterios)
    end
    println("Ingrese el número de alternativas:")
    num_alternativas = parse(Int, readline())
    return num_jerarquias, criterios_por_jerarquia, num_alternativas
end

# Función principal
function main()
    num_jerarquias, criterios_por_jerarquia, num_alternativas = pedir_datos()

    for i in 1:num_jerarquias
        println("Jerarquía $i:")
        for j in 1:criterios_por_jerarquia[i]
            nombre = "Jerarquía $i, Criterio $j"
            matriz = leer_matriz(nombre)
            max_eigenvalor, pesos = calcular_pesos(matriz)
            println("Matriz $nombre:")
            println(matriz)
            println("Autovalores y autovectores:")
            println("λ = $max_eigenvalor")
            println("w = $pesos")
        end
    end

    # Aquí se calcularían los pesos compuestos y se tomaría la decisión óptima

end

main()

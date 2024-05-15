# Definición de la estructura de datos para almacenar las matrices de comparación
struct ComparisonMatrix
    size::Int   # Tamaño de la matriz
    matrix::Matrix{Float64}   # Matriz de comparación
end

# Función para ingresar una matriz de comparación
function input_comparison_matrix(size::Int)
    println("Ingrese la matriz de comparación ($size x $size):")
    matrix = zeros(Float64, size, size)
    for i in 1:size
        for j in i:size  # Cambio en el límite superior del bucle para incluir la diagonal principal
            if i == j
                matrix[i, j] = 1.0  # Llenar la diagonal principal con 1
            else
                print("Ingrese la comparación entre el criterio ", i, " y el criterio ", j, ": ")
                value = parse(Float64, readline())
                matrix[i, j] = value
                matrix[j, i] = 1 / value
            end
        end
    end
    return ComparisonMatrix(size, matrix)
end

# Función para calcular los pesos de una matriz de comparación
function calculate_weights(matrix::Matrix{Float64})
    n = size(matrix, 1)
    weights = zeros(Float64, n)
    for i in 1:n
        weights[i] = prod(matrix[i, :] .^ (1 / n))
    end
    weights /= sum(weights)
    return weights
end

# Función para calcular los pesos compuestos de las alternativas
function calculate_alternative_weights(criteria_weights::Vector{Float64}, alternative_matrix::Matrix{Float64})
    if size(criteria_weights, 1) != size(alternative_matrix, 1)
        println("Error: Las dimensiones de las matrices de pesos de criterios y alternativas no coinciden.")
        return
    end
    
    alternative_weights = alternative_matrix * criteria_weights
    alternative_weights /= sum(alternative_weights)
    return alternative_weights
end

# Función para encontrar la decisión óptima
function optimal_decision(alternative_weights::Matrix{Float64}, alternative_names::Vector{String})
    max_weight = maximum(alternative_weights)
    index = argmax(alternative_weights)
    println("La decisión óptima es: ", alternative_names[index], " con un peso de ", max_weight)
end

# Función para ingresar una matriz de comparación individual para una alternativa
function input_alternative_comparison_matrix(alternative_name::String, num_criteria::Int)
    println("Ingrese la matriz de comparación para la alternativa $alternative_name ($num_criteria x $num_criteria):")
    matrix = zeros(Float64, num_criteria, num_criteria)
    for i in 1:num_criteria
        for j in i:num_criteria  # Cambio en el límite superior del bucle para incluir la diagonal principal
            if i == j
                matrix[i, j] = 1.0  # Llenar la diagonal principal con 1
            else
                print("Ingrese la comparación entre $alternative_name $i y $alternative_name $j: ")
                value = parse(Float64, readline())
                matrix[i, j] = value
                matrix[j, i] = 1 / value
            end
        end
    end
    return matrix
end

# Función para ingresar las matrices de comparación individuales para todas las alternativas
function input_alternatives_comparison_matrices(alternative_names::Vector{String}, num_criteria::Int)
    num_alternatives = length(alternative_names)
    alternative_matrices = Dict{String, Matrix{Float64}}()  # Diccionario para almacenar las matrices de comparación individuales
    for alternative_name in alternative_names
        alternative_matrix = input_alternative_comparison_matrix(alternative_name, num_criteria)
        alternative_matrices[alternative_name] = alternative_matrix
    end
    return alternative_matrices
end

# Función principal
function main()
    println("Bienvenido al programa de toma de decisiones utilizando AHP")
    
    # Ingreso de datos
    println("Ingrese el número de jerarquías (1 o 2):")
    num_hierarchies = parse(Int, readline())
    
    println("Ingrese el número de criterios para cada jerarquía:")
    criteria_counts = [parse(Int, readline()) for _ in 1:num_hierarchies]
    
    println("Ingrese el número de alternativas por criterio:")
    num_alternatives_per_criteria = parse(Int, readline())
    
    # Generar nombres de alternativas
    alternative_names = String[]
    for criterion in 1:num_hierarchies
        for alternative in 1:num_alternatives_per_criteria
            push!(alternative_names, "Alternativa $alternative para Criterio $criterion")
        end
    end
    
    # Ingreso de matrices de comparación
    comparison_matrices = [input_comparison_matrix(n) for n in criteria_counts]
    
    # Mostrar matrices de comparación individuales para cada alternativa
    println("Matrices de comparación individuales para cada alternativa:")
    for (i, matrix) in enumerate(comparison_matrices)
        println("Matriz de comparación para el criterio $i:")
        println(matrix)
        alternative_matrices = input_alternatives_comparison_matrices(alternative_names, criteria_counts[i].size)
        for (alternative_name, alt_matrix) in alternative_matrices
            println("Matriz para $alternative_name:")
            println(alt_matrix)
        end
    end
end


# Llamar a la función principal
main()



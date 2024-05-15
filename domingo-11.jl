# Pide al usuario los datos

println("Número de jerarquías:")
num_jerarquias = parse(Int, readline())

println("Número de criterios por jerarquía:")
num_criterios = parse(Int, readline())

println("Número de alternativas:")
num_alternativas = parse(Int, readline())

# Inicializa las matrices de comparación
matrices_comparacion = Array{Float64}(undef, num_criterios, num_alternativas, num_alternativas)

# Llena las matrices de comparación
for i in 1:num_criterios
    println("Matriz de comparación para el criterio $i:")
    for j in 1:num_alternativas
        matrices_comparacion[i, :, j] .= parse.(Float64, split(readline()))
    end
end

# Calcula los pesos compuestos
pesos_compuestos = sum(matrices_comparacion, dims=1) / num_criterios

# Determina la decisión óptima
mejor_alternativa = argmax(pesos_compuestos)

println("La decisión óptima es la alternativa $mejor_alternativa")
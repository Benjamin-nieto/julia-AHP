using DataFrames, XLSX
using Statistics

function leer_matrices_excel(ruta_archivo)
    # Abre el archivo Excel
    archivo = XLSX.readxlsx(ruta_archivo)
    hojas = XLSX.sheetnames(archivo)

    # Lee la matriz de comparación de la hoja "MATRIZ"
    hoja_matriz = archivo["MATRIZ"]
    df2 = XLSX.eachtablerow(hoja_matriz) |> DataFrames.DataFrame

    matriz_comparacion = Matrix{Float64}(df2)

    # Determina el tamaño de la matriz
    N = size(matriz_comparacion, 1)
    
    # Inicializa un diccionario para almacenar las matrices de alternativas
    matrices_alternativas = Dict{String, Matrix{Float64}}()
    
    vector_alternativas = []
    # Itera sobre las hojas y lee aquellas que comienzan con "A"
    for i in 1:N
        nombre_hoja = "A$i"
        hoja_matriz_alternativas = archivo[nombre_hoja]
        df3 = XLSX.eachtablerow(hoja_matriz_alternativas) |> DataFrames.DataFrame
    
        matriz_alternativa = Matrix{Float64}(df3)

      #  push!(vector_alternativa,matriz_alternativa)
        matrices_alternativas[nombre_hoja] = matriz_alternativa
    end
    
    return matriz_comparacion, matrices_alternativas
end

function normalizar_matriz(matriz)
    # Calcular la suma de cada columna (o fila)
    suma_columnas = sum(matriz, dims=1)
    
    # Dividir cada elemento de la matriz por la suma de su columna (o fila)
    matriz_normalizada = matriz ./ suma_columnas
    
    return matriz_normalizada
end

function calcular_vector_pesos(matriz_normalizada)
    # Calcular el promedio de las filas (o columnas) de la matriz normalizada
    vector_pesos = mean(matriz_normalizada, dims=2)  # Calcula el promedio de cada fila
    
    # Normalizar el vector de pesos para que sume 1
    vector_pesos /= sum(vector_pesos)
    
    return vector_pesos
end

function calcular_vector_pesos_ponderados(matriz_comparacion, vector_pesos)
    # Multiplicar la matriz de comparación por el vector de pesos relativos
    vector_pesos_ponderados = matriz_comparacion * vector_pesos
    
    return vector_pesos_ponderados
end

function calcular_Nmax(vector_pesos_ponderados)
    # Encontrar el índice del valor máximo en el vector de pesos ponderados
    Nmax_indice = argmax(vector_pesos_ponderados)
    
    # Calcular Nmax sumando 1 al índice (ya que los índices en Julia comienzan desde 1)
    Nmax = Nmax_indice[1]
    
    return round(Nmax,digits=4)
end

function calcular_peso_compuesto(vector_pesos_criterios, vector_peso_alternativas_normis)
    # Inicializar el peso compuesto como un vector de ceros del tamaño de las alternativas
    n_alternativas = size(first(values(vector_peso_alternativas_normis)), 1)
    peso_compuesto = zeros(n_alternativas)
    
    # Obtener los nombres de los criterios en el diccionario
    criterios = sort(collect(keys(vector_peso_alternativas_normis)))
    
    # Iterar sobre los criterios y calcular el peso compuesto
    for (i, criterio) in enumerate(criterios)
        vector_pesos_alternativas = vector_peso_alternativas_normis[criterio]
        peso_criterio = vector_pesos_criterios[i]
        peso_compuesto .+= peso_criterio .* vector_pesos_alternativas
    end
    
    return peso_compuesto
end


function calcular_indice_consistencia(Nmax, n; precision=4)
    CI = round((Nmax - n) / (n - 1), digits=precision)
    return round(CI, digits=precision)
end

function calcular_relacion_consistencia(CI, n; precision=4)
    # Índice de Aleatoriedad (RI) basado en el tamaño de la matriz n
    RI_table = Dict(1 => 0.00, 2 => 0.00, 3 => 0.58, 4 => 0.90, 5 => 1.12, 6 => 1.24, 7 => 1.32, 8 => 1.41, 9 => 1.45, 10 => 1.49)
    RI = RI_table[n]
    
    # Calcular la Relación de Consistencia (CR)
    CR = CI / RI
    return round(CR, digits=precision)
end

function calcular_RI(CI, n)
    # Índice de Aleatoriedad (RI) basado en el tamaño de la matriz n
    RI_table = Dict(1 => 0.00, 2 => 0.00, 3 => 0.58, 4 => 0.90, 5 => 1.12, 6 => 1.24, 7 => 1.32, 8 => 1.41, 9 => 1.45, 10 => 1.49)
    RI = RI_table[n]
    return RI
end


function encontrar_mayor(vector)
    if isempty(vector)
        return NaN  # Si el vector está vacío, retorna NaN (Not a Number)
    end
    
    max_valor = vector[1]  # Inicializa el máximo valor con el primer elemento del vector
    for valor in vector
        if valor > max_valor
            max_valor = valor  # Actualiza el máximo valor si encontramos uno más grande
        end
    end
    
    return max_valor
end
#################################################################################
# Ejemplo de uso
ruta_archivo = "documento/matriz_comparacion-alternativasnombre.xlsx"
matriz_comparacion, matrices_alternativas = leer_matrices_excel(ruta_archivo)

println("Matriz de Comparación:")
println(matriz_comparacion)

println("\nMatrices de Alternativas:")
for (alternativa, matriz) in matrices_alternativas
    println("$alternativa:")
    println(matriz)
end

matriz_normalizada = normalizar_matriz(matriz_comparacion)
println("Matriz de Comparación Normalizada:")
println(matriz_normalizada)

## diccionario de matriz de alternativas Normalizadas
matrices_alternativas_normis = Dict{String, Matrix{Float64}}()

println("\nMatrices de Normalizadas Alternativas:")

for (alternativa, matriz) in matrices_alternativas
    m_alternativa = normalizar_matriz(matriz)
    matrices_alternativas_normis[alternativa] = m_alternativa
    println("N$alternativa:")
    println(m_alternativa)
end


vector_pesos = calcular_vector_pesos(matriz_normalizada)
println("Vector de Pesos Relativos:")
println(vector_pesos)


## diccionario de vector de peso RELATIVO PARA ALTERNATIVAS
vector_peso_alternativas_normis = Dict{String, Matrix{Float64}}()

println("\nVectores de pesos relativos de las Alternativas:")

for (alternativa, matriz) in matrices_alternativas_normis
    vp_alternativa = calcular_vector_pesos(matriz)
    vector_peso_alternativas_normis[alternativa] = vp_alternativa
    println("W$alternativa:")
    println(vp_alternativa)
end

## 
# Calcular el vector de pesos ponderados
vector_pesos_ponderados = calcular_vector_pesos_ponderados(matriz_comparacion, vector_pesos)

println("Vector de Pesos Ponderados (A.W):")
println(vector_pesos_ponderados)

## calcular nmax
Nmax = calcular_Nmax(vector_pesos_ponderados)
println("Nmax: ", Nmax)

##calcular CI
n = size(matriz_comparacion, 1)
CI = calcular_indice_consistencia(Nmax, n, precision=4)
CR = calcular_relacion_consistencia(CI, n, precision=4)
RI = calcular_RI(CI,n)
println("Índice de Consistencia (CI): ", CI  )
println("Relación de Consistencia (CR): ", CR )
println("Índice de Aleatoriedad (RI): ", RI)
##
peso_compuesto = calcular_peso_compuesto(vector_pesos, vector_peso_alternativas_normis)
println("Peso Compuesto:")
println(peso_compuesto)

max_peso = encontrar_mayor(peso_compuesto)
println("La decisión más óptima es la correspontiente al peso compuesto de: ", max_peso)
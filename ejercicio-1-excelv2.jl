using XLSX
using DataFrames

function leer_matrices_excel(ruta_archivo)
    # Abre el archivo Excel
    archivo = XLSX.openxlsx(ruta_archivo)
    
    # Lee la hoja "MATRIZ" y conviértela en un DataFrame
    hoja_matriz = archivo["MATRIZ"]
    df_matriz = DataFrame(XLSX.readtable(hoja_matriz; infer_eltypes=true)...)

    # Convierte el DataFrame en una matriz de tipo Float64
    matriz_comparacion = Matrix{Float64}(df_matriz)
    
    # Determina el tamaño de la matriz
    N = size(matriz_comparacion, 1)
    
    # Inicializa un diccionario para almacenar las matrices de alternativas
    matrices_alternativas = Dict{String, Matrix{Float64}}()
    
    # Itera sobre las hojas y lee aquellas que comienzan con "A"
    for i in 1:N
        nombre_hoja = "A$i"
        if haskey(archivo, nombre_hoja)
            hoja_alternativa = archivo[nombre_hoja]
            df_alternativa = DataFrame(XLSX.readtable(hoja_alternativa; infer_eltypes=true)...)
            matriz_alternativa = Matrix{Float64}(df_alternativa)
            matrices_alternativas[nombre_hoja] = matriz_alternativa
        end
    end
    
    return matriz_comparacion, matrices_alternativas
end

# Ejemplo de uso
ruta_archivo = "documento/matriz_comparacion.xlsx"
matriz_comparacion, matrices_alternativas = leer_matrices_excel(ruta_archivo)

println("Matriz de Comparación:")
println(matriz_comparacion)

println("\nMatrices de Alternativas:")
for (nombre, matriz) in matrices_alternativas
    println("$nombre:")
    println(matriz)
end

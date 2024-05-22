function calcular_decision()
    # Pedir al usuario el número de estados de la naturaleza
    println("Ingrese el número de estados de la naturaleza (máximo 10):")
    n_estados = parse(Int, readline())
    
    # Validar el número de estados de la naturaleza
    while !(1 <= n_estados <= 10)
        println("Por favor, ingrese un número entre 1 y 10:")
        n_estados = parse(Int, readline())
    end

    # Pedir al usuario el número de alternativas
    println("Ingrese el número de alternativas (máximo 10):")
    n_alternativas = parse(Int, readline())
    
    # Validar el número de alternativas
    while !(1 <= n_alternativas <= 10)
        println("Por favor, ingrese un número entre 1 y 10:")
        n_alternativas = parse(Int, readline())
    end

    # Inicializar matrices para almacenar las ganancias y probabilidades
    ganancias = zeros(Float64, n_estados, n_alternativas)
    probabilidades_estados = zeros(Float64, n_estados)

    # Pedir al usuario que ingrese las ganancias por cada resultado
    for i in 1:n_estados
        for j in 1:n_alternativas
            println("Ingrese la ganancia para el estado de la naturaleza $i y la alternativa $j:")
            ganancias[i, j] = parse(Float64, readline())
        end
    end

    # Pedir al usuario que ingrese las probabilidades para los estados de la naturaleza
    println("Ingrese las probabilidades para los estados de la naturaleza:")
    while true
        total_probabilidades = 0.0
        for i in 1:n_estados
            println("Probabilidad para el estado de la naturaleza $i:")
            probabilidades_estados[i] = parse(Float64, readline())
            total_probabilidades += probabilidades_estados[i]
        end

        if total_probabilidades == 1.0
            break
        else
            println("La suma de las probabilidades debe ser 1.0. Por favor, ingréselas nuevamente.")
        end
    end

   # Mostrar la matriz de ganancias y probabilidades
   println("\nMatriz de Ganancias y Probabilidades:")
   println("Estados de la Naturaleza | ", collect(1:n_estados))
   for j in 1:n_alternativas
       print("Alternativa $j | ")
       for i in 1:n_estados
           print(ganancias[i, j], " | ")
       end
       println()
   end
   print("Probabilidades | ")
   for i in 1:n_estados
       print(probabilidades_estados[i], " | ")
   end
   println()

    # Calcular la ganancia esperada y la ganancia máxima posible para cada estrategia
    ganancia_esperada = sum(probabilidades_estados' * ganancias, dims=1)
    ganancia_maxima = maximum(ganancias, dims=1)

    # Elegir la estrategia óptima basándose en la ganancia esperada
    estrategia_optima_esperada = argmax(ganancia_esperada)
    ganancia_optima_esperada = ganancia_esperada[estrategia_optima_esperada]

    # Elegir la estrategia óptima basándose en la ganancia máxima posible
    estrategia_optima_maxima = argmax(ganancia_maxima)
    ganancia_optima_maxima = ganancia_maxima[estrategia_optima_maxima]

    # Calcular la ganancia mínima y la mínima posibilidad para cada estrategia
    ganancia_minima = minimum(probabilidades_estados' * ganancias, dims=1)
    minima_posibilidad = minimum(ganancias)

    # Elegir la estrategia óptima basándose en la ganancia esperada
    estrategia_optima_minima = argmin(ganancia_minima)
    ganancia_optima_minima = ganancia_minima[estrategia_optima_minima]

    # Elegir la estrategia óptima basándose en la ganancia mínima posible
    estrategia_optima_minima = argmin(ganancia_minima)
    ganancia_optima_minima = ganancia_minima[estrategia_optima_minima]

    # Mostrar los resultados
    println("\nResultados:")
    println("¿Desea maximizar (1) o minimizar (2)?")
    respuesta = parse(Int, readline())
    objetivo = respuesta == 1 ? "maximizar" : "minimizar"

    if objetivo == "maximizar"
        println("¿Qué resultado desea ver?")
        println("1. Valor Esperado con la alternativa óptima")
        println("2. Máxima Posibilidad con la alternativa óptima")
        println("3. Ambos resultados con las respectivas alternativas")
        respuesta_resultado = parse(Int, readline())

        if respuesta_resultado == 1 || respuesta_resultado == 3
            println("\nResultado del Valor Esperado:")
            println("Estrategia óptima: Alternativa $estrategia_optima_esperada")
            println("Ganancia Esperada: \$", ganancia_optima_esperada)
        end

        if respuesta_resultado == 2 || respuesta_resultado == 3
            println("\nResultado de la Máxima Posibilidad:")
            println("Estrategia óptima: Alternativa $estrategia_optima_maxima")
            println("Ganancia Máxima Posible: \$", ganancia_optima_maxima)
        end
    else  # Si se desea minimizar
        println("¿Qué resultado desea ver?")
        println("1. Valor Mínimo Esperado con la alternativa óptima")
        println("2. Mínima Posibilidad con la alternativa óptima")
        println("3. Ambos resultados con las respectivas alternativas")
        respuesta_resultado = parse(Int, readline())

        if respuesta_resultado == 1 || respuesta_resultado == 3
            println("\nResultado del Valor Mínimo Esperado:")
            println("Estrategia óptima: Alternativa $estrategia_optima_minima")
            println("Ganancia Mínima Esperada: \$", ganancia_optima_minima)
        end

        if respuesta_resultado == 2 || respuesta_resultado == 3
            println("\nResultado de la Mínima Posibilidad:")
            println("Estrategia óptima: Alternativa $estrategia_optima_minima")
            println("Mínima Posibilidad: \$", minima_posibilidad)
        end
    end
end

# Llamar a la función para ejecutar el algoritmo
calcular_decision()

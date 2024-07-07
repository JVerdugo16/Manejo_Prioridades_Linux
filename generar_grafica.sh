#!/bin/bash

# Archivo de estadísticas y archivo de datos para gnuplot
ARCHIVO_ESTADISTICAS="/var/log/estadisticas_cpu.txt"
ARCHIVO_DATOS="/var/log/datos_grafica_cpu.dat"

# Limpiar el archivo de datos anterior
> $ARCHIVO_DATOS

# Extraer datos del uso de CPU y formatear para gnuplot
awk '/Uso de CPU por procesador:/{flag=1; next} /Procesos que más CPU consumen:/{flag=0} flag' $ARCHIVO_ESTADISTICAS | \
grep -v "all" | awk '{print NR, 100 - $12}' > $ARCHIVO_DATOS

# Verificar si el archivo de datos está vacío
if [ ! -s $ARCHIVO_DATOS ]; then
    echo "No se encontraron datos válidos para el uso de CPU."
    exit 1
fi

# Generar gráfica con gnuplot
gnuplot -e "
    set terminal png;
    set output 'grafica_uso_cpu.png';
    set title 'Uso de CPU por Procesador';
    set xlabel 'Tiempo';
    set ylabel 'Uso de CPU (%)';
    plot '$ARCHIVO_DATOS' using 1:2 with linespoints title 'Uso de CPU';
"


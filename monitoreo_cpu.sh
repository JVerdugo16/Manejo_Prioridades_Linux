#!/bin/bash

# Leer el correo del archivo
if [ ! -f correo_admin.txt ]; then
    echo "El archivo correo_admin.txt no existe. Ejecute primero pedir_correo.sh"
    exit 1
fi
CORREO_ADMIN=$(cat correo_admin.txt)

# Archivo de estadísticas
ARCHIVO_ESTADISTICAS="estadisticas_cpu.txt"

# Comenzar a consumir recursos de CPU
stress --cpu 4 --timeout 300 &

# Función para obtener estadísticas de CPU y procesos
obtener_estadisticas_cpu() {
    echo "Fecha: $(date)" >> $ARCHIVO_ESTADISTICAS
    echo "Uso de CPU por procesador:" >> $ARCHIVO_ESTADISTICAS
    mpstat -P ALL 1 1 | grep -v "Linux" | grep -v "CPU" >> $ARCHIVO_ESTADISTICAS
    echo "Procesos que más CPU consumen:" >> $ARCHIVO_ESTADISTICAS
    ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 11 >> $ARCHIVO_ESTADISTICAS
    echo "" >> $ARCHIVO_ESTADISTICAS
}

# Función para ajustar prioridades de procesos
ajustar_prioridades() {
    procesos_alto_cpu=$(ps -eo pid,%cpu --sort=-%cpu | awk '$2>60 {print $1}')
    for pid in $procesos_alto_cpu; do
        renice +10 -p $pid
        echo "El proceso $pid ha cambiado su prioridad." >> $ARCHIVO_ESTADISTICAS
        echo "El proceso $pid ha cambiado su prioridad." | mail -s "Cambio de prioridad de proceso" $CORREO_ADMIN
    done
}

# Función para terminar procesos
terminar_procesos_alto_cpu() {
    procesos_alto_cpu=$(ps -eo pid,%cpu --sort=-%cpu | awk '$2>90 {print $1}')
    for pid in $procesos_alto_cpu; do
        kill -9 $pid
        echo "El proceso $pid ha sido terminado." >> $ARCHIVO_ESTADISTICAS
        echo "El proceso $pid ha sido terminado." | mail -s "Proceso terminado" $CORREO_ADMIN
    done
}

# Bucle principal
while true; do
    obtener_estadisticas_cpu

    # Verificar si el uso de CPU supera el 60%
    if mpstat -P ALL 1 1 | awk '$3>60 {print $3}' | grep -q "."; then
        sleep 30
        if mpstat -P ALL 1 1 | awk '$3>60 {print $3}' | grep -q "."; then
            ajustar_prioridades
        fi
    fi

    # Verificar si el uso de CPU supera el 90%
    if mpstat -P ALL 1 1 | awk '$3>90 {print $3}' | grep -q "."; then
        terminar_procesos_alto_cpu
    fi

    sleep 5
done


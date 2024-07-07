#!/bin/bash

# Función para mostrar el menú
mostrar_menu() {
    echo "--------------------------------------------"
    echo "            Monitor de Uso de CPU            "
    echo "--------------------------------------------"
    echo "Este script monitorea el uso de CPU en el sistema,"
    echo "ajusta las prioridades de los procesos y termina"
    echo "procesos si es necesario. Además, envía notificaciones"
    echo "por correo electrónico al administrador especificado."
    echo ""
    echo "Opciones:"
    echo "1. Ingresar correo electrónico del administrador"
    echo "2. Salir"
    echo "--------------------------------------------"
}

# Función para solicitar el correo electrónico
solicitar_correo() {
    read -p "Ingrese el correo electrónico del administrador: " CORREO_ADMIN
    echo $CORREO_ADMIN > correo_admin.txt
    echo "Correo electrónico guardado."
    echo "Ejecutando el script de monitoreo en segundo plano..."
    nohup ./monitoreo_cpu.sh > /dev/null 2>&1 &
    echo "Script de monitoreo ejecutándose en segundo plano."
    exit 0
}

# Mostrar el menú y manejar la selección del usuario
while true; do
    mostrar_menu
    read -p "Seleccione una opción: " OPCION
    case $OPCION in
        1)
            solicitar_correo
            ;;
        2)
            echo "Saliendo..."
            exit 0
            ;;
        *)
            echo "Opción no válida. Intente nuevamente."
            ;;
    esac
done


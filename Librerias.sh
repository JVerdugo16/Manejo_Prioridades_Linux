#!/bin/bash

# Verificar si el usuario es root
if [ "$(id -u)" -ne 0 ]; then
  echo "Este script necesita ser ejecutado como root."
  exit 1
fi

# Función para actualizar el sistema e instalar sysstat y stress
actualizar_instalar_sysstat_stress() {
    # Actualizar lista de paquetes e instalar sysstat y stress
    echo "Actualizando lista de paquetes..."
    apt update

    # Actualizar paquetes existentes
    echo "Actualizando paquetes existentes..."
    apt upgrade -y

    # Instalar sysstat y stress
    echo "Instalando sysstat y stress..."
    apt install -y sysstat stress
}

# Función para instalar y configurar postfix
instalar_configurar_postfix() {
    # Actualizar el sistema
    echo "Actualizando el sistema..."
    apt-get update
    apt-get upgrade -y

    # Instalar postfix y otros paquetes necesarios
    echo "Instalando postfix, mailutils, libsasl2-2, ca-certificates, libsasl2-modules..."
    apt-get install -y postfix mailutils libsasl2-2 ca-certificates libsasl2-modules

    # Editar el archivo de configuración main.cf de postfix
    echo "Editando /etc/postfix/main.cf..."
    cat <<EOF >/etc/postfix/main.cf
# Configuración para relay a smtp.gmail.com
relayhost = [smtp.gmail.com]:587
smtp_sasl_auth_enable = yes
smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
smtp_sasl_security_options = noanonymous
smtp_tls_CApath = /etc/ssl/certs
smtpd_tls_CApath = /etc/ssl/certs
smtp_use_tls = yes
smtp_tls_CAfile = /etc/ssl/certs/ca-certificates.crt
EOF

    # Solicitar correo electrónico y contraseña
    read -p "Ingresa tu dirección de correo electrónico (usuario@gmail.com): " correo
    read -s -p "Ingresa tu contraseña o token de aplicación para Gmail: " passcode
    echo ""

    # Crear el archivo sasl_passwd y configurarlo
    echo "Creando y configurando /etc/postfix/sasl_passwd..."
    echo "[smtp.gmail.com]:587    $correo:$passcode" > /etc/postfix/sasl_passwd

    # Actualizar postfix con la nueva configuración
    echo "Actualizando postfix con la nueva configuración..."
    postmap /etc/postfix/sasl_passwd

    # Cambiar permisos del archivo sasl_passwd y sasl_passwd.db
    echo "Cambiando permisos de /etc/postfix/sasl_passwd y sasl_passwd.db..."
    chown root:root /etc/postfix/sasl_passwd /etc/postfix/sasl_passwd.db
    chmod 400 /etc/postfix/sasl_passwd /etc/postfix/sasl_passwd.db

    # Reiniciar el servicio postfix
    echo "Reiniciando el servicio postfix..."
    /etc/init.d/postfix reload

    echo "Instalación y configuración de postfix completadas."
}

# Ejecutar todas las acciones
actualizar_instalar_sysstat_stress
instalar_configurar_postfix

exit 0


# Manejo Prioridades Linux
## Proyecto Final

## Pasos para correr el script

### Paso 1: Instalar Servicio de correo Gmail en Linux

#### Paso 1.1 - Habilitar Gmail

Primero lo primero, hay que habilitar Gmail para poder utilizarlo como servicio de correo para Postfix:

- Habilitar la autenticación de dos factores.
- Generar un passcode para nuestro servicio.

#### Paso 1.2 - Instalar y configurar el software

Actualizar el sistema y cambiarse a root para ejecutar los siguientes comandos:

```bash
sudo su
apt-get update
apt-get upgrade
```
Instalar los paquetes de software necesarios:
```bash
apt-get install postfix mailutils libsasl2-2
apt-get install ca-certificates libsasl2-modules
```
Editar el archivo de configuración de postfix /etc/postfix/main.cf y reemplazar su contenido con las siguientes líneas:
```bash
cd /etc/postfix/
nano main.cf
```
```bash
    relayhost = [smtp.gmail.com]:587
	smtp_sasl_auth_enable = yes
	smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
	smtp_sasl_security_options = noanonymous
	smtp_tls_CApath = /etc/ssl/certs
	smtpd_tls_CApath = /etc/ssl/certs
	smtp_use_tls = yes
	smtp_tls_CAfile = /etc/ssl/certs/ca-certificates.crt
```
Crear el achivo /etc/postfix/sasl_passwd el cual contendrá nuestro passcode generado en la parte 1:
```bash
nano /etc/postfix/sasl_passwd
	[smtp.gmail.com]:587    usuario@gmail.com:passcode
```
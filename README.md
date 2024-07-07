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
Posteriormente hay que indicarle a postfix que utilice este archivo y lo encripte, lo cual generará un archivo adicional con terminación .db
```bash
postmap /etc/postfix/sasl_passwd
```
Ahora debemos cambiarle los permisos y para que solo root puede acceder a ellos:
```bash
chown root.root /etc/postfix/sasl_passwd*
chmod 400 /etc/postfix/sasl_passwd
```
Por último reiniciamos el servicio con:
```bash
/etc/init.d/postfix reload
```
Para probar que este funcionando correctamente usamos el siguiente comando:

```bash
echo "Prueba" | mail -s "Asunto" correo
```
### PASO 2: Descargar el archivo "monitoreo_cpu.sh".

### PASO 3: Abrir la consola de Linux y correr como super usuario con el siguiente comando:
```bash
 sudo ./monitoreo_cpu.sh &
```
### PASO 4: Revisar su correo.

### PASO 5: Para crear la gráfica del consumo del CPU descargamos el archivo "generar_grafica.sh" y lo corremos:
```bash
chmod +x generar_grafica.sh
sudo ./generar_grafica.sh
```	
La grafica se creara en la misma ubicación del archivo "generar_grafica.sh".
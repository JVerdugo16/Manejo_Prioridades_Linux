# Manejo Prioridades Linux
## Proyecto Final

## Pasos para correr el script

### Paso 1: Instalar Servicio de correo Gmail en Linux

#### Paso 1.1 - Habilitar Gmail

Primero lo primero, hay que habilitar Gmail para poder utilizarlo como servicio de correo para Postfix:

- Habilitar la autenticación de dos factores.
- Generar un passcode para nuestro servicio.

#### Paso 1.2 - Instalar y configurar el software

Descargar el archivo "Librerias.sh", en nuestra consola de Linux nos dirigimos al usuario root

```bash
sudo su
```
Una vez en el usuario root, nos dirigimos a la carpeta donde se encuentra el archivo "Librerias.sh" y le damos permiso de ejecución
```bash
chmod +x Librerias.sh
```
Finalmente ejecutamos el script
```bash
./Librerias.sh
```

Para probar que esté funcionando correctamente usamos el siguiente comando:

```bash
echo "Prueba" | mail -s "Asunto" correo
```
### Paso 2: Descargar los archivos "Manejo_prioridades.sh" y "monitoreo_cpu.sh".
Regresamos a nuestro usuario principal y nos dirigimos donde descargamos los archivos y damos permisos de ejecución.
```bash
chmod +x Manejo_prioridades.sh
chmod +x monitoreo_cpu.sh
```
### Paso 3: Ejecutar el script "Manejo_prioridades.sh"
```bash
./Manejo_prioridades.sh
```
Al momento de la ejecución encontraremos un menú principal en donde tendremos que ingresar el correo a donde recibiremos los mensajes.

### Paso 4: Revisar su correo.

### Paso 5: Para crear la gráfica del consumo del CPU descargamos el archivo "generar_grafica.sh" y lo corremos:
```bash
chmod +x generar_grafica.sh
sudo ./generar_grafica.sh
```	
La grafica se creará en la misma ubicación del archivo "generar_grafica.sh".

##### Nota: Se recomiendo tener todos los archivos en la misma carpeta.
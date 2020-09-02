# Capturador de handshakes
Herramienta grafica desarrollada en Processing para hacer mas practica y comoda la captura de handshakes en redes WPA/WPA2.

### Instalacion
Primero es requerido instalar Java, Xterm y Aircrack-ng.
```sh
$ sudo apt-get update
$ sudo apt install default-jre
$ sudo apt xterm
$ sudo apt install aircrack-ng
```
Acorde a la arquitectura de su sistema descargue la version de 32 o 64 bits.
- [Version de 32 bits](https://github.com/Ariel65536/CapturadorHandshakes/raw/master/bin/Capturador-32bits.zip)
- [Version de 64 bits](https://github.com/Ariel65536/CapturadorHandshakes/raw/master/bin/Capturador-64bits.zip)

```sh
$ wget https://raw.githubusercontent.com/Ariel65536/CapturadorHandshakes/master/bin/Capturador-32bits.zip
$ wget https://raw.githubusercontent.com/Ariel65536/CapturadorHandshakes/master/bin/Capturador-64bits.zip
``` 

Por ultimo utilice UnZip para extraer los archivos
```sh
$ unzip Capturador-32bits.zip
$ unzip Capturador-64bits.zip
``` 

### Ejecucion
Dirijase a la carpeta que acaba de extraer y ejecute la aplicacion con
```sh
$ sudo sh CapturadorHandshakes
``` 

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
 ```sh
$ wget https://raw.githubusercontent.com/Ariel65536/CapturadorHandshakes/master/bin/Capturador-32bits.zip
``` 

- [Version de 64 bits](https://github.com/Ariel65536/CapturadorHandshakes/raw/master/bin/Capturador-64bits.zip)

```sh
$ wget https://raw.githubusercontent.com/Ariel65536/CapturadorHandshakes/master/bin/Capturador-64bits.zip
``` 

Por ultimo utilice UnZip para extraer los archivos dependiendo de su version.
```sh
$ unzip Capturador-32bits.zip
``` 
```sh
$ unzip Capturador-64bits.zip
``` 

### Ejecucion
Dirijase a la carpeta que acaba de extraer y ejecute la aplicacion.
```sh
$ sudo sh CapturadorHandshakes
``` 

### Como usar
Al ejecutar por primera vez la aplicacion comenzará a buscar adaptadores de red (USB o integrado).
![Build Status](https://github.com/Ariel65536/CapturadorHandshakes/raw/master/Imagenes/PantallaPrincipal1.png)
Al activar el modo 5Ghz el adaptador de red solo buscara redes 5GHz y la funcion para desautenticar usuario no funcionara correctamente

-

Una vez que haya detectado al menos un adaptador, seleccionamos el que vamos a usar
![Build Status](https://github.com/Ariel65536/CapturadorHandshakes/raw/master/Imagenes/PantallaPrincipal2.png)

-

Iniciamos la busqueda de routers activando "Escanear redes" (se ejecutara una ventana Xterm con Airodump)
![Build Status](https://github.com/Ariel65536/CapturadorHandshakes/raw/master/Imagenes/PantallaRouters1.png)

-

En la lista se puede ver el nombre del router, la cantidad de dispositivos conectados (Celulares, televisiones, notebooks, etc) , el nivel de señal del router (en dB) y los minutos de inactividad (minutos que transcurrieron desde la ultima vez que Airodump capturo algun paquete proveniente de ese router)

![Build Status](https://github.com/Ariel65536/CapturadorHandshakes/raw/master/Imagenes/PantallaRouters2.png)

"Ocultar inactivos" oculta de la lista los routers con un periodo de inactividad superior a los 5 minutos.
El boton Resetear borra los datos sobre los routers obtenidos en la sesion actual.

-

Con el paso del tiempo Airodump comenzara a descubrir los dispositivos conectados a un router (si es que los hay), que son necesarios para poder capturar un WPA handshake
Seleccionamos el router "Ariel" para intentar capturar un handshake

![Build Status](https://github.com/Ariel65536/CapturadorHandshakes/raw/master/Imagenes/PantallaRouters3.png)

-

Veremos la pantalla de clientes conectados al router y una informacion extra como la cantidad de paquetes que hayan enviado y la señal de los mismos. (Tambien veremos que se abre una ventana de Xterm con Airodump en el router seleccionado)

En esta pantalla podemos simplemente esperar a que algun dispositivo se reconecte por si solo al router y que Airodump capture en ese momento el handshake.
Tambien podemos acelerar el proceso haciendo uso de Aireplay, una herramienta capaz de desconectar al dispositivo del router obligando al mismo a reconectarse y permitiendo a Airodump capturar el handshake
![Build Status](https://github.com/Ariel65536/CapturadorHandshakes/raw/master/Imagenes/PantallaClientes1.png)

-

En esta pantalla podemos desautenticar a un cliente especifico que seleccionemos, o activar "Auto Desauth" para desautenticar a los usuarios de forma automatica cada cierto intervalo que indiquemos con el deslizador
(En el momento de desautenticar a un usuario se abrira una ventana de Xterm ejecutando Aireplay y la misma se cerrara al finalizar el envio de paquetes de desautenticacion)
![Build Status](https://github.com/Ariel65536/CapturadorHandshakes/raw/master/Imagenes/PantallaClientes2.png)

-

Si Airodump logra capturar un handshake con exito veremos esta pantalla.
El Handshake se guarda en la carpeta de la aplicacion Capturadora-32bits/Handshakes/ con formato .cap
Una vez que el handshake es capturado, se guarda en un registro para recordarnos que el handshake de ese router ya lo tenemos en ./handshakes/

![Build Status](https://github.com/Ariel65536/CapturadorHandshakes/raw/master/Imagenes/PantallaClientes3.png)

-

Si volvemos a la pantalla anterior veremos que tambien nos muestra que el handshake ya fue capturado
![Build Status](https://github.com/Ariel65536/CapturadorHandshakes/raw/master/Imagenes/PantallaRouters4.png)

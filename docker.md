# Conceptos básicos

## Qué es docker?

Docker es un sistema de gestión de imágenes ("ISO"s de SO, software) para una fácil instalación y gestión de las mismas

## De qué conceptos principales se nutre?

Docker se compone principalmente de:

- Imágenes: "ISO"s que disponen de un SO o software (fuente principal, https://hub.docker.com/)
- Contenedores: Imágenes en ejecución después de haberles aplicado (o no) ciertas acciones que necesitemos
- Volúmenes: "carpetas" compartidas entre el contenedor y la máquina local
- Redes: Los contenedores se crean dentro de una red de Docker (su propia LAN). En casos básicos basta con la configuración por defecto. 

## Hands on: ejemplo básico

>fichero Dockerfile
```
FROM nginx
```
En este fichero le decimos que vamos a utlizar la ISO de nginx que hay en el hub de docker

>Creación de imagen local
```
docker build -t my_local_image . 
```
Esto nos crea una simple imagen local que tiene como base nginx

>Creación de contenedor (imagen en ejecución)
```
docker run -p 80:80 my_local_image
```

Listo, ya disponemos de un servidor nginx ejecutando en local. 

## Creación de una imagen local un poco más personalizada
Obviamente, para cualquier proyectom necesitaremos hacer modificaciones sobre la ISO de nginx del hub para adaptarla a nuestras necesidades. Esto se hace desde el fichero Dockerfile. Por ejemplo:
```
#descarga la iso del nginx
FROM nginx 

#ejecutame un comando. En este caso, instalar vi
RUN apt-get install vi 

#copia de un sitio web en local hacia la imagen 
COPY path_de_mi_sitio_web_en_local /var/www/html
```
Si hacemos un build & run de este Dockerfile, tendremos un servidor web que dispone de vi, con un sitio web que tenemos en local.

#El fichero Dockerfile, la base de todo
A continuación mostramos las opciones más utilizadas en Dockerfile:
```
#load image from docker hub (se le puede especificar una versión en concreto, el tag)
FROM $image[:$tag] [as $alias_for_dockerfile]
#Ejemplo: FROM php:7.2
#Si se ponen dos FROM en el mismo fichero, solo se utilizará el ultimo. Docker no creará imagenes de las anteriores. Es util para crear una maquina temporal y aprovecharla para ciertas cosas en los siguientes FROM

#comandos a aplicar a la ISO durante el proceso de generación de la imagen (build)
#Cada uno de estos "RUN" se llaman "capa" de la imagen
RUN $command
#Ejemplo: RUN echo "hello world"
#Si cambiamos alguno de los "RUN" del Dockerfile, hara que al hacer un "build" se genere una nueva imagen. La anterior pasará a llamarse "none"

#Ejecutar un comando cuando el container se está geenerando (durante el "run")
CMD $command
#ejemplo: CMD echo "Estoy listo!"
#Solo podemos tener uno por ISO, así que podemos hacer un COPY de un .sh desde nuestro local a la imagen, y luego con CMD ejecutarlo

#copiar ficheros desde local hacia el container. Se puede utilizar un fichero .dockerignore para omitir carpetas o ficheros
COPY/ADD $origen destino ($origen por defecto trabaja con maquina local, con --from=$alias_for_dockerfile delante se selecciona otra imagen)
La diferencia entre COPY y ADD es que copy es lo mismo que 'ADD' but without the tar and remote url handling
#crear variables de entorno dentro del contenedor
ENV $variable $valor

#cambiar el directorio de trabajo actual (durante el build) para facilitar el trabajo
WORKDIR $ruta_de_la_imagen

#exponer un puerto de la imagen
EXPOSE $puerto

#metadata de la imagen
LABEL variable=valor

#cambiar el usuario que ejecuta los comandos que van a continuación., por defecto root (para saber el actual: RUN echo "$(whoami)" > /var/www/html/user.html )
USER $usuario_de_la_maquina

#directorios persistentes cuando un container se pare. Explicación detallada más adelante.
VOLUME $ruta_container
```

#Volumenes (VOLUME)
- Host: ($local_path:$container_path) contenido mapeado de la maquina local 

- Anonymous: ($container_path) docker crea una carpeta dentro de su path de la maquina local. Si la maquina no se elimina con -v, el volumen se conserva

- Named Volumes: docker volume create $volumen_name. luego se trata como en host $volumen_name:/$container_path. Lo mismo que el anterior, pero con un determinado. con -v NO se elimina, a diferencia de los anteriores


#Redes
Los contenedores trabajan sobre redes (por defecto se trabaja sobre la red "bridge")
>visualizar la red docker instalada en nuestra máquina
```
ip a | grep docker
```
Resultado:

docker0: .... inet $ip

Al crear un container asigna una ip dentro del rango de ips de la inet de docker

Existe la red "host", que es la de la maquina local. Podemos asignar a un container esta red, usa todos los settings de red de la local (incluso ip)

existe la red "none"

#Docker Compose: Facilitando la creación y comunicación de contenedores

Todo lo anterior nos ha servido para entender como funciona docker. Ahora veremos como utilizar docker-compose para hacer mucho más facil la gestión

##docker-compose.yml
Este fichero nos proporciona información de cada uno de los contenedores y qué características tendrán.

Referencia completa en https://docs.docker.com/compose/compose-file/
```
#version de docker-compose
version: '3'

#services == containers
services:

  #nombre del servicio para usos internos
  nginx:
    #nombre de la imagen que se va a generar (-t del docker build)
    image: nginx_image
    #como es una imagen custom (no de docker hub directamente), tenemos que especificarle como hacer el build
    #opciones del "docker build"
    build:
      #carpeta del Dockerfile
      context: nginx
      #por si queremos poer otro nombre diferente de dockerfile
      dockerfile: Dockerfile

    #nombre del contenedor (--name del docker run)
    container_name: nginx_container
    
    #-p del docker run
    ports:
      - "80:80"

    #volume del Dockerfile
    volumes:
      - /var/www/immigration/:/var/www/immigration/
      
     #CMD del Dockerfile
     command: $command
     
     #reiniciarlo si por algun motivo se para
     restart: always
     
     #servicios de los cuales depende
     depends_on:
        - database
        
```
>Compilar (solo en caso que tengamos servicios con imagenes custom (con builds) dentro del docker-compose)
```
docker-compose build
```
>Ejecutar
```
docker-compose 
    [-p $nombre_del_proyecto]
    [-f $fichero_compose]
    up -d
```

##variables de entorno
>En yml
```
services:
    web:
        environment:     
            - variable=valor
```
>En fichero externo

```
services:
    web:
        env_file: $env_file_path
```
##Tipos de volumenes
>Host 
services:
    web:
        volumes:
            $local_path:$container_path
>Volumen por nombre
```
services:
    web:
        volumes:
            - $vol_name:$container_path
volumes:
    $vol_name:
```

##Redes
```
services:
    web:
        networks:
            - $network_name
networks:
    $network_name:
```





#Comandos principales de consola

>Ayuda en general
```
docker --help
docker $comando --help
docker $comando $acccion --help
```

##imágenes
>construir imagen a partir del dockerfile
```
docker build -t $nombre_imagen[:$tag] [-f $dockerfile] . 
```

>listado de imagenes creadas
```
docker images
```

>eliminar imagen
```
docker rmi $imagen
```
>eliminar imagenes con tag "none"
```
docker rmi $(docker images -f "dangling=true" -q)
```

>descargar imagen del hub
```
docker pull $imagen
```

>saber el historico de capas (RUNs) de una imagen
```
docker history -H $imagen 
```

##contenedores
>ejecutar imagen para crear contenedor
```
docker run 
	[-d (background)]
	[--rm (al entrar sin el -d, al salir del container se destruye)]
	[-p $puerto_local:$puerto_container]
	[-e variable_entorno=valor]
	[-v $carpeta_local:$carpeta_container]
	[--name $nombre_custom_contenedor]
	$nombre_imagen
	[$command]
```
si ejecutamos sin "-d", entra al contenedor directamente. Al salir, el container muere.

>entrar en un contenedor
```
docker exec -ti (terminal interactiva) [-u $usuario_maquina] $nombre_container bash
```

>lanzar un comando y ver el posible output
```
docker exec $container bash -c "$comando"
```

>listar contenedores
```
docker ps (solo en ejecucion, -a para todos)
```
>listar outputs de un container al runnearlo
```
docker logs $container_name
```
>informacion de un contenedor
```
docker inspect $contenedor
```
>re/levantar contenedor
```
docker re/start $contenedor
```

>parar contenedor
```
docker stop $container_name
```

>borrar contenedor
```
docker rm -fv $NAME (sacado desde el ps)
```

>renombrar contenedor
```
docker rename $nombre $nuevo_nombre
```

>copiar un fichero al container desde maquina local (o viceversa)
```
docker cp $file $container_name:$container_path
```

>exportar container a imagen
```
docker commit $nombre_contenedor $imagen_destino
```
si tenemos volumenes (especificado en el dockerfile) no conservaran el contenido en la imagen

##Redes
>listar todas las networks de docker
```
docker network ls
```

>crear red
```
docker network create test-network
    [--subnet $ip/$range]
    [--gateway $ip (.1 de la subnet)]
```

>asignar una red determinada a un contenedor
```
docker run 
    [--network $nombre-network]
    [--ip $ip_deseada]
```

>saber qué red tiene asignada un contenedor
```
docker inspect $contenedor
```

En las redes personalizadas, los containers si pueden verse por nombre de container, en la network por defecto no
```
root@container1> ping container2
OK
```
>conectar un container a una red distinta a la suya. La red se añade al container, no sobreescribe la actual
```
docker network connect $red $container
```
>desasociar network
```
docker network disconnect $red $container
```


#soft de gestion de dbs
robo3t

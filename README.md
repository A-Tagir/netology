#
Домашнее задание к занятию 4 «Оркестрация группой Docker контейнеров на примере Docker Compose»
#
Задание 1
#
* Создаю виртуальную машину Linux Ubuntu в Hyper-V и устанавливаю докер:
apt install docker-ce
systemctl status docker
apt-get install docker-compose-plugin
docker compose version
Docker Compose version v2.32.1
* зарегистрировался на докерхаб и создал публичный репозиторий с именем "custom-nginx"
[docker hub](https://hub.docker.com/repository/docker/atagir/custom-nginx/general)
* скачал образ nginx:1.21.1
  docker pull nginx:1.21.1
* Создал Dockerfile и заменил дефолтную индекс страницу 
[Dockerfile](https://github.com/A-Tagir/netology/blob/main/Dockerfile)
* собрал образ 
  docker build . -f Dockerfile --tag nginx:1.0.0
* отправил в докерхаб:
docker push atagir/custom-nginx:1.0.0
[docker image](https://hub.docker.com/repository/docker/atagir/custom-nginx/general)
#
Задание 2
#
* Запустил образ custom-nginx:1.0.0 согласно требованиям
  docker run -d -p 8080:80 --name ATG-custom-nginx-t2 atagir/custom-nginx:1.0.0  
* Переименовал
  docker rename ATG-custom-nginx-t2 custom-nginx-t2
* Вызвал curl 127.0.0.1:8080
![curl ok](https://github.com/A-Tagir/netology/blob/main/Homework4_custom-nginx.jpg)
#
Задание 3
#
* Подключение к стандартному потоку ввода/вывода/ошибок осуществляется командой
docker attach custom-nginx-t2

Если после подключения нажать Ctrl-c, то в контейнер будет отправлен сигнал SIGKILL
и основной процесс 1 контейнера завершится, контейнер остановится, если контейнер
не был запущен с ключем -t.
![container stopped](https://github.com/A-Tagir/netology/blob/main/Homework4_custom-nginx_attach_stop.jpg)

Чтобы предотвратить такое поведение можно запустить

docker attach custom-nginx-t2 --sig-proxy=false

в таком режиме сигналы не будут передаваться в контейнер.
Отсоединиться можно трижды нажав Ctrl-c.
Также если запустить контейнер с ключем -t то при нажатии Ctrl-c трижды консоль будет
отключаться не останавливая контейнер.
![container not stopped](https://github.com/A-Tagir/netology/blob/main/Homework4_custom-nginx_attach_not_stopped.jpg)

* Далее перезапустил контейнер и установил mc
  apt install mc
  отредактировал конфиг nginx заменив порт "listen 80" на "listen 81"
  nginx -s reload
![nginx on 81](https://github.com/A-Tagir/netology/blob/main/Homework4_custom-nginx_1.jpg)

  Видим, что замена порта в конфиге nginx с 80 на 81 приводит к тому, что веб-сервер становится
  недоступен снаружи контейнера, поскольку наружу контейнера порт 81 не открыт
  (это не задано в Dockerfile или при запуске).

  Чтобы это исправить не пересобирая образ, останавливаем контейнер,
заходим в /var/lib/docker/ и меняем конфигурацию контейнера в двух конфигах:
(ExposedPorts и PortBindings 80->81).
Далее нужно сделать service docker restart (перезапуск демона docker)
Далее запускаем контейнер и убеждаемся, что вэб-сервер снова доступен. Если не перезапустить 
докер, и запустить сразу контейнер то конфиги перезапишутся старыми вариантами.
На практике править вручную конфиги думаю строит.
docker ps показывает что контейнер теперь пробросил 81 порт на 8080.
Теперь удаляем работающий контейнер

docker -rm -f custom-nginx-t2

docker ps -a показывает что все удалено:

![nginx on 81 to 8080 removed](https://github.com/A-Tagir/netology/blob/main/Homework4_custom-nginx_2.jpg)
#
Задание 4
#
* Запускаю первый контейнер из образа centos
* 
docker run -dt --name centos1 -v $(pwd):/data centos /bin/bash

* Запускаю второй контейнер из образа centos
  docker run -dt --name centos2 -v $(pwd):/data centos /bin/bash
* Заходим в первый контейнер и создаем файл Solution4
  docker exec -it centos1 /bin/bash
  
  cd data

  echo 'Test netology Solution 4' > Solution4

  exit

* Заходим во второй контейнер
  docker exec -it centos2 /bin/bash
  cd data
  ls
Видим что новый файл здесь тоже доступен:
![centos 1,2](https://github.com/A-Tagir/netology/blob/main/Homework4_CENTOS_volume.jpg)

#
Задание 5
#
* Создал согласно заданию файлы compose.yaml и docker-compose.yaml
  запустил командой
  docker compose up -d
* запустился файл compose.yaml поскольку, согласно документации,
это канонический и предпочитаемый вариант. Второй вариант именования тоже допустим,
но при наличии нескольких будет выбран канонический вариант.
* Далее в файл compose.yaml сделал include
  include:
    - docker-compose.yaml
и теперь запустятся сервисы из обоих файлов.
![compose up](https://github.com/A-Tagir/netology/blob/main/Homework4_Compose_1.jpg)

* Далее в созданный registry деплоим образ custom-nginx как custom-nginx:latest
  docker tag custom-nginx:latest localhost:5000/atagir/custom-nginx
docker tag atagir/custom-nginx localhost:5000/custom-nginx:latest
docker tag custom-nginx:latest localhost:5000/custom-nginx:1.0.0
docker tag atagir/custom-nginx:latest localhost:5000/custom-nginx:1.0.0
docker tag --help
docker tag atagir/custom-nginx:1.0.0 localhost:5000/custom-nginx:latest
docker push localhost:5000/custom-nginx:latest
https://127.0.0.1:9000
links https://127.0.0.1:9000
* Далее делаю настройку portainer и деплою следующий компоуз:

version: '3'

services:
  nginx:
    image: 127.0.0.1:5000/custom-nginx
    ports:
      - "9090:80"
* теперь делаю inspect:
![portiner inspect](https://github.com/A-Tagir/netology/blob/main/Homework4_Portainer6.jpg)

* теперь согласно заданию удаляю файла compose.yaml и делаю
  
  docker compose up -d
  
  и получаю сообщение, что есть контейнеры для которых нет описания в compose конфиге.
  Запускаю команду 
  
  docker compose up -d --remove-orphans
  
  и контейнер не описанный в yaml файле удаляется.
  
  далее оставновил проект командой 
  
  docker compose down

![remove_orphaned](https://github.com/A-Tagir/netology/blob/main/Homework4_Compose7.jpg)

Чтобы остановить одной командой сразу

 docker compose down --remove-orphans

Это удалит контейнеры которые не описаны с yaml файле и остановит проект.



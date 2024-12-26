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
*Подключение к стандартному потоку ввода/вывода/ошибок осуществляется командой
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
#
Задание 4
#

 
* Пункт 10 Ответ: Замена порта в конфиге nginx с 80 на 81 приводит к тому, что веб-сервер становится 
недоступен снаружи контейнера, поскольку наружу контейнера порт 81 не открыт
(это не задано в Dockerfile или при запуске).

* Пункт 11 Ответ: Чтобы это исправить не пересобирая образ, останавливаем контейнер,
заходим в /var/lib/docker/ и меняем конфигурацию контейнера в двух конфигах 
(ExposedPorts и PortBindings 80->81).
Далее нужно сделать service docker restart (перезапуск демона docker)
Далее запускаем контейнер и убеждаемся, что вэб-сервер снова доступен. Если не перезапустить 
докер, и запустить сразу контейнер то конфиги перезапишутся старыми вариантами.
На практике править вручную конфиги не строит?

#Решение задача 5 введение в докер

* пункт 1: Ответ: запустился файл compose.yaml поскольку, согласно документации,
это канонический и предпочитаемый вариант. Второй вариант именования тоже допустим,
но при наличии нескольких будет выбран канонический вариант.

* пункт 7: Ответ: После удаления файла compose.yaml в проекте появился контейнер которого нет
в манифесте. Предлагается запустить команду повторно, что удалит конейнер, который не описан в манифесте.
что я и сделал. Далее оставновил проект командой docker compose down

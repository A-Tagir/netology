# netology
Netology homeworks
Задача 2:

- высоконагруженная база данных MySql, критичная к отказу
  Здесь подойдет либо физический сервер либо виртуализация уровня OS (например PROXMOX LXC, поскольку можно организовать прямой
  проброс дискового хранилища и организовать отказоусточивый кластер при небольших потерях производительности на host oS).
  Физический сервер будет незначительно быстрей, но сложность разворачивания и поддержки будет выше.
  Я бы выбрал виртуализацию уровня OS, как баланс между скоростью и доступностью, а также легкостью разворачивания управления.
  
- различные web-приложения
  здесь подойдет виртуализация уровня OS (Docker) поскольку этот инструмент разработан для этой цели.
  
- Windows-системы для использования бухгалтерским отделом;
  здесь подойдет физический сервер либо паравиртуализация (необходимость проброса лицензионных ключей, возможная привязка
  лицензий к оборудованию, а также в зависимости от необходимого количества хостов.

- системы, выполняющие высокопроизводительные расчёты на GPU
  Физический сервер (если это один сервер и один заказчик) либо паравиртуализация, когда можно пробросить GPU в виртуальную
  машину(например, если физический сервер не только выполняет расчеты на GPU, но еще и другие задачи).
  
Задача 3:

- 100 виртуальных машин на базе Linux и Windows, общие задачи, нет особых требований. Преимущественно Windows based-инфраструктура,
  требуется реализация программных балансировщиков нагрузки, репликации данных и автоматизированного механизма создания резервных копий.
  
Здесь подойдет Hyper-V от Microsoft как нативная для систем Windows, либо VMWare ESXi. Выбор следует делать из бюджета и 
имеющихся специалистов. Кроме того, можно использовать бесплатную версию PROXMOX.  VMWare ESXi обладает максимальным количеством поддерживаемой оперативной памяти 24TB.
В данном случае без особых требований можно обойтись гипервизором PROXMOX, бесплатный, имеется и кластеризация и балансировка нагрузки и репликация данных и резервное копирование.

- Требуется наиболее производительное бесплатное open source-решение для виртуализации небольшой (20-30 серверов) инфраструктуры на базе Linux и Windows виртуальных машин.

- Необходимо бесплатное, максимально совместимое и производительное решение для виртуализации Windows-инфраструктуры.
  Я выберу Hyper V как бесплатный и максимально совместимый продукт с системами Windows.

- Необходимо рабочее окружение для тестирования программного продукта на нескольких дистрибутивах Linux.
Я думаю здесь подойдет PROXMOX поскольку я умею с ним работать и в нем есть все что нужно в данной ситуации.

Задача 4

Опишите возможные проблемы и недостатки гетерогенной среды виртуализации 
(использования нескольких систем управления виртуализацией одновременно) и 
что необходимо сделать для минимизации этих рисков и проблем. 
Если бы у вас был выбор, создавали бы вы гетерогенную среду или нет?

При использовании гетерогенной среды могут возникнуть следующие проблемы:
1. Необходимость иметь специалиста для каждой среды управление (гипервизора) либо самому глубоко разбираться в тонкостях
   работы двух система. Это может быть затратно и неэффективно (но может быть интересно для учебных целей) 
3. Отсуствие возможности миграции между разными гипервизорами. Необходимость мониторинга разных систем.
4. Необходимо больше физических серверов.
   ЧТобы избежать подобных проблем стоит выбрать гипервизор, который будет универсальной платформой, поддерживающей все
   необходимые программные продукты, которые использует компания. Это реально.
   Я бы не создавал гетерогенную среду для продакшена. 




  
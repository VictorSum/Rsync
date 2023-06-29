# Домашнее задание к занятию "`Резервное копирование`"
# `Островский Евгений`


### Инструкция по выполнению домашнего задания

   1. Сделайте `fork` данного репозитория к себе в Github и переименуйте его по названию или номеру занятия, например, https://github.com/имя-вашего-репозитория/git-hw или  https://github.com/имя-вашего-репозитория/7-1-ansible-hw).
   2. Выполните клонирование данного репозитория к себе на ПК с помощью команды `git clone`.
   3. Выполните домашнее задание и заполните у себя локально этот файл README.md:
      - впишите вверху название занятия и вашу фамилию и имя
      - в каждом задании добавьте решение в требуемом виде (текст/код/скриншоты/ссылка)
      - для корректного добавления скриншотов воспользуйтесь [инструкцией "Как вставить скриншот в шаблон с решением](https://github.com/netology-code/sys-pattern-homework/blob/main/screen-instruction.md)
      - при оформлении используйте возможности языка разметки md (коротко об этом можно посмотреть в [инструкции  по MarkDown](https://github.com/netology-code/sys-pattern-homework/blob/main/md-instruction.md))
   4. После завершения работы над домашним заданием сделайте коммит (`git commit -m "comment"`) и отправьте его на Github (`git push origin`);
   5. Для проверки домашнего задания преподавателем в личном кабинете прикрепите и отправьте ссылку на решение в виде md-файла в вашем Github.
   6. Любые вопросы по выполнению заданий спрашивайте в чате учебной группы и/или в разделе “Вопросы по заданию” в личном кабинете.
   
Желаем успехов в выполнении домашнего задания!
   
### Дополнительные материалы, которые могут быть полезны для выполнения задания

1. [Руководство по оформлению Markdown файлов](https://gist.github.com/Jekins/2bf2d0638163f1294637#Code)

---

### Задание 1

- Составьте команду rsync, которая позволяет создавать зеркальную копию домашней директории пользователя в директорию /tmp/backup
- Необходимо исключить из синхронизации все директории, начинающиеся с точки (скрытые)
- Необходимо сделать так, чтобы rsync подсчитывал хэш-суммы для всех файлов, даже если их время модификации и размер идентичны в источнике и приемнике.
- На проверку направить скриншот с командой и результатом ее выполнения

```
rsync -ac --delete --exclude=".*/" . /tmp/backup
```

![rsync1](https://github.com/joos-net/Rsync/blob/main/file/1.png)


---

### Задание 2

- Написать скрипт и настроить задачу на регулярное резервное копирование домашней директории пользователя с помощью rsync и cron.
- Резервная копия должна быть полностью зеркальной
- Резервная копия должна создаваться раз в день, в системном логе должна появляться запись об успешном или неуспешном выполнении операции
- Резервная копия размещается локально, в директории /tmp/backup
- На проверку направить файл crontab и скриншот с результатом работы утилиты.

```
rsync -a --delete /home/joos/ /tmp/backup

if [ "$?" -eq 0 ]; then
        logger "Backup successfully"
else    logger "Backup failed"
fi
```
```
0 * * * * /home/joos/rsync.sh
```

![rsync1](https://github.com/joos-net/Rsync/blob/main/file/2.png)


---
## Дополнительные задания (со звездочкой*)

Эти задания дополнительные (не обязательные к выполнению) и никак не повлияют на получение вами зачета по этому домашнему заданию. Вы можете их выполнить, если хотите глубже и/или шире разобраться в материале.

### Задание 3

- Настройте ограничение на используемую пропускную способность rsync до 1 Мбит/c
- Проверьте настройку, синхронизируя большой файл между двумя серверами
- На проверку направьте команду и результат ее выполнения в виде скриншота

```
rsync -a --progress --bwlimit=1000 ttt joos@10.103.7.68:/tmp/ttt
```

![rsync1](https://github.com/joos-net/Rsync/blob/main/file/3.png)

### Задание 4

- Напишите скрипт, который будет производить инкрементное резервное копирование домашней директории пользователя с помощью rsync на другой сервер
- Скрипт должен удалять старые резервные копии (сохранять только последние 5 штук)
- Напишите скрипт управления резервными копиями, в нем можно выбрать резервную копию и данные восстановятся к состоянию на момент создания данной резервной копии.
- На проверку направьте скрипт и скриншоты, демонстрирующие его работу в различных сценариях.

backup.sh
```
#!/bin/bash
srv_user=joos
srv_ip=10.103.7.20
rsync -avz --progress --delete $srv_user@$srv_ip:/home/joos/ /tmp/current/ --backup --backup-dir=/tmp/increment/`date +%Y-%m-%d-%H-%M`/

cd /tmp/increment/
ls -t | tail -n +6 | xargs rm -rf --
```
restore.sh
```
#!/bin/bash
n=1
for file in /tmp/increment/*; do
    echo "$n - $(basename "$file")"
    ((n++))
done

read -p "Write number to restore (1-5): " x

m=1
for file in /tmp/increment/*; do
    if [ "$m" -le "$x" ]; then
        rsync -avz $file/ joos@10.103.7.20:/home/joos/
    fi
    ((m++))
done
```

![rsync1](https://github.com/joos-net/Rsync/blob/main/file/1restore.png)

![rsync1](https://github.com/joos-net/Rsync/blob/main/file/2backup.png)

![rsync1](https://github.com/joos-net/Rsync/blob/main/file/3ok.png)
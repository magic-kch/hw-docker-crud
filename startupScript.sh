#!/bin/bash


# Меняем владельца директории данных
chown -R postgres:postgres /var/lib/postgresql/data

# Инициализируем директорию данных
su - postgres -c "/usr/lib/postgresql/17/bin/initdb -D /var/lib/postgresql/17/main"


# Запускаем сервер PostgreSQL под пользователем postgres
su - postgres -c "/usr/lib/postgresql/17/bin/postgres -D /var/lib/postgresql/17/main &"

# Ждем несколько секунд, чтобы сервер запустился
sleep 2

# Создаем базу данных
su - postgres -c "/usr/lib/postgresql/17/bin/createdb netology_stocks_products"

# Выполняем другие команды
python3 manage.py migrate
python3 manage.py collectstatic --noinput
gunicorn -b 0.0.0.0:80 -w 3 stocks_products.wsgi:application 

wait
FROM postgres:latest

# Установка переменных окружения
ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=postgres
ENV POSTGRES_DB=netology_stocks_products

# Открытие порта
# EXPOSE 5432

# Том для сохранения данных
VOLUME ["/var/lib/postgresql/data"]

# # Запускаем сервер Postgres
# RUN service postgres start

# Установка Python
RUN apt-get update && apt-get install -y python3 python3-pip

ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

WORKDIR /stocks_products_app/

# # Устанавливаем зависимости
# RUN python3 -m pip install -r requirements.txt
RUN apt-get update && apt-get install -y python3-venv && rm -rf /var/lib/apt/lists/*
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
COPY requirements.txt .
RUN /opt/venv/bin/pip install -r requirements.txt

# Копируем проект
COPY . /stocks_products_app/

# # Запускаем миграции
# RUN python3 manage.py migrate

# # Сборка статики
# RUN python3 manage.py collectstatic --noinput
EXPOSE 5432

# Открытие порта
EXPOSE 80

RUN chmod +x /stocks_products_app/startupScript.sh

# Запускаем скрипт после запуска сервера Postgres
CMD [ "/stocks_products_app/startupScript.sh" ]
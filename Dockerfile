FROM ubuntu:22.04

# Обновляем пакеты
RUN apt update

# Копируем deb-файл (любой версии)
COPY matrix-app_*.deb /tmp/app.deb

# Устанавливаем пакет
RUN apt install -y /tmp/app.deb

# Запуск программы
ENTRYPOINT ["matrix_app"]
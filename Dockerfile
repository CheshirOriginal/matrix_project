FROM ubuntu:24.04

# отключаем интерактивные вопросы apt
ENV DEBIAN_FRONTEND=noninteractive

# устанавливаем зависимости
RUN apt update && apt install -y \
    python3 \
    python3-pip

# устанавливаем prometheus библиотеку
RUN pip3 install prometheus-client --break-system-packages

# Копируем deb-файл (любой версии)
COPY matrix-app_*.deb /tmp/app.deb
COPY server/server.py /tmp/server.py

# Устанавливаем пакет
RUN apt install -y /tmp/app.deb

# порт для Kubernetes и Docker
EXPOSE 8080

# запуск сервера
CMD ["python3", "/tmp/server.py"]
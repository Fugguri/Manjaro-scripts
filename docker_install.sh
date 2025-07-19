#!/bin/bash

# Провека запуска с sudo
if [ "$EUID" -ne 0 ]; then
  echo "Запустите скрипт от root или с помощью sudo"
  exit 1
fi

USER_NAME=${SUDO_USER:-$(whoami)}

echo "Устанавливаем Docker и Docker Compose..."

# Обновляем пакеты и устанавливаем docker + docker-compose
pacman -Sy --noconfirm docker docker-compose python-pip

# Запускаем и включаем автоматический старт Docker
systemctl start docker.service
systemctl enable docker.service

# Добавляем пользователя в группу docker для работы без sudo
usermod -aG docker $USER_NAME

# Обновляем pip и устанавливаем docker-compose через pip (опционально, для стабильности)
sudo -u $USER_NAME pip install --user --upgrade docker-compose

echo "Установка завершена."

#echo "Пожалуйста, выполните выход и повторный вход в систему или выполните:"
#echo "  newgrp docker"
newgrp docker
#echo "чтобы изменения вступили в силу."

echo "Проверяем Docker:"
sudo -u $USER_NAME docker run --rm hello-world

echo "Проверяем Docker Compose:"
sudo -u $USER_NAME docker-compose --version

echo "Готово! Теперь вы можете пользоваться Docker и Docker Compose без sudo."

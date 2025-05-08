#!/bin/bash

# Скрипт для Manjaro: установка alacritty, tmux, htop, zsh и установка zsh как оболочки по умолчанию

# Обновляем базу пакетов
sudo pacman -Syu --noconfirm

# Устанавливаем необходимые пакеты
sudo pacman -S --noconfirm alacritty tmux htop zsh git github-cli fzf 

# Проверяем, установлен ли zsh
if ! command -v zsh &> /dev/null; then
  echo "Ошибка: zsh не установлен."
  exit 1
fi

# Устанавливаем zsh как оболочку по умолчанию для текущего пользователя
chsh -s $(which zsh)

echo "Установка завершена. Перезайдите в систему или откройте новый терминал, чтобы использовать zsh по умолчанию."


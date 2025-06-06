#!/bin/bash

# Скрипт для автоматического добавления исполняемого файла в ~/bin и настройки PATH
# Использование: ./install_to_bin.sh /путь/к/вашему_файлу

set -e

# Проверка аргумента
if [ -z "$1" ]; then
    echo "Использование: $0 /путь/к/исполняемому_файлу"
    exit 1
fi

SRC="$1"
BASENAME="$(basename "$SRC")"
TARGET="$HOME/bin/$BASENAME"

# Создать ~/bin, если не существует
mkdir -p "$HOME/bin"

# Копировать файл в ~/bin
cp "$SRC" "$TARGET"

# Сделать файл исполняемым
chmod +x "$TARGET"

# Проверить, есть ли ~/bin в PATH
if ! echo "$PATH" | grep -q "$HOME/bin" ; then
    # Добавить экспорт в .bashrc, если его нет
    if ! grep -q 'export PATH="$HOME/bin:$PATH"' "$HOME/.bashrc" ; then
        echo 'export PATH="$HOME/bin:$PATH"' >> "$HOME/.bashrc"
        echo "Добавлена строка 'export PATH=\"\$HOME/bin:\$PATH\"' в ~/.bashrc"
    fi
    # Применить изменения сразу
    export PATH="$HOME/bin:$PATH"
    echo "PATH обновлён для текущей сессии"
fi

echo "Файл $BASENAME установлен в ~/bin и доступен из любой директории."


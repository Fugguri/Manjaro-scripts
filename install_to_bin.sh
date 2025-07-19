#!/bin/bash

# Скрипт для автоматического добавления исполняемого файла в ~/bin
# и настройки PATH для bash и zsh

set -e

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

# Добавить ~/bin в PATH в .bashrc, если его там нет
#if [ -f "$HOME/.bashrc" ]; then
#    if ! grep -q 'export PATH="\$HOME/bin:\$PATH"' "$HOME/.bashrc"; then
#        echo '' >> "$HOME/.bashrc"
#        echo '# Добавлено автоматически для доступа к ~/bin' >> "$HOME/.bashrc"
#        echo 'if [[ ":$PATH:" != *":$HOME/bin:"* ]]; then' >> "$HOME/.bashrc"
#        echo '  export PATH="$HOME/bin:$PATH"' >> "$HOME/.bashrc"
#        echo 'fi' >> "$HOME/.bashrc"
#        echo "Добавлена строка для ~/bin в ~/.bashrc"
#    fi
#fi

# Добавить ~/bin в PATH в .zshrc, если его там нет
if [ -f "$HOME/.zshrc" ]; then
    if ! grep -q 'path=(\$HOME/bin $path)' "$HOME/.zshrc" && ! grep -q 'path+=("\$HOME/bin")' "$HOME/.zshrc" && ! grep -q 'export PATH="\$HOME/bin:\$PATH"' "$HOME/.zshrc"; then
        echo '' >> "$HOME/.zshrc"
        echo '# Добавлено автоматически для доступа к ~/bin' >> "$HOME/.zshrc"
        echo 'if [[ ":$PATH:" != *":$HOME/bin:"* ]]; then' >> "$HOME/.zshrc"
        echo '  path=("$HOME/bin" $path)' >> "$HOME/.zshrc"
        echo '  export PATH' >> "$HOME/.zshrc"
        echo 'fi' >> "$HOME/.zshrc"
        echo "Добавлена строка для ~/bin в ~/.zshrc"
    fi
fi

# Применить изменения к текущей сессии
#if [ "$SHELL" = "/bin/zsh" ] || [ "$SHELL" = "/usr/bin/zsh" ]; then
#    source "$HOME/.zshrc"
#elif [ "$SHELL" = "/bin/bash" ] || [ "$SHELL" = "/usr/bin/bash" ]; then
#    source "$HOME/.bashrc"
#fi

echo "Файл $BASENAME установлен в ~/bin и доступен из любой директории."


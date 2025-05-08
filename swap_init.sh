#!/bin/bash

# Скрипт автоматически находит все swap-разделы и подключает их,
# а также добавляет в /etc/fstab запись по UUID для автоподключения.

# Требуется запуск с правами root
if [ "$EUID" -ne 0 ]; then
  echo "Запустите скрипт с правами root (sudo)." >&2
  exit 1
fi

# Получаем список swap-разделов (тип partition и тип swap)
# blkid выводит все разделы с их типами, фильтруем по TYPE="swap"
SWAP_PARTS=$(blkid -t TYPE=swap -o device)

if [ -z "$SWAP_PARTS" ]; then
  echo "Swap-разделы не найдены."
  exit 1
fi

echo "Найдены swap-разделы:"
echo "$SWAP_PARTS"

for PART in $SWAP_PARTS; do
  echo "Обрабатываем $PART..."

  # Активируем swap-раздел
  swapon "$PART" 2>/dev/null || echo "Swap $PART уже активен или ошибка при подключении."

  # Получаем UUID раздела
  UUID=$(blkid -s UUID -o value "$PART")
  if [ -z "$UUID" ]; then
    echo "Не удалось получить UUID для $PART, пропускаем."
    continue
  fi

  # Проверяем, есть ли уже запись в /etc/fstab
  if grep -q "$UUID" /etc/fstab; then
    echo "Запись для $PART уже есть в /etc/fstab"
  else
    echo "Добавляем запись swap в /etc/fstab..."
    echo "UUID=$UUID none swap defaults 0 0" >> /etc/fstab
  fi
done

echo "Готово! Все найденные swap-разделы активированы и добавлены в автозагрузку."
echo "Текущий swap:"
swapon --show


# Как работать над проектом

## Один раз после клонирования
1. Запусти tools\hooks\install.bat. Это хуки, которые сами решают конфликты в картах (.dmm) и иконках (.dmi).
2. Убедись, что проект собирается: Ctrl+F7 в DM IDE (или tools\build\build.bat).

## Правила
- В main напрямую не пушим. Всё идёт через Pull Request.
- Одна задача = одна ветка = один небольшой PR. Ветка живёт день-два.
- Название ветки: feature/что-делаем, fix/что-чиним, chore/прочее.
- В локальный main ничего не коммитим, только обновляем его.
- Перед тем как взять общий файл (например _job.dm, vanderlin.dme), напиши в чат.
- Не форматируем и не переименовываем чужие файлы без согласования.
- Не коммитим .dmb, .rsc, собранные бандлы TGUI, node_modules.
- Сливаем PR кнопкой Squash and merge, потом удаляем ветку.

## Рабочий цикл (команды по порядку)
    git switch main
    git pull --ff-only
    git switch -c feature/название

    git add -A
    git commit -m "Что сделано"

    git fetch origin
    git rebase origin/main
    git push -u origin feature/название

Дальше: Pull Request на GitHub, второй человек смотрит, Squash and merge.
После слияния:

    git switch main
    git pull --ff-only
    git branch -d feature/название

## Конфликты
- git status покажет конфликтные файлы. Открой их, убери маркеры <<<<<<<, =======, >>>>>>>.
- Самый частый случай: vanderlin.dme, когда оба добавили #include рядом. Оставь обе строки.
- Затем git add <файл> и git rebase --continue. Если запутался: git rebase --abort.
- Никогда не делай git push --force в main и в чужие ветки.

## Перед деплоем
- main должен компилироваться. Деплой запускаем только после слияния PR.
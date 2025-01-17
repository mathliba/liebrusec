# liebrusec
Ваша Флибуста через Ваш телеграм

Это интеграция программы Libruks — [library russian books (библиотека русских книг)](https://libruks.wordpress.com) и телеграммного бота. Вы ставите питон, запускаете бота telegabot.py, прописываете программе-посреднику l.liebrusec/project1.exe пути к базе Libruks'a, которая находится у вас на компьютере - и теперь по поисковому запросу и номеру книги бот перешлет вам в телегу желаемое.

Как пример - https://t.me/moskva_kreml_leninu_bot, если он не спит.

Например, на запрос <br>
__lrs@Мандельброт@Фракт__ <br>
где через собак идет часть имени автора@часть названия книги он отреагирует сообщением - <br>
_№660448: Мандельброт Бенуа(1). Фрактальная геометрия природы_ <br>
После этого по запросу <br>
__lrs$660448__ <br>
Он пришлет искомое. <br>

Так же этим ботом реализован доступ к библиотеке колхоза, только запрос целиком на оглавление и не разбит на две части - имени и названия, например - <br>
__kx3@ Клайн__ <br>
чтобы найти <br>
_№13620 - Клайн М. Математика. Поиск истины (Мир 1988)(ru)(K)(600dpi)(T)(294s)_MPop_.djvu_ <br>
и т.д.

Здесь пока выложена только либрусековская часть. Она состоит из двух чатей - 

1\) liebrusec/projext1.exe - Программа-посредник между ботом и libruks'ом. Написана на [Лазарусе](https://lazarus-ide.org) <br>
Ее запускает бот, она отдает ему найденную в архивах libruks'а книгу.

В её файле настроек liebrusec/inits.txt три строки - 

> f:\lib\Libruks\Архивы Либрусек\ <br>
> F:\lib\Libruks\Libruks\Data\Библиотека Либрусек для архивов 17-03-2024.db<br>
> c:\lazarus\components\mathliba\l.liebrusec\files\

Это - 

1.1 путь к libruks'u,<br>
1.2 путь к его базе данных,<br>
1.3 путь для распаковки

Установка - это простое копирование в каталог c:\lazarus\components\mathliba\l.liebrusec\

2\) Сам телеграммный бот написан под питон 3.8.9

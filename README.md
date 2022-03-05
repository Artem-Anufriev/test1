# test1
Задание 1
Напишите приложение для мобильных устройств.
1. Устройство iPhone, только портретная ориентация.
2. Минимальная поддерживаемая версия iOS: iOS 12.0
3. Язык программирования Swift: последней версии
4. Необходимо реализовать метод загрузки картинки в ячейку таблицы.
a. Сигнатура метода: func downloadImage(withURL url: URL, forCell cell: UITableViewCell)
b. Таблица должна выводить список из 100 картинок.
c. Ссылка на картинку формируется так: ​http://placehold.it/375x150?text={​index}, где
index - порядковый номер ячейки (например, ​http://placehold.it/375x150?text=1,​
http://placehold.it/375x150?text=2,​и т.д).
5. В данной задаче з​апрещается​использовать сторонние библиотеки.
6. Для загрузки изображения необходимо использовать ​URLSession.​

Отзыв от 65apps:
- Нет выраженной структуры проекта; сервисы, контроллеры, ячейки – все в одной куче.
- Константы в коде - исправлено
- public func downloadImage и внутри func getData - исправлено
- Не выполнено требование "Устройство iPhone, только портретная ориентация" - исправлено
- Нет кэширования сетевых данных – картинки перезапрашиваются каждый раз - исправлено
- Нет остановки загрузки когда ячейка уходит с экрана.
Или
- Нет обработки ситуации когда поздно пришедший ответ должен игнорироваться - исправлено

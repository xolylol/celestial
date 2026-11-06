
-- Celestial | single-file source.lua
-- Repository: https://github.com/xolylol/celestial
-- Run:
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/xolylol/celestial/main/source.lua"))()
-- All UI library code and module configuration are embedded below.

local Config = (function()
-- Auto-generated module list (visual only, no logic)
return {
	Combat = {
		{ Name = "Anti Bot", Desc = "Детектит НПС/ботов от античита", Settings = {
			{ Type = "Mode", Name = "Режим", Default = "Matrix", Options = {"Matrix", "ReallyWorld"} },
		} },
		{ Name = "Attack Aura", Desc = "Автоматически бьет окружающих вас существ", Settings = {
			{ Type = "Mode", Name = "Сортировка", Default = "Умная", Options = {"Умная", "Поле зрения", "Дистанция", "Здоровье"} },
			{ Type = "Mode", Name = "Режим", Default = "Funtime", Options = {"Funtime", "Matrix", "Snap", "SpookyTime"} },
			{ Type = "Mode", Name = "Обход спринта", Default = "Funtime", Options = {"Funtime", "Legit"} },
			{ Type = "Mode", Name = "Режим", Default = "Незаметный", Options = {"Незаметный", "Строгий", "Таргет", "Свободный"} },
			{ Type = "Toggle", Name = "Таргетить если у цели лук, арбалет или трезубец", Default = false },
			{ Type = "Toggle", Name = "Заходить за спину цели", Default = true },
			{ Type = "Slider", Name = "Дистанция за спиной", Default = 1, Min = 0.5, Max = 2.5, Step = 0.1 },
			{ Type = "Slider", Name = "Дистанция удара", Default = 3, Min = 1, Max = 6, Step = 0.1 },
			{ Type = "Slider", Name = "Дистанция наводки", Default = 0, Min = 0, Max = 32, Step = 0.5 },
			{ Type = "Toggle", Name = "Только криты", Default = true },
			{ Type = "Toggle", Name = "Только с пробелом", Default = false },
			{ Type = "Toggle", Name = "Останавливать при использовании предмета", Default = false },
			{ Type = "Toggle", Name = "Останавливать при открытом контейнере", Default = false },
			{ Type = "Toggle", Name = "Бить через щит", Default = true },
			{ Type = "Toggle", Name = "Бить через стены", Default = true },
			{ Type = "Toggle", Name = "Дистанция под Grim", Default = false },
			{ Type = "Toggle", Name = "Убирать интерполяцию у энтити", Default = false },
			{ Type = "Toggle", Name = "Убирать взаимодействие с блоками и энтити", Default = true },
			{ Type = "Toggle", Name = "Ломать щит", Default = true },
			{ Type = "Toggle", Name = "Таргет-HUD", Default = true },
			{ Type = "Toggle", Name = "ESP", Default = true },
			{ Type = "Toggle", Name = "Silent", Default = true },
		} },
		{ Name = "Auto Explosion", Desc = "Автоматически взрывает кристалл после установки обсидиана", Settings = {
			{ Type = "Toggle", Name = "Смотреть на кристалл", Default = true },
			{ Type = "Toggle", Name = "Коррекция движения", Default = true },
		} },
		{ Name = "Auto GApple", Desc = "Автоматически ест золотое яблоко при определённом здоровье", Settings = {
			{ Type = "Slider", Name = "Здоровье", Default = 15, Min = 5, Max = 20, Step = 0.5 },
		} },
		{ Name = "Auto Pot", Desc = "Автоматически кидает зелья", Settings = {
			{ Type = "Toggle", Name = "Только в ПВП", Default = false },
			{ Type = "Toggle", Name = "Авто. выключение", Default = false },
			{ Type = "Toggle", Name = "Силу", Default = true },
		} },
		{ Name = "Auto Swap", Desc = "Автоматически меняет предмет в правой руке", Settings = {
			{ Type = "Mode", Name = "Режим", Default = "Умный", Options = {"Умный", "Бинд"} },
			{ Type = "Mode", Name = "Менять с", Default = "Щит", Options = {"Щит", "Гепл", "Шар", "Руна", "Сфера", "Тотем"} },
			{ Type = "Mode", Name = "Менять на", Default = "Гепл", Options = {"Гепл", "Щит", "Шар", "Руна", "Сфера", "Тотем"} },
			{ Type = "Bind", Name = "Клавиша свапа" },
			{ Type = "Slider", Name = "Здоровье", Default = 16.5, Min = 1, Max = 19.5, Step = 0.5 },
			{ Type = "Toggle", Name = "Проверять кристалл", Default = true },
		} },
		{ Name = "Auto Totem", Desc = "Автоматически берет тотем в руку", Settings = {
			{ Type = "Mode", Name = "Режим", Default = "Funtime", Options = {"Funtime", "Advanced"} },
			{ Type = "Toggle", Name = "Сохранять зачарованные", Default = true },
			{ Type = "Toggle", Name = "Не менять шар", Default = true },
			{ Type = "Slider", Name = "Здоровье", Default = 5, Min = 1, Max = 20, Step = 0.5 },
			{ Type = "Toggle", Name = "Счетчик тотемов", Default = true },
			{ Type = "Toggle", Name = "Кристалл", Default = true },
			{ Type = "Toggle", Name = "Обсидиан", Default = false },
			{ Type = "Toggle", Name = "Якорь", Default = false },
			{ Type = "Toggle", Name = "Динамит", Default = false },
			{ Type = "Toggle", Name = "Падение", Default = false },
		} },
		{ Name = "Bow Spam", Desc = "Позволяет быстро стрелять из лука", Settings = {
			{ Type = "Slider", Name = "Задержка", Default = 2, Min = 2, Max = 5, Step = 1 },
		} },
		{ Name = "Criticals", Desc = "Позволяет всегда бить критическами ударами", Settings = {
		} },
		{ Name = "Fast Swap", Desc = "Меняет предмет в основной руке", Settings = {
		} },
		{ Name = "Friend Protect", Desc = "Отменяет урон по друзьям", Settings = {
		} },
		{ Name = "Hitboxes", Desc = "Увеличивает хитбокс у энтити", Settings = {
			{ Type = "Slider", Name = "Размер", Default = 0.2, Min = 0.1, Max = 2, Step = 0.1 },
		} },
		{ Name = "Hit Sounds", Desc = "Воспроизводит звуки при ударе", Settings = {
			{ Type = "Mode", Name = "Выбор звука", Default = "UwU", Options = {"UwU", "Бонк", "Стоны", "Маркер"} },
			{ Type = "Slider", Name = "Питч звука", Default = 1, Min = 0.1, Max = 2, Step = 0.1 },
		} },
		{ Name = "Popka", Desc = ":D", Settings = {
		} },
		{ Name = "Super Bow", Desc = "Увеличивает урон с лука", Settings = {
			{ Type = "Slider", Name = "Сила выстрела", Default = 50, Min = 10, Max = 100, Step = 10 },
		} },
		{ Name = "Tape Mouse", Desc = "Автоматически нажимает левую или правую кнопку мыши", Settings = {
			{ Type = "Mode", Name = "Режим", Default = "ЛКМ", Options = {"ЛКМ", "ПКМ"} },
			{ Type = "Slider", Name = "Задержка в секундах", Default = 0.5, Min = 0, Max = 60, Step = 0.5 },
		} },
		{ Name = "Trigger Bot", Desc = "Автоматически бьет существо если оно на прицеле", Settings = {
			{ Type = "Mode", Name = "Обход спринта", Default = "Funtime", Options = {"Funtime", "Legit"} },
			{ Type = "Toggle", Name = "Только криты", Default = true },
			{ Type = "Toggle", Name = "Останавливать при использовании предмета", Default = false },
			{ Type = "Toggle", Name = "Останавливать при открытом контейнере", Default = false },
			{ Type = "Toggle", Name = "Только с пробелом", Default = false },
			{ Type = "Toggle", Name = "Таргет-HUD", Default = true },
		} },
		{ Name = "Velocity", Desc = "Редактирует ваше откидывание", Settings = {
			{ Type = "Mode", Name = "Режим", Default = "Vanilla", Options = {"Vanilla", "Custom", "Jump", "JumpReset"} },
		} },
	},
	Movement = {
		{ Name = "Auto Sprint", Desc = "Автоматически включает спринт", Settings = {
			{ Type = "Toggle", Name = "Голод", Default = false },
			{ Type = "Toggle", Name = "Слепоту", Default = true },
			{ Type = "Toggle", Name = "Приседание", Default = true },
			{ Type = "Toggle", Name = "Ползание", Default = true },
			{ Type = "Toggle", Name = "Использование предметов", Default = true },
			{ Type = "Toggle", Name = "Горизонтальную коллизию", Default = true },
		} },
		{ Name = "Blocks Lift", Desc = "Позволяет подниматься в блоках", Settings = {
			{ Type = "Mode", Name = "Режим", Default = "Packet", Options = {"Packet", "Glide", "Matrix"} },
		} },
		{ Name = "Flight", Desc = "Позволяет летать без креатив режима", Settings = {
			{ Type = "Mode", Name = "Режим", Default = "Vanilla", Options = {"Vanilla", "���I�\\t�u�]\\u0006F�ڗ", "Jump"} },
			{ Type = "Slider", Name = "Скорость", Default = 2, Min = 0.5, Max = 10, Step = 0.1 },
			{ Type = "Slider", Name = "Скорость", Default = 1, Min = 0.6, Max = 5, Step = 0.1 },
		} },
		{ Name = "Keep Sprint", Desc = "Не дает сбросить спринт при ударе", Settings = {
			{ Type = "Mode", Name = "Режим", Default = "Vanilla", Options = {"Vanilla", "SpookyTime"} },
		} },
		{ Name = "No Slow", Desc = "Убирает замедление при использовании предмета", Settings = {
			{ Type = "Mode", Name = "Режим", Default = "Funtime", Options = {"Funtime", "SpookyTime", "ReallyWorld", "Vanilla"} },
		} },
		{ Name = "Speed", Desc = "Увеличивает скорость игрока", Settings = {
		} },
		{ Name = "Spider", Desc = "Позволяет взбираться по стенам", Settings = {
			{ Type = "Mode", Name = "Режим", Default = "Grim", Options = {"Grim", "Matrix", "Funtime"} },
		} },
		{ Name = "Strafe", Desc = "Позволяет не замедляться при движении в стороны", Settings = {
		} },
		{ Name = "Super Firework", Desc = "Увеличивает скорость при использовании фейерверка", Settings = {
			{ Type = "Slider", Name = "Скорость по XZ", Default = 1.6, Min = 1.5, Max = 2, Step = 0.01 },
			{ Type = "Slider", Name = "Скорость по Y", Default = 1.6, Min = 1.5, Max = 2, Step = 0.01 },
		} },
		{ Name = "Timer", Desc = "Ускоряет время игры", Settings = {
			{ Type = "Slider", Name = "Скорость", Default = 1.8, Min = 1.1, Max = 10, Step = 0.1 },
			{ Type = "Toggle", Name = "Умный режим", Default = true },
			{ Type = "Slider", Name = "Скорость убывания", Default = 1, Min = 0.5, Max = 3, Step = 0.1 },
			{ Type = "Slider", Name = "Добавлять в движении", Default = 0, Min = 0, Max = 1, Step = 0.05 },
		} },
		{ Name = "Water Speed", Desc = "Увеличивает скорость в воде", Settings = {
			{ Type = "Mode", Name = "Режим", Default = "Funtime", Options = {"Funtime", "Vulcan"} },
		} },
	},
	Render = {
		{ Name = "Array List", Desc = "Отображает список включенных модулей", Settings = {
			{ Type = "Toggle", Name = "Combat", Default = true },
			{ Type = "Toggle", Name = "Movement", Default = true },
			{ Type = "Toggle", Name = "Render", Default = false },
			{ Type = "Toggle", Name = "Player", Default = true },
			{ Type = "Toggle", Name = "Util", Default = true },
			{ Type = "Toggle", Name = "Свечение", Default = true },
			{ Type = "Toggle", Name = "Маленькие буквы", Default = false },
			{ Type = "Slider", Name = "Смещение", Default = 2, Min = 0, Max = 10, Step = 1 },
		} },
		{ Name = "Block ESP", Desc = "WallHack на блоки", Settings = {
			{ Type = "Toggle", Name = "Спавнера", Default = true },
			{ Type = "Toggle", Name = "Шалкеры", Default = false },
			{ Type = "Toggle", Name = "Сундуки", Default = false },
			{ Type = "Toggle", Name = "Бочки", Default = false },
			{ Type = "Toggle", Name = "Вагонетки", Default = false },
			{ Type = "Toggle", Name = "Диспенсеры", Default = false },
			{ Type = "Toggle", Name = "Подарки", Default = false },
			{ Type = "Color", Name = "Цвет спавнеров", Default = Color3.fromRGB(255, 0, 255) },
			{ Type = "Color", Name = "Цвет шалкеров", Default = Color3.fromRGB(255, 0, 255) },
			{ Type = "Color", Name = "Цвет сундуков", Default = Color3.fromRGB(255, 0, 255) },
			{ Type = "Color", Name = "Цвет бочек", Default = Color3.fromRGB(255, 0, 255) },
			{ Type = "Color", Name = "Цвет вагонеток", Default = Color3.fromRGB(255, 0, 255) },
			{ Type = "Color", Name = "Цвет диспенсеров", Default = Color3.fromRGB(255, 0, 255) },
			{ Type = "Color", Name = "Цвет подарков", Default = Color3.fromRGB(255, 0, 255) },
		} },
		{ Name = "China Hat", Desc = "Китайская шляпка над головой", Settings = {
		} },
		{ Name = "Crosshair", Desc = "Позволяет кастомизировать ваш прицел", Settings = {
			{ Type = "Color", Name = "Цвет прицела", Default = Color3.fromRGB(255, 0, 255) },
			{ Type = "Toggle", Name = "Подсветка энтити", Default = false },
			{ Type = "Color", Name = "Цвет подсветки", Default = Color3.fromRGB(255, 0, 255) },
			{ Type = "Toggle", Name = "Учитывать кулдаун", Default = false },
			{ Type = "Toggle", Name = "Точка по середине", Default = false },
			{ Type = "Slider", Name = "Радиус", Default = 0, Min = 0, Max = 6, Step = 0.5 },
			{ Type = "Slider", Name = "Длина", Default = 4, Min = 0.5, Max = 6, Step = 0.5 },
		} },
		{ Name = "2D ESP", Desc = "WallHack на сущностей", Settings = {
			{ Type = "Toggle", Name = "Бокс", Default = false },
			{ Type = "Toggle", Name = "Здоровье", Default = true },
			{ Type = "Toggle", Name = "Предмет", Default = true },
			{ Type = "Toggle", Name = "Неймтег", Default = true },
			{ Type = "Toggle", Name = "Пинг", Default = false },
			{ Type = "Toggle", Name = "Броню", Default = true },
			{ Type = "Toggle", Name = "Зачарования", Default = true },
			{ Type = "Toggle", Name = "Эффекты", Default = true },
			{ Type = "Toggle", Name = "Превью шалкера", Default = true },
			{ Type = "Slider", Name = "Ширина", Default = 1, Min = 0.5, Max = 2, Step = 0.5 },
		} },
		{ Name = "HUD", Desc = "Пользовательский интерфейс", Settings = {
			{ Type = "Toggle", Name = "Включено", Default = true },
			{ Type = "Toggle", Name = "Фпс", Default = true },
			{ Type = "Toggle", Name = "Бпс", Default = true },
			{ Type = "Toggle", Name = "Тпс", Default = true },
			{ Type = "Toggle", Name = "Координаты", Default = true },
			{ Type = "Toggle", Name = "Включено", Default = true },
			{ Type = "Toggle", Name = "Включено", Default = true },
			{ Type = "Toggle", Name = "Включено", Default = true },
			{ Type = "Toggle", Name = "Включено", Default = true },
			{ Type = "Toggle", Name = "Включено", Default = true },
			{ Type = "Toggle", Name = "Включено", Default = false },
			{ Type = "Toggle", Name = "Оптимизация", Default = false },
			{ Type = "Mode", Name = "Режим", Default = "Плавающий", Options = {"Плавающий", "Стандартный"} },
		} },
		{ Name = "Item Physics", Desc = "Реалистичная физика предметов", Settings = {
			{ Type = "Slider", Name = "Скорость вращения", Default = 5, Min = 2, Max = 7, Step = 0.1 },
		} },
		{ Name = "Jump Circles", Desc = "Добавляет анимацию прыжка под вами", Settings = {
			{ Type = "Slider", Name = "Радиус", Default = 1.5, Min = 1, Max = 2, Step = 0.1 },
			{ Type = "Slider", Name = "Радиус свечения", Default = 1, Min = 1, Max = 2, Step = 0.1 },
			{ Type = "Slider", Name = "Скорость", Default = 0.3, Min = 0.3, Max = 1, Step = 0.1 },
		} },
		{ Name = "No Render", Desc = "Убирает некоторые элементы игры", Settings = {
			{ Type = "Toggle", Name = "Эффект тотема", Default = true },
			{ Type = "Toggle", Name = "Игроков", Default = false },
			{ Type = "Toggle", Name = "Заголовки", Default = false },
			{ Type = "Toggle", Name = "Босс бар", Default = false },
			{ Type = "Toggle", Name = "Скорборд", Default = false },
			{ Type = "Toggle", Name = "Лаву/Воду", Default = false },
		} },
		{ Name = "Notifications", Desc = "Откладка о каких либо действиях", Settings = {
			{ Type = "Toggle", Name = "Включено", Default = true },
			{ Type = "Toggle", Name = "Включено", Default = false },
			{ Type = "Toggle", Name = "Вас", Default = false },
			{ Type = "Toggle", Name = "Друзей", Default = false },
			{ Type = "Toggle", Name = "Включено", Default = false },
			{ Type = "Toggle", Name = "Включено", Default = false },
			{ Type = "Toggle", Name = "Включено", Default = false },
			{ Type = "Toggle", Name = "Включено", Default = false },
			{ Type = "Toggle", Name = "Уведомлять об окончании важных эффектов", Default = true },
			{ Type = "Toggle", Name = "Воспроизводить звук", Default = true },
		} },
		{ Name = "Pointers", Desc = "Рисует стрелки к сущностям", Settings = {
			{ Type = "Mode", Name = "Режим", Default = "Клиентский", Options = {"Клиентский", "Индикатор"} },
			{ Type = "Color", Name = "Цвет друзей", Default = Color3.fromRGB(255, 0, 255) },
			{ Type = "Mode", Name = "Режим", Default = "Обычный", Options = {"Обычный", "Пиксельный"} },
			{ Type = "Toggle", Name = "Здоровье", Default = true },
			{ Type = "Toggle", Name = "Дистанцию", Default = true },
			{ Type = "Toggle", Name = "Ник", Default = true },
			{ Type = "Slider", Name = "Размер", Default = 7, Min = 5, Max = 10, Step = 1 },
			{ Type = "Slider", Name = "Радиус", Default = 100, Min = 50, Max = 150, Step = 5 },
			{ Type = "Toggle", Name = "Свечение", Default = true },
		} },
		{ Name = "Shulker Preview", Desc = "Отображает содержимое шалкера при наведении на него", Settings = {
			{ Type = "Bind", Name = "Открыть меню" },
		} },
		{ Name = "Staff Viewer", Desc = "Отображает активный персонал на сервере", Settings = {
			{ Type = "Toggle", Name = "Сообщать об изменении статуса персонала", Default = true },
		} },
		{ Name = "Structure Timer", Desc = "Отображает время действия трапок и пластов", Settings = {
		} },
		{ Name = "Swing Animations", Desc = "Изменяет положение предметов в руках", Settings = {
			{ Type = "Mode", Name = "Режим", Default = "Type 1", Options = {"Type 1", "Type 2", "Default"} },
			{ Type = "Toggle", Name = "Только с AttackAura", Default = false },
			{ Type = "Slider", Name = "Сила", Default = 70, Min = 10, Max = 100, Step = 10 },
			{ Type = "Slider", Name = "Скорость", Default = 7, Min = 1, Max = 10, Step = 1 },
			{ Type = "Slider", Name = "X координата", Default = 0, Min = -1.5, Max = 1.5, Step = 0.1 },
			{ Type = "Slider", Name = "Y координата", Default = 0, Min = -1.5, Max = 1.5, Step = 0.1 },
			{ Type = "Slider", Name = "Z координата", Default = 0, Min = -1.5, Max = 1.5, Step = 0.1 },
			{ Type = "Slider", Name = "X координата", Default = 0, Min = -1.5, Max = 1.5, Step = 0.1 },
			{ Type = "Slider", Name = "Y координата", Default = 0, Min = -1.5, Max = 1.5, Step = 0.1 },
			{ Type = "Slider", Name = "Z координата", Default = 0, Min = -1.5, Max = 1.5, Step = 0.1 },
		} },
		{ Name = "Time Changer", Desc = "Изменяет время суток", Settings = {
			{ Type = "Mode", Name = "Режим", Default = "Закат", Options = {"Закат", "День", "Ночь"} },
		} },
		{ Name = "Trails", Desc = "Оставляет след за вами", Settings = {
		} },
		{ Name = "Items Overlay", Desc = "Отображает полезные данные о предметах в инвентаре", Settings = {
		} },
	},
	Player = {
		{ Name = "Auto Use", Desc = "Автоматически использует предметы в нужный момент", Settings = {
		} },
		{ Name = "Blink", Desc = "Замедляет пакеты отправляемые на сервер", Settings = {
			{ Type = "Mode", Name = "Режим замедления", Default = "Normal", Options = {"Normal", "Delay"} },
			{ Type = "Slider", Name = "Длительность", Default = 0.5, Min = 0.1, Max = 5, Step = 0.1 },
			{ Type = "Toggle", Name = "Отображать настоящую позицию", Default = true },
		} },
		{ Name = "Gui Move", Desc = "Позволяет ходить в открытых контейнерах", Settings = {
			{ Type = "Mode", Name = "Режим", Default = "Advanced", Options = {"Advanced", "Funtime", "Vanilla"} },
			{ Type = "Toggle", Name = "Не в текстовых полях", Default = true },
		} },
		{ Name = "No Clip", Desc = "Позволяет проходить сквозь блоки", Settings = {
		} },
		{ Name = "Auto Exp", Desc = "Автоматически кидает пузырьки с опытом под ноги", Settings = {
			{ Type = "Bind", Name = "Кидать на" },
			{ Type = "Slider", Name = "Задержка", Default = 0, Min = 0, Max = 100, Step = 10 },
		} },
		{ Name = "Auto Leave", Desc = "Избегает определенных условий", Settings = {
			{ Type = "Toggle", Name = "Мало ХП", Default = true },
			{ Type = "Toggle", Name = "Рядом игрок", Default = false },
			{ Type = "Slider", Name = "Дистанция до игрока", Default = 128, Min = 10, Max = 128, Step = 5 },
			{ Type = "Toggle", Name = "Staff в сети", Default = false },
			{ Type = "Toggle", Name = "Staff в спеке", Default = false },
			{ Type = "Toggle", Name = "Бан в чате", Default = false },
			{ Type = "Mode", Name = "Метод лива", Default = "Отключение", Options = {"Отключение", "Перезаход", "Сообщение"} },
			{ Type = "Slider", Name = "Минут для перезахода", Default = 1, Min = 0.1, Max = 30, Step = 0.1 },
		} },
		{ Name = "Auto Reconnect", Desc = "Автоматически перезаходит на последний игровой режим", Settings = {
		} },
		{ Name = "Auto Respawn", Desc = "Автоматически респавнит вас после смерти", Settings = {
		} },
		{ Name = "Auto Tool", Desc = "Автоматически берет лучший инструмент для ломания блока", Settings = {
		} },
		{ Name = "Chest Stealer", Desc = "Автоматически забирает ресурсы из сундука", Settings = {
		} },
		{ Name = "Fast Break", Desc = "Позволяет ломать блоки быстрее", Settings = {
			{ Type = "Slider", Name = "Сила", Default = 0.4, Min = 0, Max = 1, Step = 0.1 },
			{ Type = "Slider", Name = "Задержка", Default = 0, Min = 0, Max = 5, Step = 1 },
			{ Type = "Toggle", Name = "Обход Grim", Default = false },
		} },
		{ Name = "Free Camera", Desc = "Позволяет летать в режиме наблюдателя", Settings = {
			{ Type = "Slider", Name = "Скорость", Default = 1.5, Min = 0.5, Max = 5, Step = 0.1 },
			{ Type = "Toggle", Name = "Выключать при дамаге", Default = false },
		} },
		{ Name = "Ghost Hand", Desc = "Позволяет взаимодействовать с контейнерами сквозь стены", Settings = {
		} },
		{ Name = "Items Delay", Desc = "Ставит задержку на предмет после его использования", Settings = {
			{ Type = "Toggle", Name = "Включено", Default = true },
			{ Type = "Toggle", Name = "Включено", Default = true },
			{ Type = "Toggle", Name = "Включено", Default = true },
			{ Type = "Toggle", Name = "Включено", Default = true },
			{ Type = "Toggle", Name = "Включено", Default = true },
			{ Type = "Toggle", Name = "Компенсировать задержку", Default = false },
			{ Type = "Toggle", Name = "Только в ПВП", Default = false },
		} },
		{ Name = "No Delay", Desc = "Убирает задержку на что-либо", Settings = {
			{ Type = "Toggle", Name = "Прыжок", Default = true },
			{ Type = "Toggle", Name = "ПКМ", Default = false },
		} },
		{ Name = "No Interact", Desc = "Не дает нажимать ПКМ по выбранным объектам", Settings = {
			{ Type = "Toggle", Name = "Все объекты", Default = false },
			{ Type = "Toggle", Name = "Игроки", Default = false },
			{ Type = "Toggle", Name = "Армор стенды", Default = true },
			{ Type = "Toggle", Name = "Сундуки", Default = false },
			{ Type = "Toggle", Name = "Бочки", Default = false },
			{ Type = "Toggle", Name = "Двери", Default = true },
			{ Type = "Toggle", Name = "Воронки", Default = true },
			{ Type = "Toggle", Name = "Кнопки", Default = true },
			{ Type = "Toggle", Name = "Раздатчики", Default = true },
			{ Type = "Toggle", Name = "Нотные блоки", Default = false },
			{ Type = "Toggle", Name = "Верстаки", Default = true },
			{ Type = "Toggle", Name = "Люки", Default = true },
			{ Type = "Toggle", Name = "Печки", Default = true },
			{ Type = "Toggle", Name = "Калитки", Default = true },
			{ Type = "Toggle", Name = "Наковальни", Default = false },
			{ Type = "Toggle", Name = "Рычаги", Default = false },
			{ Type = "Toggle", Name = "Только в ПВП", Default = false },
		} },
		{ Name = "No Push", Desc = "Игнорирует отталкивание от\\ чего-либо", Settings = {
			{ Type = "Toggle", Name = "Блоки", Default = true },
			{ Type = "Toggle", Name = "Сущности", Default = true },
			{ Type = "Toggle", Name = "Удочки", Default = true },
			{ Type = "Toggle", Name = "Воду", Default = false },
			{ Type = "Toggle", Name = "Пузыри", Default = false },
			{ Type = "Toggle", Name = "Границу", Default = false },
		} },
		{ Name = "Nuker", Desc = "Автоматически ломает блоки вокруг вас", Settings = {
			{ Type = "Toggle", Name = "Смотреть на блоки", Default = true },
			{ Type = "Slider", Name = "Радиус по XZ", Default = 3, Min = 1, Max = 6, Step = 1 },
			{ Type = "Slider", Name = "Радиус по Y", Default = 3, Min = 1, Max = 6, Step = 1 },
			{ Type = "Slider", Name = "Задержка", Default = 150, Min = 0, Max = 2000, Step = 10 },
			{ Type = "Toggle", Name = "Оптимизировать копание", Default = true },
		} },
		{ Name = "Projectile Helper", Desc = "Утилитарный модуль для снарядов и их оружия", Settings = {
			{ Type = "Toggle", Name = "Эндер пёрлы", Default = true },
			{ Type = "Toggle", Name = "Стрелы", Default = true },
			{ Type = "Toggle", Name = "Трезубцы", Default = true },
			{ Type = "Toggle", Name = "Зелья", Default = true },
			{ Type = "Toggle", Name = "Предметы", Default = false },
			{ Type = "Toggle", Name = "Автоматически стрелять если цель в зоне", Default = false },
			{ Type = "Toggle", Name = "Не давать отпустить если полностью не заряжен", Default = true },
			{ Type = "Toggle", Name = "Автоматически стрелять если цель в зоне", Default = false },
			{ Type = "Toggle", Name = "Автоматически отпускать при полном заряде", Default = false },
			{ Type = "Toggle", Name = "Не давать отпустить если полностью не заряжен", Default = true },
			{ Type = "Toggle", Name = "Автоматически стрелять если цель в зоне", Default = false },
			{ Type = "Slider", Name = "Сила натяжения", Default = 0.5, Min = 0.1, Max = 1, Step = 0.1 },
			{ Type = "Toggle", Name = "Не давать отпустить если не достаточно заряжен", Default = true },
			{ Type = "Slider", Name = "Размер хитбокса", Default = 0.3, Min = -0.2, Max = 0.3, Step = 0.01 },
		} },
		{ Name = "Streamer Mode", Desc = "Скрывает некоторые элементы игры", Settings = {
			{ Type = "Toggle", Name = "Скрывать свой", Default = true },
			{ Type = "Toggle", Name = "Скрывать друзей", Default = false },
			{ Type = "Toggle", Name = "Скрывать информацию", Default = false },
			{ Type = "Toggle", Name = "Скрывать анархию/гриф", Default = false },
			{ Type = "Toggle", Name = "Скрывать координаты", Default = false },
			{ Type = "Toggle", Name = "Режим ютубера", Default = false },
		} },
	},
	Util = {
		{ Name = "Auto Duel", Desc = "Автоматически находит дуэли", Settings = {
			{ Type = "Mode", Name = "Сервер", Default = "Funtime", Options = {"Funtime", "ReallyWorld"} },
		} },
		{ Name = "Auto Fish", Desc = "Автоматически ловит рыбу за вас", Settings = {
		} },
		{ Name = "Elytra Swap", Desc = "Автоматически переключает слот с нагрудником на элитру", Settings = {
			{ Type = "Bind", Name = "Клавиша свапа" },
			{ Type = "Bind", Name = "Клавиша фейерверка" },
			{ Type = "Toggle", Name = "Получил урон", Default = false },
			{ Type = "Toggle", Name = "Приземлился", Default = false },
			{ Type = "Toggle", Name = "Нанёс урон", Default = false },
			{ Type = "Toggle", Name = "Автоматический полёт", Default = true },
			{ Type = "Toggle", Name = "Запускать 1 фейерверк", Default = false },
			{ Type = "Toggle", Name = "Не работать в ПВП", Default = false },
		} },
		{ Name = "No Server Rots", Desc = "Убирает ротацию со стороны сервера", Settings = {
		} },
		{ Name = "Death Coords", Desc = "Отображает координаты вашей смерти", Settings = {
		} },
		{ Name = "Anti AFK", Desc = "Обходит сервера с проверкой на АФК", Settings = {
			{ Type = "Mode", Name = "Режим", Default = "Funtime", Options = {"Funtime", "Vanilla"} },
		} },
		{ Name = "Anti Shuffler", Desc = "Убирает переключение слотов античитом", Settings = {
		} },
		{ Name = "Auto Accept", Desc = "Автоматически принимает запросы на что-либо", Settings = {
		} },
		{ Name = "Auto Auth", Desc = "Автоматически регистрируется и авторизируется на сервере", Settings = {
		} },
		{ Name = "Auto Buy", Desc = "Утилитарный модуль для работы с аукционом", Settings = {
			{ Type = "Mode", Name = "Процесс", Default = "Покупающий", Options = {"Покупающий", "Проверяющий", "process"} },
		} },
		{ Name = "Base Finder", Desc = "Утилитарный модуль для поиска баз", Settings = {
			{ Type = "Toggle", Name = "Сундуки", Default = true },
			{ Type = "Toggle", Name = "Шалкера", Default = true },
			{ Type = "Toggle", Name = "Бочки", Default = true },
			{ Type = "Toggle", Name = "Наковальни", Default = false },
			{ Type = "Toggle", Name = "Столы зачарования", Default = false },
			{ Type = "Toggle", Name = "Печки", Default = false },
			{ Type = "Toggle", Name = "Избегать враждебных существ", Default = true },
		} },
		{ Name = "Casino", Desc = "Test", Settings = {
		} },
		{ Name = "Chat Helper", Desc = "Утилитарный модуль для чата", Settings = {
			{ Type = "Toggle", Name = "Call", Default = true },
			{ Type = "Toggle", Name = "Invsee", Default = true },
			{ Type = "Toggle", Name = "Ah", Default = false },
			{ Type = "Toggle", Name = "Duel", Default = false },
			{ Type = "Toggle", Name = "Сохранение истории", Default = false },
		} },
		{ Name = "Clan Upgrader", Desc = "Помогает в улучшении клана на Funtime", Settings = {
		} },
		{ Name = "Click Friend", Desc = "Добавляет или удаляет игрока из друзей на клавишу", Settings = {
			{ Type = "Bind", Name = "Клавиша" },
		} },
		{ Name = "Click Pearl", Desc = "Бросает эндер-пёрл на клавишу", Settings = {
			{ Type = "Mode", Name = "Режим", Default = "Vanilla", Options = {"Vanilla", "HolyWorld"} },
			{ Type = "Bind", Name = "Клавиша" },
		} },
		{ Name = "Creeper Farm", Desc = "Baritone для охоты на криперов", Settings = {
			{ Type = "Toggle", Name = "Автоматический прыжок", Default = true },
			{ Type = "Toggle", Name = "Атаковать одновременно несколько существ", Default = true },
			{ Type = "Toggle", Name = "Отключаться при полном инвентаре", Default = true },
			{ Type = "Toggle", Name = "Автоматический перезаход на режим", Default = true },
			{ Type = "Slider", Name = "Секунд для перезахода", Default = 60, Min = 10, Max = 600, Step = 5 },
		} },
		{ Name = "Event Parser", Desc = "Отслеживает появление событий и устанавливает путь к ним", Settings = {
			{ Type = "Mode", Name = "Режим", Default = "Автоматический", Options = {"Автоматический", "Ручной"} },
			{ Type = "Toggle", Name = "Автоматически удалять точку через время", Default = true },
			{ Type = "Slider", Name = "Минут для удаления", Default = 10, Min = 1, Max = 30, Step = 1 },
		} },
		{ Name = "Farm Builder", Desc = "Помогает в постройке фермы криперов", Settings = {
			{ Type = "Mode", Name = "Режим", Default = "Люки", Options = {"Люки", "Полублоки", "onChangeMode"} },
		} },
		{ Name = "FT Helper", Desc = "Утилитарный модуль для Funtime", Settings = {
			{ Type = "Toggle", Name = "Улучшать команды", Default = true },
			{ Type = "Toggle", Name = "Улучшать информацию о предметах на аукционе", Default = true },
			{ Type = "Toggle", Name = "Уведомлять когда на вас наложили плохие эффекты", Default = true },
			{ Type = "Toggle", Name = "Авто. перевыставление предметов в хранилище", Default = true },
			{ Type = "Toggle", Name = "Авто. инвестирование в клан", Default = false },
			{ Type = "Toggle", Name = "Авто. добавление друзей в регион", Default = false },
			{ Type = "Toggle", Name = "Позволять открывать шалкер внутри шалкера", Default = true },
			{ Type = "Toggle", Name = "Не ставить сферы", Default = false },
		} },
		{ Name = "Grief Joiner", Desc = "Помогает зайти на гриф сервера ReallyWorld", Settings = {
		} },
		{ Name = "HW Helper", Desc = "Утилитарный модуль для HolyWorld", Settings = {
		} },
		{ Name = "Item Scroller", Desc = "Позволяет быстро забирать или перекладывать предметы", Settings = {
			{ Type = "Slider", Name = "Задержка", Default = 0, Min = 0, Max = 100, Step = 10 },
		} },
		{ Name = "Leave Tracker", Desc = "Отслеживает позицию телепорта игроков", Settings = {
		} },
		{ Name = "Minecraft Optimizer", Desc = "Оптимизирует майнкрафт", Settings = {
			{ Type = "Toggle", Name = "Баннеры", Default = true },
			{ Type = "Toggle", Name = "Рамки", Default = false },
		} },
		{ Name = "Potion Tracker", Desc = "Отслеживает накладываемые зелья на игроков", Settings = {
		} },
		{ Name = "RW Helper", Desc = "Утилитарный модуль для ReallyWorld", Settings = {
			{ Type = "Toggle", Name = "Флай на драгоне", Default = true },
			{ Type = "Toggle", Name = "Закрытие меню", Default = true },
			{ Type = "Toggle", Name = "Не ставить шары", Default = true },
			{ Type = "Toggle", Name = "Авто. полёт", Default = true },
			{ Type = "Toggle", Name = "Авто. починка", Default = true },
			{ Type = "Toggle", Name = "Авто. исцеление", Default = true },
		} },
		{ Name = "SRP Spoofer", Desc = "Убирает ресурспак на серверах где это запрещено", Settings = {
		} },
		{ Name = "Test Func", Desc = "Test :)", Settings = {
		} },
		{ Name = "Totem Tracker", Desc = "Отслеживает снос тотемов", Settings = {
		} },
		{ Name = "Tps Sync", Desc = "Синхронизирует модули с тикрейтом сервера", Settings = {
		} },
		{ Name = "Use Tracker", Desc = "Отслеживает использование предметов", Settings = {
		} },
		{ Name = "X-Ray", Desc = "WallHack на блоки для серверов с сильным античитом", Settings = {
			{ Type = "Mode", Name = "Режим", Default = "Default", Options = {"Default", "Ancient"} },
			{ Type = "Slider", Name = "Радиус сканирования", Default = 16, Min = 6, Max = 64, Step = 1 },
			{ Type = "Slider", Name = "Скорость сканирования", Default = 20, Min = 1, Max = 30, Step = 1 },
		} },
	},
}
end)()

local Library = (function()
--!strict
-- CelestialUI: visual-only menu library (no features behind the controls).
-- ModuleScript. Usage: see Main.client.lua

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")

local Library = {}
Library.__index = Library

-- ===== Theme (taken from the original: purple gradient, dark panels, blur) =====
local Theme = {
	Accent1 = Color3.fromHex("#BE65FF"),
	Accent2 = Color3.fromHex("#3E1568"),
	Background = Color3.fromRGB(16, 14, 24),
	Sidebar = Color3.fromRGB(22, 19, 33),
	Module = Color3.fromRGB(28, 25, 41),
	ModuleHover = Color3.fromRGB(36, 32, 52),
	Setting = Color3.fromRGB(23, 20, 34),
	Text = Color3.fromRGB(235, 230, 245),
	SubText = Color3.fromRGB(150, 142, 170),
	Font = Enum.Font.Montserrat, -- if Cyrillic looks broken, try Enum.Font.SourceSans
	Radius = UDim.new(0, 8),
}

local CATEGORY_ORDER = { "Combat", "Movement", "Render", "Player", "Util" }
local CATEGORY_ICON = { -- emoji placeholders; replace with uploaded rbxassetid icons if you want
	Combat = "⚔", Movement = "➤", Render = "◉", Player = "☺", Util = "⚙",
}

local TWEEN = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- ===== helpers =====
local function create(class: string, props: { [string]: any }, children: { Instance }?): any
	local inst = Instance.new(class)
	for k, v in pairs(props) do
		(inst :: any)[k] = v
	end
	if children then
		for _, c in ipairs(children) do
			c.Parent = inst
		end
	end
	return inst
end

local function corner(r: number?): UICorner
	return create("UICorner", { CornerRadius = r and UDim.new(0, r) or Theme.Radius })
end

local function gradient(rot: number?): UIGradient
	return create("UIGradient", {
		Color = ColorSequence.new(Theme.Accent1, Theme.Accent2),
		Rotation = rot or 0,
	})
end

local function label(props: { [string]: any }): TextLabel
	local p = {
		BackgroundTransparency = 1,
		Font = Theme.Font,
		TextColor3 = Theme.Text,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
	}
	for k, v in pairs(props) do
		p[k] = v
	end
	return create("TextLabel", p)
end

local function tween(inst: Instance, props: { [string]: any }, info: TweenInfo?)
	TweenService:Create(inst, info or TWEEN, props):Play()
end

local function roundStep(v: number, step: number): number
	if step <= 0 then
		return v
	end
	return math.floor(v / step + 0.5) * step
end

local function fmt(v: number): string
	if v % 1 == 0 then
		return tostring(v)
	end
	return string.format("%.2f", v):gsub("0+$", ""):gsub("%.$", "")
end

-- ===== setting builders: each returns a Frame; ctx.set(value) reports changes =====
local SettingHeight = 28

local function newRow(parent: Instance, order: number): Frame
	return create("Frame", {
		BackgroundColor3 = Theme.Setting,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, SettingHeight),
		LayoutOrder = order,
		Parent = parent,
	})
end

local Builders: { [string]: (any, Instance, number, (any) -> ()) -> Frame } = {}

Builders.Toggle = function(def, parent, order, report)
	local row = newRow(parent, order)
	label({ Text = def.Name, Size = UDim2.new(1, -56, 1, 0), Position = UDim2.fromOffset(10, 0), Parent = row })
	local track = create("Frame", {
		BackgroundColor3 = Color3.fromRGB(48, 43, 66),
		Size = UDim2.fromOffset(32, 16),
		Position = UDim2.new(1, -42, 0.5, -8),
		Parent = row,
	}, { corner(8), gradient(0) })
	local g = track:FindFirstChildOfClass("UIGradient") :: UIGradient
	g.Enabled = false
	local knob = create("Frame", {
		BackgroundColor3 = Color3.new(1, 1, 1),
		Size = UDim2.fromOffset(12, 12),
		Position = UDim2.fromOffset(2, 2),
		Parent = track,
	}, { corner(6) })
	local state = def.Default == true
	local function apply(animate: boolean)
		g.Enabled = state
		track.BackgroundColor3 = state and Color3.new(1, 1, 1) or Color3.fromRGB(48, 43, 66)
		local pos = state and UDim2.fromOffset(18, 2) or UDim2.fromOffset(2, 2)
		if animate then
			tween(knob, { Position = pos })
		else
			knob.Position = pos
		end
	end
	apply(false)
	local btn = create("TextButton", { BackgroundTransparency = 1, Text = "", Size = UDim2.fromScale(1, 1), Parent = row })
	btn.MouseButton1Click:Connect(function()
		state = not state
		apply(true)
		report(state)
	end)
	return row
end

Builders.Slider = function(def, parent, order, report)
	local row = newRow(parent, order)
	row.Size = UDim2.new(1, 0, 0, 38)
	label({ Text = def.Name, Size = UDim2.new(1, -70, 0, 18), Position = UDim2.fromOffset(10, 3), Parent = row })
	local valueLabel = label({
		Size = UDim2.fromOffset(60, 18), Position = UDim2.new(1, -70, 0, 3),
		TextXAlignment = Enum.TextXAlignment.Right, TextColor3 = Theme.SubText, Parent = row,
	})
	local bar = create("Frame", {
		BackgroundColor3 = Color3.fromRGB(48, 43, 66),
		Size = UDim2.new(1, -20, 0, 5),
		Position = UDim2.new(0, 10, 1, -11),
		Parent = row,
	}, { corner(3) })
	local fill = create("Frame", { BackgroundColor3 = Color3.new(1, 1, 1), Size = UDim2.fromScale(0, 1), Parent = bar }, { corner(3), gradient(0) })
	local value: number = def.Default
	local function render(animate: boolean)
		local a = (value - def.Min) / (def.Max - def.Min)
		valueLabel.Text = fmt(value)
		if animate then
			fill.Size = UDim2.fromScale(a, 1)
		else
			fill.Size = UDim2.fromScale(a, 1)
		end
	end
	render(false)
	local dragging = false
	local function setFromX(x: number)
		local a = math.clamp((x - bar.AbsolutePosition.X) / math.max(bar.AbsoluteSize.X, 1), 0, 1)
		local v = math.clamp(roundStep(def.Min + (def.Max - def.Min) * a, def.Step or 0.1), def.Min, def.Max)
		if v ~= value then
			value = v
			render(true)
			report(value)
		end
	end
	bar.InputBegan:Connect(function(i: InputObject)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			setFromX(i.Position.X)
		end
	end)
	UserInputService.InputChanged:Connect(function(i: InputObject)
		if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			setFromX(i.Position.X)
		end
	end)
	UserInputService.InputEnded:Connect(function(i: InputObject)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
	return row
end

Builders.Mode = function(def, parent, order, report)
	local row = newRow(parent, order)
	label({ Text = def.Name, Size = UDim2.new(0.5, -10, 1, 0), Position = UDim2.fromOffset(10, 0), Parent = row })
	local idx = table.find(def.Options, def.Default) or 1
	local valueLabel = label({
		Text = def.Options[idx], Size = UDim2.new(0.5, -10, 1, 0), Position = UDim2.new(0.5, 0, 0, 0),
		TextXAlignment = Enum.TextXAlignment.Right, TextColor3 = Theme.Accent1, Parent = row,
	})
	local btn = create("TextButton", { BackgroundTransparency = 1, Text = "", Size = UDim2.fromScale(1, 1), Parent = row })
	btn.MouseButton1Click:Connect(function()
		idx = idx % #def.Options + 1
		valueLabel.Text = def.Options[idx]
		report(def.Options[idx])
	end)
	btn.MouseButton2Click:Connect(function()
		idx = (idx - 2) % #def.Options + 1
		valueLabel.Text = def.Options[idx]
		report(def.Options[idx])
	end)
	return row
end

Builders.Color = function(def, parent, order, report)
	local holder = create("Frame", {
		BackgroundColor3 = Theme.Setting, BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, SettingHeight), LayoutOrder = order,
		ClipsDescendants = true, Parent = parent,
	})
	label({ Text = def.Name, Size = UDim2.new(1, -56, 0, SettingHeight), Position = UDim2.fromOffset(10, 0), Parent = holder })
	local swatch = create("Frame", {
		BackgroundColor3 = def.Default or Color3.new(1, 0, 1),
		Size = UDim2.fromOffset(26, 14), Position = UDim2.new(1, -36, 0, 7), Parent = holder,
	}, { corner(4) })
	local hueBar = create("Frame", {
		BackgroundColor3 = Color3.new(1, 1, 1), Size = UDim2.new(1, -20, 0, 10),
		Position = UDim2.new(0, 10, 0, 34), Parent = holder,
	}, { corner(5) })
	local seq = {}
	for i = 0, 6 do
		table.insert(seq, ColorSequenceKeypoint.new(i / 6, Color3.fromHSV(i / 6, 1, 1)))
	end
	create("UIGradient", { Color = ColorSequence.new(seq), Parent = hueBar })
	local valBar = create("Frame", {
		BackgroundColor3 = Color3.new(1, 1, 1), Size = UDim2.new(1, -20, 0, 10),
		Position = UDim2.new(0, 10, 0, 50), Parent = holder,
	}, { corner(5) })
	local valGrad = create("UIGradient", { Parent = valBar })
	local h, s, v = (def.Default or Color3.new(1, 0, 1)):ToHSV()
	local function update()
		local c = Color3.fromHSV(h, s, v)
		swatch.BackgroundColor3 = c
		valGrad.Color = ColorSequence.new(Color3.new(0, 0, 0), Color3.fromHSV(h, s, 1))
		report(c)
	end
	update()
	local open = false
	create("TextButton", {
		BackgroundTransparency = 1, Text = "", Size = UDim2.new(1, 0, 0, SettingHeight), Parent = holder,
	}).MouseButton1Click:Connect(function()
		open = not open
		tween(holder, { Size = UDim2.new(1, 0, 0, open and 68 or SettingHeight) })
	end)
	local function dragBar(bar: Frame, apply: (number) -> ())
		local dragging = false
		bar.InputBegan:Connect(function(i: InputObject)
			if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				apply(math.clamp((i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1))
			end
		end)
		UserInputService.InputChanged:Connect(function(i: InputObject)
			if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
				apply(math.clamp((i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1))
			end
		end)
		UserInputService.InputEnded:Connect(function(i: InputObject)
			if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
				dragging = false
			end
		end)
	end
	dragBar(hueBar, function(a) h = a; update() end)
	dragBar(valBar, function(a) v = a; update() end)
	return holder
end

Builders.Bind = function(def, parent, order, report)
	local row = newRow(parent, order)
	label({ Text = def.Name, Size = UDim2.new(1, -90, 1, 0), Position = UDim2.fromOffset(10, 0), Parent = row })
	local keyLabel = label({
		Text = "NONE", Size = UDim2.fromOffset(70, 1), Position = UDim2.new(1, -80, 0, 0),
		TextXAlignment = Enum.TextXAlignment.Right, TextColor3 = Theme.SubText, Parent = row,
	})
	keyLabel.Size = UDim2.new(0, 70, 1, 0)
	local listening = false
	local btn = create("TextButton", { BackgroundTransparency = 1, Text = "", Size = UDim2.fromScale(1, 1), Parent = row })
	btn.MouseButton1Click:Connect(function()
		listening = true
		keyLabel.Text = "..."
		keyLabel.TextColor3 = Theme.Accent1
	end)
	UserInputService.InputBegan:Connect(function(i: InputObject, gp: boolean)
		if not listening or i.UserInputType ~= Enum.UserInputType.Keyboard then
			return
		end
		listening = false
		keyLabel.TextColor3 = Theme.SubText
		if i.KeyCode == Enum.KeyCode.Escape or i.KeyCode == Enum.KeyCode.Backspace then
			keyLabel.Text = "NONE"
			report(nil)
		else
			keyLabel.Text = i.KeyCode.Name:upper()
			report(i.KeyCode)
		end
	end)
	return row
end

-- ===== module row =====
local function buildModule(list: Instance, def: any, order: number, report: (string, any) -> ())
	local holder = create("Frame", {
		BackgroundColor3 = Theme.Module, BorderSizePixel = 0,
		Size = UDim2.new(1, -6, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = order, Parent = list,
	}, {
		corner(),
		create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder }),
	})

	local header = create("Frame", {
		BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 38), LayoutOrder = 0, Parent = holder,
	})
	local glow = create("Frame", {
		BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1), Parent = header,
	}, { corner(), gradient(0) })
	local title = label({
		Text = def.Name, Size = UDim2.new(1, -50, 0, 18), Position = UDim2.fromOffset(12, 4),
		Font = Enum.Font.Montserrat, TextSize = 14, Parent = header,
	})
	local desc = label({
		Text = def.Desc or "", Size = UDim2.new(1, -50, 0, 14), Position = UDim2.fromOffset(12, 21),
		TextSize = 10, TextColor3 = Theme.SubText, Parent = header,
	})
	local arrow = label({
		Text = "›", Size = UDim2.fromOffset(20, 38), Position = UDim2.new(1, -26, 0, 0),
		TextXAlignment = Enum.TextXAlignment.Center, TextSize = 20, TextColor3 = Theme.SubText,
		Visible = #def.Settings > 0, Parent = header,
	})

	local settingsFrame = create("Frame", {
		BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = 1, Visible = false, Parent = holder,
	}, {
		create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 1) }),
	})
	local values: { [string]: any } = {}
	for i, sdef in ipairs(def.Settings) do
		local builder = Builders[sdef.Type]
		if builder then
			local key = sdef.Name
			values[key] = sdef.Default
			builder(sdef, settingsFrame, i, function(v)
				values[key] = v
				report(key, v)
			end)
		end
	end

	local enabled = false
	local expanded = false
	local function renderEnabled()
		tween(glow, { BackgroundTransparency = enabled and 0.55 or 1 })
		title.TextColor3 = enabled and Color3.new(1, 1, 1) or Theme.Text
	end
	local btn = create("TextButton", { BackgroundTransparency = 1, Text = "", Size = UDim2.fromScale(1, 1), Parent = header })
	btn.MouseButton1Click:Connect(function()
		enabled = not enabled
		renderEnabled()
		report("__enabled", enabled)
	end)
	btn.MouseButton2Click:Connect(function()
		if #def.Settings == 0 then
			return
		end
		expanded = not expanded
		settingsFrame.Visible = expanded
		tween(arrow, { Rotation = expanded and 90 or 0 })
	end)
	btn.MouseEnter:Connect(function()
		if not enabled then
			tween(holder, { BackgroundColor3 = Theme.ModuleHover })
		end
	end)
	btn.MouseLeave:Connect(function()
		tween(holder, { BackgroundColor3 = Theme.Module })
	end)
	return holder
end

-- ===== window =====
export type Config = { [string]: { any } }

function Library.new(config: Config, options: { [string]: any }?)
	options = options or {}
	local opts: any = options
	local self = setmetatable({}, Library)
	self.Callback = opts.Callback -- function(category, module, setting, value)
	self.ToggleKey = opts.ToggleKey or Enum.KeyCode.RightShift
	self.Title = opts.Title or "Celestial"
	self._open = false

	local gui = create("ScreenGui", {
		Name = "CelestialUI", ResetOnSpawn = false, IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling, Enabled = false,
	})
	local player = Players.LocalPlayer
	assert(player, "CelestialUI must be required from a LocalScript")
	gui.Parent = player:WaitForChild("PlayerGui")
	self.Gui = gui

	local blur = create("BlurEffect", { Size = 0, Enabled = false, Parent = Lighting })
	self._blur = blur

	local main = create("Frame", {
		BackgroundColor3 = Theme.Background, BorderSizePixel = 0,
		Size = UDim2.fromOffset(640, 420), Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5), Parent = gui,
	}, {
		corner(10),
		create("UIStroke", { Thickness = 1.5, Color = Color3.new(1, 1, 1) }, { gradient(45) }),
	})
	local scale = create("UIScale", { Scale = 0.9, Parent = main })
	self._main, self._scale = main, scale

	-- drag by the top bar
	local topBar = create("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 40), Parent = main })
	do
		local dragging, startPos, startMouse = false, nil, nil
		topBar.InputBegan:Connect(function(i: InputObject)
			if i.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging, startPos, startMouse = true, main.Position, i.Position
			end
		end)
		UserInputService.InputChanged:Connect(function(i: InputObject)
			if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
				local d = i.Position - startMouse
				main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
			end
		end)
		UserInputService.InputEnded:Connect(function(i: InputObject)
			if i.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = false
			end
		end)
	end

	-- sidebar
	local sidebar = create("Frame", {
		BackgroundColor3 = Theme.Sidebar, BorderSizePixel = 0,
		Size = UDim2.new(0, 140, 1, 0), Parent = main,
	}, { corner(10) })
	create("Frame", { -- square off the inner right corners
		BackgroundColor3 = Theme.Sidebar, BorderSizePixel = 0,
		Size = UDim2.new(0, 12, 1, 0), Position = UDim2.new(1, -12, 0, 0), Parent = sidebar,
	})
	label({
		Text = self.Title, Size = UDim2.new(1, -20, 0, 40), Position = UDim2.fromOffset(16, 6),
		TextSize = 20, Font = Enum.Font.Montserrat, TextColor3 = Color3.new(1, 1, 1), Parent = sidebar,
	}, nil)
	local titleLabel = sidebar:FindFirstChildOfClass("TextLabel") :: TextLabel
	local tg = gradient(0)
	tg.Parent = titleLabel

	local tabList = create("Frame", {
		BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, -60), Position = UDim2.fromOffset(0, 54), Parent = sidebar,
	}, {
		create("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder }),
		create("UIPadding", { PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8) }),
	})

	local content = create("Frame", {
		BackgroundTransparency = 1, Size = UDim2.new(1, -156, 1, -16), Position = UDim2.fromOffset(148, 8), Parent = main,
	})

	local pages: { [string]: ScrollingFrame } = {}
	local tabs: { [string]: { btn: TextButton, glow: Frame } } = {}
	local current: string? = nil

	local function select(name: string)
		if current == name then
			return
		end
		current = name
		for n, page in pairs(pages) do
			page.Visible = (n == name)
			tween(tabs[n].glow, { BackgroundTransparency = (n == name) and 0.45 or 1 })
		end
	end

	local order = 0
	for _, catName in ipairs(CATEGORY_ORDER) do
		local mods = config[catName]
		if mods then
			order += 1
			local tabBtn = create("TextButton", {
				BackgroundTransparency = 1, Text = "", Size = UDim2.new(1, 0, 0, 34), LayoutOrder = order, Parent = tabList,
			})
			local g = create("Frame", {
				BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1), Parent = tabBtn,
			}, { corner(), gradient(0) })
			label({
				Text = CATEGORY_ICON[catName] or "•", Size = UDim2.fromOffset(28, 34), Position = UDim2.fromOffset(8, 0),
				TextXAlignment = Enum.TextXAlignment.Center, TextSize = 16, Parent = tabBtn,
			})
			label({ Text = catName, Size = UDim2.new(1, -44, 1, 0), Position = UDim2.fromOffset(38, 0), Parent = tabBtn })
			tabs[catName] = { btn = tabBtn, glow = g }

			local page = create("ScrollingFrame", {
				BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1),
				CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
				ScrollBarThickness = 3, ScrollBarImageColor3 = Theme.Accent1, Visible = false, Parent = content,
			}, {
				create("UIListLayout", { Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder }),
			})
			pages[catName] = page
			for i, mdef in ipairs(mods) do
				buildModule(page, mdef, i, function(setting: string, value: any)
					if self.Callback then
						self.Callback(catName, mdef.Name, setting, value)
					end
				end)
			end
			tabBtn.MouseButton1Click:Connect(function()
				select(catName)
			end)
		end
	end
	for _, categoryName in ipairs(CATEGORY_ORDER) do
		if pages[categoryName] then
			select(categoryName)
			break
		end
	end

	UserInputService.InputBegan:Connect(function(i: InputObject, gp: boolean)
		if not gp and i.KeyCode == self.ToggleKey then
			self:Toggle()
		end
	end)

	return self
end

function Library:Toggle(state: boolean?)
	local open = state
	if open == nil then
		open = not self._open
	end
	self._open = open :: boolean
	if open then
		self.Gui.Enabled = true
		self._blur.Enabled = true
		tween(self._blur, { Size = 16 })
		tween(self._scale, { Scale = 1 }, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
	else
		tween(self._blur, { Size = 0 })
		tween(self._scale, { Scale = 0.9 })
		task.delay(0.2, function()
			if not self._open then
				self.Gui.Enabled = false
				self._blur.Enabled = false
			end
		end)
	end
end

function Library:Destroy()
	self.Gui:Destroy()
	self._blur:Destroy()
end

return Library

end)()

assert(type(Library) == "table" and type(Library.new) == "function",
    "[Celestial] UI library failed to initialize")

local menu = Library.new(Config, {
    Title = "Celestial",
    ToggleKey = Enum.KeyCode.RightShift,
    Callback = function(category, moduleName, settingName, value)
        print(("[Celestial] %s / %s / %s = %s"):format(
            tostring(category), tostring(moduleName), tostring(settingName), tostring(value)
        ))
    end,
})

menu:Toggle(true)
print("[Celestial] Loaded successfully. RightShift toggles the UI.")
return menu

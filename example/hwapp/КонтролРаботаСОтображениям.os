&Желудь
&Прозвище("Контроллер")
&Маршрут("/demoviews")
&Отображение(Шаблон = "./hwapp/view/main.html", Метод = "ПолучитьМодельКонтрола")
Процедура ПриСозданииОбъекта()

КонецПроцедуры

Функция ПолучитьМодельКонтрола(Запрос) Экспорт
	Модель = Новый Структура("Заголовок, Дата", "Демонстрация работы отображений", Запрос.ДатаПолучения);

	Возврат Модель;
КонецФункции

&Отображение("./hwapp/view/view1.html")
&ТочкаМаршрута("demo1")
Процедура ДемонстрацияОтображения(Ответ) Экспорт

	Ответ.УстановитьТипКонтента("html");

	ГСЧ = Новый ГенераторСлучайныхЧисел();
	
	СлучайноеЧисло = ГСЧ.СлучайноеЧисло(1, 10);

	Массив = Новый Массив();

	Для Сч = 1 по СлучайноеЧисло Цикл
		Массив.Добавить(Строка(Новый УникальныйИдентификатор()));
	КонецЦикла;

	Модель = Новый Структура();
	Модель.Вставить("СлучайноеЧисло", СлучайноеЧисло);
	Модель.Вставить("МассивСтрок", Массив);

	МассивФруктов = Новый Массив();
	МассивФруктов.Добавить("Яблоко");
	МассивФруктов.Добавить("Апельсин");
	МассивФруктов.Добавить("Банан");
	МассивФруктов.Добавить("Желудь");

	Модель.Вставить("ВторойМассив", МассивФруктов);

	Ответ.Модель = Модель;

КонецПроцедуры
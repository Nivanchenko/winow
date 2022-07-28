Перем ПарсерСоединений;
Перем Маршрутизатор;
Перем ФабрикаОтветов;
Перем ОтправщикОтветов;

&Желудь
Процедура ПриСозданииОбъекта(
							&Пластилин("ПарсерСоединений") _ПарсерСоединений,
							&Пластилин("Маршрутизатор") _Маршрутизатор,
							&Пластилин("ФабрикаОтветов") _ФабрикаОтветов,
							&Пластилин("ОтправщикОтветов") _ОтправщикОтветов
							)
	ПарсерСоединений = _ПарсерСоединений;
	Маршрутизатор = _Маршрутизатор;
	ФабрикаОтветов = _ФабрикаОтветов;
	ОтправщикОтветов = _ОтправщикОтветов;
КонецПроцедуры

Процедура Обработать(Соединение) Экспорт

	Запрос = ПарсерСоединений.ПолучитьЗапрос(Соединение);	

	ОбработчикИПараметры = Маршрутизатор.НайтиОбработчикИПараметрыПоПолномуПути(Запрос.Путь);

	Запрос.ПараметрыПорядковые = ОбработчикИПараметры.Параметры;

	Если ЗначениеЗаполнено(ОбработчикИПараметры.Действие) Тогда

		Ответ = ФабрикаОтветов.НовыйОтвет();

		Попытка
			ОбработчикИПараметры.Действие.Выполнить(Запрос, Ответ);	
		Исключение
			ТекстОшибки = ОписаниеОшибки();
			Ответ = ФабрикаОтветов.НовыйОтвет500();
		КонецПопытки;

	Иначе

		Ответ = ФабрикаОтветов.НовыйОтвет404();

	КонецЕсли;

	ОтправщикОтветов.ОтправитьОтвет(Ответ, Соединение);

	Соединение.Закрыть();

КонецПроцедуры
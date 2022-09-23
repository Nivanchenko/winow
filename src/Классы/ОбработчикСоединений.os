&Пластилин Перем ПарсерСоединений Экспорт;
&Пластилин Перем Маршрутизатор Экспорт;
&Пластилин Перем ФабрикаОтветов Экспорт;
&Пластилин Перем ОтправщикОтветов Экспорт;
&Пластилин Перем МенеджерСессий Экспорт;
&Пластилин Перем МенеджерОтображений Экспорт;
&Пластилин Перем МенеджерДоступа Экспорт;
&Пластилин Перем Поделка Экспорт;
&Пластилин Перем КонструкторыПараметров Экспорт;

Перем Рефлектор;

&Желудь
Процедура ПриСозданииОбъекта()
	Рефлектор = Новый Рефлектор();
КонецПроцедуры

Процедура Обработать(Соединение) Экспорт

	Попытка
		Запрос = ПарсерСоединений.ПолучитьЗапрос(Соединение);	
	Исключение
		ЗакрытьСоединениеВПопытке(Соединение);
		// TODO: ДОБАВИТЬ ЛОГГЕР
		Сообщить("Не удалось обработать входящее соединение");
		Возврат;
	КонецПопытки;	

	ОбработчикИПараметры = Маршрутизатор.НайтиОбработчикИПараметрыПоПолномуПути(Запрос.Путь);

	Запрос.ПараметрыПорядковые = ОбработчикИПараметры.Параметры;

	Если ЗначениеЗаполнено(ОбработчикИПараметры.Действие) Тогда

		Сессия = ПолучитьСессию(Запрос.Куки);

		ДействиеДоступно = Ложь;
		ЗапроситьТокен = Ложь;
		
		Если МенеджерДоступа.ТочкаМаршрутаИмеетРоли(ОбработчикИПараметры.Действие) Тогда
			Если ЗначениеЗаполнено(Сессия.Логин) и МенеджерДоступа.ТочкаМаршрутаДоступна(Сессия.Логин, ОбработчикИПараметры.Действие) Тогда
				ДействиеДоступно = Истина;	

			ИначеЕсли ЗначениеЗаполнено(Сессия.Логин) и НЕ МенеджерДоступа.ТочкаМаршрутаДоступна(Сессия.Логин, ОбработчикИПараметры.Действие) Тогда
				ДействиеДоступно = Ложь;

			ИначеЕсли НЕ ЗначениеЗаполнено(Сессия.Логин) И Запрос.Заголовки["Authorization"] = Неопределено Тогда
				ДействиеДоступно = Ложь;
				ЗапроситьТокен = Истина;

			ИначеЕсли НЕ ЗначениеЗаполнено(Сессия.Логин) И НЕ Запрос.Заголовки["Authorization"] = Неопределено Тогда
				ДанныеАвторизации = РазобратьАвторизационныеДанные(Запрос.Заголовки["Authorization"]);

				Если ЗначениеЗаполнено(ДанныеАвторизации.Логин) И
						ЗначениеЗаполнено(ДанныеАвторизации.Токен) Тогда

					Если МенеджерДоступа.ТокенВалидный(ДанныеАвторизации.Логин, ДанныеАвторизации.Токен) Тогда
						Сессия.Логин = ДанныеАвторизации.Логин;
						ДействиеДоступно = МенеджерДоступа.ТочкаМаршрутаДоступна(Сессия.Логин, ОбработчикИПараметры.Действие);
					Иначе
						ДействиеДоступно = Ложь;
						ЗапроситьТокен = Истина;
					КонецЕсли;
				Иначе 
					ДействиеДоступно = Ложь;
					ЗапроситьТокен = Истина;
				
				КонецЕсли

			КонецЕсли;
		Иначе
			ДействиеДоступно = Истина;
		КонецЕсли;

		Если ДействиеДоступно Тогда
			Ответ = АвторизованныйОтвет(Запрос, Сессия, ОбработчикИПараметры);
		ИначеЕсли Не ДействиеДоступно и ЗапроситьТокен Тогда
			Ответ = ФабрикаОтветов.НовыйОтвет401();
			Ответ.Заголовки["WWW-Authenticate"] = "Basic";
		Иначе
			Ответ = ФабрикаОтветов.НовыйОтвет403();
		КонецЕсли;

	Иначе

		Ответ = ФабрикаОтветов.НовыйОтвет404();
		Ответ.Модель = Новый Структура();
		Ответ.Модель.Вставить("КодСостояния", 404);
		Ответ.Модель.Вставить("ТекстСообщения", "Страница не найдена");
		Ответ.Модель.Вставить("Запрос", Запрос);
		Ответ.ОбработатьМодель();

	КонецЕсли;

	ОтправщикОтветов.ОтправитьОтвет(Ответ, Соединение);

	ЗакрытьСоединениеВПопытке(Соединение);

КонецПроцедуры

Процедура ЗакрытьСоединениеВПопытке(Соединение)
	Попытка
		Соединение.Закрыть();	
	Исключение
		// TODO: ДОБАВИТЬ ЛОГГЕР
		Сообщить("Не удалось закрыть входящее соединение");	
	КонецПопытки;
КонецПроцедуры

Функция РазобратьАвторизационныеДанные(знач СтрокаЗаголовкаАвторизациии)
	Возврат МенеджерДоступа.ПолучитьАвторизационныеДанныеПоСтрокеЗаголовка(СтрокаЗаголовкаАвторизациии);
КонецФункции

Функция АвторизованныйОтвет(Запрос, Сессия, ОбработчикИПараметры)

	Ответ = ФабрикаОтветов.НовыйОтвет();
	Ответ.Куки.Добавить(ИмяКукаСессии(), Сессия.Идентификатор());

	Отображене = МенеджерОтображений.ПолучитьОтображениеДействия(ОбработчикИПараметры.Действие);
	Если ЗначениеЗаполнено(Отображене) Тогда
		Ответ.УстановитьТекстШаблона(Отображене);
	КонецЕсли;

	Попытка
		ПараметрыТочкиМаршрута = КонструкторыПараметров.СформироватьПараметрыТочкиМаршрута(
														ОбработчикИПараметры.Действие,
														ОбработчикИПараметры.Действие.Параметры,
														Запрос,
														Ответ,
														Сессия);

		Рефлектор.ВызватьМетод(	ОбработчикИПараметры.Действие.Желудь, 
								ОбработчикИПараметры.Действие.ИмяМетода, 
								ПараметрыТочкиМаршрута);
		Ответ.ОбработатьМодель();
		ОбработатьШаблонКонтрола(Ответ, ОбработчикИПараметры.Действие, Запрос, Сессия);
	Исключение
		ТекстОшибки = ОписаниеОшибки();
		Ответ = ФабрикаОтветов.НовыйОтвет500();
		Ответ.Модель = Новый Структура();
		Ответ.Модель.Вставить("КодСостояния", 500);
		Ответ.Модель.Вставить("ТекстСообщения", ТекстОшибки);
		Ответ.Модель.Вставить("Запрос", Запрос);
		Ответ.ОбработатьМодель();
	КонецПопытки;	

	Возврат Ответ;

КонецФункции

Процедура ОбработатьШаблонКонтрола(Ответ, Действие, Запрос, Сессия)
	Если Не ЗначениеЗаполнено(Действие.Шаблон) Тогда
		Возврат;
	КонецЕсли;
	Массив = Новый Массив();
	Массив.Добавить(МенеджерОтображений.ПолучитьОтображение(Действие.Шаблон));
	Шаблон = Поделка.НайтиЖелудь("Шаблон", Массив);

	ПараметрыМетода = КонструкторыПараметров.СформироватьПараметрыТочкиМаршрута(
														Действие,
														Действие.ПараметрыШаблона,
														Запрос,
														Ответ,
														Сессия);

	Если ЗначениеЗаполнено(Действие.МетодШаблона) Тогда
		Модель = Рефлектор.ВызватьМетод(Действие.Желудь, 
										Действие.МетодШаблона,
										ПараметрыМетода);
	Иначе
		Модель = Неопределено;
	КонецЕсли;

	ТекстКонтрола = Шаблон.СформироватьТекст(Модель);

	Ответ.ТелоТекст = СтрЗаменить(ТекстКонтрола, "@Контент", Ответ.ТелоТекст); 
	
КонецПроцедуры

Функция ПолучитьСессию(Куки)
	ИдСессии = Куки.ПолучитьЗначениеПоИмени(ИмяКукаСессии());
	Возврат МенеджерСессий.ПолучитьСессиюПоИдентификатору(ИдСессии);
КонецФункции

Функция ИмяКукаСессии()
	Возврат "SessionID";
КонецФункции
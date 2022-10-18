
&Пластилин	Перем ОбработчикСоединений Экспорт;
&Пластилин	Перем Настройки Экспорт;
&Пластилин	Перем СлушательПорта Экспорт;

&Желудь
Процедура ПриСозданииОбъекта()
	
КонецПроцедуры 

Процедура Старт() Экспорт

	СлушательПорта.Запустить();

	Пока СлушательПорта.Активен() Цикл

		Соединение = СлушательПорта.ОжидатьСоединения();

		МассивПараметров = Новый Массив();
		МассивПараметров.Добавить(Соединение);

		Если Настройки.ЗапросВФоновыхЗаданиях = Истина Тогда

			ОбработчикСоединений.ОбработатьАсинх(Соединение);
		
		Иначе

			ОбработчикСоединений.Обработать(Соединение);

		КонецЕсли;

	КонецЦикла
	
КонецПроцедуры
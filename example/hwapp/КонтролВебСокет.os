&Желудь
&Прозвище("Контроллер")
&Маршрут("/socket")

Процедура ПриСозданииОбъекта()

КонецПроцедуры

&Отображение("./hwapp/view/socket.html")
&ТочкаМаршрута("")
Процедура Индекс() Экспорт


КонецПроцедуры

&ТочкаМаршрута("ws")
Процедура ОбработкаСокета(Запрос, Ответ) Экспорт
	Если не Запрос.Заголовки["Sec-WebSocket-Key"] = Неопределено Тогда
		ЗаголовокОтвета = Запрос.Заголовки["Sec-WebSocket-Key"] + "258EAFA5-E914-47DA-95CA-C5AB0DC85B11";	
		Ответ.Заголовки.Вставить("Sec-WebSocket-Accept", ЗаголовокОтвета);
		Ответ.Заголовки.Вставить("Upgrade", "websocket");
		Ответ.Заголовки.Вставить("Connection", "Upgrade");
		Ответ.СостояниеКод = "101";
		Ответ.СостояниеТекст = "Switching Protocols";

	КонецЕсли;
КонецПроцедуры
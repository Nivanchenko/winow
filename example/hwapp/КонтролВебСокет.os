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

		ПростоХеш = ГенерацияХешаОтвета("hFDf0q+qrE3XrVg3YgqfJA=="); 
		а = ПростоХеш = "uo/E2pDBlagwgbfkbn8rDMNjaks=";
		
		ЗаголовокОтвета = ГенерацияХешаОтвета(Запрос.Заголовки["Sec-WebSocket-Key"]);
		
		Ответ.Куки.Очистить();
		Ответ.Заголовки.Очистить();

		Ответ.Заголовки.Вставить("Upgrade", "websocket");
		Ответ.Заголовки.Вставить("Connection", "Upgrade");
		Ответ.Заголовки.Вставить("Sec-WebSocket-Accept", ЗаголовокОтвета);
		//Ответ.Заголовки.Вставить("Sec-WebSocket-Extensions", "permessage-deflate");
		Ответ.СостояниеКод = "101";
		Ответ.СостояниеТекст = "Switching Protocols";

	КонецЕсли;
КонецПроцедуры

Функция ГенерацияХешаОтвета(КлючВхода)
	Результат = КлючВхода + "258EAFA5-E914-47DA-95CA-C5AB0DC85B11";	
	Провайдер = Новый ХешированиеДанных(ХешФункция.SHA1);
	Провайдер.Добавить(Результат);
	Результат = Base64Строка(Провайдер.ХешСумма);
	Возврат Результат;	
КонецФункции
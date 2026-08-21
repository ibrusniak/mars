
// Универсальный JSON-RPC 2.0 интерфейс для взаимодействия с информационной базой 1С.
// JSON-RPC 2.0 — это лёгкий протокол удалённого вызова методов.
// Спецификация протокола JSON-RPC 2.0 тут: https://www.jsonrpc.org/specification

//	Точка входа. Сюда поступают все запросы POST /invoke
//
// 4 Request object
// A rpc call is represented by sending a Request object to a Server. The Request object has the following members:
// 
// jsonrpc
// A String specifying the version of the JSON-RPC protocol. MUST be exactly "2.0".
// method
// A String containing the name of the method to be invoked. Method names that begin with the word rpc followed by a period character (U+002E or ASCII 46) are reserved for rpc-internal methods and extensions and MUST NOT be used for anything else.
// params
// A Structured value that holds the parameter values to be used during the invocation of the method. This member MAY be omitted.
// id
// An identifier established by the Client that MUST contain a String, Number, or NULL value if included. If it is not included it is assumed to be a notification. The value SHOULD normally not be Null [1] and Numbers SHOULD NOT contain fractional parts [2]
//
// {
//     "jsonrpc": "2.0",
//     "method": "system.ping",
//     "id": 1
// }
//
Функция InvokePOST(Запрос)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТелоЗапросаКакСтрока = Запрос.ПолучитьТелоКакСтроку();
	
	Ответ = Новый HTTPСервисОтвет(200);
	Ответ.Заголовки.Вставить("Content-Type", "application/json");
	
	Попытка
		ТелоЗапросаКакСоответствие = МарсОбщегоНазначения.ДесериализоватьИзJson(ТелоЗапросаКакСтрока);
	Исключение
		Ио = ИнформацияОбОшибке();
		СтруктураОтвета = МарсОбщегоНазначения.СтруктураОтвета(, МарсОбщегоНазначения.СтруктураОшибки(-32700, КраткоеПредставлениеОшибки(Ио), ПодробноеПредставлениеОшибки(Ио)));		
		Ответ.УстановитьТелоИзСтроки(МарсОбщегоНазначения.СериализоватьВJson(СтруктураОтвета), КодировкаТекста.UTF8);
		Возврат Ответ;
	КонецПопытки;
	
	jsonrpc	= ТелоЗапросаКакСоответствие["jsonrpc"];
	id = ТелоЗапросаКакСоответствие["id"];
	
	Если jsonrpc = Неопределено ИЛИ jsonrpc <> "2.0" Тогда
		ТекстОшибки = "'method' - must be a String specifying the version of the JSON-RPC protocol. MUST be exactly ""2.0"".";
		СтруктураОтвета = МарсОбщегоНазначения.СтруктураОтвета(, МарсОбщегоНазначения.СтруктураОшибки(
			-32700,
			ТекстОшибки,
			ТекстОшибки), id);	
		Ответ.УстановитьТелоИзСтроки(МарсОбщегоНазначения.СериализоватьВJson(СтруктураОтвета), КодировкаТекста.UTF8);
		Возврат Ответ;		
	КонецЕсли;
	
	method	= ТелоЗапросаКакСоответствие["method"];
	
	Если method = Неопределено ИЛИ ТипЗнч(method) <> Тип("Строка") Тогда
		ТекстОшибки = "'method' - must be a String containing the name of the method to be invoked. Method names that begin with the word rpc followed by a period character (U+002E or ASCII 46) are reserved for rpc-internal methods and extensions and MUST NOT be used for anything else.";
		СтруктураОтвета = МарсОбщегоНазначения.СтруктураОтвета(, МарсОбщегоНазначения.СтруктураОшибки(
			-32700,
			ТекстОшибки,
			ТекстОшибки), id);	
		Ответ.УстановитьТелоИзСтроки(МарсОбщегоНазначения.СериализоватьВJson(СтруктураОтвета), КодировкаТекста.UTF8);
		Возврат Ответ;		
	КонецЕсли;
	
	Попытка
		СтруктураОтвета = МарсДиспетчерЗапросов.ВыполнитьФункцию(method, ТелоЗапросаКакСоответствие["params"]);
		СтруктураОтвета.id = id;
	Исключение
		СтруктураОтвета = МарсОбщегоНазначения.СтруктураОтвета(, МарсОбщегоНазначения.СтруктураОшибки(-32603, "Internal error	Internal JSON-RPC error.", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())), id);		
		Ответ.УстановитьТелоИзСтроки(МарсОбщегоНазначения.СериализоватьВJson(СтруктураОтвета), КодировкаТекста.UTF8);
		Возврат Ответ;
	КонецПопытки;
	
	Ответ.УстановитьТелоИзСтроки(МарсОбщегоНазначения.СериализоватьВJson(СтруктураОтвета), КодировкаТекста.UTF8);
	Возврат Ответ;
	
КонецФункции

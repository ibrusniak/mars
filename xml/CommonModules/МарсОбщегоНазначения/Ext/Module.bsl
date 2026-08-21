
Функция СериализоватьВJson(Структура) Экспорт
	ЗаписьJSON = Новый ЗаписьJSON();
	ЗаписьJSON.УстановитьСтроку(Новый ПараметрыЗаписиJSON(ПереносСтрокJSON.Авто, Символы.Таб));
	ЗаписатьJSON(ЗаписьJSON, Структура);
	Возврат ЗаписьJSON.Закрыть();
КонецФункции

Функция ДесериализоватьИзJson(Json) Экспорт
	ЧтениеJSОN = Новый ЧтениеJSON;
	ЧтениеJSОN.УстановитьСтроку(Json);
	Соответствие = ПрочитатьJSON(ЧтениеJSОN, Истина);
	ЧтениеJSОN.Закрыть();
	Возврат Соответствие;
КонецФункции

// Структура ответа
//
// 5 Response object
// When a rpc call is made, the Server MUST reply with a Response, except for in the case of Notifications. The Response is expressed as a single JSON Object, with the following members:
// 
// jsonrpc
// 	A String specifying the version of the JSON-RPC protocol. MUST be exactly "2.0".
// result
// 	This member is REQUIRED on success.
// 	This member MUST NOT exist if there was an error invoking the method.
// 	The value of this member is determined by the method invoked on the Server.
// error
// 	This member is REQUIRED on error.
// 	This member MUST NOT exist if there was no error triggered during invocation.
// 	The value for this member MUST be an Object as defined in section 5.1.
// id
// 	This member is REQUIRED.
// 	It MUST be the same as the value of the id member in the Request Object.
// 	If there was an error in detecting the id in the Request object (e.g. Parse error/Invalid Request), it MUST be Null.
// 	Either the result member or error member MUST be included, but both members MUST NOT be included.
Функция СтруктураОтвета(result = Неопределено, error = Неопределено, id = Неопределено) Экспорт
	Возврат Новый Структура("jsonrpc, result, error, id", "2.0", result, error, id);
КонецФункции

// Возвращает структуру ошибки
//
// 5.1 Error object
// When a rpc call encounters an error, the Response Object MUST contain the error member with a value that is a Object with the following members:
// 
// code
//  A Number that indicates the error type that occurred.
//  This MUST be an integer.
// message
//  A String providing a short description of the error.
//  The message SHOULD be limited to a concise single sentence.
// data
//  A Primitive or Structured value that contains additional information about the error.
//  This may be omitted.
//  The value of this member is defined by the Server (e.g. detailed error information, nested errors etc.).
//
// The error codes from and including -32768 to -32000 are reserved for pre-defined errors. Any code within this range, but not defined explicitly below is reserved for future use. The error codes are nearly the same as those suggested for XML-RPC at the following url: http://xmlrpc-epi.sourceforge.net/specs/rfc.fault_codes.php
// 
// code	message	meaning
// -32700	Parse error	Invalid JSON was received by the server.
// An error occurred on the server while parsing the JSON text.
// -32600	Invalid Request	The JSON sent is not a valid Request object.
// -32601	Method not found	The method does not exist / is not available.
// -32602	Invalid params	Invalid method parameter(s).
// -32603	Internal error	Internal JSON-RPC error.
// -32000 to -32099	Server error	Reserved for implementation-defined server-errors.
// The remainder of the space is available for application defined errors.
//
Функция СтруктураОшибки(code, message, data) Экспорт
	Возврат Новый Структура("code, message, data", code, message, data);
КонецФункции

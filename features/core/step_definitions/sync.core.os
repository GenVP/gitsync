﻿#Использовать tempfiles
#Использовать 1commands
#Использовать fs
// Реализация шагов BDD-фич/сценариев c помощью фреймворка https://github.com/artbear/1bdd

Перем БДД; //контекст фреймворка 1bdd

// Метод выдает список шагов, реализованных в данном файле-шагов
Функция ПолучитьСписокШагов(КонтекстФреймворкаBDD) Экспорт
	БДД = КонтекстФреймворкаBDD;

	ВсеШаги = Новый Массив;

	ВсеШаги.Добавить("ЯСоздаюВременныйКаталогИСохраняюЕгоВПеременной");
	ВсеШаги.Добавить("ЯСоздаюНовыйМенеджерПлагинов");
	ВсеШаги.Добавить("ЯСобираюТестовыйПлагинИСохраняюВКонтекст");
	ВсеШаги.Добавить("ЯУстанавливаюФайлПлагинаИзПеременной");
	ВсеШаги.Добавить("ЯЗагружаюПлагиныИзКаталогаВПеременной");
	ВсеШаги.Добавить("ЯПодключаюПлагиныВМенеджерсинхронизации");

	Возврат ВсеШаги;
КонецФункции

// Реализация шагов

// Процедура выполняется перед запуском каждого сценария
Процедура ПередЗапускомСценария(Знач Узел) Экспорт
	


КонецПроцедуры

// Процедура выполняется после завершения каждого сценария
Процедура ПослеЗапускаСценария(Знач Узел) Экспорт

КонецПроцедуры

//Я создаю временный каталог и сохраняю его в переменной "КаталогПлагинов"
Процедура ЯСоздаюВременныйКаталогИСохраняюЕгоВПеременной(Знач ИмяПеременной) Экспорт

	ВременныйКаталог = ВременныеФайлы.СоздатьКаталог();
	
	БДД.СохранитьВКонтекст(ИмяПеременной, ВременныйКаталог);
	
КонецПроцедуры

//Я собираю тестовый плагин и сохраняю в контекст "ПутьКФайлуПлагина"
Процедура ЯСобираюТестовыйПлагинИСохраняюВКонтекст(Знач ИмяПеременной) Экспорт
	
	ВременныйКаталог = ВременныеФайлы.СоздатьКаталог();
	
	ФС.КопироватьСодержимоеКаталога(КаталогТестовогоПлагина(), ВременныйКаталог);

	Команда = Новый Команда;
	Команда = Новый Команда;
	Команда.УстановитьКоманду("opm");
	Команда.ДобавитьПараметр("build");
	Команда.ДобавитьПараметр("--out");
	Команда.ДобавитьПараметр(ВременныйКаталог);
	Команда.ДобавитьПараметр(ВременныйКаталог);
	КодВозврата = Команда.Исполнить();

	Если НЕ КодВозврата = 0 Тогда
		ВызватьИсключение Новый ИнформацияОбОшибке("Ошибка создания тестового плагина", Команда.ПолучитьВывод());
	КонецЕсли;

	Сообщить(Команда.ПолучитьВывод());

	МассивФайлов = НайтиФайлы(ВременныйКаталог, "*.ospx");

	Если МассивФайлов.Количество() = 0 Тогда
		ВызватьИсключение Новый ИнформацияОбОшибке("Ошибка создания тестового плагина", "Не найден собранный файл плагина");
	КонецЕсли;

	ФайлПлагина = МассивФайлов[0].ПолноеИмя;

	БДД.СохранитьВКонтекст(ИмяПеременной, ФайлПлагина);

КонецПроцедуры

//Я создаю новый МенеджерПлагинов
Процедура ЯСоздаюНовыйМенеджерПлагинов() Экспорт
	МенеджерПлагинов = Новый МенеджерПлагинов;
	
	БДД.СохранитьВКонтекст("МенеджерПлагинов", МенеджерПлагинов);
КонецПроцедуры

//Я загружаю плагины из каталога в переменной "КаталогПлагинов"
Процедура ЯЗагружаюПлагиныИзКаталогаВПеременной(Знач ИмяПеременнойКаталога) Экспорт

	МенеджерПлагинов = БДД.ПолучитьИзКонтекста("МенеджерПлагинов");
	КаталогПлагинов = БДД.ПолучитьИзКонтекста(ИмяПеременнойКаталога);

	МенеджерПлагинов.УстановитьКаталогПлагинов(КаталогПлагинов);
	МенеджерПлагинов.ЗагрузитьПлагины();

	МенеджерПлагинов.ВключитьПлагин("test_plugin");

КонецПроцедуры

//Я подключаю плагины в МенеджерСинхронизации
Процедура ЯПодключаюПлагиныВМенеджерсинхронизации() Экспорт

	МенеджерПлагинов = БДД.ПолучитьИзКонтекста("МенеджерПлагинов");
	
	ВсеПлагины = МенеджерПлагинов.ПолучитьПлагины();

	МенеджерСинхронизации = БДД.ПолучитьИзКонтекста("МенеджерСинхронизации");
	МенеджерСинхронизации.ПодпискиНаСобытия(ВсеПлагины);
	МенеджерСинхронизации.ПараметрыПодписокНаСобытия(Новый Соответствие);

КонецПроцедуры

//Я устанавливаю файл плагина из переменной "ПутьКФайлуПлагина"
Процедура ЯУстанавливаюФайлПлагинаИзПеременной(Знач ПутьКФайлуПлагина) Экспорт

	КаталогПлагинов = БДД.ПолучитьИзКонтекста("КаталогПлагинов");
	ФайлПлагина = БДД.ПолучитьИзКонтекста(ПутьКФайлуПлагина);
	МенеджерПлагинов = БДД.ПолучитьИзКонтекста("МенеджерПлагинов");
	МенеджерПлагинов.УстановитьКаталогПлагинов(КаталогПлагинов);
	МенеджерПлагинов.УстановитьФайлПлагин(ФайлПлагина);


КонецПроцедуры

Функция КаталогТестовогоПлагина()
	Возврат ОбъединитьПути(ТекущийСценарий().Каталог, "testsata", "test_plugin");
КонецФункции



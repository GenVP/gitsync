#Использовать logos
#Использовать tempfiles
#Использовать fs
#Использовать "../../core"
#Использовать "../../core/Классы/internal/files"

Перем ЛогПриложения;
Перем ОбщиеПараметры;
Перем ОбщийКаталогДанныхПриложения;
Перем СохрКаталогПриложения;
Перем ЭтоПриложениеEXE;
Перем КаталогПлагинов;
Перем ИмяКаталогаПлагинов;
Перем ИмяКаталогаПриложения;
Перем ИмяФайлаНастройкиПриложения;
Перем МенеджерПлагинов;
Перем ИмяФайлаПлагинов;

Процедура Инициализация()
	
	ОбщиеПараметры = Новый Структура();
	ОбщиеПараметры.Вставить("ВерсияПлатформы", "8.3");
	ОбщиеПараметры.Вставить("ПутьКПлатформе", "");
	ОбщиеПараметры.Вставить("ДоменПочты", "localhost");
	ОбщиеПараметры.Вставить("ПутьКГит", "");

	ИмяКаталогаПлагинов = "plugins";
	ИмяКаталогаПриложения = ".gitsync";
	ИмяФайлаНастройкиПриложения = "config.json";
	ИмяФайлаПлагинов = "plugins.json gitsync-plugins.json";
	МенеджерПлагинов = Новый МенеджерПлагинов;

	ОпределитьКаталогПлагинов();

КонецПроцедуры

// Выполняет чтение включенных плагинов из файла
//
// Возвращаемое значение:
//   Соответствие - набор данных о плагина
//					* ключ - строка - имя плагина
//					* значение - булево - признак включенности плагина
//
Функция ПрочитатьВключенныеПлагины()

	ВключенныеПлагины = Новый Соответствие;

	ПутьКФайлу = ПолучитьПутьКФайлуПлагинов();
	ФайлПлагинов = Новый Файл(ПутьКФайлу);

	Если Не ФайлПлагинов.Существует() Тогда
		Возврат ВключенныеПлагины;
	КонецЕсли;

	JsonСтрока = РаботаСФайлами.ПрочитатьФайл(ПутьКФайлу);

	Если ПустаяСтрока(JsonСтрока) Тогда
		Возврат ВключенныеПлагины;
	КонецЕсли;

	ДанныеФайла = РаботаСФайлами.ОбъектИзJson(JsonСтрока);

	Для каждого ДанныеПлагинаИзФайла Из ДанныеФайла Цикл
		
		Если Булево(ДанныеПлагинаИзФайла.Значение) Тогда
			ВключенныеПлагины.Вставить(ДанныеПлагинаИзФайла.Ключ, ДанныеПлагинаИзФайла.Значение);
		КонецЕсли;

	КонецЦикла;

	Возврат ВключенныеПлагины;

КонецФункции

Функция МенеджерПлагинов() Экспорт
	Возврат МенеджерПлагинов;
КонецФункции

// Процедура записывает активированные плагины в файл
//
Процедура ЗаписатьВключенныеПлагины() Экспорт

	ИмяФайла = ПолучитьПутьКФайлуПлагинов();

	КаталогФайла = Новый Файл(ИмяФайла).Путь;
	ФС.ОбеспечитьКаталог(КаталогФайла);

	ДанныеДляЗаписи = Новый Соответствие;
	ИндексПлагинов = МенеджерПлагинов.ПолучитьИндексПлагинов();

	Для каждого КлючЗначение Из ИндексПлагинов Цикл
		
		Плагин = КлючЗначение.Значение;
		ДанныеДляЗаписи.Вставить(Плагин.Имя(), Плагин.Включен());
	
	КонецЦикла;
	
	ТекстФайла = РаботаСФайлами.ОБъектВJson(ДанныеДляЗаписи);

	РаботаСФайлами.ЗаписатьФайл(ИмяФайла, ТекстФайла);

КонецПроцедуры

#КонецОбласти

Функция ПолучитьПутьКФайлуПлагинов()
	
	МассивИменФайла = СтрРазделить(ИмяФайлаПлагинов, " ", Ложь);

	Для каждого ИмяФайла Из МассивИменФайла Цикл
		
		ПутьКФайлуПлагинов = ОбъединитьПути(КаталогПлагинов(), ИмяФайла);

		ФайлПлагинов = Новый Файл(ПутьКФайлуПлагинов);

		Если Не ФайлПлагинов.Существует() Тогда
			Возврат ФайлПлагинов.ПолноеИмя;
		КонецЕсли;

	КонецЦикла;

	Возврат ОбъединитьПути(КаталогПлагинов(), МассивИменФайла[0]);

КонецФункции

Функция ЭтоСборкаEXE() Экспорт
	
	Если ЭтоПриложениеEXE = Неопределено Тогда
		ЭтоПриложениеEXE = ВРег(Прав(ТекущийСценарий().Источник, 3)) = "EXE";
	КонецЕсли;

	Возврат ЭтоПриложениеEXE;

КонецФункции

Процедура УстановитьВерсиюПлатформы(Знач ВерсияПлатформы) Экспорт
	ОбщиеПараметры.Вставить("ВерсияПлатформы", ВерсияПлатформы);
КонецПроцедуры

Процедура УстановитьПутьКГит(Знач ПутьКГит) Экспорт
	ОбщиеПараметры.Вставить("ПутьКГит", ПутьКГит);
КонецПроцедуры

Процедура УстановитьПутьКПлатформе(Знач ПутьКПлатформе) Экспорт
	ОбщиеПараметры.Вставить("ПутьКПлатформе", ПутьКПлатформе);
КонецПроцедуры

Процедура УстановитьКаталогПлагинов(Знач ПутьККаталогуПлагинов) Экспорт
	
	ЛогПриложения.Отладка("Устанавливаю каталог плагинов <%1>", ПутьККаталогуПлагинов);
	
	Если ЗначениеЗаполнено(ПутьККаталогуПлагинов) Тогда
	
		МенеджерПлагинов.УстановитьКаталогПлагинов(ПутьККаталогуПлагинов);
	
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьДоменПочты(Знач ДоменПочты) Экспорт
	ОбщиеПараметры.Вставить("ДоменПочты", ДоменПочты);
КонецПроцедуры

Функция ПредустановленныеПлагины() Экспорт
	
	МассивИменПлагинов = Новый Массив;
	МассивИменПлагинов.Добавить("gitsync-plugins");

	Возврат МассивИменПлагинов;

КонецФункции

Функция ПолучитьЛокальныйКаталогДанныхПриложения()

	Если ЗначениеЗаполнено(ОбщийКаталогДанныхПриложения) Тогда
		Возврат ОбщийКаталогДанныхПриложения;
	КонецЕсли;

	СистемнаяИнформация = Новый СистемнаяИнформация;
	ОбщийКаталогДанныхПриложений = СистемнаяИнформация.ПолучитьПутьПапки(СпециальнаяПапка.ЛокальныйКаталогДанныхПриложений);

	ОбщийКаталогДанныхПриложения = ОбъединитьПути(ОбщийКаталогДанныхПриложений, ИмяПриложения());
	Возврат ОбщийКаталогДанныхПриложения;

КонецФункции

Функция КаталогПлагиновПоУмолчанию()
	Возврат ОбъединитьПути(ПолучитьЛокальныйКаталогДанныхПриложения(), "plugins");
КонецФункции

Функция КаталогПлагинов() Экспорт
	Возврат КаталогПлагинов;
КонецФункции

Процедура ОпределитьКаталогПлагинов()

	КаталогПлагинов = "";

	Если УстановитьКаталогИзПеременныхСреды() Тогда

		Возврат;
		
	ИначеЕсли ПроверитьТекущийКаталог() Тогда

		Возврат;

	Иначе

		КаталогПлагинов =  КаталогПлагиновПоУмолчанию();

	КонецЕсли;

КонецПроцедуры

Функция УстановитьКаталогИзПеременныхСреды()
	
	МассивИменПеременныхСреды = "GITSYNC_PLUGINS_PATH GITSYNC_PLUGINS_DIR GITSYNC_PL_DIR";

	МассивПеременныхСреды = СтрРазделить(МассивИменПеременныхСреды, " ", Ложь);

	Для каждого ПеременнаяСреды Из МассивПеременныхСреды Цикл
		
		КаталогПлагинов = ПолучитьПеременнуюСреды(ПеременнаяСреды);

		Если ЗначениеЗаполнено(КаталогПлагинов) Тогда
			Возврат Истина;
		КонецЕсли;

	КонецЦикла;

	Возврат Ложь;

КонецФункции

Функция ПроверитьТекущийКаталог() Экспорт

	РабочийКаталог = ТекущийКаталог();

	ПутьККаталогуПриложения = ОбъединитьПути(РабочийКаталог, ИмяКаталогаПриложения);

	Если НЕ ФС.КаталогСуществует(ПутьККаталогуПриложения) Тогда
		Возврат Ложь;
	КонецЕсли;

	ПутьКФайлуНастройки = ОбъединитьПути(ПутьККаталогуПриложения, ИмяФайлаНастройкиПриложения);

	Если НЕ ФС.ФайлСуществует(ПутьКФайлуНастройки) Тогда
		
		ПрочитатьНастройкиПриложенияИзФайла(ПутьКФайлуНастройки);
		
		Если ЗначениеЗаполнено(КаталогПлагинов) Тогда
		
			Возврат Истина; // Подумать если не задано что делать
		
		КонецЕсли;

	КонецЕсли;

	КаталогПлагинов = ОбъединитьПути(ПутьККаталогуПриложения, ИмяКаталогаПлагинов);

	Если ФС.КаталогСуществует(КаталогПлагинов) Тогда
		ФС.ОбеспечитьКаталог(КаталогПлагинов);
	КонецЕсли;

	Возврат Истина;

КонецФункции

Процедура ПрочитатьНастройкиПриложенияИзФайла(ПутьКФайлуНастройки)
	// TODO	Сделать чтение настройки из файла
КонецПроцедуры

Функция ИмяФайлаНастройкиПакетнойСинхронизации() Экспорт
	Возврат "config.json";
КонецФункции

Процедура ВыполнитьПодпискуПриРегистрацииКомандыПриложения(Команда) Экспорт

	ОбработчикПодписок = МенеджерПлагинов.НовыйМенеджерПодписок();
	ОбработчикПодписок.ПриРегистрацииКомандыПриложения(Команда.ПолучитьИмяКоманды(), Команда);

КонецПроцедуры

Процедура ПодготовитьПлагины() Экспорт
	
	МенеджерПлагинов = Новый МенеджерПлагинов;
	МенеджерПлагинов.УстановитьКаталогПлагинов(КаталогПлагинов());
	МенеджерПлагинов.ЗагрузитьПлагины();
	ВключенныеПлагины = ПрочитатьВключенныеПлагины();
	МенеджерПлагинов.ВключитьПлагины(ВключенныеПлагины);

	ОбщиеПараметры.Вставить("МенеджерПлагинов", МенеджерПлагинов);

КонецПроцедуры

Процедура УстановитьВременныйКаталог(Знач Каталог) Экспорт
		
	Если ЗначениеЗаполнено(Каталог) Тогда
		
		БазовыйКаталог  = Каталог;
		ФайлБазовыйКаталог = Новый Файл(БазовыйКаталог);
		Если Не (ФайлБазовыйКаталог.Существует()) Тогда
			
			СоздатьКаталог(ФайлБазовыйКаталог.ПолноеИмя);
			
		КонецЕсли;
		
		ВременныеФайлы.БазовыйКаталог = ФайлБазовыйКаталог.ПолноеИмя;
		
		// Это специально для 1С
		УстановитьПеременнуюСреды("TEMP", Каталог);
		УстановитьПеременнуюСреды("Temp", Каталог);
		УстановитьПеременнуюСреды("Tmp", Каталог);

	КонецЕсли;

КонецПроцедуры

Функция КаталогПриложения() Экспорт
	
	Если Не СохрКаталогПриложения = Неопределено Тогда
		Возврат СохрКаталогПриложения;
	КонецЕсли;

	ПутьККаталогу = ОбъединитьПути(ТекущийСценарий().Каталог, "..", "..", "..");

	ФайлКаталога = Новый Файл(ПутьККаталогу);
	СохрКаталогПриложения = ФайлКаталога.ПолноеИмя;
	Возврат СохрКаталогПриложения;
КонецФункции

Функция УровеньЛога() Экспорт
	Возврат ЛогПриложения.Уровень();
КонецФункции

Процедура УстановитьРежимОтладкиПриНеобходимости(Знач РежимОтладки) Экспорт
	
	Если РежимОтладки Тогда
		
		Лог().УстановитьУровень(УровниЛога.Отладка);
		МенеджерПлагинов().УстановитьРежимОтладки();

	КонецЕсли;
	
КонецПроцедуры 

Функция Параметры() Экспорт
	Возврат ОбщиеПараметры;
КонецФункции

Функция Лог() Экспорт
	
	Если ЛогПриложения = Неопределено Тогда
		ЛогПриложения = Логирование.ПолучитьЛог(ИмяЛогаПриложения());
		
	КонецЕсли;

	Возврат ЛогПриложения;

КонецФункции

Функция ИмяЛогаПриложения() Экспорт
	Возврат "oscript.app." + ИмяПриложения();
КонецФункции

Функция ИмяПриложения() Экспорт

	Возврат "gitsync";
		
КонецФункции

Функция Версия() Экспорт
	
	Возврат "3.0.0";
			
КонецФункции

Инициализация();

﻿
Процедура ОписаниеКоманды(Команда) Экспорт
	
	Команда.Опция("c commit", Ложь, "закоммитить изменения в git").Флаг();
	
	Команда.Аргумент("VERSION", "", "Номер версии для записи в файл.").ТСтрока();
	Команда.Аргумент("WORKDIR", "", "Каталог исходников внутри локальной копии git-репозитория.")
				.ТСтрока()
				.ВОкружении("GITSYNC_WORKDIR")
				.Обязательный(Ложь)
				.ПоУмолчанию(ТекущийКаталог());
	
	ПараметрыПриложения.ВыполнитьПодпискуПриРегистрацииКомандыПриложения(Команда);

КонецПроцедуры

Процедура ВыполнитьКоманду(Знач Команда) Экспорт
	
	Лог = ПараметрыПриложения.Лог();
	
	НомерВерсии				= Команда.ЗначениеАргумента("VERSION");
	КаталогРабочейКопии		= Команда.ЗначениеАргумента("WORKDIR");

	ВызватьКоммит		= Команда.ЗначениеОпции("commit");

	ОбщиеПараметры = ПараметрыПриложения.Параметры();
	МенеджерПлагинов = ПараметрыПриложения.МенеджерПлагинов();
	
	ВсеПлагины = МенеджерПлагинов.ПолучитьПлагины();

	Распаковщик = Новый МенеджерСинхронизации();
	Распаковщик.ВерсияПлатформы(ОбщиеПараметры.ВерсияПлатформы)
				.ПутьКПлатформе(ОбщиеПараметры.ПутьКПлатформе)
				.ДоменПочтыПоУмолчанию(ОбщиеПараметры.ДоменПочты)
			   .ИсполняемыйФайлГит(ОбщиеПараметры.ПутьКГит)
			   .ПодпискиНаСобытия(ВсеПлагины)
			   .ПараметрыПодписокНаСобытия(Команда.ПараметрыКоманды())
			   .УровеньЛога(ПараметрыПриложения.УровеньЛога());
	
	ФайлВерсий = Новый Файл(ОбъединитьПути(КаталогРабочейКопии, "VERSION"));
	Распаковщик.ЗаписатьФайлВерсийГит(ФайлВерсий.Путь, НомерВерсии);

	Если ВызватьКоммит Тогда
		ГитРепозиторий = Распаковщик.ПолучитьГитРепозиторий(КаталогРабочейКопии);
		ГитРепозиторий.ДобавитьФайлВИндекс(ФайлВерсий.ПолноеИмя);
		ГитРепозиторий.Закоммитить("Изменена версия в файле VERSION");
	КонецЕсли;

	Лог.Информация("Версия установлена");

КонецПроцедуры // ВыполнитьКоманду

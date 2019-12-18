#Использовать "../../core/Классы/internal/bindata"

Перем ЭтоWindows;

Перем ИмяКомандыGitsync;
Перем КаталогДокументации;
Перем Лог;

Процедура ОписаниеКоманды(Команда) Экспорт

    Команда.Аргумент("COMMAND", "", "Команда для вывода подробностей использования").ТСтрока().Обязательный(Ложь);

КонецПроцедуры

Процедура ВыполнитьКоманду(Знач Команда) Экспорт

	ИмяКоманды = Команда.ЗначениеАргумента("COMMAND");

    Если ПустаяСтрока(ИмяКоманды) Тогда
        ВывестиОбщееИспользование();
    Иначе
        ВывестиИспользованиеКоманды(НРег(ИмяКоманды));
    КонецЕсли;

КонецПроцедуры

Процедура ВывестиОбщееИспользование()

    ТекстОбщегоОписания = "
    |  Общее описание сценария использования:
    |
    |  Для начала выполнения синхронизации необходимо выполнить подготовку рабочей копии:
    |   
    |  I Порядок настройки:
    |   
    |  1. Активизация нужных плагинов:
    |     
    |     > %1 plugins enable ИМЯПЛАГИНА
    |      или активизация всех плагинов
    |     > %1 plugins enable -a
    |    
    |     Подробные описание использования команды <plugins>: 
    |   
    |     > %1 usage plugins 
    |    
    |  2. Настройка переменных окружения (можно пропустить и указывать в строке использования): 
    |    
    |    Общие переменные окружения:
    |    *GITSYNC_WORKDIR   - рабочий каталог для команд gitsync
    |    *GITSYNC_V8VERSION - маска версии платформы (8.3, 8.3.5, 8.3.6.2299 и т.п.)
    |    *GITSYNC_TEMP      - путь к каталогу временных файлов
    |    *GITSYNC_VERBOSE   - вывод отладочной информации в процессе выполнения
    |    
    |    Дополнительные переменные окружения можно посмотреть 
    |    в справке соответствующей команды
    |   
    |  II Порядок использования:
    |   
    |  1. Создание рабочей копии (можно пропустить если уже есть):
    |   
    |    Инициализация или клонирование существующего git-репозитория и подготовка начальных данных:
    |     > %1 init 
    |      или 
    |     > %1 clone
    |    
    |    Подробные описание использования: 
    |   
    |     > %1 usage init 
    |      или 
    |     > %1 usage clone
    |   
    |  2. Установка уже синхронизированной версии (если требуется):
    |    
    |     > %1 setversion 
    |     
    |    Подробное описание использования команды <setversion>: 
    |    
    |     > %1 usage setversion
    |   
    |  3. Выполнение синхронизации хранилища 1С с git репозиторием:
    |    
    |     > %1 sync 
    |     
    |    Подробное описание использования команды <sync>: 
    |    
    |     > %1 usage sync
    |";

    ВывестиОписание(ТекстОбщегоОписания);

КонецПроцедуры

Процедура ВывестиИспользованиеКоманды(Знач ИмяКоманды)

    ИмяКомандыСправки = "";

    Если ИмяКоманды = "init"
        или ИмяКоманды = "i" Тогда
        ИмяКомандыСправки = "init";
    ИначеЕсли ИмяКоманды = "clone" 
        или ИмяКоманды = "c" Тогда
        ИмяКомандыСправки = "clone";
    ИначеЕсли ИмяКоманды = "sync" 
        или ИмяКоманды = "s" Тогда
        ИмяКомандыСправки = "sync";
    ИначеЕсли ИмяКоманды = "setversion"
        или ИмяКоманды = "sv" Тогда
        ИмяКомандыСправки = "set-version";
    ИначеЕсли ИмяКоманды = "plugins" 
        или ИмяКоманды = "p" Тогда
        ИмяКомандыСправки = "plugins";
    Иначе
        ИмяКомандыСправки = "usage";
    КонецЕсли;

    ВывестиОписаниеДляКоманды(ИмяКомандыСправки);

КонецПроцедуры

Процедура ВывестиОписание(Знач ТекстОписания)
    
    Консоль = Новый Консоль();
    // ЦветТекстаКонсоли = Консоль.ЦветТекста;
    // Консоль.ЦветТекста = ЦветТекстаКонсоли;
    ИтоговаяСправка = ТекстОписания;// СтрШаблон(ТекстОписания, ИмяКомандыGitsync);

    МассивСтрокВывода = СтрРазделить(ИтоговаяСправка, Символы.ПС);

    Для каждого СтрокаВывода Из МассивСтрокВывода Цикл
        Если СтрНачинаетсяС(СокрЛП(Строкавывода),"*")  Тогда
            СтрокаВывода  =  СтрЗаменить(СтрокаВывода,"*", " ");
            
            // Консоль.ЦветТекста = ЦветаКонсоли().ЦветСписка;
   
            Консоль.ВывестиСтроку(Строкавывода);
            
            // Консоль.ЦветТекста = ЦветТекстаКонсоли;

        ИначеЕсли СтрНачинаетсяС(СокрЛП(Строкавывода),">")  Тогда
            //СтрокаВывода  =  СтрЗаменить(Строкавывода,">", " ");
            
            // Консоль.ЦветТекста = ЦветаКонсоли().ЦветКоманды;
   
            Консоль.ВывестиСтроку(Строкавывода);
            
            // Консоль.ЦветТекста = ЦветТекстаКонсоли;
        Иначе
            Консоль.ВывестиСтроку(Строкавывода);
        КонецЕсли;
    КонецЦикла;

    
    // Консоль.ЦветТекста = ЦветТекстаКонсоли;
    //Консоль.ВывестиСтроку(ИтоговаяСправка);
    Консоль = Неопределено;


КонецПроцедуры

Процедура ВывестиОписаниеДляКоманды(Знач ИмяКоманды)

    ИмяФайла = СтрШаблон("%1.md", ИмяКоманды);

    Если ПараметрыПриложения.ЭтоСборкаEXE() Тогда
        
        ЗагрузчикЗапакованныхФайловGitsync = Новый ЗагрузчикЗапакованныхФайловGitsync;
        ТекстОписанияКоманды = ПрочитатьФайл(ЗагрузчикЗапакованныхФайловGitsync.ПолучитьПутьКФайлу(ИмяФайла));

    Иначе

        КаталогДокументации = ОбъединитьПути(ОбъединитьПути(ТекущийСценарий().Каталог, "..","..", ".."),"docs");
        ТекстОписанияКоманды = ПрочитатьФайл(ОбъединитьПути(КаталогДокументации, ИмяФайла));

    КонецЕсли;
  
    ВывестиОписание(ТекстОписанияКоманды);

КонецПроцедуры

Функция Инициализация()

    СистемнаяИнформация = Новый СистемнаяИнформация;
    ЭтоWindows = Найти(НРег(СистемнаяИнформация.ВерсияОС), "windows") > 0;

    Лог = ПараметрыПриложения.Лог();

КонецФункции

Функция ПрочитатьФайл(Знач ИмяФайла)
	
	Чтение = Новый ЧтениеТекста(ИмяФайла, КодировкаТекста.UTF8);
	Рез  = Чтение.Прочитать();
	Чтение.Закрыть();
	
	Возврат Рез;

КонецФункции // ПрочитатьФайл()

Функция ЦветаКонсоли() Экспорт;
    
    Цвета = Новый Структура;
    // Цвета.Вставить("ЦветСписка", ЦветКонсоли.Желтый);
    // Цвета.Вставить("ЦветКоманды", ЦветКонсоли.Зеленый);
 
    Возврат Цвета;

КонецФункции

Инициализация();
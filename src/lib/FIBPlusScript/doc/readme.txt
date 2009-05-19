{*************************************************}
{                                                 }
{             FIBPlus Script, version 1.8b2       }
{                                                 }
{     Copyright by Nikolay Trifonov, 2003-2006    }
{                                                 }
{           E-mail: t_nick@mail.ru                }
{                                                 }
{*************************************************}

После долгих поисков набора компонент для FibPlus, который бы выполняли мои скрипты
я решил плюнуть на это дело и написать свой. При этом старался обеспечить
максимальную совместимость по свойствам с аналогичными компонентами из IBX, 
но при этом мне необходимо было в своих скриптах выполнять конструкции вроде
"execute procedure", "create or alter", "describe" и т.д., чего небыло в IBX.
Компонент успешно работает в нескольких коммерческих приложениях, например в 
"АТС Тарификатор" (www.atstariff.com), Blazetop (www.blazetop.com).

Данный FibPlus Script предназначен для выполнения скриптов, например:

==========
DECLARE EXTERNAL FUNCTION TIMETOSECONDS 
    TIME
    RETURNS INTEGER BY VALUE
    ENTRY_POINT 'TimeToSeconds' MODULE_NAME 'nntudf';

ALTER PROCEDURE SP_GET_ROUNDMINUTES (
    DURATION TIME)
RETURNS (
    DURATION_ROUNDMINUTES INTEGER)
AS
declare variable duration_hour integer;
declare variable duration_minute integer;
declare variable duration_second integer;
declare variable dontusefirstseconds integer;
BEGIN
  select Z(extract(hour from :duration)), Z(extract(minute from :duration)), Z(extract(second from :duration))
  from rdb$database
  into :duration_hour, :duration_minute, :duration_second;

  SUSPEND;
END ;
=========

Бросьте компонент на форму и заполните свойства DataBase и Transaction.
Можете также заполнить свойства LastDDLQueryLog и LastDMLQueryLog.
Например указать в них путь к текстовым файлам, в которые будут записываться
последние выполняемые команды. Сделано исключительно для удобства нахождения
"какая же команда в моем большом скрипте сбоит".

Для работоспособности модуля на FIBPlus версии ниже 5.0 необходимо 
перенести в FIBDatabase.pas процедуру RemoveDatabase из секции 
protected в секцию public и перекомпилировать FibPlus.


Пример использования:

===
FIBScript1.Script.Assign(ListSQL);
FIBScript1.AutoDDL := False;
if FIBScript1.ValidateScript then FIBScript1.ExecuteScript;
if FIBScript1.Transaction.InTransaction then FIBScript1.Transaction.Commit;
===


Благодарности:
  Serge Buzadzhy, Serg Vostrikov и компании Devrace за отличную библиотеку.
  Dmitriy Kovalenko (Devrace)
  Pavel Shibanov (Devrace)
  Nikolai Voynov
  Vladimir A. Bakhvaloff (за скриптер yascript, откуда был взят образец работы с BLOB)
  Svetlana Bulanova
  Mihail Veselov
  Victor Ivanov (за идею и начатую работу с переработкой describe)

Что нового:

v1.8b2 от 24.01.2006
 1. При выполнении скрипта возникала ошибка <Неверный текст запроса>. (by Mihail Veselov)
 2. Переработана работа с DESCRIBE, теперь полностью поддерживаются многострочные описания.
    (ориг. идея by Victor Ivanov, адаптация и окончательная доработка by автор)

v1.8b1 от 12.07.2005
 1. Исправлены серьезные ошибки при выполнении запросов DML и соединения/создания базы, 
    если не заполнено свойство Database (т.е. если подключение к базе выполняется командами 
    скрипта CONNECT или CREATE DATABASE).
 2. Теперь скриптер понимает, но пока игнорирует команду SET CLIENTLIB.
 3. Если в скрипте в CONNECT не указан пароль, то автоматически используется masterkey.
 4. Исправлена ошибка в обработке синтаксиса команды IBExpert:
    DESCRIBE EXCEPTION EXC_EDITDATA ...;
 5. Иногда возникал AV на правильном скрипте. (by Svetlana Bulanova)
 6. При Connect не верно задавался charset. (by Svetlana Bulanova)
 7. Не чистились параметры на DoCreate. (by Svetlana Bulanova)

v1.7 от 26.02.2005
 1. Добавлен dpk для Delphi7.
 2. Исправлена ошибка в обработке синтаксиса команды IBExpert:
    DESCRIBE DOMAIN T_DOCUM ...;
 3. Исправлена ошибка в обработке GRANT ... PROCEDURE (by Kirov Ilya).

v1.7beta2 от 05.11.2004
 1. public свойство IfDefine.
 2. В скрипте поддерживаются директивы $IFDEF и $ENDIF:
    {$IFDEF INS_VALUE}
       insert into (...) values (...);
    {$ENDIF}
    При этом INS_VALUE должно быть указано в свойстве IfDefine. Например я это делаю, 
    считывая из ini-файла в момент инициализации программы. Если ничего не указать, то скрипт 
    выполняется как было раньше, а строки между IFDEF,ENDIF просто игнорируются.
 3. Исправлена ошибка в обработке синтаксиса таких команд IBExpert:
    DESCRIBE PARAMETER D PROCEDURE USZ_ZN_SDN ...;
    DESCRIBE TRIGGER DOCUM_AU ...;
    DESCRIBE VIEW VW_DOCUM ...;

v1.6 от 12.09.2004
 1. Неправильно работал SET BLOBFILE.
 2. В TMappedMemoryStream не закрывался fHandle.
 3. public свойство BlobFileName.

v1.5 от 25.07.2004
 1. public свойство SQLParser и везде по тексту переход на его использование.
 2. Разделение на токены шло только по пробелу, добавлены #13,#9,#10,#0,'(',')'
 3. Ошибка парсера при встрече сиквела DESCRIBE PROCEDURE PARAMETRE.
 4. В TokenizeNextLine немного изменен момент с выходом из парсинга 
    процедуры/триггера со стандартным терминатором для получения корректного 
    значения CurrentLine.
 5. Процедура DoConnect - неправильно определяла пароль и чарсет.
 6. Процедура DoCreate - убрано пересоздание БД при коннекте.
 7. Изменен порядок вызова FOnParse в TpFIBScript.ParserParse.
 8. Rollback при останове скриптера по ошибке.
 9. Добавлена обработка блоб-файлов, которые поддерживает IBExpert. (идея 
    взята с модуля yascript by Vladimir A. Bakhvaloff).
10. Добавлен компонент pFIBExtract (с дополнительной настройкой опций, а также 
    поддержкой функции describe IBExpert).

v1.4 от 28.05.2004
 1. Доработки парсера.
 2. Убран из uses IB_Services за ненадобностью.
 3. В TpFIBParseKind добавлен stmtALTER - для ALTER DATABASE ADD - пока 
    необрабатывается.
 4. Свойство property EndLine: Integer read FEndLine; - без него очень 
    много приходилось делать телодвижений для вычисления последней строки 
    текущего стейтмента.
 5. Немного изменена обработка для CurrentLine (ScriptIndex) - не 
    корректно устанавливалась строка начала стейтмента - захватывала 
    лидирующие комментарии.
 6. Поддержка смены терминатра (SET TERM).
 7. Введена поддержка RECREATE для их распознавания как DDL стейтментов.
 8. Введена обработка CREATE /* */ PROCEDURE ...
 9. Правка бага при котором не корректно распознавалось EXECUTE PROCEDURE 
    внутри триггеров и процедур.

v1.3 от 20.05.2004
 1. Были проблемы с выполнением команд ALTER TRIGGER ... INACTIVE/ACTIVE.
 2. Не всегда логировались DML команды.

v1.2 от 28.04.2004
 1. Добавлено выполнение команды DESCRIBE, синтаксис которой идентичен 
    синтаксису в модуле IBEScript из IBExpert. Теперь для того, чтобы 
    сделать описание обьекта, достаточно написать в скрипте 
    для таблицы:
    DESCRIBE TABLE DATASETS_INFO 'Информация об источниках данных';
    и для поля: 
    DESCRIBE FIELD NAME TABLE PRODUCTS 'Наименование';
    FibScript сам подменит эти команды на соответствующие запросы к
    системным таблицам.

v1.1 от 21.02.2004
 1. Исправлена ошибка с выполнением некоторых DML запросов.


Nikolay Trifonov
E-mail: t_nick@mail.ru
http://www.atstariff.com/fibscript/

//Если определена переменная USEMEMORYCRYPTDLL, то надо определить USENEWMYSQLTYPES
//Иногда не определена USENEWMYSQLTYPES и при старте встроенного mysql-сервера возникает ошибка:
//A call to an mysql_server_init failed
//из-за того, что передаются параметры инициализации в специализированную сборку, которые ей не известны
{$ifdef USEMEMORYCRYPTDLL}
  {$ifndef USENEWMYSQLTYPES}
    {$define USENEWMYSQLTYPES}
  {$endif}
{$endif}

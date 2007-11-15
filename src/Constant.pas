unit Constant;

interface

uses Graphics;

const
  JUNK_CLR	= $00669ef2;
	AWAIT_CLR	= $00b8ff71;
	LEADER_CLR	= clMoneyGreen;
	REG_CLR		= clLime;
	COMPACT_PERIOD	= 3;
  VITALLYIMPORTANT_CLR = clGreen;
  //“екуща€ верси€ базы данных дл€ работы программ
  CURRENT_DB_VERSION = 44;

	JET_SCHEMA_USERROSTER = '{947bb102-5d43-11d1-bdbf-00c04fb92675}';

  // ол-во заказа, котором отображаетс€ предупреждение
  WarningOrderCount : Integer = 1000;
  //ћаксимальное кол-во заказа, которое может прин€ть сервер
  MaxOrderCount : Integer = 65535;

implementation

end.

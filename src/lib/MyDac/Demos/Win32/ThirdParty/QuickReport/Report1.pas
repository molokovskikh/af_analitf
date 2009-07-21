unit Report1;

interface

uses Windows, SysUtils, Messages, Classes, Graphics, Controls, StdCtrls, ExtCtrls, Forms,
  Quickrpt, QRCtrls, Db, MemDS, DBAccess, MyAccess;

type
  TqrReport1 = class(TQuickRep)
    QRBand1: TQRBand;
    QRBand2: TQRBand;
    QRDBText1: TQRDBText;
    QRDBText2: TQRDBText;
    QRDBText3: TQRDBText;
    quEmp: TMyQuery;
    QRSubDetail1: TQRSubDetail;
    QRDBText4: TQRDBText;
    quDept: TMyQuery;
    QRLabel1: TQRLabel;
    QRDBText5: TQRDBText;
    QRDBText7: TQRDBText;
    QRDBText8: TQRDBText;
    QRDBText9: TQRDBText;
    QRDBText10: TQRDBText;
    QRShape1: TQRShape;
    QRSysData1: TQRSysData;
    QRBand3: TQRBand;
    QRLabel2: TQRLabel;
    GroupFooterBand1: TQRBand;
    GroupHeaderBand1: TQRBand;
    QRLabel3: TQRLabel;
    QRLabel4: TQRLabel;
    QRLabel5: TQRLabel;
    QRLabel6: TQRLabel;
    QRLabel7: TQRLabel;
    QRLabel8: TQRLabel;
    QRLabel9: TQRLabel;
    QRDBText6: TQRDBText;
    QRExpr1: TQRExpr;
    QRExpr2: TQRExpr;
    QRShape2: TQRShape;
    QRLabel10: TQRLabel;
    QRLabel11: TQRLabel;
    QRLabel12: TQRLabel;
    DataSource1: TDataSource;
    procedure QuickRepBeforePrint(Sender: TCustomQuickRep;
      var PrintReport: Boolean);
    procedure QuickRepAfterPreview(Sender: TObject);
  private

  public

  end;

var
  qrReport1: TqrReport1;

implementation
uses
  Main;

{$R *.DFM}

procedure TqrReport1.QuickRepBeforePrint(Sender: TCustomQuickRep;
  var PrintReport: Boolean);
begin
  quDept.Open;
  quEmp.Open;
end;

procedure TqrReport1.QuickRepAfterPreview(Sender: TObject);
begin
  quEmp.Close;
  quDept.Close;
end;

end.

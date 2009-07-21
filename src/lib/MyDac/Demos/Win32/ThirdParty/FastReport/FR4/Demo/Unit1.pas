unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Db, DBTables, frxDesgn, frxClass, frxDCtrl, frxBDEComponents,
  frxChart, frxRich, frxBarcode, ImgList, ComCtrls, ExtCtrls, frxOLE,
  frxCross, frxDMPExport, frxExportImage, frxExportRTF, frxExportTXT,
  frxExportXML, frxExportXLS, frxExportHTML, frxGZip, frxExportPDF,
  frxMYDACComponents, frxDACComponents;

type
  TForm1 = class(TForm)
    DesignB: TButton;
    frxDesigner1: TfrxDesigner;
    frxBarCodeObject1: TfrxBarCodeObject;
    frxRichObject1: TfrxRichObject;
    frxChartObject1: TfrxChartObject;
    frxDialogControls1: TfrxDialogControls;
    ImageList1: TImageList;
    PreviewB: TButton;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    frxOLEObject1: TfrxOLEObject;
    frxCrossObject1: TfrxCrossObject;
    frxDotMatrixExport1: TfrxDotMatrixExport;
    frxBMPExport1: TfrxBMPExport;
    frxJPEGExport1: TfrxJPEGExport;
    frxTIFFExport1: TfrxTIFFExport;
    frxTXTExport1: TfrxTXTExport;
    frxHTMLExport1: TfrxHTMLExport;
    frxXLSExport1: TfrxXLSExport;
    frxXMLExport1: TfrxXMLExport;
    frxRTFExport1: TfrxRTFExport;
    frxGZipCompressor1: TfrxGZipCompressor;
    frxMYDACComponents1: TfrxMYDACComponents;
    frxReport1: TfrxReport;
    procedure DesignBClick(Sender: TObject);
    procedure PreviewBClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    WPath: String;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormShow(Sender: TObject);
begin
  WPath := ExtractFilePath(Application.ExeName);
  TfrxPDFExport.Create(nil);
end;

procedure TForm1.DesignBClick(Sender: TObject);
begin
  frxReport1.DesignReport;
end;

procedure TForm1.PreviewBClick(Sender: TObject);
begin
  frxReport1.ShowReport;
end;

end.

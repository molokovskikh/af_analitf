unit DownloadAppFiles;

interface

uses
  SysUtils,
  Classes,
  Contnrs,
  StrUtils,
  Windows,
  U_ExchangeLog,
  AProc;

type
  TDownloadAppFileType = (dfCritical, dfNormal);
  TDownloadAppFileTypes = set of TDownloadAppFileType;

  TDownloadAppFile = class
   public
    FileName : String;
    FileHash : String;
    FileType : TDownloadAppFileType;
    NeedDownload : Boolean;
    constructor Create(aFileName, aFileHash : String; aFileType : TDownloadAppFileType);
    procedure Check;
  end;

  TDownloadAppFilesHelper = class
   protected
    function NeedDownloadByTypes(types : TDownloadAppFileTypes) : Boolean;
   public
    CheckedFiles : TObjectList;
    constructor Create();
    function ProcessCheckDownload() : Boolean;
    function NeedDownload() : Boolean;
    function NeedDownloadCritical() : Boolean;
  end;

var
  DownloadAppFilesHelper : TDownloadAppFilesHelper;

implementation

{ TDownloadAppFile }

procedure TDownloadAppFile.Check;
var
  fullFileName,
  realFileHash : String;
begin
  NeedDownload := True;
  fullFileName := ExePath + FileName;
  if FileExists(fullFileName) then begin
    realFileHash := GetFileHash(fullFileName);
    NeedDownload := not AnsiSameText(realFileHash, FileHash);
  end;
end;

constructor TDownloadAppFile.Create(aFileName, aFileHash: String;
  aFileType: TDownloadAppFileType);
begin
  FileName := aFileName;
  FileHash := aFileHash;
  FileType := aFileType;
  NeedDownload := False;
end;

{ TDownloadAppFilesHelper }

constructor TDownloadAppFilesHelper.Create;
begin
  CheckedFiles := TObjectList.Create(True);
  CheckedFiles.Add(TDownloadAppFile.Create('libeay32.dll', '791361C065BF50F4309A59E327DBC261', dfCritical));
  CheckedFiles.Add(TDownloadAppFile.Create('ssleay32.dll', '6E56CDE5CA2855353FEDAFE7CABB4B58', dfCritical));
  CheckedFiles.Add(TDownloadAppFile.Create('7-zip32.dll', 'D9901FE21B94400800FE250BFE587F9A', dfCritical));
  CheckedFiles.Add(TDownloadAppFile.Create('Eraser.dll', '8C38B469DBE39B8094B0537A528933AD', dfCritical));
  CheckedFiles.Add(TDownloadAppFile.Create('RollbackAF.exe', '52C9839B7098BF564EB1046CAACF8840', dfCritical));

  CheckedFiles.Add(TDownloadAppFile.Create('Frf\BigCostTicket.frf', '55677D04BB2617A9C3F7B3AD611C4AA2', dfNormal));
  CheckedFiles.Add(TDownloadAppFile.Create('Frf\BigRackCard.frf', '3FC2F869B1BDC186614E719EA7E10B62', dfNormal));
  CheckedFiles.Add(TDownloadAppFile.Create('Frf\Core.frf', '88A6C956D5A529C15A0A24B3EF064E6D', dfNormal));
  CheckedFiles.Add(TDownloadAppFile.Create('Frf\CoreFirm.frf', '7E7BC36A8C3080F5F03F3AA953CF39FE', dfNormal));
  CheckedFiles.Add(TDownloadAppFile.Create('Frf\Defectives.frf', '33A7863A809813412006E0280407006E', dfNormal));
  CheckedFiles.Add(TDownloadAppFile.Create('Frf\Invoice.frf', '8B7C50C3E9B16269718924C9CAF2BF9E', dfNormal));
  CheckedFiles.Add(TDownloadAppFile.Create('Frf\Orders.frf', 'FC2AD6110835ED2B7AAE60DDEDEE45FD', dfNormal));
  CheckedFiles.Add(TDownloadAppFile.Create('Frf\RackCard.frf', '87456D2492CDB0A287BACEEFE7010122', dfNormal));
  CheckedFiles.Add(TDownloadAppFile.Create('Frf\Reestr.frf', '1A18274DE1984B4073930D095898EA19', dfNormal));
  CheckedFiles.Add(TDownloadAppFile.Create('Frf\SmallTicket.frf', '6F72BE7DCB7D425BD5907A5DDD3C4CE7', dfNormal));
  CheckedFiles.Add(TDownloadAppFile.Create('Frf\Summary.frf', '633871AE6F05799F31A6C4D0C93B110E', dfNormal));
  CheckedFiles.Add(TDownloadAppFile.Create('Frf\Ticket.frf', 'A811D66F4EC24D486AA912235AA0CEDD', dfNormal));
  CheckedFiles.Add(TDownloadAppFile.Create('Frf\Waybill.frf', 'C077ADA72C2E1FE5FC232CF19D5206A6', dfNormal));
end;

function TDownloadAppFilesHelper.NeedDownload: Boolean;
begin
  Result := NeedDownloadByTypes([dfCritical, dfNormal]);
end;

function TDownloadAppFilesHelper.NeedDownloadByTypes(
  types: TDownloadAppFileTypes): Boolean;
var
  I : Integer;
begin
  Result := False;
  for I := 0 to CheckedFiles.Count-1 do
    if (TDownloadAppFile(CheckedFiles[i]).FileType in types) and TDownloadAppFile(CheckedFiles[i]).NeedDownload then begin
      Result := True;
      Exit;
    end;
end;

function TDownloadAppFilesHelper.NeedDownloadCritical: Boolean;
begin
  Result := NeedDownloadByTypes([dfCritical]);
end;

function TDownloadAppFilesHelper.ProcessCheckDownload: Boolean;
var
  I : Integer;
begin
  for I := 0 to CheckedFiles.Count-1 do
    TDownloadAppFile(CheckedFiles[i]).Check;

  Result := NeedDownload();
end;

initialization
  DownloadAppFilesHelper := TDownloadAppFilesHelper.Create;
end.

unit RecThread;

interface

uses Classes, SysUtils;

type
  TReclameThread = class(TThread)
	Terminated: boolean;
  private
    { Private declarations }
  protected
    procedure Execute; override;
  end;

implementation

uses Exchange, DModule, AProc;

procedure TReclameThread.Execute;
var
	FileStream: TFileStream;
	ReclameURL: string;
	RegionCode: string;
begin
	Terminated := False;
	RegionCode := DM.adtClients.FieldByName( 'RegionCode').AsString;
	ReclameURL := StringReplace( DM.adtReclame.FieldByName( 'ReclameURL').AsString, '#',
		RegionCode, [rfReplaceAll, rfIgnoreCase]);
	try
		if ExchangeForm.HTTPReclame.Host = '' then exit;
		ExchangeForm.HTTPReclame.Head( ReclameURL);
		if ExchangeForm.HTTPReclame.Response.LastModified <=
			DM.adtReclame.FieldByName( 'UpdateDateTime').AsDateTime then
		begin
			Terminated := True;
			exit;
		end;
	except
	end;

	FileStream := TFileStream.Create( ExePath + SDirIn + '\r' + RegionCode + '.zip',
		fmCreate or fmOpenWrite);
	try
		ExchangeForm.HTTPReclame.Get( ReclameURL, FileStream);
		DM.adtReclame.Edit;
		DM.adtReclame.FieldByName( 'UpdateDateTime').AsDateTime := Now;
		DM.adtReclame.Post;
	except
	end;
	if FileStream.Size = 0 then
	begin
		FileStream.Free;
		DeleteFile( ExePath + SDirIn + '\r' + RegionCode + '.zip');
	end
	else
		FileStream.Free;
	Terminated := True;
end;

end.

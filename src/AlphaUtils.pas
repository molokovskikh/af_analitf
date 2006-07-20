unit AlphaUtils;

interface

uses
  SysUtils, Windows, Types, Controls, Classes, Graphics, CommCtrl, Consts;

type
  PRGBArray=^TRGBArray;
  TRGBArray=array[0..1000000] of TRGBTriple;
     {  Вместо 1000000 может быть любое число, даже 0, только тогда придётся
        отключить проверку диапазона. Экземпляры массивов этого типа всё равно
        не создаются  }
        

function Set32BPP: boolean;
function GetImageListAlpha( Owner: TComponent; ResPath: string; BaseIndex: integer; WH: integer): TImageList;
procedure ConvertTo32BitImageList(const ImageList: TImageList);
procedure LoadToImageList(const ImageList: TImageList; ResPath: String; BaseIndex: Integer);
procedure ProduceAlphaBlendRect(SearchText, DisplayText : String; Canvas: TCanvas; Rect: TRect; BM : TBitmap);
procedure AlphaBlendRect(Canvas: TCanvas; Rect: TRect; BlendColor: TColor; BM : TBitmap);




implementation

function IsWinXP: boolean;
var
	Version: DWORD;
	Major, Minor: DWORD;
begin
	Version := GetVersion;
	Major := DWORD( LOBYTE( LOWORD( Version)));
	Minor := DWORD( HIBYTE( LOWORD( Version)));
	result := False;

	if (( Version < $80000000) and                 // The OS is a NT family
		( Major >= 5) and ( Minor >= 1))       // Windows NT 5.1 is an Windows XP version
		then result := True;
end;

function ScreenBPP: integer;
var
	dc: HDC;
begin
	// Возвращает количество битов на точку в данном режиме
	result := 0;
	dc := GetDC( 0);
	if ( dc <> 0) then
	begin
		result := GetDeviceCaps( dc, BITSPIXEL);
		ReleaseDC( 0, dc);
	end;
end;

function Set32BPP: boolean;
begin
	result := ( IsWinXP and ( ScreenBPP >= 32));
end;

function GetImageListAlpha( Owner: TComponent; ResPath: string; BaseIndex: integer; WH: integer): TImageList;
var
	icon: TIcon;
	count: integer;
	hi: HICON;
	bm: TBitmap;
begin
	result := TImageList.Create( Owner);
	result.Width := WH;
	result.Height := WH;
	result.BlendColor := clFuchsia;

	count := 0;
	hi := LoadIcon( GetModuleHandle( PChar( ResPath)),
		MakeIntResource( BaseIndex + count));
	while ( hi <> 0) and ( count < 100) do
	begin
		icon := TIcon.Create;
		icon.Handle := hi;

		if Set32BPP then result.AddIcon( icon)
		else
		begin
			icon.Transparent := True;
			bm := TBitmap.Create;
			bm.Canvas.Brush.Color := clFuchsia;
			bm.Width := icon.Width;
			bm.Height := icon.Height;
			bm.Canvas.Draw( 0, 0, icon);
			result.AddMasked( bm, clFuchsia);
		end;
		inc( count);
		hi := LoadIcon( GetModuleHandle( PChar( ResPath)),
			MakeIntResource( BaseIndex + count));
	end;

end;

procedure ConvertTo32BitImageList(const ImageList: TImageList);
const
  Mask: array[Boolean] of Longint = (0, ILC_MASK);
var
  TemporyImageList: TImageList;
begin
  if Assigned(ImageList) then
  begin
    TemporyImageList := TImageList.Create(nil);
    try
      TemporyImageList.Assign(ImageList);
      with ImageList do
      begin
        ImageList.Handle := ImageList_Create(Width, Height, ILC_COLOR32 or Mask[Masked], 0, AllocBy);
        if not ImageList.HandleAllocated then
        begin
          raise EInvalidOperation.Create(SInvalidImageList);
        end;
      end;
      ImageList.AddImages(TemporyImageList);
    finally
      TemporyImageList.Free;
    end;
  end;
end;

procedure LoadToImageList(const ImageList: TImageList; ResPath: String; BaseIndex: Integer);
var
	icon: TIcon;
	count: integer;
	hi: HICON;
begin
  ImageList.Clear;
  ConvertTo32BitImageList(ImageList);
	count := 0;
  BaseIndex := 100;
	hi := LoadIcon( GetModuleHandle( PChar(ResPath) ), MakeIntResource( BaseIndex + count));
	while ( hi <> 0) and ( count < 100) do
	begin
		icon := TIcon.Create;
		icon.Handle := hi;
    ImageList.AddIcon( icon );
		inc( count);
		hi := LoadIcon( GetModuleHandle( PChar(ResPath) ), MakeIntResource( BaseIndex + count));
	end;
end;

procedure AlphaBlendRect(Canvas: TCanvas; Rect: TRect;
  BlendColor: TColor; BM : TBitmap);
var
  Transparency : Integer;
  CW,CH :Integer;  //  размеры клиентской части окна
  X,Y:Integer;   //  Нужно для организации циклов
  SL:PRGBArray;  //  Указатель на строку пикселей
begin
  Transparency := 60;
  CW := Rect.Right - Rect.Left;
  CH := Rect.Bottom - Rect.Top;
  BM.Width:=CW;          //  Ну, это даже не интересно рассказывать...
  BM.Height:=CH;         //  Просто готовим картинку к тому, что сейчас будем рисовать
  BM.PixelFormat:=pf24bit;

  BM.Canvas.CopyRect(Classes.Rect(0, 0, CW, CH), Canvas, Rect);

  for Y:=0 to CH-1 do   //  А в этих циклах на записанный нами кусок экрана
  begin              //  Накладывается светофильтр
    SL:=BM.ScanLine[Y];
    for X:=0 to CW-1 do
    begin
      SL[X].rgbtRed:=(Transparency*SL[X].rgbtRed+(100-Transparency)*GetRValue(BlendColor)) div 100;
      SL[X].rgbtGreen:=(Transparency*SL[X].rgbtGreen+(100-Transparency)*GetGValue(BlendColor)) div 100;
      SL[X].rgbtBlue:=(Transparency*SL[X].rgbtBlue+(100-Transparency)*GetBValue(BlendColor)) div 100
       {
          Взято отсюда: http://www.delphisources.ru/forum/showthread.php?p=1095

          Предыдущие три строчки - реализация алгоритма смешения цветов
          Pr:=(Pa*Wa+Pb*Wb)/(Wa+Wb), где Pr - результирующий цвет,
          Pa и Pb - исходные цвета, Wa и Wb - веса этих цветов.
          У нас в качестве Pa берётся цвет пикселя скопированной с экрана картинки,
          В качестве Pb - заранее заданный цвет TranspColor, Wa=Transparency,
          Wb=100-Transparency. Очевидно, что эту операцию необходимо выполнить для
          каждого из основных цветов в отдельности.
          Здесь открывается широкое поле для деятельности. Можно, например, сделать
          Transparency не постоянным, а зависящим от координаты - получится градиентная
          прозрачность. Или можно в качестве Pb взять не фиксированный цвет, а цвет
          пикселя другой картинки - получится окно, фоном которого служит
          полупрозрачная картинка. В конце концов, можно изменить алгоритм смешения
          цветов, и тогда откроются новые возможности.

          Кстати, вот пример градиентной прозрачности:
            SL[X].rgbtRed:=((CH-Y)*SL[X].rgbtRed+Y*GetRValue(TranspColor)) div CH;
            SL[X].rgbtGreen:=((CH-Y)*SL[X].rgbtGreen+Y*GetGValue(TranspColor)) div CH;
            SL[X].rgbtBlue:=((CH-Y)*SL[X].rgbtBlue+Y*GetBValue(TranspColor)) div CH;
          Хочу добавить, что это смотрится нормально только в режимах True Color.
          High Color для этого недостаточно. А в режимах, худших, чем High Color,
          полупрозрачные окна выглядят страшнее, чем ядерная война.
       }
    end;
  end;

  Canvas.Draw(Rect.Left, Rect.Top, BM);
end;

procedure ProduceAlphaBlendRect(SearchText, DisplayText : String; Canvas: TCanvas; Rect: TRect; BM : TBitmap);
var
  R : TRect;
  TextPos : Integer;
  PreTextWidth, SearchTextWidth : Integer;
  SearchLen : Integer;
begin
  SearchLen := Length(SearchText);
  if SearchLen > 0 then begin
    TextPos := AnsiPos(AnsiUpperCase(SearchText), AnsiUpperCase(DisplayText));
    if TextPos > 0 then begin
      R := Rect;
      InflateRect(R, -1, -1);
      PreTextWidth := Canvas.TextWidth( Copy(DisplayText, 1, TextPos-1) );
      SearchTextWidth := Canvas.TextWidth( Copy(DisplayText, TextPos, SearchLen) );
      R := Classes.Rect(R.Left + PreTextWidth, R.Top, R.Left + PreTextWidth + SearchTextWidth + 1, R.Bottom);
      AlphaBlendRect(Canvas, R, clSkyBlue, BM);
    end;
  end;
end;

end.

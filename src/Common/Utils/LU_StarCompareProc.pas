unit LU_StarCompareProc;

interface

// Cравнение по шаблону двух строк, второй параметр функции - шаблон;
// символ шаблона '*' - выступает шаблоном только как последний символ;
// 'ABC' = 'AB*'; 'AB'='AB*'; 'AB=AB'; 'ABCDE = AB*'; ''='';
function StarMatch ( AString : string; APattern : string ) : boolean;

implementation

function StarMatch ( AString : string; APattern : string ) : boolean;
var
  len_AString, len_APattern : integer;
begin
  len_AString := length (AString);
  len_APattern := length (APattern);

  if (len_AString = 0) and (len_APattern = 0) then begin
    result := true;
    exit;
  end;

  if (len_AString = 0) or (len_APattern = 0) then begin
    result := false;
    exit;
  end;

  if APattern[len_APattern] <> '*' then begin
    result := AString = APattern;
    exit;
  end;

  result := copy (AString, 1, len_APattern - 1) =
            copy (APattern, 1, len_APattern - 1);

end;

end.

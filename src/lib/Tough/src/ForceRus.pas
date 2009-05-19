unit ForceRus;

interface

const
	RusKeys	= 'àáâãäå¸æçèéêëìíîïğñòóôõö÷øùúûüışÿ' +
		'ÀÁÂÃÄÅ¨ÆÇÈÉÊËÌÍÎÏĞÑÒÓÔÕÖ×ØÙÚÛÜİŞß';
	EngKeys	= 'f,dult`;pbqrkvyjghcnea[wxio]sm''.z' +
		'F<DULT~:PBQRKVYJGHCNEA{WXIO}SM">Z';

type

TForceRus = class( TObject)
	constructor Create;
	destructor Destroy; override;

	function DoIt( AStr: string): string;
private
	Keyboard: array of char;
end;

implementation

{ TForceRus }

constructor TForceRus.Create;
var
	i, max: integer;
begin
	max := 0;
	for i := 1 to Length( EngKeys) do
	begin
		if max < Ord( EngKeys[ i]) then
		begin
			max := Ord( EngKeys[ i]);
			SetLength( Keyboard, max + 1);
		end;
		Keyboard[ Ord( EngKeys[ i])] := RusKeys[ i];
	end;
end;

destructor TForceRus.Destroy;
begin
	SetLength( Keyboard, 0);
end;

function TForceRus.DoIt( AStr: string): string;
var
	i: integer;
begin
	result := '';
	for i := 1 to Length( AStr) do
		if ( Ord( AStr[ i]) < Length( Keyboard)) and
			( Keyboard[ Ord( AStr[ i])] <> #0) then
			result := result + Keyboard[ Ord( AStr[ i])]
                else result := result + AStr[ i];
end;

end.

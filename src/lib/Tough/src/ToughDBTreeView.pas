unit ToughDBTreeView;

interface

uses
	SysUtils, Classes, Controls, ComCtrls, DB;

type
TToughDBTreeView = class;

TTreeDataLink = class( TDataLink)
private
	FTree: TToughDBTreeView;
protected
public
	constructor Create( ATree: TToughDBTreeView);
	destructor Destroy; override;
	property Tree: TToughDBTreeView read FTree;
end;

TToughDBTreeView = class( TTreeView)
private
	FL1DataSource: TDataSource;
	FL2DataSource: TDataSource;
	FL1FieldName: string;
	FL2FieldName: string;

	function GetDataSource1: TDataSource;
	procedure SetDataSource1( Value: TDataSource);
	function GetDataSource2: TDataSource;
	procedure SetDataSource2( Value: TDataSource);
protected
public
published
	property Level1DataSource: TDataSource read GetDataSource1 write SetDataSource1;
	property Level2DataSource: TDataSource read GetDataSource2 write SetDataSource2;
	property Level1FieldName: string read FL1FieldName write FL1FieldName;
	property Level2FieldName: string read FL2FieldName write FL2FieldName;
end;

procedure Register;

implementation

procedure Register;
begin
	RegisterComponents( 'Tough', [ TToughDBTreeView]);
end;

{ TTreeDataLink }

constructor TTreeDataLink.Create(ATree: TToughDBTreeView);
begin
	inherited Create;
	FTree := ATree;
	VisualControl := True;
end;

destructor TTreeDataLink.Destroy;
begin
//	ClearMapping;
	inherited Destroy;
end;

{ TToughDBTreeView }

function TToughDBTreeView.GetDataSource1: TDataSource;
begin
	result := FL1DataSource;
end;

function TToughDBTreeView.GetDataSource2: TDataSource;
begin
	result := FL2DataSource;
end;

procedure TToughDBTreeView.SetDataSource1( Value: TDataSource);
begin
	if Value = FL1DataSource then exit;
	FL1DataSource := Value;
end;

procedure TToughDBTreeView.SetDataSource2( Value: TDataSource);
begin
	if Value = FL2DataSource then exit;
	FL2DataSource := Value;
end;

end.

unit DataSetHelper;

interface

uses
  DB;

type
  TDataSetHelper = class
   public
    class function AddLargeIntField(dataSet : TDataSet; FieldName : String) : TLargeintField;
    class function AddStringField(dataSet : TDataSet; FieldName : String) : TStringField; overload;
    class function AddStringField(dataSet : TDataSet; FieldName : String; Size : Integer) : TStringField; overload;
    class function AddIntegerField(dataSet : TDataSet; FieldName : String) : TIntegerField;
    class function AddMemoField(dataSet : TDataSet; FieldName : String) : TMemoField;
    class function AddFloatField(dataSet : TDataSet; FieldName : String) : TFloatField;
    class function AddBooleanField(dataSet : TDataSet; FieldName : String) : TBooleanField;
    class function AddSmallintField(dataSet : TDataSet; FieldName : String) : TSmallintField;
    class function AddDateTimeField(dataSet : TDataSet; FieldName : String) : TDateTimeField;
    class function AddDateField(dataSet : TDataSet; FieldName : String) : TDateField;
    class function AddCalculatedFloatField(dataSet : TDataSet; FieldName : String) : TFloatField;
    class function AddCalculatedCurrencyField(dataSet : TDataSet; FieldName : String) : TCurrencyField;
    class procedure SetDisplayFormat(dataSet : TDataSet; fieldNames : array of string);
  end;

implementation

{ TDataSetHelper }

class function TDataSetHelper.AddLargeIntField(
  dataSet: TDataSet; FieldName : String): TLargeintField;
begin
  Result := TLargeintField.Create(dataSet);
  Result.fieldname := FieldName;
  Result.Dataset := dataSet;
end;

class function TDataSetHelper.AddStringField(dataSet: TDataSet;
  FieldName: String): TStringField;
begin
  Result := TStringField.Create(dataSet);
  Result.fieldname := FieldName;
  Result.Dataset := dataSet;
end;

class function TDataSetHelper.AddIntegerField(dataSet: TDataSet;
  FieldName: String): TIntegerField;
begin
  Result := TIntegerField.Create(dataSet);
  Result.fieldname := FieldName;
  Result.Dataset := dataSet;
end;

class function TDataSetHelper.AddMemoField(dataSet: TDataSet;
  FieldName: String): TMemoField;
begin
  Result := TMemoField.Create(dataSet);
  Result.fieldname := FieldName;
  Result.Dataset := dataSet;
end;

class function TDataSetHelper.AddFloatField(dataSet: TDataSet;
  FieldName: String): TFloatField;
begin
  Result := TFloatField.Create(dataSet);
  Result.fieldname := FieldName;
  Result.Dataset := dataSet;
end;

class function TDataSetHelper.AddBooleanField(dataSet: TDataSet;
  FieldName: String): TBooleanField;
begin
  Result := TBooleanField.Create(dataSet);
  Result.fieldname := FieldName;
  Result.Dataset := dataSet;
end;

class function TDataSetHelper.AddSmallintField(dataSet: TDataSet;
  FieldName: String): TSmallintField;
begin
  Result := TSmallintField.Create(dataSet);
  Result.fieldname := FieldName;
  Result.Dataset := dataSet;
end;

class function TDataSetHelper.AddDateTimeField(dataSet: TDataSet;
  FieldName: String): TDateTimeField;
begin
  Result := TDateTimeField.Create(dataSet);
  Result.fieldname := FieldName;
  Result.Dataset := dataSet;
end;

class function TDataSetHelper.AddCalculatedCurrencyField(dataSet: TDataSet;
  FieldName: String): TCurrencyField;
begin
  Result := TCurrencyField(dataSet.FindField(FieldName));
  if not Assigned(Result) then begin
    Result := TCurrencyField.Create(dataSet);
    Result.fieldname := FieldName;
    Result.FieldKind := fkCalculated;
    Result.Calculated := True;
    Result.DisplayFormat := '0.00;;';
    Result.Dataset := dataSet;
  end;
end;

class function TDataSetHelper.AddCalculatedFloatField(dataSet: TDataSet;
  FieldName: String): TFloatField;
begin
  Result := TFloatField(dataSet.FindField(FieldName));
  if not Assigned(Result) then begin
    Result := TFloatField.Create(dataSet);
    Result.fieldname := FieldName;
    Result.FieldKind := fkCalculated;
    Result.Calculated := True;
    Result.DisplayFormat := '0.00;;';
    Result.Dataset := dataSet;
  end;
end;

class procedure TDataSetHelper.SetDisplayFormat(dataSet: TDataSet;
  fieldNames: array of string);
var
  I : Integer;
  field : TField;
begin
  for I := Low(fieldNames) to High(fieldNames) do
  begin
    field := dataSet.FindField(fieldNames[i]);
    if Assigned(field) and (field is TFloatField) then
      TFloatField(field).DisplayFormat := '0.00;;';
  end;
end;

class function TDataSetHelper.AddStringField(dataSet: TDataSet;
  FieldName: String; Size: Integer): TStringField;
begin
  Result := AddStringField(dataSet, FieldName);
  Result.Size := Size;
end;

class function TDataSetHelper.AddDateField(dataSet: TDataSet;
  FieldName: String): TDateField;
begin
  Result := TDateField.Create(dataSet);
  Result.fieldname := FieldName;
  Result.Dataset := dataSet;
end;

end.

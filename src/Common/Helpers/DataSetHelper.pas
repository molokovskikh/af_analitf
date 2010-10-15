unit DataSetHelper;

interface

uses
  DB;

type
  TDataSetHelper = class
   public
    class function AddLargeIntField(dataSet : TDataSet; FieldName : String) : TLargeintField;
    class function AddStringField(dataSet : TDataSet; FieldName : String) : TStringField;
    class function AddIntegerField(dataSet : TDataSet; FieldName : String) : TIntegerField;
    class function AddMemoField(dataSet : TDataSet; FieldName : String) : TMemoField;
    class function AddFloatField(dataSet : TDataSet; FieldName : String) : TFloatField;
    class function AddBooleanField(dataSet : TDataSet; FieldName : String) : TBooleanField;
    class function AddSmallintField(dataSet : TDataSet; FieldName : String) : TSmallintField;
    class function AddDateTimeField(dataSet : TDataSet; FieldName : String) : TDateTimeField;
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

end.

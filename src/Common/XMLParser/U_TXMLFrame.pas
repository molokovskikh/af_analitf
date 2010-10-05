unit U_TXMLFrame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, U_TSGXMLDocument, U_TSGXMLAttribute, U_XMLElementStructs;

type
  TXMLFrame = class(TFrame)
    tvXML: TTreeView;
    mValue: TMemo;
    lbAttributes: TListBox;
    procedure tvXMLClick(Sender: TObject);
    procedure lbAttributesClick(Sender: TObject);
  private
    { Private declarations }
    {Добавляет в дерево XML-элемент}
    procedure   AddXMLElement(
      ATreeNode   : TTreeNode;
      AXMLElement : TSGXMLElement);
  public
    { Public declarations }
    {Заполняет дерево XML-элементом, если элемент является XML-документом,
     то вставляет заголовок}
    procedure InputXML(AXMLElement : TSGXMLElement);
  end;

implementation

{$R *.DFM}

{ TXMLFrame }

procedure TXMLFrame.AddXMLElement(ATreeNode: TTreeNode;
  AXMLElement: TSGXMLElement);
var
  I : Integer;
begin
  for I := 0 to AXMLElement.GetCount-1 do
    if AXMLElement[i] is TSGXMLElement then
      AddXMLElement(tvXML.Items.AddChildObject(ATreeNode,
                                  TSGXMLElement(AXMLElement[i]).XMLElemName,
                                  Pointer(AXMLElement[i])),
        TSGXMLElement(AXMLElement[i]))
    else if AXMLElement[i] is TSGXMLPCData then
           tvXML.Items.AddChildObject(ATreeNode,
                         '#PCDATA',
                         Pointer(AXMLElement[i]));
end;

procedure TXMLFrame.InputXML(AXMLElement: TSGXMLElement);
var
  TmpStr : String;
begin
  tvXML.Items.Clear;
  lbAttributes.Clear;
  mValue.Clear;
  if AXMLElement <> nil then begin
    if AXMLElement is TSGXMLDocument then begin
      TmpStr := '<?xml version = "' + TSGXMLDocument(AXMLElement).Version + '"';
      if TSGXMLDocument(AXMLElement).Encoding <> '' then
        TmpStr := TmpStr + ' encoding = "' +
                        TSGXMLDocument(AXMLElement).Encoding + '"';
      TmpStr := TmpStr + ' standalone = "';
      if TSGXMLDocument(AXMLElement).Standalone then
        TmpStr := TmpStr + 'yes'
      else TmpStr := TmpStr + 'no';
      TmpStr := TmpStr + '" ?>';
      tvXML.Items.AddChild(nil, TmpStr);
    end;
    AddXMLElement(tvXML.Items.AddChildObject(nil, AXMLElement.XMLElemName,
                                Pointer(AXMLElement)), AXMLElement);
  end;
end;

procedure TXMLFrame.tvXMLClick(Sender: TObject);
var
  I : Integer;
begin
  lbAttributes.Clear;
  mValue.Clear;
  if tvXML.Selected <> nil then begin
    tvXML.Selected.Selected := True;
    if TSGBasisXMLNode(tvXML.Selected.Data) is TSGXMLElement then
      for I := 0 to TSGXMLElement(tvXML.Selected.Data).GetAttributeCount-1 do
        lbAttributes.Items.Add(
          TSGXMLElement(tvXML.Selected.Data).GetAttributeName(i))
    else if TSGBasisXMLNode(tvXML.Selected.Data) is TSGXMLPCData then
           mValue.Lines.Text := TSGXMLPCData(tvXML.Selected.Data).Value;
  end;
end;

procedure TXMLFrame.lbAttributesClick(Sender: TObject);
var
  I : Integer;
begin
  for I := 0 to lbAttributes.Items.Count-1 do
    if lbAttributes.Selected[i] then
      mValue.Lines.Text :=
        TSGXMLElement(tvXML.Selected.Data).GetAttributeValue(i)
end;

end.

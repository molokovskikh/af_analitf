//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "Main.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "MemDS"
#pragma link "DBAccess"
#pragma link "MyAccess"
#pragma link "MydacVcl"
#pragma resource "*.dfm"
TfmMain *fmMain;
//---------------------------------------------------------------------------
__fastcall TfmMain::TfmMain(TComponent* Owner)
    : TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TfmMain::btOpenClick(TObject *Sender)
{
  MyQuery->Open();
}
//---------------------------------------------------------------------------
void __fastcall TfmMain::btCloseClick(TObject *Sender)
{
  MyQuery->Close();
}
//---------------------------------------------------------------------------
void __fastcall TfmMain::btDisconnectClick(TObject *Sender)
{
  MyConnection->Disconnect();
}
//---------------------------------------------------------------------------

void __fastcall TfmMain::btExecuteClick(TObject *Sender)
{
  MyQuery->Execute();
}
//---------------------------------------------------------------------------

void __fastcall TfmMain::FormShow(TObject *Sender)
{
  meSQL->Lines->Assign(MyQuery->SQL);
}
//---------------------------------------------------------------------------

void __fastcall TfmMain::meSQLExit(TObject *Sender)
{
  if (meSQL->Lines->Text != MyQuery->SQL->Text)
    MyQuery->SQL->Assign(meSQL->Lines);
}
//---------------------------------------------------------------------------

void __fastcall TfmMain::btConnectClick(TObject *Sender)
{
  MyConnection->Connect();        
}
//---------------------------------------------------------------------------


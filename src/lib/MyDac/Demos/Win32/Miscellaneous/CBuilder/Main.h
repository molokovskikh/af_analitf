//---------------------------------------------------------------------------
#ifndef MainH
#define MainH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "MemDS.hpp"
#include <ComCtrls.hpp>
#include <Db.hpp>
#include <DBCtrls.hpp>
#include <DBGrids.hpp>
#include <ExtCtrls.hpp>
#include <Grids.hpp>
#include "DBAccess.hpp"
#include <DBTables.hpp>
#include "MyAccess.hpp"
#include "MyDacVcl.hpp"
//---------------------------------------------------------------------------
class TfmMain : public TForm
{
__published:    // IDE-managed Components
    TPanel *ToolBar;
    TButton *btOpen;
    TButton *btClose;
    TButton *btExecute;
    TDBNavigator *DBNavigator;
    TMemo *meSQL;
    TDBGrid *DBGrid;
    TDataSource *DataSource;
    TButton *btDisconnect;
    TSplitter *Splitter1;
    TButton *btConnect;
    TMyConnection *MyConnection;
    TMyConnectDialog *MyConnectDialog;
    TMyQuery *MyQuery;
    void __fastcall btOpenClick(TObject *Sender);
    void __fastcall btCloseClick(TObject *Sender);
    void __fastcall btDisconnectClick(TObject *Sender);
    void __fastcall btExecuteClick(TObject *Sender);
    void __fastcall FormShow(TObject *Sender);
    void __fastcall meSQLExit(TObject *Sender);
        void __fastcall btConnectClick(TObject *Sender);
private:        // User declarations
public:         // User declarations
    __fastcall TfmMain(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TfmMain *fmMain;
//---------------------------------------------------------------------------
#endif

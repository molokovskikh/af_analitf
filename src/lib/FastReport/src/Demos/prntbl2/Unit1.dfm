�
 TFORM1 0�  TPF0TForm1Form1Left� TopkBorderStylebsDialogCaptionForm1ClientHeighttClientWidth� 
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style PixelsPerInch`
TextHeight TButtonButton1Left8TopTWidthKHeightCaptionShow reportTabOrder OnClickButton1Click  	TfrReport	frReport1InitialZoom	pzDefaultPreviewButtonspbZoompbLoadpbSavepbPrintpbFindpbHelppbExit 
StoreInDFM	
OnGetValuefrReport1GetValueOnBeforePrintfrReport1EnterRectOnPrintColumnfrReport1PrintColumnLeftTop
ReportForm
�     �       HP LaserJet 6L PCL on LPT1: �	   5  �                   ����  ��          Page1   Form   ��   x   |  ,    �    Band1      �   �  (   0           ���     frDBDataSet1       ��                 �          E   Band3      �   �  (   0           ���             ��                 �          �   Band2  8       �   /  0           ���    * Band1=frUserDataset1;Band3=frUserDataset2;       ��                 �           S   Memo1  8   �   �   (               ���,       [Cell]    ��            Arial 
         
          ���             �   Memo2  8   �   �   (              ���,       [Header]    ��            Arial 
         
          ���           �       ��      TfrDBDataSetfrDBDataSet1
DataSourceDataSource1LeftLTop(  TfrUserDatasetfrUserDataset1RangeEndreCountLeft\Top  TTableTable1Active	DatabaseNameDBDEMOS	TableNamecustomer.dbLeftTop( TFloatFieldTable1CustNo	FieldNameCustNo  TStringFieldTable1Company	FieldNameCompanySize  TStringFieldTable1Addr1	FieldNameAddr1Size  TStringFieldTable1Addr2	FieldNameAddr2Size  TStringField
Table1City	FieldNameCitySize  TStringFieldTable1State	FieldNameState  TStringField	Table1Zip	FieldNameZipSize
  TStringFieldTable1Country	FieldNameCountry  TStringFieldTable1Phone	FieldNamePhoneSize  TStringField	Table1FAX	FieldNameFAXSize  TFloatFieldTable1TaxRate	FieldNameTaxRate  TStringFieldTable1Contact	FieldNameContact  TDateTimeFieldTable1LastInvoiceDate	FieldNameLastInvoiceDate   TDataSourceDataSource1DataSetTable1Left,Top(  TfrUserDatasetfrUserDataset2RangeEndreCountLeft|Top   
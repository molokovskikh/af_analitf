rem ������⥪� ��� ������ exe �� ����������
dcc32 Eraser\Eraser.dpr
brcc32 -foEraserDLL.RES Eraser\EraserDLL.rc

rem �����஢���� �ண���-���
brcc32 -foProgress.RES Progress\Progress.rc

rem ������ � ��������
brcc32 -foIcons.RES Icons\Icons.rc
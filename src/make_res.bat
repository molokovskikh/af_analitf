rem Библиотека для замены exe при обновлении
dcc32 Eraser\Eraser.dpr
brcc32 -foEraserDLL.RES Eraser\EraserDLL.rc

rem Анимированный прогресс-бар
brcc32 -foProgress.RES Progress\Progress.rc

rem Ресурс с иконками
brcc32 -foIcons.RES Icons\Icons.rc
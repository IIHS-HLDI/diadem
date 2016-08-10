robocopy . "\\IIHS\IIHSDrive\VRC\Private\DIAdem" /MIR /Z /XD ".git" ".vs" ".vscode" /XF "diadem.sln" "publish.bat" "vwd.webinfo" "web.config" "web.debug.config"
IF %ERRORLEVEL% LEQ 2 exit 0
'-------------------------------------------------------------------------------
'-- VBS script file
'-- Created on 04/08/2010 15:38:46
'-- Author: 
'-- Comment: 
'-------------------------------------------------------------------------------
Option Explicit 
Call ScriptInclude(CurrentScriptPath & "Tools.VBS", "Tools") 'This script file must be set in the root directory for the Diadem repo.
GlobalDim("APPPATH")
dim AppName, AppDataPath, Shell
 'This will need to be set in every repo so that each set of scripts knows where to look for config information
Set Shell = CreateObject("WScript.Shell")
AppName = "IIHSProcessing"
AppDataPath = Shell.ExpandEnvironmentStrings("%USERPROFILE%") & "\AppData\Local\" & AppName

Call Tools.CreateAppFolder(AppDataPath)
Call Tools.SetStartPath(AppDataPath)
APPPATH = Tools.GetAppPath(appName)

Call Tools.SetupIIHSMenu
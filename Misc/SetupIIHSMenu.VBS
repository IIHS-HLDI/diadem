'-------------------------------------------------------------------------------
'-- VBS script file
'-- Created on 08/03/2016 09:08:28
'-- Author: 
'-- Comment: 
'-------------------------------------------------------------------------------
Option Explicit  'Forces the explicit declaration of all the variables in a script.
Sub CreateMenuSelection(Name, Title, Index, Bar, IconName, Code)
  Dim oItem 
  If Not Barmanager.ActionObjs.Exists(Name) Then
    Set oItem = BarManager.ActionObjs.Add(Name, "CustomButton")    
  Else
    Set oItem = BarManager.ActionObjs.Item(Name)
  End If
  oItem.Caption = Title
  oItem.OnClickCode.Code = Code
  If IsEmpty(IconName) = False Then
    Call FileCopy(CurrentScriptPath & IconName, Barmanager.ResourcePath, true)
    oItem.Picture = IconName
  End If
  Call Bar.UsedActionObjs.Insert(oItem, Index) 
End Sub

Sub SetupPopup (Name, Destination, Bar, Index)
  Dim oMyActionObj, IIHSBar
  If Not BarManager.ActionObjs.Exists(Name) Then
    Set oMyActionObj = BarManager.ActionObjs.Add(Name, "CustomPopup")
    oMyActionObj.Caption = "IIHS"
    Call FileCopy(CurrentScriptPath & "iihs.ico", Barmanager.ResourcePath, true)
    oMyActionObj.Picture = "iihs.ico"
    Set IIHSBar = Bar
    oMyActionObj.BarID = IIHSBar.ID
    Call BarManager.Bars(Destination).UsedActionObjs.Insert(oMyActionObj, Index)
  End If
End Sub

Sub SetupIIHSMenu()
  Call SetupPopup("IIHSViewPopup","VIEWGroup", BuildIIHSViewBar, 1)
  Call SetupPopup("IIHSNavPopup","NAVMenuMain", BuildIIHSNavBar, 6)
End Sub

Function BuildIIHSViewBar
  Dim Bar
  Set Bar = CreateBar("IIHSViewBar")
  Bar.Style = eBarStyleIconCaption
  Bar.ActionObjPictureHeight = 32
  Bar.ActionObjPictureWidth = 32
  Call CreateMenuSelection("CrashDialog", "Process/Open Crash Test", 1, Bar, "window_dialog.ico", "call ScriptStart(APPPATH & ""\diadem\Tools.VBS"", ""OpenCrash"")") 
  Call CreateMenuSelection("AddVideo", "Add Video To View", 2, Bar, "video.ico", "Call ScriptStart(APPPATH & ""\diadem\Tools.VBS"", ""OpenAddVideo"")") 
  Call CreateMenuSelection("LoadAnalysis", "Load Crash Analysis", 3, Bar, "document_pulse.ico", "Call ScriptStart(APPPATH & ""\diadem\Tools.VBS"", ""OpenAnalysis"")") 
  Call CreateMenuSelection("SwitchView", "Switch VIEW", 4, Bar, "chart.ico", "Call ScriptStart(APPPATH & ""\diadem\Misc\ChangeView.VBS"")") 
  Call CreateMenuSelection("Export", "Export Data To Excel", 5, Bar, "MSExcel.ico", "call ScriptStart(APPPATH & ""\diadem\Tools.VBS"", ""ExportToExcel"")") 
  Call Bar.UsedActionObjs.Add("Separator")
  Call CreateMenuSelection("AEBDialog", "AEB Dialog", 7, Bar, "window_dialog.ico", "call ScriptStart(APPPATH & ""\diadem\Tools.VBS"", ""OpenAEB"")") 
  Call CreateMenuSelection("AEBOpen", "Open Existing AEB Test", 8, Bar, "folder.ico", "call ScriptStart(APPPATH & ""\diadem\Tools.VBS"", ""OpenAEBTest"")") 
  Call Bar.UsedActionObjs.Add("Separator")
  Call CreateMenuSelection("HeadlightDialog", "Headlight Dialog", 10, Bar, "window_dialog.ico", "call ScriptStart(APPPATH & ""\diadem\Tools.VBS"", ""OpenHeadlight"")") 
  Set BuildIIHSViewBar = Bar
End Function

Function BuildIIHSNavBar
  Dim Bar
  Set Bar = CreateBar("IIHSNavBar")
  Bar.Style = eBarStyleIconCaption
  Bar.ActionObjPictureHeight = 32
  Bar.ActionObjPictureWidth = 32
  Call CreateMenuSelection("CrashDialog", "Process/Open Crash Test", 1, Bar, "window_dialog.ico", "call ScriptStart(APPPATH & ""\diadem\Tools.VBS"", ""OpenCrash"")") 
  Call CreateMenuSelection("Export", "Export Data To Excel", 2, Bar, "MSExcel.ico", "call ScriptStart(APPPATH & ""\diadem\Tools.VBS"", ""ExportToExcel"")") 
  Call Bar.UsedActionObjs.Add("Separator")
  Call CreateMenuSelection("AEBDialog", "AEB Dialog", 4, Bar, "window_dialog.ico", "call ScriptStart(APPPATH & ""\diadem\Tools.VBS"", ""OpenAEB"")") 
  Call CreateMenuSelection("AEBOpen", "Open Existing AEB Test", 5, Bar, "folder.ico", "call ScriptStart(APPPATH & ""\diadem\Tools.VBS"", ""OpenAEBTest"")") 
  Call Bar.UsedActionObjs.Add("Separator")
  Call CreateMenuSelection("HeadlightDialog", "Headlight Dialog", 7, Bar, "window_dialog.ico", "call ScriptStart(APPPATH & ""\diadem\Tools.VBS"", ""OpenHeadlight"")") 
  Set BuildIIHSNavBar = Bar
End Function

Function CreateBar(Name)
  Dim Bar
  If Not Barmanager.Bars.Exists(Name) Then
    Set Bar = Barmanager.Bars.Add(Name)
    Bar.ID = Name
    Set CreateBar = Bar
  End If
End Function

Function GetAppPath(appName)
  Dim fso, file, shell, folderPath
  Set Shell = CreateObject("WScript.Shell")
  folderPath = Shell.ExpandEnvironmentStrings("%USERPROFILE%") & "\AppData\Local\" & appName
  Set fso = CreateObject("Scripting.FileSystemObject")
  If fso.FolderExists(folderPath) = True Then
    If fso.FileExists(folderPath & "\path.config") = True Then
      Set file = fso.OpenTextFile(folderPath & "\path.config")
      GetAppPath = file.ReadLine 
      file.Close
      Set file = Nothing
      Set fso = Nothing
      Exit Function
    End If
  End If
  Set fso = Nothing
  GetAppPath = Null
End Function


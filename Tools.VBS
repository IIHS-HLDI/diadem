'-------------------------------------------------------------------------------
'-- VBS script file
'-- Created on 08/02/2016 17:55:47
'-- Author: 
'-- Comment: Must be placed in root directory
'-------------------------------------------------------------------------------
Option Explicit  'Forces the explicit declaration of all the variables in a script.
Dim TOOLSPATH
TOOLSPATH = CurrentScriptPath
Sub SetupIIHSMenu
  Call menureset("VIEW")
  Call menureset("NAVIGATOR")
  Call ScriptStart(TOOLSPATH & "\Misc\SetupIIHSMenu.VBS", "SetupIIHSMenu")
End Sub

Sub OpenAnalysis
  Dim Prefix, Area
  Set Area = View.ActiveSheet.ActiveArea 
  View.ActiveSheet.ActiveArea.DisplayObjType = "Dialog"
  Prefix = GetTestIdPrefix(data.Root.Properties("Test_ID").Value)
  If IsNull(Prefix) = False Then
    Select Case Prefix
      Case "CES", "CS"
        View.ActiveSheet.ActiveArea.DisplayObj.Filename = APPPATH & "crashworthiness\Side\Side Film Analysis.SUD"
        View.ActiveSheet.ActiveArea.DisplayObj.DlgName = "Dlg1" 
      Case "CEF", "CF"
        View.ActiveSheet.ActiveArea.DisplayObj.Filename = APPPATH & "crashworthiness\Frontal\Moderate Overlap Analysis.SUD"
        View.ActiveSheet.ActiveArea.DisplayObj.DlgName = "Dlg1"
      Case "CEN", "CN"
        View.ActiveSheet.ActiveArea.DisplayObj.Filename = APPPATH & "crashworthiness\Frontal\Small Overlap Analysis.SUD"
        View.ActiveSheet.ActiveArea.DisplayObj.DlgName = "Dlg1"
      Case Else
        Call MsgBox("Invalid TestID")
    End Select
  End If 
End Sub

Sub OpenAEB
  ScriptStart(APPPATH & "aeb\Processing\AEBStartup.VBS")
End Sub

Sub OpenAEBTest
  Call SudDlgShow("SearchTests", APPPATH & "aeb\Processing\CrashAvoidanceDialog.sud")
End Sub

Sub OpenHeadlight
  ScriptStart(APPPATH & "headlights\Processing\Headlight_processing.VBS")
End Sub

Sub OpenCrash
  ScriptStart(APPPATH & "crashworthiness\CrashStartup.VBS")
End Sub

Sub ExportToExcel
  Dim Prefix, TestID
  If data.Root.Properties.Exists("Test_ID") Then
    TestID = data.Root.Properties("Test_ID").Value
  End If
  If data.Root.Properties.Exists("TestIDDialog") Then
    TestID = data.Root.Properties("TestIDDialog").Value
  End If
  Prefix = GetTestIdPrefix(TestID)
  If IsNull(Prefix) = False Then
    Select Case Prefix
      Case "CES", "CS"
        Call ScriptInclude(APPPATH & "crashworthiness\Side\Transfer Side CE to Excel")
      Case "CEF", "CF", "CEN", "CN"
        Call ScriptInclude(APPPATH & "crashworthiness\Frontal\Transfer Frontal Data to Excel")
      Case "SER", "SR"
        Call ScriptInclude(APPPATH & "crashworthiness\Rear Impact\Transfer Rear Data to Excel")
        Call ScriptInclude(APPPATH & "crashworthiness\Rear Impact\Transfer Pulse Data to Excel")
      Case "AEB"
        Call ScriptInclude(APPPATH & "aeb\Transfer AEB Data to Excel")
      Case Else
        Call MsgBox("Invalid TestID")
    End Select
  End If 
End Sub

Sub OpenAddVideo
  Call SUDDlgShow("Dlg1", TOOLSPATH & "Misc\AddVideo.SUD")
End Sub

Function GetTestIdPrefix(TestId)
  Dim Length, i, Prefix, Char 
  Length = Len(TestId)
  For i = 1 to Length
    Char = Mid(TestId, i, 1)
    If IsNumeric(Char) = False Then
      Prefix = Prefix & Char
    Else
      GetTestIdPrefix = Prefix
      Exit Function
    End If
  Next
  Call MsgBox("Could not determine IIHSTestId prefix")
  GetTestIdPrefix = Null
End Function

Function IsConnected
  Dim Filesys, Newfolder
  Set Filesys = CreateObject("Scripting.FileSystemObject")
  If Not Filesys.FolderExists(TOOLSPATH) THEN
    IsConnected = False
    Exit Function
  Else
    IsConnected = True
    Exit Function
  End If
End Function

Function IsDataFileLoaded
  If Data.Root.Name = "NoName" Then
    IsDataFileLoaded = False
    Exit Function
  Else
    IsDataFileLoaded = True
    Exit Function
  End If
End Function

Function IsViewLoaded
  If View.FileName = "NONAME" Then
    IsViewLoaded = False
    Exit Function
  Else
    IsViewLoaded = True
    Exit Function
  End If
End Function

Function GetTestDirectory (TestID)
  dim fso, RootPath, folder, TestType, TestYear
  
  set fso = CreateObject("Scripting.FileSystemObject")
  If Left(TestID,3) = "CEF" or Left(TestID,3) = "CES" or Left(TestID,3) = "CEN" or Left(TestID,3) = "SER" Then
    TestType = "CE"
  ElseIf Left(TestID,2) = "CF" or Left(TestID,2) = "CS" or Left(TestID,2) = "CN" or Left(TestID,2) = "SR"Then
    TestType = "R&D"
  Else
    Exit Function
  End If
  
  If Left(TestID, 2) = "CS" or Left(TestID, 3) = "CES" Then
    RootPath = "\\IIHS\IIHSDrive\VRC\Shared\Crashworthiness Program\Side-Impact Crash Tests\"
  ElseIf Left(TestID, 2) = "CF" or Left(TestID, 3) = "CEF" or  Left(TestID, 2) = "CN" or Left(TestID, 3) = "CEN" Then
    RootPath = "\\IIHS\IIHSDrive\VRC\Shared\Crashworthiness Program\Frontal Crash Tests\"
  ElseIf Left(TestID, 2) = "SR" or Left(TestID, 3) = "SER"  Then
    RootPath = "\\IIHS\IIHSDrive\VRC\Shared\Crashworthiness Program\Rear Impact Sled Tests\"
  End If
    
  For Each folder in fso.GetFolder(RootPath).SubFolders
      If folder.Name = TestID Then
        GetTestDirectory = folder.Path
      End If
  Next
  
  For Each folder in fso.GetFolder(RootPath & "Archived\").SubFolders
    If TestType = "CE" Then 
      If Mid(TestID, 4, 2) = right(folder.Name, 2) Then 
        RootPath = RootPath & "Archived\" & folder.Name & "\" & TestType & "\"
      End If
    End If
    If TestType = "R&D" Then
      If Mid(TestID, 3, 2) = right(folder.Name, 2) Then
        RootPath = RootPath & "Archived\" & folder.Name & "\" & TestType & "\"
      End If
    End If 
  Next
  
  For Each folder in fso.GetFolder(RootPath).SubFolders
      If folder.Name = TestID Then
        GetTestDirectory = folder.Path
        Exit Function
      End If
  Next
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

Sub CreateAppFolder(folderName)
  Dim fso
  Set fso = CreateObject("Scripting.FileSystemObject")
  If fso.FolderExists(folderName) = False Then
    fso.CreateFolder(folderName)
  End If
  Set fso = Nothing
End Sub

Sub SetStartPath(folderName)
  Dim fso, currentPath, parentPath, configFile
  Set fso = CreateObject("Scripting.FileSystemObject")
  currentPath = CurrentScriptPath
  parentPath = fso.GetParentFolderName(currentPath)
  
  Set configFile = fso.CreateTextFile(folderName & "\path.config", true)
  configFile.WriteLine(parentPath & "\")
  configFile.Close
  
  Set fso = Nothing
  Set configFile = Nothing
End Sub
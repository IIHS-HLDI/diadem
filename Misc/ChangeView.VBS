'-------------------------------------------------------------------------------
'-- VBS script file
'-- Created on 08/26/2013 11:18:27
'-- Author: 
'-- Comment: 
'-------------------------------------------------------------------------------
Option Explicit  'Forces the explicit declaration of all the variables in a script.
  dim datapath
  datapath = datareadpath
  Call Suddlgshow("Dlg1", currentscriptpath & "ChangeView.SUD", datapath)
  If Not IsEmpty(datapath) Then
    ChangeView(datapath)
  End If


  Sub ChangeView(path)
    If View.FileName = "NONAME" Then
        View.LoadLayout(path)
    Else
      Select Case MsgBoxDisp("Do you want to save the current view?", "MB_YESNOCANCEL")
        Case "IDYes"
          Call View.SaveLayout(View.FullPath)
          Call View.LoadLayout(path)
        Case "IDNo"
          Call View.LoadLayout(path)
        Case "IDCancel"
      End Select
    End If
  End Sub
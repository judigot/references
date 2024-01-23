Remove Context Menu Items:

Registry Jumper.vbs
========================================

Set WshShell = CreateObject("WScript.Shell")
Dim JumpToKey
JumpToKey=Inputbox("Enter registry key:")
WshShell.RegWrite "HKCU\Software\Microsoft\Windows\CurrentVersion\Applets\Regedit\Lastkey",JumpToKey,"REG_SZ"
WshShell.Run "regedit", 1,True
Set WshShell = Nothing

========================================

Download Registry Jumper:
https://drive.google.com/drive/folders/1RJuiTjfTbJYc-3Ty4u3QmaF6S4H3QaAA

Default Contex Menu:
HKEY_CLASSES_ROOT\Directory\Background\shell

Folder Context Menu:
HKEY_CLASSES_ROOT\Directory\shell

AMD Catalyst Control Center:
HKEY_CLASSES_ROOT\Directory\Background\shellex\ContextMenuHandlers\ACE

Double click "(Default)" and add "-" at the beginning of the value
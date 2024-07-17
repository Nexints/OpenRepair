Dim Msg, Style, Title, Help, Ctxt, Response, MyString
Msg = "Done! Restored backup and reinstalled Windows."    ' Define message.
Style = vbOK Or vbInformation    ' Define buttons.
Title = "Done Restoring Backup"    ' Define title.
        ' Display message.
Response = MsgBox(Msg, Style, Title)
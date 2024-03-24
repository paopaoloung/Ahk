

#NoTrayIcon
send "^c"
ClipWait
sleep 500

if SubStr(A_Clipboard, -1) != "`n"
{
A_Clipboard := A_Clipboard "`n"
}

if InStr(A_Clipboard, "/*")
	{
	A_Clipboard := StrReplace(A_Clipboard, "/*---------------------------------")
	A_Clipboard := StrReplace(A_Clipboard, "---------------------------------*/")
	A_Clipboard := StrReplace(A_Clipboard, "/*")
	A_Clipboard := StrReplace(A_Clipboard, "*/")
	}
Else
	A_Clipboard := "/*---------------------------------`n" A_Clipboard "---------------------------------*/`n"
sleep 500
send "^v"




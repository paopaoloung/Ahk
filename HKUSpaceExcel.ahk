
#Requires AutoHotkey v2.0
#SingleInstance force

/*---------------------------------
.+NumpadEnter		簽名+日期
LCtrl & Down		Home: 返回第一例
---------------------------------*/



;for excel表格
NumPadEnter::
{
send "^a"
sleep "500"
send "^c"
ClipWait
sleep "500"
;-----------------------------------------------------------------
if RegExMatch(A_Clipboard, "^\d+$", &z0)	;剪貼板是全數字
{
  if z0.Len[0] = 4					;四位數字
  {
      x1 := SubStr(A_Clipboard, 1, 2)		;截前2位
      x2 := SubStr(A_Clipboard, -2)			;截後2位
	  ;-------------------------------------
	  if (x2 = 00 or x2 = 30 or x2 = 45)		;判斷時間
	  {
	      ;MsgBox "time: " x2
	      A_Clipboard := x1 ":" x2
	  }
	  ;-------------------------------------
	  Else
	{
	      A_Clipboard := x1 "/" x2
	  }
  }  ;//if z0.Len[0] = 4
}  ;//if RegExMatch

if (A_Clipboard = ".")
{
  A_Clipboard := "Lung"
  sleep "500"
  send "^v"
  sleep "500"
  send "`t"
  A_Clipboard :=  A_DD "/" A_MM
  sleep "500"
  send "^v"
  Return
}
;-----------------------------------------------------------------

sleep "500"
send "^v"
send "{tab}"
}




LCtrl & Down::
{
  send "{Home}"
  send "{Down}"
  send "{F2}"
}







;-------------------- 藍色小提示窗口 --------------------
blueWin(txtTip, t){
    if WinExist("[GuiTip]")
	{
	WinClose
	}

GuiTip0 := Gui("+AlwaysOnTop -Caption +Border", "[GuiTip]", )
GuiTip0.BackColor := "Aqua"

guiTip0.SetFont("s15 w1000", "norm")
GuiTip0.Add("Text", "vtxt x30 y5 R1", txtTip)
GuiTip0.Add("Text", "x+10 w50")

GuiTip0.Show("NoActivate AutoSize")
SetTimer () => GuiTip0.Destroy(), "-" . t . "000"
}
;-------------------- /藍色小提示窗口/ --------------------


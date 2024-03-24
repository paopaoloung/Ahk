
#Requires AutoHotkey v2.0
#SingleInstance force
InstallMouseHook
InstallKeybdHook
KeyHistory  2
CoordMode "Mouse", "Screen"	;全局获取模式
OnOff := "Off"

/*---------------------------------
雙擊或拖動滑鼠選單彈出菜單 icon file: %systemroot%\system32\accessibilitycpl.dll
1. 快速雙擊 200ms		調出符號菜單
2. 慢雙擊 >200ms		普通選擇
3. 按住、右移、放開左鍵		等於拖動：自動複制
---------------------------------*/


;-------------------- 0. 產生單個符號Menu --------------------
;zz插入單個符號
sym0Txt := [
  "()",
  "[]",
  "{`n  `n}`n",

  "---",
  "=",
  "@",
  "#",
  "^",
  "＆",
  "*",
  "_",
  "|",
  "※"
]

SymbMenu0 := Menu()
Loop sym0Txt.Length
{
	if (sym0Txt[A_Index] = "---")			;分隔線
	{
	  SymbMenu0.Add()
	  Continue
	}
	SymbMenu0.Add(sym0Txt[A_Index], pastSymb)
}
pastSymb(Item, *)
{
  A_Clipboard := Item
  if A_Clipboard = "＆"
    A_Clipboard := "&"
    Send "^v"
  if StrLen(A_Clipboard) = 2		;開關括號時
    send "{Left}"
  ;------------- 其他特別情況 -----------------
  if (InStr(A_Clipboard, "{"))  {
    send "{Left 3}"
  }
  ;------------- /其他特別情況/ -----------------
}

::zz::
{
sleep 500
    CaretGetPos(&x, &y)
    x2 := x0 + 10
    y += 50
  SymbMenu0.Show(x, y)

}
;-------------------- /0. 產生單個符號Menu/ --------------------







;-------------------- 1. 產生符號菜單 --------------------
;將所選文字插入以下符號
SymbMenuTxt := [
  "`"雙引號`"",
  "(小括號)",
  "[中括號]",
  "{大括號}",
  "---",
  "複制",
  "貼上",
  "---",
  "[停止菜單]"
]

SymbMenu := Menu()
Loop SymbMenuTxt.Length
{
	if (SymbMenuTxt[A_Index] = "---")			;分隔線
	{
	  SymbMenu.Add()
	  Continue
	}
	SymbMenu.Add(SymbMenuTxt[A_Index], changeTxt)
}
;-------------------- /1. 產生符號菜單/ --------------------





;-------------------- 2. 產生 [開啟符號] 菜單 --------------------
/*
Menu0 := Menu()
Menu0.Add("開啟符號", openSybMenu)
*/

symbW := 40  ;符號Button寛度

guiMenu0  := Gui("+AlwaysOnTop -Caption +Border +Owner", "MenuWin")
fxbutton := guiMenu0.Add("Button", "x0 y0 h30 w" symbW, "符號")
fxbutton.OnEvent("Click", openSybMenu)
openSybMenu(*)
{
  global
  OnOff := "On"
  guiMenu0.Hide()

  x0 -= 60
  y0 -= 80
  SymbMenu.Show(x0, y0)
}
;-------------------- /2. 產生 [開啟符號] 菜單/ --------------------




;-------------------- 選擇菜單項功能 --------------------
changeTxt(Item, *) {
if (Item = "[停止菜單]")
	{
	global OnOff, x0, y0
	OnOff := "off"
	;tooltip "close符號...", x0, y0, 1
	;SetTimer () => ToolTip(), -2000
	Return
	}

if (Item = "複制")
{
	Send "^c"
	ClipWait 2
	sleep 500
	blueWin(A_Clipboard, 2)
  Return tooltip
}

if (Item = "貼上")
{
  sleep "500"
  send "^v"
  Return tooltip
}

	global clip0
	Send "^c"
	ClipWait
	sleep 500
	clip0 := A_Clipboard

str1 := SubStr(Item, 1, 1)
str2 := SubStr(Item, -1)

A_Clipboard := str1 clip0 str2
sleep "500"
send "^v"
}
;-------------------- /選擇菜單項功能/ --------------------





cursor_dbclick_gaptime:=500	;鼠标两次点击事件间隔时间小于200这个时间判断为双击
cursor_drag_gaptime :=500	;鼠标按下到弹起时间大于这个时间判断为拖动
cursor_over_dist:=30	;鼠标横扫的像素大于等于这个值时认为是拖动
LB_down_cursor:=0	;按下时鼠标的形状
x0:=0
y0:=0
x1:=0
y1:=0
x2:=0
y2:=0










~LButton::
{

    global
    LB_down_cursor := A_Cursor
    MouseGetPos &x0, &y0
    x2 := x0 + 10
    y2 := y0 + 30

    ;鼠標雙擊 <200ms 時
    ;有使用~LButton up 拖曳功能時使用
    ;if(A_PriorHotkey="~LButton up" && A_TimeSincePriorHotkey<= cursor_dbclick_gaptime && A_Cursor="IBeam")

    ;沒使用左鍵拖曳功能時使用
    if(ThisHotkey =A_PriorHotkey && A_TimeSincePriorHotkey<= cursor_dbclick_gaptime && A_Cursor="IBeam")
    {
	if (OnOff = "on")
	{
	  ;sleep cursor_drag_gaptime		;啟用拖放功能時才用
	  SymbMenu.Show(x0, y0)
	}  ;//(OnOff = "on")

	Else  if (OnOff = "off")
	{
	  ;sleep cursor_drag_gaptime		;啟用拖放功能時才用
	  ;Menu0.Show(x0, y0)
	  guiMenu0.Show("NoActivate h30 x" x2 . "y" y2 . "w" symbW)
	  SetTimer () => guiMenu0.Hide(), -2500
	}

    }
}


/*
~LButton up::
{
  global
  MouseGetPos &x1, &y1
  ;判断鼠标拖动事件
  if(A_PriorHotkey="~LButton" && A_TimeSincePriorHotkey>=cursor_drag_gaptime )
    {
	;限制鼠标形状的拖動
	;在 Chrome 中如果 highlight 超出文本范圍，鼠標變成箭尖，會失效
	;if((LB_down_cursor="IBeam" && A_Cursor="IBeam")&& abs(x1-x0)> cursor_over_dist)

	if((LB_down_cursor="IBeam")&& abs(x1-x0)> cursor_over_dist) 
	{
		Send "^c"
		ClipWait 2
		sleep 500
		blueWin(A_Clipboard, 2)





;--------------------  --------------------
		if (OnOff = "on")
		{
		SymbMenu.Show(x0, y0)
		Return
		}

		if (OnOff = "off")
		{
		  Menu0.Show(x0, y0)
		}
	}
    } ;//if(A_PriorHotkey=..
} ;//~LButton up::
*/






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


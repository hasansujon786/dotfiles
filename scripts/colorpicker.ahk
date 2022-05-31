; =====================================================================================================================
; Name:				Quick Palette (color picker)
; Description:		pick a color from a standard palette
; Topic:
; Sript version:	1.0
; AHK Version:		1.1.24.03 (A32/U32/U64)
; Tested on:		Win 7 (x64)
; Author:			SpeedMaster
; How to use:	  	cick a color to copy hex RGB value to clipboard
;					click on column index to copy the column to clipboard (ready to use object )
;					click on color name to copy the row to clipboard (ready to use object)
;=======================================================================================================================
version:=1.0

#SingleInstance force
SetBatchLines, -1

WM_MOUSEMOVE := 0x200

onmessage(WM_MOUSEMOVE, "OnMouseMove")

red:=["FF9999","FF6666","FF3333","FF0000","D90000","B20000","8C0000","660000","400000"]
flame:=["FFB299","FF8C66","FF6633","FF4000","D93600","B22D00","8C2300","661A00","401000"]
orange:=["FFCC99","FFB266","FF9933","FF8000","D96C00","B25900","8C4600","663300","402000"]
amber:=["FFE599","FFD966","FFCC33","FFBF00","D9A300","B28600","8C6900","664D00","403000"]
yellow:=["FFFF99","FFFF66","FFFF33","FFFF00","D9D900","B2B200","8C8C00","666600","404000"]
lime:=["E5FF99","D9FF66","CCFF33","BFFF00","A3D900","86B200","698C00","4D6600","304000"]
chartreuse:=["CCFF99","B2FF66","99FF33","80FF00","6CD900","59B200","468C00","336600","204000"]
green:=["99FF99","66FF66","33FF33","00FF00","00D900","00B200","008C00","006600","004000"]
sea:=["99FFCC","66FFB2","33FF99","00FF80","00D96C","00B259","008C46","006633","004020"]
turquoise:=[ "99FFE5","66FFD9","33FFCC","00FFBF","00D9A3","00B286","008C69","00664D","004030"]
cyan:=["99FFFF","66FFFF","33FFFF","00FFFF","00D9D9","00B2B2","008C8C","006666","004040"]
sky:=["99E5FF","66D9FF","33CCFF","00BFFF","00A3D9","0086B2","00698C","004D66","003040"]
azure:=["99CCFF","66B2FF","3399FF","0080FF","006CD9","0059B2","00468C","003366","002040"]
blue:=["9999FF","6666FF","3333FF","0000FF","0000D9","0000B2","00008C","000066","000040"]
han:=["B299FF","8C66FF","6633FF","4000FF","3600D9","2D00B2","23008C","1A0066","100040"]
violet:=["CC99FF","B266FF","9933FF","8000FF","6C00D9","5900B2","46008C","330066","200040"]
purple:=["E599FF","D966FF","CC33FF","BF00FF","A300D9","8600B2","69008C","4D0066","300040"]
fuchsia:=["FF99FF","FF66FF","FF33FF","FF00FF","D900D9","B200B2","8C008C","660066","400040"]
magenta:=["FF99E5","FF66D9","FF33CC","FF00BF","D900A3","B20086","8C0069","66004D","400030"]
pink:=["FF99CC","FF66B2","FF3399","FF0080","D9006C","B20059","8C0046","660033","400020"]
crimson:=["FF99B2","FF668C","FF3366","FF0040","D90036","B2002D","8C0023","66001A","400010"]
gray:=["DEDEDE","BFBFBF","9E9E9E","808080","666666","4D4D4D","333333","1A1A1A","000000"]
sepia:=["DED3C3","BFAB8F","9E8664","806640","665233","4D3D26","33291A","1A140D","000000"]

colors:=["Red","Flame","Orange","Amber","Yellow","Lime","Chartreuse","Green","Sea","Turquoise","Cyan","Sky","Azure","Blue","Han","Violet","Purple","Fuchsia","Magenta","Pink","Crimson","Gray","Sepia"]

gui, font, s11, consolas
gui, font, csilver bold

creategrid(ctr:="text", clln:="3_", cmj:=false, gpx:=100+10+5, gpy:=1, cols:=9, rows:=1, wsp:=24, hsp:="24", opt:=" w24 h24 goutcol  BackGroundTrans -border -disabled 0x201", fill:="2")
creategrid(ctr:="text", clln:="1_", cmj:=false, gpx:=10, gpy:=25, cols:=1, rows:=23, wsp:=100, hsp:="24", opt:=" w100 h24  BackGroundTrans goutpal -border -disabled 0x201 right", fill:=" colors")
creategrid(ctr:="text", clln:="2_", cmj:=false, gpx:=gpx+wsp+5, gpy:=25, cols:=9, rows:=23, wsp:="24", hsp:="24", opt:=" w24 h24 border ghello", fill:="100")
creategrid(ctr:="listview", clln:="", cmj:=false, gpx, gpy:=25, cols:=9, rows:=23, wsp:="24", hsp:="24", opt:=" w24 h25  Backgroundff0000 -Hdr -E0x200", fill:="")


for i, r in colors {
  drawchar("1_" i "_" 1, r " ")
    for j, c in %r% {
      ColorListview( i "_" j, c)
        cell:= "2_" i "_" j
        %cell%:=c
    }
}

loop, 9
drawchar("3_1_" a_index, a_index)

gui, color, black
gui, show,, %  "Quick Palette v" . version "  - by Speedmaster"

return

guicontextmenu:
if (strsplit(a_guicontrol,"_").1=2)
gosub, hello
return

hello:
Traytip, Quick Palette:, % "#" %a_guicontrol%  " picked"
clipboard:= % %a_guicontrol%

exit:
gui, hide
tooltip,
  sleep, 2000
  exitapp
  return

  outpal:
rowselect:=strsplit(a_guicontrol,"_").2

outcolor:=colors[rowselect]


for k, v in %outcolor%
out .= k ":" """" v """" ","
out:=rtrim(out, ",")
out:=outcolor ":={" out "}"
gui, hide

clipboard:= out
Traytip, Quick Palette:, % outcolor  " picked"
gosub, exit
return

outcol:
colselect:=strsplit(a_guicontrol,"_").3
for k, v in colors
out .=  v  ":" """"  %v%[3]  """" ","
out:=rtrim(out, ",")
out:="Shade" colselect " := {" out "}"
clipboard:= out
Traytip, Quick Palette:, % "Shade" colselect  " picked"
gosub, exit
return

OnMouseMove() {
  if (a_guicontrol)
    tooltip, %  %a_guicontrol%
  else
    tooltip,
}
return

;guiclose:
esc::
exitapp
return

creategrid(ctr:="pic", clln:="", cmj:="true", gpx:=10, gpy:=10, cols:=30, rows:=20, wsp:="32", hsp:="32", opt:=" BackGroundTrans  -disabled", fill:="X") {
  global
    r:=0,  c:=0
    While r++ < rows {
      while c++ < cols{
        gui 1: add, % ctr, % opt " v" ((cmj) ? (clln c "_" r " Hwndh" clln  c "_" r):(clln r "_" c " Hwndh" clln  r "_" c)) ((c=1 && r=1) ? " x"gpx " y"gpy " section"
            : (c!=1 && r=1) ? " xp+"wsp " yp" : (c=1 && r!=1) ? " xs" " yp+"hsp : " xp+"wsp " yp"), % fill
      } c:=0
    } r:=c:=0
}

drawchar(varname, chartodraw:="@", color:="")
{
  global
    guicontrol,, %varname%, %chartodraw%
    if (color)
      colorcell(varname, color)
}

ColorCell(cell_to_paint, color:="red")
{
  GuiControl, +c%color%  , %cell_to_paint%
    GuiControl, MoveDraw, % cell_to_paint
}

ColorListview(cell_to_paint, color:="red")
{
  GuiControl, +background%color%  , %cell_to_paint%
    GuiControl, MoveDraw, % cell_to_paint
}


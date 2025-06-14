#Requires AutoHotkey v2
#SingleInstance Force

BITMAP_BG_COLOR := 0x007000
BITMAP_BORDER_COLOR := 0x888888
WINDOW_TRANSPARENT := 120
SUB_GRID_TRANSPARENT := 80 ; Value from 0 (invisible) to 255 (opaque)
FONT_COLOR := "cddffdd"
FONT_FAMILY := "Ubuntu Sans"
SUB_GRID_FONT_SIZE := 9
FONT_SIZE := 14
CENTER_POINT_COLOR := "BackgroundYellow"
CENTER_POINT_SIZE := 7

DIRECTION_X := ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"]
DIRECTION_Y := ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "a", "s", "d", "f", "g", "h", "j", "k", "l", ";", "z", "x", "c", "v", "b", "n"]
SUB_GRID_2D_DIRECTIN := [
  ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"],
  ["a", "s", "d", "f", "g", "h", "j", "k", "l", ";"],
  ["z", "x", "c", "v", "b", "n", "m", ",", ".", "/"]
]
FINE_POINT_DIRECTIONAL_KEYS := ["h", "j", "k", "l" ]

#y::render()
Hotkey("alt", render)

global isInit := 1
global mouseGridActive := 0
global bufferInput := ""
global cellMap := Map()
global lastFocusedCell := 0
global innerCellMap := Map()
global pointLocation := { x: 0, y:0, box: { x: 0, y: 0, w: 0, h: 0 } }
global finePointCellKey := 0

setGridState() {
  global CANVAS_WIDTH := A_ScreenWidth
  global CANVAS_HEIGHT := A_ScreenHeight
  global CELL_WIDTH := CANVAS_WIDTH / DIRECTION_X.Length
  global CELL_HEIGHT := CANVAS_HEIGHT / DIRECTION_Y.Length

  ; Global gui & hooks
  global GRID_IH := InputHook("")
  global BORDER_GRID, TAG_GRID, BORDER_SUB_GRID, TAG_SUB_GRID
  global FOCUS_COL_BOX := Array()
  global POINTER_BOX, POINTER_BOX_BG

  ; Convert key arrays into maps
  global DIRECTION_X_MAPS := Map()
  global DIRECTION_Y_MAPS := Map()
  global FIND_POINT_DIRECTION_MAPS := Map()
  for i, val in DIRECTION_X
    DIRECTION_X_MAPS[val] := i
  for i, val in DIRECTION_Y
    DIRECTION_Y_MAPS[val] := i
  for i, val in FINE_POINT_DIRECTIONAL_KEYS
    FIND_POINT_DIRECTION_MAPS[val] := val
}
setGridState()

render(*) {
  global BORDER_GRID, TAG_GRID, mouseGridActive, GRID_IH
  if (mouseGridActive) {
    escape(GRID_IH, "")
    return
  }

  BORDER_GRID := Gui("+AlwaysOnTop -Caption +ToolWindow -SysMenu +E0x20", "Transparent Grid Backgrounnd")
  WinSetTransparent(WINDOW_TRANSPARENT, BORDER_GRID.Hwnd)  ; Value from 0 (invisible) to 255 (opaque)
  BORDER_GRID.BackColor := BITMAP_BG_COLOR  ; Required for transparency to work
  pic := BORDER_GRID.Add("Pic", "x0 y0 w" CANVAS_WIDTH " h" CANVAS_WIDTH)
  hbm := CreateGridBitmap(CANVAS_WIDTH, CANVAS_WIDTH, CELL_WIDTH, CELL_HEIGHT, DIRECTION_Y.Length, DIRECTION_X.Length)
  pic.Value := "HBITMAP:*" hbm

  TAG_GRID := Gui("+AlwaysOnTop -Caption +ToolWindow -SysMenu +E0x20", "Transparent Grid") ; +E0x20 allows click-through
  TAG_GRID.BackColor := BITMAP_BG_COLOR  ; Required for transparency to work
  TAG_GRID.SetFont("s" FONT_SIZE " Bold q2 " FONT_COLOR, FONT_FAMILY)
  WinSetTransColor(BITMAP_BG_COLOR, TAG_GRID.Hwnd)

  renderGridCells()
  renderPointer(CANVAS_WIDTH/2, CANVAS_HEIGHT/2)

  BORDER_GRID.Show("NoActivate x0 y0 w" CANVAS_WIDTH " h" CANVAS_HEIGHT)
  TAG_GRID.Show("NoActivate x0 y0 w" CANVAS_WIDTH " h" CANVAS_HEIGHT)
  watchKeyPress()
  mouseGridActive := 1
}
; render()

renderGridCells() {
  ; Build grid and map labels to controls
  for rowIndex, row in DIRECTION_Y {
    for colIndex, col in DIRECTION_X {
      label := col . row
      x := (colIndex - 1) * CELL_WIDTH
      y := (rowIndex - 1) * CELL_HEIGHT

      ctrl := TAG_GRID.AddText("x" x " y" y " w" CELL_WIDTH " h" CELL_HEIGHT " Center BackgroundTrans +0x200", StrUpper(col "   " row))
      cellMap[label] := {ctrl: ctrl, x: x, y: y}
    }
  }
}

renderPointer(x, y) {
  global POINTER_BOX_BG := BORDER_GRID.AddText("x0 y0 w" CANVAS_WIDTH " h" CANVAS_HEIGHT " " "Backgrounda13131 Hidden", "")
  global POINTER_BOX := BORDER_GRID.AddText("x0 y0 w" CENTER_POINT_SIZE " h" CENTER_POINT_SIZE " " CENTER_POINT_COLOR, "")
  movePointer({ x: 0, y:0, w: CANVAS_WIDTH, h: CANVAS_HEIGHT })
}
movePointer(box := 0, renderBox := 0) {
  global pointLocation, POINTER_BOX, POINTER_BOX_BG
  halfSize := CENTER_POINT_SIZE / 2
  pointLocation := {
    x: box.x + (box.w / 2),
    y: box.y + (box.h / 2),
    box: box
  }

  POINTER_BOX.Visible := false
  POINTER_BOX.Visible := true
  POINTER_BOX.Move(pointLocation.x - halfSize,  pointLocation.y - halfSize)
  if (renderBox) {
    POINTER_BOX_BG.Visible := true
    POINTER_BOX_BG.Move(box.x, box.y, box.w, box.h)
  } else {
    POINTER_BOX_BG.Visible := false
  }
}
moveCursor(x:=0, y:=0) {
  CoordMode("Mouse", "Screen")
  MouseMove(x,y)
}

highlightCell(cellId) {
  global lastFocusedCell, BORDER_SUB_GRID, TAG_SUB_GRID

  if !cellMap.Has(cellId) {
    ; dd("Invalid cell: " cellId)
    return
  }

  restoreLastCellTag()
  cell := cellMap[cellId]
  cell.ctrl.Visible := false
  destroyCellGrid() ; Destroy old focusesd cell
  destroyFocusCol()

  gw := CELL_WIDTH
  gh := CELL_HEIGHT
  col := SUB_GRID_2D_DIRECTIN[1].Length
  row := SUB_GRID_2D_DIRECTIN.Length
  cw := gw / col
  ch := gh / row

  BORDER_SUB_GRID := Gui("+AlwaysOnTop -Caption +ToolWindow -SysMenu +E0x20", "Transparent Cell Grid Backgrounnd")  ; +E0x20 allows click-through
  pic := BORDER_SUB_GRID.Add("Pic", "x0 y0 w" gw " h" gh)
  hbm := CreateGridBitmap(gw, gh, cw, ch, row, col, 0x00ff00)
  pic.Value := "HBITMAP:*" hbm
  WinSetTransparent(SUB_GRID_TRANSPARENT, BORDER_SUB_GRID.Hwnd)  ; Value from 0 (invisible) to 255 (opaque)
  BORDER_SUB_GRID.Show("NoActivate x" cell.x " y" cell.y " w" gw " h" gh)

  TAG_SUB_GRID := Gui("+AlwaysOnTop -Caption +ToolWindow -SysMenu +E0x20", "Transparent Cell Grid Forgrounnd")  ; +E0x20 allows click-through
  TAG_SUB_GRID.SetFont("s" SUB_GRID_FONT_SIZE " Bold q2 " FONT_COLOR, FONT_FAMILY)
  TAG_SUB_GRID.BackColor := BITMAP_BG_COLOR  ; Required for transparency to work
  TAG_SUB_GRID.Show("NoActivate x" cell.x " y" cell.y " w" gw " h" gh)
  WinSetTransColor(BITMAP_BG_COLOR, TAG_SUB_GRID)

  movePointer({x: cell.x, y: cell.y, w: CELL_WIDTH, h: CELL_HEIGHT})

  for rowIndex, row in SUB_GRID_2D_DIRECTIN {
    for colIndex, label in row {
      x := (colIndex - 1) * cw
      y := (rowIndex - 1) * ch
      cellCtrl := TAG_SUB_GRID.AddText("x" x " y" y " w" cw " h" ch " Center BackgroundTrans +0x200", StrUpper(label))
      innerCellMap[label] := {ctrl: cellCtrl, x: x, y: y, cw: cw, ch: ch}
    }
  }

  ; dd("Cell: " cellId "`nX: " cell.x " Y: " cell.y "`nSize: " CELL_WIDTH "x" CELL_HEIGHT)
  lastFocusedCell := cell
  return cell
}

destroyCellGrid() {
  global BORDER_SUB_GRID, TAG_SUB_GRID
  if (IsSet(BORDER_SUB_GRID) && BORDER_SUB_GRID is Gui && BORDER_SUB_GRID.Hwnd) {
    BORDER_SUB_GRID.Destroy()
    BORDER_SUB_GRID := 0
  }
  if (IsSet(TAG_SUB_GRID) && TAG_SUB_GRID is Gui && TAG_SUB_GRID.Hwnd) {
    TAG_SUB_GRID.Destroy()
    TAG_SUB_GRID := 0
  }
}
destroyFocusCol() {
  global FOCUS_COL_BOX
  for index, colG in FOCUS_COL_BOX {
    colG.Visible := false
    FOCUS_COL_BOX := Array()
  }
}
restoreLastCellTag() {
  ; cell.ctrl.Opt("+Background003000")
  global lastFocusedCell
  if (lastFocusedCell && lastFocusedCell.ctrl.Visible == 0) {
    lastFocusedCell.ctrl.Visible := true
  }
}


highlightCol(char) {
  global FOCUS_COL_BOX

  if(DIRECTION_X_MAPS.Has(char) == 0) {
    return false
  }

  destroyFocusCol()
  restoreLastCellTag()

  colX := 0
  focusColIndex := DIRECTION_X_MAPS[char]
  if (focusColIndex > 1) {
    colX := (focusColIndex - 1) * CELL_WIDTH
  }

  movePointer({x : colX, y: 0, w: CELL_WIDTH, h: CANVAS_HEIGHT})
  col1 := BORDER_GRID.AddText("x" colX-1 " y0 w5 h" CANVAS_HEIGHT " Center Border BackgroundYellow", "")
  col2 := BORDER_GRID.AddText("x" colX+CELL_WIDTH-5 " y0 w5 h" CANVAS_HEIGHT " Center Border BackgroundYellow", "")
  FOCUS_COL_BOX := [ col1, col2 ]
  WinRedraw(BORDER_GRID.Hwnd)
  return true
}

escape(ih, char) {
  global bufferInput, lastFocusedCell, finePointCellKey

  ; restoreLastCellTag()
  ih.Stop()
  lastFocusedCell := 0
  finePointCellKey := 0
  bufferInput := ""
  destroyFocusCol()
  destroyCellGrid()
  TAG_GRID.Destroy()
  BORDER_GRID.Destroy()
  global mouseGridActive := 0
}

; Define the OnEnd callback function
onInputEnd(ih, char) {
  global bufferInput, FOCUS_COL_BOX, BORDER_SUB_GRID, TAG_SUB_GRID, lastFocusedCell, finePointCellKey, POINTER_BOX

  if (StrLen(bufferInput) >= 2) {
    bufferInput := SubStr(bufferInput, -1) . char ; set last char with new char
  } else {
    global bufferInput .= char
  }

  EscChar := Chr(27)
  if (char = EscChar) {
    escape(ih, char)
    return
  }

  spaceChar := Chr(32)
  if (char = spaceChar) {
    if (finePointCellKey && innerCellMap.Has(finePointCellKey)) {
      ; Cursor should already on a finePointCellKey, so just send click
      Send("{Click}")
    } else {
      moveCursor(pointLocation.x,pointLocation.y)
      Send("{Click}")
    }

    escape(ih, char)
    return
  }

  ; finePointCellKey directional mappings
  if (finePointCellKey && innerCellMap.Has(finePointCellKey) && FIND_POINT_DIRECTION_MAPS.Has(char)) {
    innerCel := innerCellMap[finePointCellKey]
    targetX := lastFocusedCell.x + innerCel.x
    targetY := lastFocusedCell.y + innerCel.y

    if (char == "h") {
      targetX := targetX
      targetY := targetY + innerCel.ch / 2
    } else if (char == "l") {
      targetX := targetX + innerCel.cw
      targetY := targetY + innerCel.ch / 2
    } else if (char == "k") {
      targetX := targetX + innerCel.cw / 2
      targetY := targetY
    } else if (char == "j") {
      targetX := targetX + innerCel.cw / 2
      targetY := targetY + (innerCel.ch - 1)
    }

    moveCursor(targetX, targetY)
    ; finePointCellKey := 0
    return
  }

  if (IsSet(TAG_SUB_GRID) && TAG_SUB_GRID != 0 && TAG_SUB_GRID is Gui && TAG_SUB_GRID.Hwnd) {
    lowerChar := StrLower(char)
    if (innerCellMap.Has(lowerChar)) {
      innerCel := innerCellMap[lowerChar]

      leftShift := GetKeyState("LShift", "P")
      rightShift := GetKeyState("RShift", "P")

      targetY := lastFocusedCell.y + innerCel.y + (innerCel.ch / 2)
      targetX := lastFocusedCell.x + innerCel.x  + (innerCel.cw / 2)

      if(leftShift || rightShift) {
        finePointCellKey := lowerChar
        POINTER_BOX.Visible := false
        moveCursor(targetX, targetY)
        return
      }

      targetY := lastFocusedCell.y + innerCel.y + (innerCel.ch / 2)
      targetX := lastFocusedCell.x + innerCel.x  + (innerCel.cw / 2)
      moveCursor(targetX, targetY)
      Send("{Click}")
      escape(ih, char)
      return
    }
  }

  focusCell := highlightCell(bufferInput)
  if (focusCell) {
    bufferInput := ""  ; Reset buffer after 2 characters
    return
  }

  if (StrLen(bufferInput) == 1) {
    hasVaidCol := highlightCol(bufferInput)
    if(hasVaidCol == 0 && FIND_POINT_DIRECTION_MAPS.Has(char)) {
      bufferInput := ""
      box := pointLocation.box
      Switch char {
        Case "h":
          movePointer({ x: box.x, y: box.y, w: box.w / 2, h: box.h }, 1)
        Case "l" :
          movePointer({ x: box.x + box.w / 2, y: box.y, w: box.w / 2, h: box.h }, 1)
        Case "k" :
          movePointer({ x: box.x, y: box.y, w: box.w, h: box.h / 2 }, 1)
        Case "j" :
          movePointer({ x: box.x, y: box.y + box.h / 2, w: box.w, h: box.h / 2}, 1)
      }
    }
    return
  }
}

; ------------------------------------------------
; -- Keymaps Listeners ---------------------------
; ------------------------------------------------
watchKeyPress() {
  global GRID_IH
  GRID_IH.KeyOpt("{All}", "N")  ; Allow all keys
  GRID_IH.OnChar := onInputEnd
  GRID_IH.Start()
}

; Class Keymap {
;   static GRID_KEYMAP_HOOK := InputHook("B L1 T1", "{Esc}")

;   static AltStart() {
;    Keymap.GRID_KEYMAP_HOOK.Start()
;     reason := Keymap.GRID_KEYMAP_HOOK.Wait()
;     if (reason = "Stopped") {
;       render()
;     } else if (reason = "Max") {
;       SendInput "{Blind}{LAlt down}"
;       SendInput Keymap.GRID_KEYMAP_HOOK.Input
;     }
;   }

;   static AltUp() {
;     if (Keymap.GRID_KEYMAP_HOOK.InProgress) {
;       Keymap.GRID_KEYMAP_HOOK.Stop()
;     } else {
;       Send "{LAlt up}"
;     }
;   }
; }

; Draw a grid using GDI
CreateGridBitmap(w, h, cw, ch, rows, cols, borderColor := BITMAP_BORDER_COLOR) {
  hdc := DllCall("CreateCompatibleDC", "Ptr", 0, "Ptr")
  hbm := DllCall("CreateCompatibleBitmap", "Ptr", DllCall("GetDC", "Ptr", 0, "Ptr"), "Int", w, "Int", h, "Ptr")
  obm := DllCall("SelectObject", "Ptr", hdc, "Ptr", hbm, "Ptr")

  ; Fill background white
  backgroundBrush := DllCall("gdi32.dll\CreateSolidBrush", "UInt", BITMAP_BG_COLOR, "Ptr")
  rect := Buffer(16, 0)  ; RECT structure: left, top, right, bottom
  NumPut("Int", 0, rect, 0)
  NumPut("Int", 0, rect, 4)
  NumPut("Int", w, rect, 8)
  NumPut("Int", h, rect, 12)
  DllCall("User32.dll\FillRect", "Ptr", hdc, "Ptr", rect, "Ptr", backgroundBrush)
  DllCall("gdi32.dll\DeleteObject", "Ptr", backgroundBrush)

  ; Create red pen (BGR format: 0x0000FF = red)
  borderPen := DllCall("gdi32.dll\CreatePen", "Int", 0, "Int", 1, "UInt", borderColor, "Ptr")
  DllCall("gdi32.dll\SelectObject", "Ptr", hdc, "Ptr", borderPen)

  ; Draw vertical lines (starting from x = 0, no offset)
  Loop cols + 1 {
    x := (A_Index - 1) * cw ; Start from 0 for the first line
    x := x - (A_Index == 1 ? 0 : 1)

    DllCall("gdi32.dll\MoveToEx", "Ptr", hdc, "Int", x, "Int", 0, "Ptr", 0)
    DllCall("gdi32.dll\LineTo", "Ptr", hdc, "Int", x, "Int", h)
  }

  ; Draw horizontal lines (starting from y = 0)
  Loop rows + 1 {
    y := (A_Index - 1) * ch
    y := y - (A_Index == 1 ? 0 : 1)

    DllCall("gdi32.dll\MoveToEx", "Ptr", hdc, "Int", 0, "Int", y, "Ptr", 0)
    DllCall("gdi32.dll\LineTo", "Ptr", hdc, "Int", w, "Int", y)
  }

  ; Cleanup
  DllCall("gdi32.dll\DeleteObject", "Ptr", borderPen)
  DllCall("DeleteDC", "Ptr", hdc)
  return hbm
}

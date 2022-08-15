



Dim Port$(50)

CompilerIf #PB_Compiler_OS = #PB_OS_Windows
  BasePort$ = "COM"
CompilerElse
  BasePort$ = "/dev/ttyS"
CompilerEndIf


; window xyhw
winx = 100
winy = 200
winh = 450
winw = 400

; frame relative to window not screen 
frax = 20
fray = 20
frah = winh - fray - fray
fraw = winw - frax - frax

; list relative to window not frame
lvx = frax + 20
lvy = fray + 20
lvh = frah - fray - fray 
lvw = fraw - frax - frax

; button relative to window
butx = frax 
buty = winh - 80
buth = winh / 10
butw = winw / 10

; adjust frame and list to account for button 
frah = frah - buth - 20
lvh = lvh - buth - 20


If OpenWindow(0, winx, winy, winw, winh, "Serial Port list", #PB_Window_MinimizeGadget|#PB_Window_SizeGadget)
Gosub repaint
  Repeat
    Event = WaitWindowEvent()
    
    If Event = #PB_Event_Gadget 
      Select EventGadget()
         Case 3 ; Quit...
           Event = #PB_Event_CloseWindow
           
         Case 4 ; refresh 
           Gosub repaint 
      EndSelect
    EndIf
    If Event = #PB_Event_SizeWindow
      winx = WindowX(0)
      winy = WindowY(0)
      winw = WindowWidth(0)
      winh = WindowHeight(0)
      Gosub repaint    
    EndIf 
    If Event = #PB_Event_Timer
      Gosub repaint
    EndIf 
  Until Event = #PB_Event_CloseWindow

EndIf

End

repaint:


; adjust size if window gets to small
If winh < 200
  winh = 200
EndIf 
If winw < 200 
  winw = 200
EndIf


; frame relative to window not screen 
  frax = 20
  fray = 20
  frah = winh - fray - fray - 40
  fraw = winw - frax - frax

; list relative to window not frame
  lvx = frax + 20
  lvy = fray + 20
  lvh = frah - fray - fray 
  lvw = fraw - frax - frax

; button relative to window
  butx = frax 
  buty = frah
  buth = 20
  butw = 40
  

  
; adjust frame and list to account for button 
  frah = frah - buth - 20
  lvh = lvh - buth - 20

  
  ResizeWindow(0, winx, winy, winw, winh)
  FrameGadget(1, frax, fray, fraw, frah, "Ports Found") 
  ListViewGadget(2, lvx, lvy, lvw, lvh)
  
  found = 0
  For x = 1 To 50
    Port$(x-1) = BasePort$+ Str(x)
    If OpenSerialPort(0, Port$(x-1), 300, #PB_SerialPort_NoParity, 8, 1, #PB_SerialPort_NoHandshake, 1024, 1024)
;     Debug "Success " + "Serial Port: " + Port$(x-1)
      AddGadgetItem(2 ,-1, Port$(x-1))
      found = found + 1
      CloseSerialPort(0)
    EndIf

  Next 
  CloseGadgetList()
  
  ButtonGadget (3, butx, buty, butw, buth, "Quit" )
  ButtonGadget (4, butx + butx + butx, buty, butw+butw, buth, "Refresh")
  f$ = "Found: " + Str(found)
  TextGadget  (5, 10, winh-30, 250, 24, f$)
  
  Return

; IDE Options = PureBasic 6.00 LTS (Windows - x64)
; CursorPosition = 127
; FirstLine = 90
; Folding = -
; EnableXP
; Executable = ..\..\..\output\SerialPortList.exe
; DisableDebugger
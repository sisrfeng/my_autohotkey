# my_autohotkey
Make your keyboard more powerful!




Some comments are in Chinese, so a translation tool may help.

content below is all in the wf_key.ahk file.
# 1. {space} as a modify key(modifier)
```
; #Hotstring EndChars -()[]{}:;'"/\,.?!`n `t
;  `n is Enter
;  `t is Tab
; #Hotstring EndChars `t ,
; because I have many  `~space & x` like hotkeys，if use {space} as Endchar，it often behaves as if {space} did not release
#Hotstring EndChars `t
#Include, D:\leo_string.ahk

~space & l::MsgBox,  %A_ThisHotkey%
~space & p::+!p
~space & r::To_theProgram("C:\Program Files\Alacritty\alacritty.exe")
```

# and so on



   ; 要编译才能运行，所以不像python那样顺序执行？
 ; command后面，别加initial comma了
; https://lexikos.github.io/v2/docs/v2-changes.htm

; 阻止win alt键弹出菜单
; Send {Blind}{LButton down}
; 阻止shift键不{up},可能要用:


; todo   等v2发布了exe就转过去
#NoEnv   ; Avoids checking empty variables to see if they are environment variables (recommended
#Warn UseUnsetGlobal  ; detecting common errors.
#Warn UseUnsetLocal  ; detecting common errors.d
; #Warn All  ; detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
; v2的改进: SendMode defaults to Input instead of Events

SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#persistent         ;让脚本持久运行不退出

/*
keyboard hook is normally installed only when the script contains one of the following:
1) hotstrings;
2) one or more hotkeys that require the keyboard hook (most do not);
3) SetCaps/Scroll/NumLock AlwaysOn/AlwaysOff;
4) the Input command, for which the hook is installed upon first actual use.
*/
#InstallKeybdHook ;  consume at least 500 KB of memory
#InstallMouseHook

; 加了这行, capslock就死掉了，在powertoy里map为vk88也不行:
; SetCapsLockState, AlwaysOff

SetScrollLockState, AlwaysOff

; force no initial commas

/*
; sc076会被ignore
; CapsLock::
; Send {SC076}
; MsgBox, %A_ThisHotkey%
; return

; SC076::
; MsgBox, sc7 %A_ThisHotkey%
; return

; Send {Ctrl down}c{Ctrl up}  ; 不行，
; Send {Ctrl Down}c{Ctrl Up}  ; 可以
*/

; [[=======================================正文====================================]]

vscode_wf:= "C:\Users\noway\AppData\Local\Programs\Microsoft VS Code\code.exe"
chrome_wf:= "C:\Program Files\Google\Chrome\Application\chrome.exe"

; 用法：  msg("你的string")  ; 单引号不行
msg(my_msg){
    MsgBox, ,标题 ,%my_msg% , 0.3
}

; #Hotstring EndChars -()[]{}:;'"/\,.?!`n `t
;  `n is Enter
;  `t is Tab
#Hotstring EndChars /.
; 因为有很多~space & 的hotkey，如果用空格作为Endchar，space就会经常仿佛没弹起来
; #Hotstring EndChars `t ,
#Include, D:\leo_string.ahk

; 激活quicker
; Lalt & Esc::


VK88 & c::MsgBox, , Title, %A_ThisHotkey%, 0.3  ; 逐步淘汰这个：保护小指. 而且这货在zsh里是小写变大写




; VK88 & s::

; #If WinActive("ahk_exe AutoHotkey.exe")
; CapsLock:: ToolTip, %A_ThisHotkey%
; VK88:: ToolTip, %A_ThisHotkey%
; #If


; If WinActive("ahk_class code.exe")  ; 换成这行，并删掉下面的#If后，报错：duplicate key啥的：
#If WinActive("ahk_class code.exe")
{
VK88:: Send {ESC}  ; /这行如果在下面那行下面，会多输出{F11}

!n::
Send {F11}
;myIME()  ; /貌似在vscode里设置了？
}
#If

; todo: sc021换回f
;   别这么干，敲f半天出不来字母
; SC021::
        ; SC021 代表f
        ; KeyWait, KeyName , Options
        ; If `options` is blank, the command will wait indefini为ely for
        ; the specified key or mouse/joystick button to be physically released by the user.
; keywait, SC021,  T0.3
; if (ErrorLevel)
; {
    ; send {F1}
    ; keywait,SC021
; }
; else
    ; send {SC021}
; return
; }
; #If

; SC021代表 {f}，如果前面的代码用了scan code表示{f}，这里用f就识别不到
; #f::这行留着，方便搜索
;
; #SC021::
; v: visit
; #v::
;    Send {Ctrl down}c{Ctrl up}
;    run ,  %chrome_wf%  "%Clipboard%"
;    exit

; v2: SendText, equivalent to SendRaw but using {Text} mode instead of {Raw} mode.

; ^!+# 顺序 does not matter. For example, ^!c is the same as !^c.

;v2:          #IfWinActive 改成  #HotIf:

; ctrl p /  ctrl  n
    #IfWinActive ahk_exe chrome.exe
        ; Tab::Send {space 4}
        ^p::Send, {up}
        ^n::Send, {down}
    #IfWinActive


    #IfWinActive ahk_exe Explorer.EXE
        ^p::Send, {up}
        ^n::Send, {down}
    #IfWinActive

    #IfWinActive ahk_exe alacritty.EXE
        ^p::Send, {up}
        ^n::Send, {down}
    #IfWinActive

!x::MsgBox, %A_ThisHotkey%



; the $ prefix is equivalent to having specified `#UseHook` somewhere above the definition of this hotkey.
; The $ prefix has no effect for mouse hotkeys, since they always use the mouse hook


/*
LAlt & VK88::ShiftAltTab  ; 别用了，alt tab就行
Alt-Tab hotkeys simplify the mapping of new key combinations to the system's Alt-Tab hotkeys


AppsKey::ToolTip Press < or > to cycle through windows.
AppsKey Up::ToolTip
~AppsKey & <::Send !+{Esc}
~AppsKey & >::Send !{Esc}

VK88 & p::
send {end}
send {enter}
send %clipboard%
return
*/





VK88 & v::
    Send {HOME}e
    if WinActive("ahk_exe WindowsTerminal.exe") or WinActive("ahk_exe code.exe") or  WinActive("ahk_exe code.exe")
        Send {Enter}
    return

; todo: 改成#HotIf包住
#If WinActive("Local: wf_key.ahk") or WinActive("Local: leo_string.ahk")
{
~^s::
;波浪号： When the hotkey fires, its key's `native` function will not be blocked
    ; ~RButton::MsgBox You clicked the right mouse button.   ; fired as soon as the button is pressed.
    ; ~RButton & C::MsgBox You pressed C while holding down the right mouse button.
    Send {Esc}
    SendRaw :w
    ; 少了一个冒号就不行，有一次半天找不到问题在哪
    Send {Enter}
    msg("重新加载ahk脚本")
    Reload
    return
}
#If


#IfWinActive ahk_exe chrome.exe
    ; vimium-c搞定了, 不再需要:
        ; ~^h::Send ^{PGUP}
        ; ~^l::Send ^{PGDN}
    ^w::send,^{BACKSPACE}
#IfWinActive




; powertoy 把capslock 改成了vk136  (本来没有意义的键)
; ahk里用VK136作为modify key (但在ahk里, 用16进制表示virtual key,  \x88 = 136  )
VK88 & g::
MsgBox, %A_ThisHotkey%
return



; 发现处女地：VK88 + space +  字母


VK88 & q::  ; 关闭窗口中的tab
    if WinActive("ahk_exe code.exe") or WinActive("ahk_exe MobaXterm.exe") or WinActive("ahk_exe WindowsTerminal.exe"){
        Send {Ctrl down}{F4}{Ctrl up}
        ; 不行。关掉neovim也不行
        ; VK88 & q::
        ; Send :q
        ; return
        }
    else if WinActive("ahk_exe wechat.exe")
        Send {Alt down}{F4}{Alt up}
        ;  WinActive("ahk_exe Explorer.EXE") : 别这么设，容易不小心关机了：
    else if WinActive("ahk_exe wps.exe") or WinActive("ahk_exe chrome.exe") or WinActive("ahk_exe msedge.exe")
        Send ^w
    else
        msg(A_ThisHotkey)

    return

; zsh下不行
VK88 & y::
send {home}
send +{end}
send ^c
send {down}
return


~Tab & Enter::msg("千万别 把Tab前的波浪号去掉，否则无法得到4个空格")

#q::
MsgBox, %A_ThisHotkey%

return


;  04090409: 英文输入法
myIME(dwLayout:= 04090409){
    HKL:=DllCall("LoadKeyboardLayout", Str, dwLayout, UInt, 1)
    ControlGetFocus,ctl,A
    SendMessage,0x50,0,HKL,%ctl%,A
}


VK88::
    if not WinActive("ahk_exe WeChat.exe")
        Send {ESC}
    myIME()
    ; #If WinActive("ahk_exe chrome.exe")
    ; ; Send ^c  ; 牛客和leetcode的vim切到normal

    return


VK88 & '::  Send &

#IfWinActive ahk_exe chrome.exe
VK88 & \::
send  +{End}
send  ^{\}
Return
#IfWinActive



To_theProgram(Program){
    SplitPath Program, File_Without_Path
    /*
    [[ ============ 关于plitPath=====================
    SplitPath, InputVar , OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive

    假设 InputStr := "C:\My Documents\Address List.txt"

    To fetch only its directory:
    SplitPath, InputStr,, dir

    To fetch all info:
    SplitPath, InputStr, name, dir, ext, name_no_ext, drive

    The above will set the variables as follows:
    name = Address List.txt
    dir = C:\My Documents
    ext = txt
    name_no_ext = Address List
    drive = C:
    ;    ============ 关于plitPath=====================]]

    ;  A value of 0 usually indicates success, and any other value usually indicates failure. You can also set the value of ErrorLevel yourself.
    ; Process, Exist , PIDOrName
        ; Sets ErrorLevel to the Process ID (PID) if a matching process exists,
        ; or 0 otherwise
     */

    Process, Exist, %File_Without_Path%
    /*
    用于debug：
    MsgBox  ErrorLevel 是：%ErrorLevel%  File_Without_Path是: %File_Without_Path%
    如果开了多个桌面，无法切换到另一个桌面中的Process吧 （起码chrome是这样）

    暂时不管这个说法？ ErrorLevel is set to 0 if a sub-command failed or timed out.
    Built-in variables such as Clipboard, ErrorLevel, and A_TimeIdle are never local
    报错：if (%ErrorLevel% = 0) {
    */
    if (ErrorLevel = 0) {
        ; run, Target , WorkingDir, Options, OutputVarPID
        ; WorkingDir: The working directory for the launched item.
        ;   Do not enclose the name in double quotes even if it contains spaces.
        Run, %Program%, ,Max
    }

    else
        WinActivate, ahk_pid %ErrorLevel%
    WinMaximize, A
}



; 会锁屏
; #l::


/*
; 应该不行，tab有输入，在文本框不能作为修饰键
~Tab & h::
SendEvent {Blind}{( down}
KeyWait h
SendEvent {Blind}{( up}
return
*/



; >>>---------------------------------------------------------------------CapsLock great again帝国
; vim里面 这是注释
; ^/::Send {BS}

; 小括号
VK88 & u::Send (
; 中括号
VK88 & i::Send )
; 输入大括号
VK88 & o::Send {{}

; 被占用了
; VK88 & n:: Send ^{BS}

; todo  vscode里有时不灵
~^VK88::
Send ^+{Tab}
return

; https://autohotkey.com/board/topic/19388-sending-ctrl-number-to-wow/
; ^[::  ; vim里有用

; ~^8:
; Send ^{Tab}
; return

; 别用
; ~!VK88::
; Send !+{Tab}
; return

; 留给 VK88 alt ，再加其他键
LAlt & VK88::
Send {-}{Enter}
; MsgBox, , wf_标题, 往上返回, 0.1
return



VK88 & h::
if GetKeyState("control") = 0
{
    if GetKeyState("alt") = 0
        Send {Left}
    else
        Send +{Left}
    return
}
else {
    if GetKeyState("alt") = 0
        Send ^{Left}
    else
        Send +^{Left}
    return
}
return

;---------------------------------begin
VK88 & j::
if GetKeyState("control") = 0
{
    if GetKeyState("alt") = 0
        Send {Down}
    else
        Send +{Down}
    return
}
else {
    if GetKeyState("alt") = 0
        Send ^{Down}
    else
        Send +^{Down}
    return
}
return
;-----------------------------------end
VK88 & k::
if GetKeyState("control") = 0
{
    if GetKeyState("alt") = 0
        Send {Up}
    else
        Send +{Up}
    return
}
else {
    if GetKeyState("alt") = 0
        Send ^{Up}
    else
        Send +^{Up}
    return
}
return

VK88 & l::
if GetKeyState("control") = 0
{
    if GetKeyState("alt") = 0
        Send {Right}
    else
        Send +{Right}
    return
}
else {
    if GetKeyState("alt") = 0
        Send ^{Right}
    else
        Send +^{Right}
    return
}
return
; ---------------------------------------------------------------------《《《 CapsLock great again帝国


; >>>--------------------------------------------------------------------- copy search 复制搜索 专区：
CopyAll_Search(engine_url){
    ; Clipboard := ""
    Send {Home}
    Send +{End}
    Send {Ctrl Down}c{Ctrl Up}
    cmd := engine_url
    ClipWait, 0.6
    if ErrorLevel
        MsgBox, , , 复制失败, 0.2
    run  "%cmd%%Clipboard%"
    }

; URLs occur most commonly to reference web pages (http)
; but are also used for file transfer (ftp), email (mailto), database access (JDBC), and many other applications.
; A typical URL could have the form http://www.example.com/index.html, which indicates a protocol (http), a hostname (www.example.com), and a file name (index.html).

CopySearch(engine_url){
    if not ( WinActive("ahk_exe code.exe")  or WinActive("ahk_exe MobaXterm.exe") or WinActive("ahk_exe WindowsTerminal.exe")  )
    ; 开了vim时 用vim的register复制, 而非ctrl c. 不清空clipboard
        {Clipboard := ""
        Send {Ctrl Down}c{Ctrl up}
        ClipWait, 0.5
        if ErrorLevel
            MsgBox, , , 复制失败, 0.2
            }

    str := engine_url . """" . Clipboard . """"
        ; 改搜索关键词套上双引号, 精准搜索
        ; engine_url和Clipboard是个string类型的变量? 所以别再加引号?
        ; 失败尝试:
            ;str := %engine_url . """" . Clipboard . """"
            ; str := %engine_url . """" . %Clipboard% . """"
    run %str%
    ; run ,  %chrome_wf%  "%cmd%%Clipboard%"  ; 默认就是用 默认的浏览器打开
    Return
        ; 需要return吗？
    }

~space & i::msg("待用")
    ; Send {Ctrl Down}c{Ctrl up}
    ; chrome_wf := "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
    ; ClipWait
    ; cmd := "https://www.bing.com/search?q="
    ; run ,  %chrome_wf%  "%cmd%%Clipboard%"

#`::MsgBox, ,  , %A_ThisHotkey%, 0.2
#a::run "https://cmb-d3-ocr.feishu.cn/drive/home/"  ; 飞书，拼音：f ei 飞，念着像a
#b::CopySearch("https://www.bing.com/search?q=")

#c::
    Clipboard := ""
    Send {Ctrl Down}c{Ctrl up}
    ClipWait, 0.9
    if ErrorLevel
        MsgBox, , , 复制失败, 0.2
    str := "https://www.google.com/search?q=" . """" . Clipboard . """" "+site:stackoverflow.com"
    run %str%
    return



#i::CopySearch("https://www.google.com/search?q=")
#^i::CopyAll_Search("https://www.google.com/search?q=")

; #g::CopySearch("https://www.github.com/search?q=")
; "https://hub.fastgit.org/search?q="
#g::
    Clipboard := ""
    Send {Ctrl Down}c{Ctrl up}
    ClipWait, 0.9
    if ErrorLevel
        MsgBox, , , 复制失败, 0.2
    ; 谷歌搜索时，单引号和双引号作用有时一致，但官方教的是双引号
    str := "https://www.google.com/search?q=" . """" . Clipboard . """" "+site:github.com"
    run  %str%
    return
        ; a double-quote is represented by ""  点号用于字符串拼接
        ; 单引号和双引号的失败用法
            ; 1. 如果Clipboard两边加%, 会把复制到的字符串当作变量
            ; tmp := "https://www.google.com/search?q=" . """" . %Clipboard% . """" "+site:github.com"

            ; 2.不能用单引号包住网址
                ; run  "C:\Program Files\Google\Chrome\Application\chrome.exe" 'https://www.google.com/'
                ; run  'https://www.google.com/search?q="%Clipboard%"+site:github.com'
            ; 3. 不能双引号套双引号
                ; run  "https://www.google.com/search?q="%Clipboard%"+site:github.com"

#k::CopySearch("https://search.bilibili.com/all?keyword=")  ; k for kuaile 看b站就很快乐

#o::run, https://docs.opencv.org/4.x/index.html


; q for question 或者p（python）的下一个字母

#p::
    keywait, p,  T0.1  ; 等这个键被release
    if (ErrorLevel)
    {
        ;长按, 外接显示器
        Send #p
        keywait, p
    }
    else  ; 短按
        CopySearch("https://docs.python.org/3.10/search.html?q=")
    return

; 或者用https://www.robvanderwoude.com/rundll.php来切到第二屏幕


#s::CopySearch("https://www.semanticscholar.org/search?q=")
#t::CopySearch("https://pytorch.org/docs/stable/search.html?q=") ; t for torch

; #x:: 可以用windows给的功能
; https://www.interfacett.com/blogs/modify-winx-menu-windows-10/
; 或者 删除
; C:\Users\user_name\AppData\Local\Microsoft\Windows\WinX
; Or  deleted all contents of its group folders


#y::CopySearch("https://www.youtube.com/search?q=")
; #z::CopySearch("https://www.zhihu.com/search?type=content&sort=upvoted_count&vertical=answer&q=")
    ; sort=upvoted_count有bug, 删掉
#z::CopySearch("https://www.zhihu.com/search?type=content&vertical=answer&q=")
                                                                            ; 只搜回答
^#z::CopySearch("https://www.zhihu.com/search?type=content&q=%E8%83%86%E5%A4%A7%E8%B7%AF%E9%87%8E%20%20")  ; 搜自己的知乎

; ---------------------------------------------------------------------《《《copy search 复制搜索 专区


; ------------------------------------------------------ ~space & 系列
; space作为modify key，可能有bug，尝试：
    /*
    Space::return
    Space Up::
        if (A_PriorKey = "Space")
        {
            Send {Space}
        }
        return
    */

    space & Ctrl::send,^{BS}

    ; space 加 capslock ，无法实现alt F4
    ~space & Esc::send !{F4}

    ; 这样有bug：没有chrome窗口存在时，无法启动chrome。（仅在开了多桌面 且另外一个桌面有chrome才有这bug？）
    ; ~space & c:: To_theProgram("C:\Program Files\Google\Chrome\Application\chrome.exe")

    ~space & c::
        if WinExist( "ahk_exe chrome.exe")
            WinActivate
        else
            Run, "C:\Program Files\Google\Chrome\Application\chrome.exe", , Max
        return

    ~space & d::
        ; 等{d}这个键被release
        keywait, d,  T0.1
        if (ErrorLevel)  ; 长按才会到桌面  避免想输入{d}时，不小心同时按下空格和d，
        {
            ; Send #d
            msg("长按d  待用")
            keywait, d
        }
        else
            send {d}
    return

    ; tmux 的prefix
        ^Space::send ^!{F10}
        ; #If not ( WinActive("ahk_exe code.exe")  or WinActive("ahk_exe MobaXterm.exe") or WinActive("ahk_exe WindowsTerminal.exe")  )
        ;     ; 方便search，留着
        ;     ; ^{Space}
        ;     ; ctrl space
        ;     ^Space::send ^{Del}
        ; #If
        ; vscode 里设置了：
        ; { "key": "ctrl+space",
        ;   "command": "deleteWordRight",
        ;   "when": "textInputFocus && !editorReadonly" }


        RAlt::Send ^!{F10}
            ; 在nvim,tmux和vscode里的涉及这个键
            ; tmux.conf 里设置了：set -g prefix
            ; # 多个快捷键都在vscode中无效.  别在vscode里开tmux了

        ; 让左右Alt都可以作为tmux的prefix
            ; 容易出bug, 先别搞
            ; Lalt::
            ; SC01D::
            ;     ; 等{LAlt}这个键被release
            ;     keywait, SC01D,  T0.1
            ;     if (ErrorLevel)  ; 长按才会到桌面  避免想输入{d}时，不小心同时按下空格和d，
            ;     {
            ;         ; Send {CtrlDown}{ShiftDown}}2{ShiftUp}{CtrlUp}
            ;         msg("hihihi")
            ;         keywait, SC01D
            ;     }
            ;     else
            ;         send SC01D
            ; return

    ; explorer
    ~space & e::
        if WinExist("ahk_class CabinetWClass")
            ; UniqueID := WinExist(WinTitle, 和其他可选参数)
            WinActivate, ahk_class CabinetWClass
        else{
            ; Run, "shell:C:\\Users\\noway\\Downloads"
            Run, "shell:desktop"
            sleep, 300
            }
    WinMaximize, A
    Return

    ; ~space & f::MsgBox, %A_ThisHotkey%
    ; 用leaderF时 如果按太快, 会弹窗, 先注释掉

    ; j: 键盘
    ~space & j::
        if WinExist( "Local: wf_key.ahk")
            WinActivate
        else{
            ; todo:  字符串/string，在ahk v2里，只能用expression，legancy被淘汰了
            ; https://www.autohotkey.com/docs/Language.htm#strings
            my_file :=  "C:\Users\noway\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\wf_key.ahk"
            ; my_target := "%vscode_wf%%my_file%"  ; 空格无法转义，“Start Menu”被断开
            myDir := "C:\Users\noway\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"  ; 作为WorkinDir
            ; WorkingDir: The working directory for the launched item.
            ;             Do not enclose the name in double quotes even if it contains spaces.

            ; Run, Target---------------, WorkingDir, Options, OutputVarPID
            Run, %vscode_wf% "%my_file%", , Max
            ; 加了, workdingDir不生效  ; Max也不生效...
            ; 参考了：run ,  %chrome_wf%  "%cmd%%Clipboard%"
            sleep 1500
            }
        WinMaximize, A  ; A	:  The Active Window
        send {space up}
        ; todo
        ; 长时间休眠后，空格就像一直按下不弹回。要手动按下一次
    return

    ~space & l::MsgBox , ,  , %A_ThisHotkey%, 0.2
    ~space & p::^+!p
    ; ~space & #p::#p  ; 不行

    ~space & r::To_theProgram("C:\\Program Files\\Alacritty\\alacritty.exe")
    ; ~space & r::To_theProgram("F:\\cmder\\Cmder.exe")

    ~space & s::  ; ssh 远程
        if WinExist( "SSH: 2080ti")
            WinActivate
        else
            Run, "F:\vscode_ssh_2080ti.bat", , Max
        WinMaximize, A  ; A	:  The Active Window
    return

    ; 不能这么写，wt.exe和其程序窗口名不一致:
    ; ~space & t::To_theProgram("C:\\Users\\noway\\AppData\\Local\\Microsoft\\WindowsApps\\wt.exe")
    ; u for ubuntu, 这个terminal仅用于打开本地ubuntu
    ~space & u::
        if WinExist( "Terminal")
            WinActivate
        else
            Run, "C:\\Users\\noway\\AppData\\Local\\Microsoft\\WindowsApps\\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\\wt.exe", , Max
        return

#If WinActive( "ahk_exe WindowsTerminal.exe")
        !1::send {CtrlDown}{ShiftDown}}1{ShiftUp}{CtrlUp}
        ; !2::send {Ctrl}{shift}2  ;
        !2::send {CtrlDown}{ShiftDown}}2{ShiftUp}{CtrlUp}
        !3::send {CtrlDown}{ShiftDown}}3{ShiftUp}{CtrlUp}
#If

    ~space & v::  ; v for vscode
        if WinExist("Local")
            WinActivate
        else{
            Run, %vscode_wf% "D:\write_写作", ,Max
            Sleep 1000
            }
        WinMaximize, A  ; A	:  The Active Window
    return


    ~space & w::To_theProgram("F:\WPS Office\ksolaunch.exe")

    ~space & x::
        if WinExist("ahk_exe MobaXterm.exe")
            WinActivate
        else{
            Run, "F:\mobaxterm\2080Ti", , Max
            MsgBox,  , , 正在启动moba, 0.3
            }
    return

    ; ~space & x::
    ;     if WinExist( "Terminal")
    ;         WinActivate
    ;     else
    ;         Run, "C:\\Users\\noway\\AppData\\Local\\Microsoft\\WindowsApps\\wt.exe", , Max
    ;     return

    ; ~space & y::
    ; 会导致选择的文本不对

    ~space & z::To_theProgram("C:\Program Files (x86)\Zotero\zotero.exe")

    ; 系统设置里的“输入语言热键”，本来用ctrl space切换输入法/非输入法, 但我用了capslock,重复了待用

    #space::MsgBox ,  %A_ThisHotkey%

    ; ------------------------------------------------------------------------<<<space & 系列


^q::
    SetTitleMatchMode, 2 ;  2 = A window's title can contain WinTitle anywhere inside it to be a match
    if WinActive(".pdf")
        Send ^5  ; 划线
    else{
        Send,^{b}  ; bold
        Send,^{u}  ;underline
    }
    SetTitleMatchMode, 1
            ; 恢复默认设置
    return

; VK88 &;::
; Send :
; https://www.reddit.com/r/AutoHotkey/comments/8g54tj/problem_with_replacing_the_key/



; 会导致ditto有bug，抢ctrl键
; Rctrl::;
; Rctrl::;
VK88 & RShift::Send +6  ; 符号 ^

VK88 & SC02B::send, {F5}
    ; 这些都不行:
        ; VK88 & `\\::
        ; VK88 & `\::
        ; VK88 & \::
        ;     MsgBox, %A_ThisHotkey%

             return


; 算了, 只有知乎有这问题, stackedit没有:
;  想让知乎的markdown里敲backtick时不用切换到英文输入法. 失败的尝试:
    ; :?o:\b::``{space}``{space}{left}{left}

    ; Alt & Enter::
    ;     ; 在微信(不用加sleep和send,i)里可以, 但chrome不行
    ;     if not WinActive("ahk_exe WeChat.exe")
    ;         Send {ESC}
    ;     myIME()
    ;     Sleep, 1000
    ;     send i
    ;     Sleep, 1000
    ;     send ``
    ;     return

        ; LAlt & Enter::Send, ``
            ; 还是不能让搜狗输入法在中文模式下输入半角backtick

            ; 类似\\来转义backslash自己, ``表示一个backtick(反引号)

            ; `r is for a carriage return.
            ; `n is for a new line.
            ; `t is for a tab.
            ; 不行:
                ; VKC0::Send, ``

RShift::_
LShift & RShift::Send -


; https://www.zhihu.com/question/41446565/answer/91110371
VK88 & r::
myIME(00000804)  ; 中文
return

+Space::
myIME()
Send ~
return

+^Space::msg("待用")
; myIME()
; Send ~/
; return

; todo 能用嘛
; +!::
; Send !{F4}

; +!m::  ; 会漏掉几个数字
+!q::
myIME()
Send 666666666@qq.com
return


+!s::
myIME()
Send 441966666666666666
return

+!x::
myIME()
Send 2066666666
return

+!c::
myIME()
Send 13666666666
return


; VK88 & u::
; if GetKeyState("control") = 0
; {
    ; if GetKeyState("alt") = 0
        ; Send {PgUp}
    ; else
        ; Send +{PgUp}
    ; return
; }
; else {
    ; if GetKeyState("alt") = 0
        ; Send ^{PgUp}
    ; else
        ; Send +^{PgUp}
    ; return
; }
; return


;=====================================================================o
;                     VK88 Mouse Controller
;-----------------------------------o---------------------------------o
;                   VK88 + Up   |  Mouse Up
;                   VK88 + Down |  Mouse Down
;                   VK88 + Left |  Mouse Left
;                  VK88 + Right |  Mouse Right
 ;-----------------------------------o---------------------------------o
VK88 & Up::
if GetKeyState("alt") = 1
{
    if GetKeyState("control") = 0
        MouseMove, 0, -240, 0, R
    else
        MouseMove, -120, -120, 0, R
}
else {
    if GetKeyState("control") = 0
        MouseMove, 0, -16, 0, R
    else
        MouseMove, -16, -16, 0, R
}
return
VK88 & Down::
if GetKeyState("alt") = 1
{
    if GetKeyState("control") = 0
        MouseMove, 0, 240, 0, R
    else
        MouseMove,120, 120, 0, R
}
else {
    if GetKeyState("control") = 0
        MouseMove, 0, 16, 0, R
    else
        MouseMove, 16, 16, 0, R
}
return
VK88 & Left::
if GetKeyState("alt") = 1
{
    if GetKeyState("control") = 0
        MouseMove, -240, 0, 0, R
    else
        MouseMove, -120, 120, 0, R
}
else {
    if GetKeyState("control") = 0
        MouseMove, -16, 0, 0, R
    else
        MouseMove, -16, 16, 0, R
}
return

VK88 & Right::
if GetKeyState("alt") = 1
{
    if GetKeyState("control") = 0
        MouseMove, 240, 0, 0, R
    else
        MouseMove, 120, -120, 0, R
}
else {
    if GetKeyState("control") = 0
        MouseMove, 16, 0, 0, R
    else
        MouseMove, 16, -16, 0, R
}
return

VK88 & BackSpace::
send ^a
send {BackSpace}
Return

VK88 & ]::Send +8
VK88 & [::Send +3

VK88 & ,:: Send +4
VK88 & .:: Send +8
VK88 & /:: Send +1

VK88 & RCtrl::Send +5  ; 符号 ^


VK88 & Enter::
    Send {Blind}{LButton down}
    ; blind: 例子
    ; ^space::Send {Blind}{Ctrl Up} allows Ctrl to be logically up
    ; even though it is physically down.
    KeyWait Enter
    Send {Blind}{LButton up}
    ; 鼠标左键单击 等价于Enter，所以会输入 竖线 |？
    ; 不，之前忘了加下面这行return，导致`send |` 后才return
    Return

VK88 & RAlt::send +5
LShift & RAlt::send +5

VK88 & w:: Send ^{Right}
VK88 & b:: Send ^{Left}




; p： pair  百分号在vim里面用于match pair
VK88 & p::send +5



~Space & LAlt:: Send {WheelUp 2}
LAlt & Space:: Send {WheelDown 2}
!WheelDown::Send {WheelDown 20}
!WheelUp::Send {WheelUp 20}
; #u,
; #l
; https://www.autohotkey.com/docs/misc/Override.htm 说：
; You can disable all built-in Windows hotkeys except Win+L and Win+U
; 但这里教人禁用lock功能
; https://stackoverflow.com/questions/301053/re-assign-override-hotkey-win-l-to-lock-windows#



; VK88 & 2:: Send,{F5}
VK88 & 3:: Send,+3
VK88 & 4:: Send,+4
VK88 & 5:: Send,+5
; 不太好按
; VK88 & 6:: Send,+6
; VK88 & 7:: Send,+7
; VK88 & 8:: Send,+8
; VK88 & 9:: Send,+9
; VK88 & 0:: Send,+0
VK88 & -:: Send,+-
VK88 & =:: Send,+=

; VK88 & F1:: Send,
; VK88 & F12:: Send,






; +{Xbutton1}::BackSpace
Xbutton1::Del
Xbutton2::Enter

; ~!Xbutton1::
; Send {.}
; Send {BACKSPACE}
; return





; VK88 & Xbutton1::
VK88 & LButton::
MsgBox, %A_ThisHotkey%
return

VK88 & RButton::
MsgBox, %A_ThisHotkey%
return

VK88 & MButton::
MsgBox, %A_ThisHotkey%
return


!j:
Send +!9
Send {Shift}
return




/*
函数要一定要return或者exit？
非也
A blank value is returned when the function explicitly omits Return's parameter.
When a function uses the Exit command to terminate the current thread,
its caller does not receive a return value at al
*/

VK88 & space:: Send ^{DEL}  ; 往左删 m for move
; VK88 & n:: Send ^{BS}  ; n在m的左边一个键，大步往左


/*
; 这两个在wps ppt里，只能移动光标，不能删除，不知道为啥
VK88 & x::
    if WinActive("ahk_exe wps.exe"){
        send {Del}
        msg("wps里未能实现剪切")
        }
    else{
        ; 剪切文本时，靠谱，剪切文件时，如果右边有文件，会多选了一个文件,小心使用
        send {LShift Down}{right}{LShift Up}
        sleep 200
        send {LCtrl Down}{x}{LCtrl Up}
        }

    return
*/
VK88 & x::send {Del}

/*
VK88 & c::
    if WinActive("ahk_exe wps.exe"){
        send ^{Del}
        msg("wps里未能实现剪切")
        }
    else{
        send {CtrlDown}{ShiftDown}{right}{ShiftUp}{CtrlDown}
        sleep 200
        send {CtrlDown}{x}{CtrlUp}
        }

    return
*/

; \>>>---------------------------------------------------------------------wps相关

    ; 知乎编辑器里，如果光标所在行是空白的，按{home}会跳到顶部。所以先在空白行随便输入点东西
    VK88 & d::
        ; todo: ppt也是用的wps啊
        if WinActive("ahk_exe POWERPNT.EXE")
             Send !hu2{Enter}
        else if WinActive("ahk_exe wps.exe")
            Send ^{F2}  ; pdf highlight.
        else{
            /*
            myIME()
            Send {a}
            Send {Home}
            Send +{End}
            ; Send ^x  ; 有点bug
            Send ^y
            Send {Del}
            Send {BackSpace}
            Send {Down}
            */

            myIME()
            Send +{End}
            Send {ctrl Down}x{ctrl Up}
            }

        exit

    #IfWinActive ahk_exe wps.exe
        ^g::Send ^{PGUP}
        ^+g::Send ^{PGDN}
        VK88 & f::Send ^5
        ^d::Send !hu2{Enter}  ; 删除线
        ; ^p::MsgBox, %A_ThisHotkey% 用作打印 浪费了
        ^p::Send, {up}
        ^n::Send, {down}
        ; 别用：有点卡：
        ; https://zhuanlan.zhihu.com/p/163521202
    #IfWinActive


; ---------------------------------------------------------------------《《《  wps相关


:?o:\ld::<Leader>

; win键的设置错了？#k啥的都可以，#n用不了

; 反引号用于转义/escape：
VK88 & SC027:: Send `;
; SC027表示: 分号那个键的scancode
SC027::Send :
+SC027::Send `;

; 仿vim
    VK88 & a::
        if GetKeyState("alt") = 1
        ; if GetKeyState("control") = 1  ; 不好按
                Send +{Home}  ; 选中直到行首
        else
                Send {Home}
        return

    VK88 & e::
        if GetKeyState("alt") = 1
                Send +{End}
        else
                Send {End}
        return

; ; 数字键:
;     RAlt & a::send,1
;     RAlt & s::send,2
;     RAlt & d::send,3
;     RAlt & f::send,4
;     RAlt & v::send,5

;     ; alt h留给了zsh 跳到home目录
;     LAlt & n::send,6
;     LAlt & j::send,7
;     LAlt & k::send,8
;     LAlt & l::send,9
;     LAlt & SC027::send,0

; 为了设置窗口透明，折腾了一通。。。。。
; 导致lalt不弹回
; 因为要先一致按着lalt，再按tab？
; LAlt & Tab::
; Send #m
; Send {LAlt Down}{Tab Down}{Tab Up}{LAlt Up}
; Send {LAlt Down}{Tab}{Tab Up}
; return





; todo: 开机后空格没弹起:
; https://www.autohotkey.com/board/topic/75405-solved-space-not-working/

; 这样可以?  每次reload时, 强制弹起space
; send, Space Up
; 还是不行

^Esc::send,{CtrlDown}{Pause}{CtrlUp}


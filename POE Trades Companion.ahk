/*
*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*
*					POE Trades Companion																														*
*					See all the information about the trade request upon receiving a poe.trade whisper															*
*																																								*
*					https://github.com/lemasato/POE-Trades-Companion/																							*
*					https://www.reddit.com/r/pathofexile/comments/57oo3h/																						*
*					https://www.pathofexile.com/forum/view-thread/1755148/																						*
*																																								*	
*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*
*/

; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

; #Warn LocalSameAsGlobal, StdOut
; #ErrorStdOut
#SingleInstance, Off
#KeyHistory 0
#Persistent
#NoEnv

OnExit("Exit")

DetectHiddenWindows, Off
FileEncoding, UTF-8 ; Cyrilic characters
SetWinDelay, 0
ListLines, Off

; Basic tray menu
if ( !A_IsCompiled && FileExist(A_ScriptDir "\resources\icon.ico") )
	Menu, Tray, Icon, %A_ScriptDir%\resources\icon.ico
Menu,Tray,Tip,POE Trades Companion
Menu,Tray,NoStandard
Menu,Tray,Add,Tool is loading..., DoNothing
Menu,Tray,Disable,Tool is loading...
Menu,Tray,Add,GitHub,Tray_GitHub
Menu,Tray,Add
Menu,Tray,Add,Reload,Tray_Reload
Menu,Tray,Add,Close,Tray_Exit
Menu,Tray,Icon
; Left click
OnMessage(0x404, "AHK_NOTIFYICON") 

Hotkey, IfWinActive, ahk_group POEGameGroup
Hotkey, ^RButton, StackClick

Hotkey, IfWinActive
Hotkey, ~*Space, SpaceRoutine

Hotkey, IfWinActive,% "ahk_pid " DllCall("GetCurrentProcessId")

if (!A_IsUnicode) {
	MsgBox(4096+48, "POE Trades Companion", "This tool does not support ANSI versions of AutoHotKey."
	. "`nPlease download and install AutoHotKey Unicode 32/64 or use the compiled executable."
	. "`nAutoHotKey's official website will open upon closing this box.")
	Run,% "https://www.autohotkey.com/"
	ExitApp
}

; try {
	Start_Script()
; }
; catch e {
; 	MsgBox, 16,, % "Exception thrown!`n`nwhat: " e.what "`nfile: " e.file
;         . "`nline: " e.line "`nmessage: " e.message "`nextra: " e.extra
; }
Return

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
SpaceRoutine() {
	global PROGRAM, AUTOWHISPER_CANCEL, AUTOWHISPER_WAITKEYUP, SPACEBAR_WAIT

	if (SPACEBAR_WAIT) {
		SplashTextOff()
	}
	else if (AUTOWHISPER_WAITKEYUP) {
		AUTOWHISPER_CANCEL := True
		ShowToolTip(PROGRAM.NAME "`nEasy whisper canceled.")
	}
}

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Start_Script() {

	global DEBUG 							:= {} ; Debug values
	global PROGRAM 							:= {} ; Specific to the program's informations
	global GAME								:= {} ; Specific to the game config files
	global RUNTIME_PARAMETERS 				:= {}

	global Stats_TradeCurrencyNames 		:= {} ; Abridged currency names from poe.trade
	global Stats_RealCurrencyNames 			:= {} ; All currency full names

	global LEAGUES 							:= [] ; Trading leagues
	global MyDocuments

	; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	Handle_CmdLineParameters() 		; RUNTIME_PARAMETERS
	Load_DebugJSON()

	MyDocuments 					:= (RUNTIME_PARAMETERS.MyDocuments)?(RUNTIME_PARAMETERS.MyDocuments):(A_MyDocuments)

	; Set global - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	PROGRAM.NAME					:= "POE Trades Companion"
	PROGRAM.VERSION 				:= "1.15.BETA_91"
	PROGRAM.IS_BETA					:= IsContaining(PROGRAM.VERSION, "beta")?"True":"False"

	PROGRAM.GITHUB_USER 			:= "lemasato"
	PROGRAM.GITHUB_REPO 			:= "POE-Trades-Companion"
	PROGRAM.GUTHUB_BRANCH			:= "master"

	PROGRAM.MAIN_FOLDER 			:= MyDocuments "\lemasato\" PROGRAM.NAME
	PROGRAM.LOGS_FOLDER 			:= PROGRAM.MAIN_FOLDER "\Logs"
	PROGRAM.TEMP_FOLDER 			:= PROGRAM.MAIN_FOLDER "\Temp"
	PROGRAM.DATA_FOLDER				:= (A_IsCompiled?PROGRAM.MAIN_FOLDER:A_ScriptDir) . (A_IsCompiled?"\Data":"\data")
	PROGRAM.SFX_FOLDER 				:= (A_IsCompiled?PROGRAM.MAIN_FOLDER:A_ScriptDir) . (A_IsCompiled?"\SFX":"\resources\sfx")
	PROGRAM.SKINS_FOLDER 			:= (A_IsCompiled?PROGRAM.MAIN_FOLDER:A_ScriptDir) . (A_IsCompiled?"\Skins":"\resources\skins")
	PROGRAM.FONTS_FOLDER 			:= (A_IsCompiled?PROGRAM.MAIN_FOLDER:A_ScriptDir) . (A_IsCompiled?"\Fonts":"\resources\fonts")
	PROGRAM.IMAGES_FOLDER			:= (A_IsCompiled?PROGRAM.MAIN_FOLDER:A_ScriptDir) . (A_IsCompiled?"\Images":"\resources\imgs")
	PROGRAM.ICONS_FOLDER			:= (A_IsCompiled?PROGRAM.MAIN_FOLDER:A_ScriptDir) . (A_IsCompiled?"\Icons":"\resources\icons")
	PROGRAM.TRANSLATIONS_FOLDER		:= (A_IsCompiled?PROGRAM.MAIN_FOLDER:A_ScriptDir) . (A_IsCompiled?"\Translations":"\resources\translations")
	PROGRAM.CURRENCY_IMGS_FOLDER	:= (A_IsCompiled?PROGRAM.MAIN_FOLDER:A_ScriptDir) . (A_IsCompiled?"\CurrencyImages":"\resources\currency_imgs")
	PROGRAM.CHEATSHEETS_FOLDER		:= (A_IsCompiled?PROGRAM.MAIN_FOLDER:A_ScriptDir) . (A_IsCompiled?"\Cheatsheets":"\resources\cheatsheets")

	prefsFileName 					:= (RUNTIME_PARAMETERS.InstanceName)?(RUNTIME_PARAMETERS.InstanceName "_Preferences"):("Preferences")
	sellBackupFileName 				:= (RUNTIME_PARAMETERS.InstanceName)?(RUNTIME_PARAMETERS.InstanceName "_Sell_Trades_Backup"):("Sell_Trades_Backup")
	buyBackupFileName 				:= (RUNTIME_PARAMETERS.InstanceName)?(RUNTIME_PARAMETERS.InstanceName "_Buy_Trades_Backup"):("Buy_Trades_Backup")
	tradesSellHistoryFileName 		:= (RUNTIME_PARAMETERS.InstanceName)?(RUNTIME_PARAMETERS.InstanceName "_Sell_History"):("Sell_History")
	tradesBuyHistoryFileName 		:= (RUNTIME_PARAMETERS.InstanceName)?(RUNTIME_PARAMETERS.InstanceName "_Buy_History"):("Buy_History")
	tradesSellHistoryFileNameOld 		:= (RUNTIME_PARAMETERS.InstanceName)?(RUNTIME_PARAMETERS.InstanceName "_Trades_History"):("Trades_History")
	tradesBuyHistoryFileNameOld 		:= (RUNTIME_PARAMETERS.InstanceName)?(RUNTIME_PARAMETERS.InstanceName "_Buy_History"):("Buy_History")
	PROGRAM.FONTS_SETTINGS_FILE		:= PROGRAM.FONTS_FOLDER "\Settings.ini"
	PROGRAM.SETTINGS_FILE			:= PROGRAM.MAIN_FOLDER "\" prefsFileName ".json"
	PROGRAM.SETTINGS_FILE_OLD		:= PROGRAM.MAIN_FOLDER "\" prefsFileName ".ini"
	PROGRAM.LOGS_FILE 				:= PROGRAM.LOGS_FOLDER "\" A_YYYY "-" A_MM "-" A_DD " " A_Hour "h" A_Min "m" A_Sec "s.txt"
	PROGRAM.CHANGELOG_FILE 			:= (A_IsCompiled?PROGRAM.MAIN_FOLDER:A_ScriptDir) . (A_IsCompiled?"\changelog.txt":"\resources\changelog.txt")
	PROGRAM.CHANGELOG_FILE_BETA 	:= (A_IsCompiled?PROGRAM.MAIN_FOLDER:A_ScriptDir) . (A_IsCompiled?"\changelog_beta.txt":"\resources\changelog_beta.txt")
	PROGRAM.TRADES_SELL_HISTORY_FILE 		:= PROGRAM.MAIN_FOLDER "\" tradesSellHistoryFileName ".json"
	PROGRAM.TRADES_SELL_HISTORY_FILE_OLD 	:= PROGRAM.MAIN_FOLDER "\" tradesSellHistoryFileNameOld ".ini"
	PROGRAM.TRADES_BUY_HISTORY_FILE			:= PROGRAM.MAIN_FOLDER "\" tradesBuyHistoryFileName ".json"
	PROGRAM.TRADES_BUY_HISTORY_FILE_OLD 	:= PROGRAM.MAIN_FOLDER "\" tradesBuyHistoryFileNameOld ".ini"
	PROGRAM.TRADES_SELL_BACKUP_FILE	:= PROGRAM.MAIN_FOLDER "\" sellBackupFileName ".json"
	PROGRAM.TRADES_BUY_BACKUP_FILE	:= PROGRAM.MAIN_FOLDER "\" buyBackupFileName ".json"

	PROGRAM.NEW_FILENAME			:= PROGRAM.MAIN_FOLDER "\POE-TC-NewVersion.exe"
	PROGRAM.UPDATER_FILENAME 		:= PROGRAM.MAIN_FOLDER "\POE-TC-Updater.exe"
	PROGRAM.LINK_UPDATER 			:= "https://raw.githubusercontent.com/lemasato/POE-Trades-Companion/master/Updater_v2.exe"
	PROGRAM.LINK_CHANGELOG 			:= "https://raw.githubusercontent.com/lemasato/POE-Trades-Companion/master/resources/changelog.txt"

	PROGRAM.CURL_EXECUTABLE			:= PROGRAM.MAIN_FOLDER "\curl.exe"

	PROGRAM.LINK_REDDIT 			:= "https://www.reddit.com/user/lemasato/submitted/"
	PROGRAM.LINK_GGG 				:= "https://www.pathofexile.com/forum/view-thread/1755148/"
	PROGRAM.LINK_GITHUB 			:= "https://github.com/lemasato/POE-Trades-Companion"
	PROGRAM.LINK_SUPPORT 			:= "https://www.paypal.me/masato/"
	PROGRAM.LINK_DISCORD 			:= "https://discord.gg/UMxqtfC"

	GAME.MAIN_FOLDER 				:= MyDocuments "\my games\Path of Exile"
	GAME.INI_FILE 					:= GAME.MAIN_FOLDER "\production_Config.ini"
	GAME.INI_FILE_COPY 		 		:= PROGRAM.MAIN_FOLDER "\production_Config.ini"
	GAME.EXECUTABLES 				:= "PathOfExile.exe,PathOfExile_x64.exe,PathOfExileSteam.exe,PathOfExile_x64Steam.exe,PathOfExile_KG.exe,PathOfExile_x64_KG.exe"
	GAME.CHALLENGE_LEAGUE 			:= "Legion"
	GAME.CHALLENGE_LEAGUE_TRANS		:= {"RUS":"Легион","KOR":"군단"} ; Rest doesn't have translations. Translated whispers suck and are inconsistent

	PROGRAM.PID 					:= DllCall("GetCurrentProcessId")

	SetWorkingDir,% PROGRAM.MAIN_FOLDER

	; Auto admin reload
	if (!A_IsAdmin && !RUNTIME_PARAMETERS.SkipAdmin && !DEBUG.SETTINGS.skip_admin) {
		ReloadWithParams(" /MyDocuments=""" MyDocuments """", getCurrentParams:=True, asAdmin:=True)
	}

	; Creating settings and file
	LocalSettings_CreateFileIfNotExisting()
	LocalSettings_VerifyEncoding()

	Delete_OldLogsFile()
	Create_LogsFile()

	; Loading global GDIP 
	GDIP_Startup()
	
	; Loading fonts
	LoadFonts() 

	; Closing previous instance
	if (!RUNTIME_PARAMETERS.NewInstance)
		Close_PreviousInstance()
	TrayRefresh()

	; More local settings stuff
	Set_LocalSettings()
	Update_LocalSettings()
	Declare_LocalSettings(localSettings)
	PROGRAM.TRANSLATIONS := GetTranslations(PROGRAM.SETTINGS.GENERAL.Language)
	Declare_SkinAssetsAndSettings()

	; Game executables groups
	global POEGameArr := []
	Loop, Parse,% GAME.EXECUTABLES, % ","
		POEGameArr.Push(A_LoopField)
	global POEGameList := GAME.EXECUTABLES	
	for nothing, executable in POEGameArr
		GroupAdd, POEGameGroup, ahk_exe %executable%

	; Create local directories - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	directories := PROGRAM.MAIN_FOLDER "`n" PROGRAM.SFX_FOLDER "`n" PROGRAM.LOGS_FOLDER "`n" PROGRAM.SKINS_FOLDER
	. "`n" PROGRAM.FONTS_FOLDER "`n" PROGRAM.IMAGES_FOLDER "`n" PROGRAM.DATA_FOLDER "`n" PROGRAM.ICONS_FOLDER
	. "`n" PROGRAM.TEMP_FOLDER "`n" PROGRAM.TRANSLATIONS_FOLDER "`n" PROGRAM.CURRENCY_IMGS_FOLDER "`n" PROGRAM.CHEATSHEETS_FOLDER

	Loop, Parse, directories, `n, `r
	{
		if (!InStr(FileExist(A_LoopField), "D")) {
			AppendtoLogs("Local directory non-existent. Creating: """ A_LoopField """")
			FileCreateDir, % A_LoopField
			if (ErrorLevel && A_LastError) {
				AppendtoLogs("Failed to create local directory. System Error Code: " A_LastError ". Path: """ A_LoopField """")
			}
		}
	}

	; Extracting assets
	if !(DEBUG.settings.skip_assets_extracting)
		AssetsExtract()

	; Warning stuff
	if !FileExist(PROGRAM.TRANSLATIONS_FOLDER "\english.json") {
		MsgBox(4096+48,"ERROR","/!\ PLEASE READ CAREFULLY /!\"
		. "`n`nUnable to find translation files. Please re-download the tool."
		. "`nThe GitHub releases page will open upon closing this box."
		. "`nDetails are included on the post.")
		Run,% "https://github.com/lemasato/POE-Trades-Companion/releases"
	}
	if (A_AhkVersion = "1.1.30.00") {
		Run,% "https://www.autohotkey.com/"
		Msgbox,% 4096+16, POE Trades Companion, You are using AHK v%A_AhkVersion% which contains a bug making the application crash. Please update your AHK to the latest version.	
		ExitApp
	}

	; Loading currency data for stats gui
	PROGRAM.DATA := {}
	FileRead, allCurrency,% PROGRAM.DATA_FOLDER "\CurrencyNames.txt"
	Loop, Parse, allCurrency, `n, `r
	{
		if (A_LoopField)
			currencyList .= A_LoopField ","
	}
	StringTrimRight, currencyList, currencyList, 1 ; Remove last comma
	PROGRAM.DATA.CURRENCY_LIST := currencyList
	FileRead, JSONFile,% PROGRAM.DATA_FOLDER "\poeTradeCurrencyData.json"
    PROGRAM["DATA"]["POETRADE_CURRENCY_DATA"] := JSON.Load(JSONFile)
	FileRead, gggCurrency,% PROGRAM.DATA_FOLDER "\poeDotComCurrencyData.json"
	PROGRAM["DATA"]["POEDOTCOM_CURRENCY_DATA"] := JSON.Load(gggCurrency)

	; Loading maps data for item grid
	FileRead, mapsData,% PROGRAM.DATA_FOLDER "\mapsData.json"
	PROGRAM.DATA.MAPS_DATA := JSON.Load(mapsData)
	FileRead, uniqueMapsList,% PROGRAM.DATA_FOLDER "\UniqueMaps.txt"
	PROGRAM.DATA.UNIQUE_MAPS_LIST := uniqueMapsList

	; Game settings
	Declare_GameSettings(gameSettings)
	Get_TradingLeagues()

	; Update checking
	if !(DEBUG.settings.skip_update_check) {
		periodicUpdChk := PROGRAM.SETTINGS.UPDATE.CheckForUpdatePeriodically
		updChkTimer := (periodicUpdChk="OnStartOnly")?(0)
			: (periodicUpdChk="OnStartAndEveryFiveHours")?(18000000)
			: (periodicUpdChk="OnStartAndEveryDay")?(86400000)
			: (0)
		
		if (updChkTimer)
			SetTimer, UpdateCheck, %updChkTimer%

		if (DEBUG.settings.force_update_check)
			UpdateCheck(checkType:="forced")
		else {
			if (A_IsCompiled)
				UpdateCheck(checktype:="on_start")
			else
				UpdateCheck(checkType:="on_start", "box")
		}
	}

	if (PROGRAM.SETTINGS.GENERAL.AskForLanguage = "True")
		GUI_ChooseLang.Show()
	
	TrayMenu()
	EnableHotkeys()

	GUI_Intercom.Create()
	; ImageButton_TestDelay()

	GUI_Trades_V2.Create("", buyOrSell:="Sell", slotsOrTab:="Tabs")
	GUI_Trades_V2.Create("", buyOrSell:="Buy", slotsOrTab:="Slots")
	GUI_Trades_V2.LoadBackup("Sell")
	GUI_Trades_V2.LoadBackup("Buy")

	; Parse debug msgs
	if (DEBUG.settings.use_chat_logs) {
		Loop % DEBUG.chatlogs.MaxIndex()
			Parse_GameLogs(DEBUG.chatlogs[A_Index])
	}
	Monitor_GameLogs()

	global GuiSettings
	if !WinExist("ahk_id " GuiSettings.Handle)
		Gui_Settings.Create()
	if (DEBUG.settings.open_settings_gui)
		Gui_Settings.Show()

	if (DEBUG.settings.open_mystats_gui)
		GUI_MyStats.Show()

	if (PROGRAM.SETTINGS.PROGRAM.Show_Changelogs = True) 
	|| (PROGRAM.SETTINGS.GENERAL.ShowChangelog = "True") {
		PROGRAM.SETTINGS.Delete("PROGRAM") ; old section
		PROGRAM.SETTINGS.GENERAL.ShowChangelog := "False"
		Save_LocalSettings()
		trayMsg := StrReplace(PROGRAM.TRANSLATIONS.TrayNotifications.UpdateSuccessful_Msg, "%version%", PROGRAM.VERSION)
		TrayNotifications.Show(PROGRAM.TRANSLATIONS.TrayNotifications.UpdateSuccessful_Title, trayMsg)
		GUI_Settings.Show("Misc Updating")
	}

	; Shellmessage, after all gui are created	
	ShellMessage_Enable()

	; Clipboard change funcs + refresh list
	OnClipboardChange("OnClipboardChange_Func")
	SetTimer, GUI_Trades_V2_Sell_RefreshIgnoreList, 60000 ; One min

	; Showing tray notification
	trayMsg := PROGRAM.TRANSLATIONS.TrayNotifications.AppLoaded_Msg
	if (PROGRAM.SETTINGS.SETTINGS_MAIN.NoTabsTransparency <= 20)
		trayMsg .= "`n`n" . StrReplace(PROGRAM.TRANSLATIONS.TrayNotifications.AppLoadedTransparency_Msg, "%number%", PROGRAM.SETTINGS.SETTINGS_MAIN.NoTabsTransparency)
	if (PROGRAM.SETTINGS.SETTINGS_MAIN.AllowClicksToPassThroughWhileInactive = "True")
		trayMsg .= "`n`n" PROGRAM.TRANSLATIONS.TrayNotifications.AppLoadedClickthrough_Msg
	TrayNotifications.Show(PROGRAM.NAME, trayMsg)
}

DoNothing:
Return

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#Include %A_ScriptDir%\lib\

#Include Class_Gui_Trades_V2.ahk

#Include Class_GUI.ahk
#Include Class_GUI_BetaTasks.ahk
#Include Class_GUI_CheatSheet.ahk
#Include Class_GUI_ImportPre1dot13Settings.ahk
#Include Class_GUI_SimpleWarn.ahk
#Include Class_Gui_ChooseInstance.ahk
#Include Class_GUI_ChooseLang.ahk
#Include Class_Gui_ItemGrid.ahk
#Include Class_Gui_MyStats.ahk
#Include Class_GUI_SetHotkey.ahk
#Include Class_Gui_Settings.ahk
#Include Class_Gui_Trades.ahk
#Include Class_Gui_TradesMinimized.ahk
#Include Class_GUI_TradesBuyCompact.ahk
#Include Intercom_Receiver.ahk
#Include WM_Messages.ahk

#Include AssetsExtract.ahk
#Include Class_INI.ahk
#Include CmdLineParameters.ahk
#Include Debug.ahk
#Include EasyFuncs.ahk
#Include Exit.ahk
#Include FileInstall.ahk
#Include Game.ahk
#Include Game_File.ahk
#Include GGG_API.ahk
#Include GitHubAPI.ahk
#Include Hotkeys.ahk
#Include Local_File.ahk
#Include Logs.ahk
#Include ManageFonts.ahk
#Include Misc.ahk
#Include OnClipboardChange.ahk
#Include PoeDotCom.ahk
#Include PoeTrade.ahk
#Include PushBullet.ahk
#Include Reload.ahk
#Include ShellMessage.ahk
#Include ShowToolTip.ahk
#Include SplashText.ahk
#Include StackClick.ahk
#Include Translations.ahk
#Include TrayMenu.ahk
#Include TrayNotifications.ahk
#Include TrayRefresh.ahk
#Include Updating.ahk
#Include WindowsSettings.ahk

#Include %A_ScriptDir%\lib\third-party\
#Include AddToolTip.ahk
#Include ChooseColor.ahk
#Include class_EasyIni.ahk
#Include Class_ImageButton.ahk
#Include Clip.ahk
#Include cURL.ahk
#Include CSV.ahk
#Include Download.ahk
#Include Extract2Folder.ahk
#Include FGP.ahk
#Include GDIP.ahk
#Include Get_ProcessInfos.ahk
#Include IEComObj.ahk
#Include JSON.ahk
#Include LV_SetSelColors.ahk
#Include SetEditCueBanner.ahk
#Include StdOutStream.ahk
#Include StringtoHex.ahk
#Include TilePicture.ahk
#Include WinHttpRequest.ahk


if (A_IsCompiled) {
	#Include %A_ScriptDir%/FileInstall_Cmds.ahk
	Return
}

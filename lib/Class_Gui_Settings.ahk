Class GUI_Settings {
	
	Create(whichTab="") {
		global PROGRAM, GAME, SKIN
		global GuiSettings, GuiSettings_Controls, GuiSettings_Submit
		global GuiTrades, GuiTrades_Controls
		static guiCreated
	
		; Initialize gui arrays
		GUI_Settings.Destroy()
		Gui.New("Settings", "-Caption -Border +LabelGUI_Settings_ +HwndhGuiSettings", "POE TC - " PROGRAM.TRANSLATIONS.TrayMenu.Settings)
		GuiSettings.Is_Created := False

		guiCreated := False
		guiFullHeight := 600, guiFullWidth := 650, borderSize := 1, borderColor := "Black"
		guiHeight := guiFullHeight-(2*borderSize), guiWidth := guiFullWidth-(2*borderSize)
		leftMost := borderSize, rightMost := leftMost+guiWidth
		upMost := borderSize, downMost := upMost+guiHeight

		GuiSettings.Style_Tab := Style_Tab := [ [0, "0x1c4563", "0x878787", "0x80c4ff", 0, , ""] ; normal
			,  [0, "0x132f44", "", "0x80c4ff", 0] ; hover
			,  [3, "0x132f44", "0x0f2434", "0x0f8fff", 0]  ; press
			,  [3, "0x132f44", "0x0f2434", "0x0f8fff", 0 ] ] ; default

		GuiSettings.Style_RedBtn := Style_RedBtn := [ [0, "0xff5c5c", "", "White", 0, , ""] ; normal
			, [0, "0xff5c5c", "", "White", 0] ; hover
			, [3, "0xe60000", "0xff5c5c", "Black", 0]  ; press
			, [3, "0xff5c5c", "0xe60000", "White", 0 ] ] ; default
		
		GuiSettings.Style_ResetBtn := Style_ResetBtn := [ [0, "0xf9a231", "", "Black", 0, , ""] ; normal
			, [0, "0xf9a231", "", "Red", 0] ; hover
			, [3, "0xf9a231", "0xe7740e", "Red", 0]  ; press
			, [0, "0xe7740e", "", "Red", 0 ] ] ; default

		global ACTIONS_SECTIONS := {}
		for key, value in PROGRAM.TRANSLATIONS.ACTIONS.SECTIONS
			ACTIONS_SECTIONS[key] := value

		global ACTIONS_TEXT_NAME := {}
		for key, value in PROGRAM.TRANSLATIONS.ACTIONS.TEXT_NAME
			ACTIONS_TEXT_NAME[key] := value

		global ACTIONS_DEFAULT_CONTENT := {}
		for key, value in PROGRAM.TRANSLATIONS.ACTIONS.DEFAULT_CONTENT
			ACTIONS_DEFAULT_CONTENT[key] := value

		global ACTIONS_FORCED_CONTENT := { "":""
			, "SEND_TO_LAST_WHISPER":"@%lwr% "
			, "WRITE_TO_LAST_WHISPER":"@%lwr% "
			, "SEND_TO_LAST_WHISPER_SENT":"@%lws% "
			, "WRITE_TO_LAST_WHISPER_SENT":"@%lws% "
			, "SEND_TO_BUYER":"@%buyer% "
			, "WRITE_TO_BUYER":"@%buyer% "
			, "INVITE_BUYER":"/invite %buyer%"
			, "TRADE_BUYER":"/tradewith %buyer%"
			, "KICK_BUYER":"/kick %buyer%"
			, "KICK_MYSELF":"/kick %myself%"

			, "CMD_AFK":"/afk "
			, "CMD_AUTOREPLY":"/autoreply "
			, "CMD_DND":"/dnd "
			, "CMD_HIDEOUT":"/hideout"
			, "CMD_OOS":"/oos"
			, "CMD_REMAINING":"/remaining"
			, "CMD_WHOIS":"/whois"
			, "":""}

		global ACTIONS_READONLY := "INVITE_BUYER,TRADE_BUYER,KICK_BUYER,KICK_MYSELF"
			. ",SAVE_TRADE_STATS,COPY_ITEM_INFOS,GO_TO_NEXT_TAB,GO_TO_PREVIOUS_TAB"
			. ",CLOSE_TAB,TOGGLE_MIN_MAX,FORCE_MIN,FORCE_MAX,CMD_OOS,CMD_REMAINING"
			. ",IGNORE_SIMILAR_TRADE,CLOSE_SIMILAR_TABS,SHOW_GRID,SHOW_LEAGUE_SHEETS"
		Loop 9
			ACTIONS_READONLY .= ",CUSTOM_BUTTON_" A_Index

		global COLORS_TYPES := {}
		for key, value in PROGRAM.TRANSLATIONS.GUI_Settings.COLORS_TYPES
			COLORS_TYPES[key] := value

		global ACTIONS_WRITE := "WRITE_MSG,WRITE_THEN_GO_BACK,WRITE_TO_LAST_WHISPER,WRITE_TO_LAST_WHISPER_SENT,WRITE_TO_BUYER"

		global ACTIONS_AVAILABLE := ""
		. "-> " ACTIONS_SECTIONS.Simple
		. "|" ACTIONS_TEXT_NAME.SEND_MSG
		. "|" ACTIONS_TEXT_NAME.SEND_TO_LAST_WHISPER
		. "|" ACTIONS_TEXT_NAME.SEND_TO_LAST_WHISPER_SENT
		. "|" ACTIONS_TEXT_NAME.WRITE_MSG
		. "|" ACTIONS_TEXT_NAME.WRITE_THEN_GO_BACK
		. "|" ACTIONS_TEXT_NAME.WRITE_TO_LAST_WHISPER
		. "|" ACTIONS_TEXT_NAME.WRITE_TO_LAST_WHISPER_SENT
		. "| "
		. "|-> " ACTIONS_SECTIONS.Interactions
		. "|" ACTIONS_TEXT_NAME.SEND_TO_BUYER
		. "|" ACTIONS_TEXT_NAME.WRITE_TO_BUYER
		. "|" ACTIONS_TEXT_NAME.INVITE_BUYER
		. "|" ACTIONS_TEXT_NAME.TRADE_BUYER
		. "|" ACTIONS_TEXT_NAME.KICK_BUYER
		. "|" ACTIONS_TEXT_NAME.KICK_MYSELF
		. "|  "
		. "|-> " ACTIONS_SECTIONS.Special
		. "|" ACTIONS_TEXT_NAME.CLOSE_TAB
		. "|" ACTIONS_TEXT_NAME.SAVE_TRADE_STATS
		. "|" ACTIONS_TEXT_NAME.SHOW_GRID
		. "|" ACTIONS_TEXT_NAME.IGNORE_SIMILAR_TRADE
		. "|" ACTIONS_TEXT_NAME.CLOSE_SIMILAR_TABS
		. "|" ACTIONS_TEXT_NAME.COPY_ITEM_INFOS
		. "|" ACTIONS_TEXT_NAME.TOGGLE_MIN_MAX
		. "|" ACTIONS_TEXT_NAME.FORCE_MIN
		. "|" ACTIONS_TEXT_NAME.FORCE_MAX		
		. "|" ACTIONS_TEXT_NAME.GO_TO_NEXT_TAB
		. "|" ACTIONS_TEXT_NAME.GO_TO_PREVIOUS_TAB
		. "|" ACTIONS_TEXT_NAME.SHOW_LEAGUE_SHEETS
		. "|   "
		. "|-> " ACTIONS_SECTIONS.Commands
		. "|" ACTIONS_TEXT_NAME.CMD_AFK
		. "|" ACTIONS_TEXT_NAME.CMD_AUTOREPLY
		. "|" ACTIONS_TEXT_NAME.CMD_DND
		. "|" ACTIONS_TEXT_NAME.CMD_HIDEOUT
		. "|" ACTIONS_TEXT_NAME.CMD_OOS
		. "|" ACTIONS_TEXT_NAME.CMD_REMAINING
		. "|" ACTIONS_TEXT_NAME.CMD_WHOIS
		. "|    "
		. "|-> " ACTIONS_SECTIONS.Miscellaneous
		. "|" ACTIONS_TEXT_NAME.SENDINPUT
		. "|" ACTIONS_TEXT_NAME.SENDEVENT
		. "|" ACTIONS_TEXT_NAME.SLEEP

		/* * * * * * *
		* 	CREATION
		*/

		Gui.Margin("Settings", 0, 0)
		Gui.Color("Settings", "334a5b", "374a58")
		Gui.Font("Settings", "Segoe UI", "8", "5", "0x80c4ff")
		Gui, Settings:Default ; Required for LV_ cmds

		; *	* Borders
		bordersPositions := [{X:0, Y:0, W:guiFullWidth, H:borderSize}, {X:0, Y:0, W:borderSize, H:guiFullHeight} ; Top and Left
			,{X:0, Y:downMost, W:guiFullWidth, H:borderSize}, {X:rightMost, Y:0, W:borderSize, H:guiFullHeight}] ; Bottom and Right

		Loop 4 ; Left/Right/Top/Bot borders
			Gui.Add("Settings", "Progress", "x" bordersPositions[A_Index]["X"] " y" bordersPositions[A_Index]["Y"] " w" bordersPositions[A_Index]["W"] " h" bordersPositions[A_Index]["H"] " Background" borderColor)

		; * * Title bar
		Gui.Add("Settings", "Text", "x" leftMost " y" upMost " w" guiWidth-(borderSize*2)-30 " h25 hwndhTEXT_HeaderGhost BackgroundTrans ", "") ; Title bar, allow moving
		Gui.Add("Settings", "Progress", "xp yp wp hp Background359cfc") ; Title bar background
		Gui.Add("Settings", "Text", "xp yp wp hp Center 0x200 cWhite BackgroundTrans ", "POE Trades Companion - " PROGRAM.TRANSLATIONS.TrayMenu.Settings) ; Title bar text
		imageBtnLog .= Gui.Add("Settings", "ImageButton", "x+0 yp w30 hp hwndhBTN_CloseGUI", "X", Style_RedBtn, PROGRAM.FONTS["Segoe UI"], 8)
		Gui.BindFunctionToControl("GUI_Settings", "Settings", "hTEXT_HeaderGhost", "DragGui", GuiSettings.Handle)
		Gui.BindFunctionToControl("GUI_Settings", "Settings", "hBTN_CloseGUI", "Close")

		; * * Tab controls
		allTabs := ["Settings", "Skins", "Buying", "Selling", "Hotkeys", "Updating", "About"]
		for index, tabName in allTabs
			allTabsList .= "|" tabName
		Gui.Add("Settings", "Tab2", "x0 y0 w0 h0 vTab_AllTabs hwndhTab_AllTabs Choose1", allTabsList) ; Make our list of tabs
		Gui, Settings:Tab ; Whatever comes next will be on all tabs

		; * * Tab buttons
		tabWidth := (guiWidth)/(allTabs.Count()), tabHeight := 30
		for index, tabName in allTabs {
			xpos := A_Index=1?leftMost:xpos+tabWidth, ypos := upMost+25
			Gui.Add("Settings", "ImageButton", "x" xpos " y" ypos " w" tabWidth " h" tabHeight " hwndhBTN_Tab" tabName, tabName, Style_Tab, PROGRAM.FONTS["Segoe UI"], 8)
			Gui.BindFunctionToControl("GUI_Settings", "Settings", "hBTN_Tab" tabName, "OnTabBtnClick", tabName)
		}
		leftMost2 := leftMost+10, rightMost2 := rightMost-10, upMost2 := ypos+tabHeight+10, downMost2 := downMost-50-10

		/* * * * * * * * * * *
		*	TAB SETTINGS
		*/
		Gui, Settings:Tab, Settings

		; * * Accounts
		Gui.Add("Settings", "Text", "x" leftMost2 " y" upMost2 " Center hwndhTEXT_POEAccountsList", PROGRAM.TRANSLATIONS.GUI_Settings.hTEXT_POEAccountsList), poeAccTxtPos := Get_ControlCoords("Settings", GuiSettings_Controls.hTEXT_POEAccountsList)
		Gui.Add("Settings", "DropDownList", "xp y+3 w" poeAccTxtPos.W-2-25 " hwndhDDL_PoeAccounts", "")
		Gui.Add("Settings", "Button", "x+2 yp w25 hp hwndhBTN_EditPoeAccountsList", "+") ; TO_DO_V2 special gui, one account per line, some text tips
		poeAccDdlPos := Get_ControlCoords("Settings", GuiSettings_Controls.hDDL_PoeAccounts)

		; * * Buying selling modes
		Gui.Add("Settings", "Text", "x+20 y" upMost2 " Center hwndhTEXT_BuyingInterfaceMode", "Buying interface mode:"), buyIntefaceTxtPos := Get_ControlCoords("Settings", GuiSettings_Controls.hTEXT_BuyingInterfaceMode)
		Gui.Add("Settings", "DropDownList", "xp y+3 w" buyIntefaceTxtPos.W " hwndhDDL_BuyingInterfaceMode", "Tabs|Stack|Disabled")

		Gui.Add("Settings", "Text", "x+20 y" upMost2 " Center hwndhTEXT_SellingInterfaceMode", "Selling interface mode:"), sellIntefaceTxtPos := Get_ControlCoords("Settings", GuiSettings_Controls.hTEXT_SellingInterfaceMode)
		Gui.Add("Settings", "DropDownList", "xp y+3 w" sellIntefaceTxtPos.W " hwndhDDL_SellingInterfaceMode", "Tabs|Stack")
		topMost3 := poeAccDdlPos.Y+poeAccDdlPos.H+25
		
		; * * Interface
		Gui.Add("Settings", "CheckBox", "x" leftMost2 " y" topMost3 " hwndhCB_HideInterfaceWhenOutOfGame", PROGRAM.TRANSLATIONS.GUI_Settings.hCB_HideInterfaceWhenOutOfGame)
		Gui.Add("Settings", "CheckBox", "xp y+5 hwndhCB_MinimizeInterfaceToBottomLeft", PROGRAM.TRANSLATIONS.GUI_Settings.hCB_MinimizeInterfaceToBottomLeft)
		Gui.Add("Settings", "CheckBox", "xp y+15 hwndhCB_CopyItemInfosOnTabChange", PROGRAM.TRANSLATIONS.GUI_Settings.hCB_CopyItemInfosOnTabChange)
		Gui.Add("Settings", "CheckBox", "xp y+5 hwndhCB_AutoFocusNewTabs", PROGRAM.TRANSLATIONS.GUI_Settings.hCB_AutoFocusNewTabs)
		Gui.Add("Settings", "CheckBox", "xp y+15 hwndhCB_AutoMinimizeOnAllTabsClosed", PROGRAM.TRANSLATIONS.GUI_Settings.hCB_AutoMinimizeOnAllTabsClosed)
		Gui.Add("Settings", "CheckBox", "xp y+5 hwndhCB_AutoMaximizeOnFirstNewTab", PROGRAM.TRANSLATIONS.GUI_Settings.hCB_AutoMaximizeOnFirstNewTab)
		Gui.Add("Settings", "CheckBox", "xp y+12 hwndhCB_SendTradingWhisperUponCopyWhenHoldingCTRL Center", PROGRAM.TRANSLATIONS.GUI_Settings.hCB_SendTradingWhisperUponCopyWhenHoldingCTRL)

		; * * Map Tab settings
		Gui.Add("Settings", "Checkbox", "xp y+10 hwndhCB_ItemGridHideNormalTab", PROGRAM.TRANSLATIONS.GUI_Settings.hCB_ItemGridHideNormalTab)
		Gui.Add("Settings", "Checkbox", "xp y+5 hwndhCB_ItemGridHideQuadTab", PROGRAM.TRANSLATIONS.GUI_Settings.hCB_ItemGridHideQuadTab)
		Gui.Add("Settings", "Checkbox", "xp y+5 hwndhCB_ItemGridHideNormalTabAndQuadTabForMaps", PROGRAM.TRANSLATIONS.GUI_Settings.hCB_ItemGridHideNormalTabAndQuadTabForMaps)

		; * * Transparency
		Gui.Add("Settings", "Checkbox", "xp y+12 Center hwndhCB_AllowClicksToPassThroughWhileInactive", PROGRAM.TRANSLATIONS.GUI_Settings.hCB_AllowClicksToPassThroughWhileInactive)
		Gui.Add("Settings", "Text", "xp y+10 Center hwndhTEXT_NoTabsTransparency", PROGRAM.TRANSLATIONS.GUI_Settings.hTEXT_NoTabsTransparency)
		Gui.Add("Settings", "Slider", "x+1 yp w120 AltSubmit ToolTip Range0-100 hwndhSLIDER_NoTabsTransparency")
		Gui.Add("Settings", "Text", "x" leftMost2 " y+5 Center hwndhTEXT_TabsOpenTransparency", PROGRAM.TRANSLATIONS.GUI_Settings.hTEXT_TabsOpenTransparency)
		Gui.Add("Settings", "Slider", "x+1 yp w120 AltSubmit ToolTip Range30-100 hwndhSLIDER_TabsOpenTransparency")

		; * * Notifications
		secondColX := 300
		Gui.Add("Settings", "Text", "x300 y" topMost3 " hwndhTEXT_PlaySoundNotificationWhen", PROGRAM.TRANSLATIONS.GUI_Settings.hTEXT_PlaySoundNotificationWhen)
		Gui.Add("Settings", "CheckBox", "x" secondColX+10 " y+10 hwndhCB_TradingWhisperSFXToggle", PROGRAM.TRANSLATIONS.GUI_Settings.hCB_TradingWhisperSFXToggle)
		Gui.Add("Settings", "Edit", "x+5 yp-4 w100 R1 ReadOnly hwndhEDIT_TradingWhisperSFXPath")
		Gui.Add("Settings", "Button", "x+2 yp w25 hp ReadOnly hwndhBTN_BrowseTradingWhisperSFX", "O")
		Gui.Add("Settings", "CheckBox", "x" secondColX+10 " y+6 hwndhCB_RegularWhisperSFXToggle", PROGRAM.TRANSLATIONS.GUI_Settings.hCB_RegularWhisperSFXToggle)
		Gui.Add("Settings", "Edit", "x+5 yp-4 w100 R1 ReadOnly hwndhEDIT_RegularWhisperSFXPath")
		Gui.Add("Settings", "Button", "x+2 yp w25 hp ReadOnly hwndhBTN_BrowseRegularWhisperSFX", "O")
		Gui.Add("Settings", "CheckBox", "x" secondColX+10 " y+6 hwndhCB_BuyerJoinedAreaSFXToggle", PROGRAM.TRANSLATIONS.GUI_Settings.hCB_BuyerJoinedAreaSFXToggle)
		Gui.Add("Settings", "Edit", "x+5 yp-4 w100 R1 ReadOnly hwndhEDIT_BuyerJoinedAreaSFXPath")
		Gui.Add("Settings", "Button", "x+2 yp w25 hp ReadOnly hwndhBTN_BrowseBuyerJoinedAreaSFX", "O")
		Gui.Add("Settings", "CheckBox", "x" secondColX " y+6 hwndhCB_ShowTabbedTrayNotificationOnWhisper Center", PROGRAM.TRANSLATIONS.GUI_Settings.hCB_ShowTabbedTrayNotificationOnWhisper)

		Gui.Add("Settings", "Text", "x" secondColX " y+20 hwndhTEXT_PushBulletNotifications", PROGRAM.TRANSLATIONS.GUI_Settings.hTEXT_PushBulletNotifications)
		Gui.Add("Settings", "Text", "xp+10 y+10 hwndhTEXT_PushBulletToken", PROGRAM.TRANSLATIONS.GUI_Settings.hTEXT_PushBulletToken)
		Gui.Add("Settings", "Edit", "x+2 yp-3 w120 hwndhEDIT_PushBulletToken")
		Gui.Add("Settings", "CheckBox", "x" secondColX+10 " y+5 hwndhCB_PushBulletOnTradingWhisper", PROGRAM.TRANSLATIONS.GUI_Settings.hCB_PushBulletOnTradingWhisper)
		Gui.Add("Settings", "CheckBox", "xp y+5 hwndhCB_PushBulletOnlyWhenAfk", PROGRAM.TRANSLATIONS.GUI_Settings.hCB_PushBulletOnlyWhenAfk)
		
		; * * Reset
		resetBtnW := Get_TextCtrlSize("RESET SETTINGS TO DEFAULT", "Segoe UI", 8, "", "", ctrlType:="Button").W
		Gui.Add("Settings", "ImageButton", "x" rightMost2-resetBtnW " y" downMost2-30 " h30 hwndhBTN_ResetToDefaultSettings", "RESET SETTINGS TO DEFAULT", Style_ResetBtn, PROGRAM.FONTS["Segoe UI"], 8)
		Gui.BindFunctionToControl("GUI_Settings", "Settings", "hBTN_ResetToDefaultSettings", "ResetToDefaultSettings")
		
		; User settings
		GUI_Settings.TabsSettingsMain_SetUserSettings()

		/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
		*	TAB CUSTOMIZATION SKINS
		*/
		Gui, Settings:Tab, Skins

		; * * Preset
		Gui.Add("Settings", "Text", "x" leftMost2 " y" upMost2 " w130 Center hwndhTEXT_Preset", "Preset:")
		Gui.Add("Settings", "ListBox", "xp y+5 wp R5 hwndhLB_SkinPreset")

		; * * Skin base
		Gui.Add("Settings", "Text", "x+10 y" upMost2 " w130 Center hwndhTEXT_SkinBase", "Skin base:")
		Gui.Add("Settings", "ListBox", "xp y+5 wp R5 hwndhLB_SkinBase")
		
		; * * Font
		Gui.Add("Settings", "Text", "x+10 y" upMost2 " w130 Center hwndhTEXT_TextFont", "Text font:")
		Gui.Add("Settings", "ListBox", "xp y+5 wp R5 hwndhLB_SkinFont")

		; * * Options
		Gui.Add("Settings", "Checkbox", "x+5 yp hwndhCB_UseRecommendedFontSettings","Use recommended font settings?")
		Gui.Add("Settings", "Text", "xp y+10 hwndhTEXT_FontSize","Size:")
		Gui.Add("Settings", "Edit", "x+2 yp-3 w50 R1 ReadOnly hwndhEDIT_SkinFontSize")
		Gui.Add("Settings", "UpDown", "Range1-24 hwndhUPDOWN_SkinFontSize")
		fontSizeTextPos := Get_ControlCoords("Settings", GuiSettings_Controls.hTEXT_FontSize)
		Gui.Add("Settings", "Text", "x+10 y" fontSizeTextPos.Y " hwndhTEXT_FontQuality","Quality:")
		Gui.Add("Settings", "Edit", "x+2 yp-3 w50 R1 ReadOnly hwndhEDIT_SkinFontQuality")
		Gui.Add("Settings", "UpDown", "Range0-5 hwndhUPDOWN_SkinFontQuality")
		useFontSettingsCbPos := Get_ControlCoords("Settings", GuiSettings_Controls.hCB_UseRecommendedFontSettings)
		Gui.Add("Settings", "Text", "x" useFontSettingsCbPos.X " y+15 hwndhTEXT_ScalingSize","Interface scaling (`%):")
		Gui.Add("Settings", "Edit", "x+5 yp-3 w55 R1 ReadOnly hwndhEDIT_SkinScalingPercentage")
		Gui.Add("Settings", "UpDown", "Range5-200 hwndhUPDOWN_SkinScalingPercentage")

		; * * Text colors TO_DO_V2 find new way of doing things
		; Gui.Add("Settings", "Text", "x" leftMost2+15 " y+80 hwndhTEXT_TextColor","Text color:")
		; Gui.Add("Settings", "DropDownList", "x+5 yp-3 w140 hwndhDDL_ChangeableFontColorTypes")
		; ddlHeight := Get_ControlCoords("Settings", GuiSettings_Controls.hDDL_ChangeableFontColorTypes).H
		; Gui.Add("Settings", "Progress", "x+5 yp w" ddlHeight " h" ddlHeight " BackgroundRed hwndhPROGRESS_ColorSquarePreview")
		; Gui.Add("Settings", "Button", "x+5 yp-1  hwndhBTN_ShowColorPicker R1", "Show Color Picker")

		; * * Preview btn
		Gui.Add("Settings", "Button", "x" rightMost2-215 " y" downMost2-30 " w215 h30 hwndhBTN_RecreateTradesGUI", "Apply skin changes now")
		Gui.BindFunctionToControl("GUI_Settings", "Settings", "hBTN_RecreateTradesGUI", "TabCustomizationSkins_RecreateTradesGUI")

		; * * Subroutines + User settings
		GUI_Settings.TabCustomizationSkins_SetUserSettings()

		/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
		*	TAB Customization Selling
		*/
		Gui, Settings:Tab, Selling

		Gui.Add("Settings", "Button", "x" leftMost2 " y" upMost2 " w25 h25 hwndhBTN_CustomizationSellingButtonMinusRow1", "-")
		Gui.Add("Settings", "Button", "x+0 yp wp hp hwndhBTN_CustomizationSellingButtonPlusRow1", "+")
		Gui.Add("Settings", "Button", "x" leftMost2 " y+3 wp hp hwndhBTN_CustomizationSellingButtonMinusRow2", "-")
		Gui.Add("Settings", "Button", "x+0 yp wp hp wp hp hwndhBTN_CustomizationSellingButtonPlusRow2", "+")
		Gui.Add("Settings", "Button", "x" leftMost2 " y+3 wp hp hwndhBTN_CustomizationSellingButtonMinusRow3", "-")
		Gui.Add("Settings", "Button", "x+0 yp wp hp wp hp hwndhBTN_CustomizationSellingButtonPlusRow3", "+")
		Gui.Add("Settings", "Button", "x" leftMost2 " y+3 wp hp hwndhBTN_CustomizationSellingButtonMinusRow4", "-")
		Gui.Add("Settings", "Button", "x+0 yp wp hp wp hp hwndhBTN_CustomizationSellingButtonPlusRow4", "+")

		Gui.Add("Settings", "Text", "x" leftMost2 " y" upMost2 " w0 h200", "")
		Gui.Add("Settings", "DropDownList", "x" leftMost2+20+( (200+295+5) / 2)-75-40-5 " y+10 w80 hwndhDDL_CustomizationSellingButtonType Choose1", "Text|Icon")
		Gui.Add("Settings", "Edit", "x+5 yp w150 R1 hwndhEDIT_CustomizationSellingButtonName", "Button Name")
		Gui.Add("Settings", "DropDownList", "xp yp wp hwndhDDL_CustomizationSellingButtonIcon Choose1", "Clipboard|Invite|Kick|ThumbsUp|ThumbsDown|Trade|Whisper")
		Gui.Add("Settings", "DropDownList", "x" leftMost2+20 " y+5 w200 R50 hwndhDDL_CustomizationSellingActionType Choose2", ACTIONS_AVAILABLE)
		Gui.Add("Settings", "Edit", "x+5 yp w295 hwndhEDIT_CustomizationSellingActionContent")
		Gui.Add("Settings", "Text", "x" leftMost2+20 " y+5 w500 R2 hwndhTEXT_CustomizationSellingActionTypeTip")
		Gui.Add("Settings", "ListView", "x" leftMost2+20 " y+10 w500 R8 hwndhLV_CustomizationSellingActionsList -Multi AltSubmit +LV0x10000 NoSortHdr NoSort -LV0x10", "#|Type|Content")

		/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
		*	TAB Customization Buying
		*/
		Gui, Settings:Tab, Buying

		Gui.Add("Settings", "Button", "x" leftMost2 " y" upMost2 " w25 h25 hwndhBTN_CustomizationBuyingButtonMinusRow1", "-")
		Gui.Add("Settings", "Button", "x+0 yp wp hp hwndhBTN_CustomizationBuyingButtonPlusRow1", "+")
		Gui.Add("Settings", "Button", "x" leftMost2 " y+3 wp hp hwndhBTN_CustomizationBuyingButtonMinusRow2", "-")
		Gui.Add("Settings", "Button", "x+0 yp wp hp wp hp hwndhBTN_CustomizationBuyingButtonPlusRow2", "+")
		Gui.Add("Settings", "Button", "x" leftMost2 " y+3 wp hp hwndhBTN_CustomizationBuyingButtonMinusRow3", "-")
		Gui.Add("Settings", "Button", "x+0 yp wp hp wp hp hwndhBTN_CustomizationBuyingButtonPlusRow3", "+")
		Gui.Add("Settings", "Button", "x" leftMost2 " y+3 wp hp hwndhBTN_CustomizationBuyingButtonMinusRow4", "-")
		Gui.Add("Settings", "Button", "x+0 yp wp hp wp hp hwndhBTN_CustomizationBuyingButtonPlusRow4", "+")

		Gui.Add("Settings", "Text", "x" leftMost2 " y" upMost2 " w0 h200", "")
		Gui.Add("Settings", "DropDownList", "x" leftMost2+20+( (200+295+5) / 2)-75-40-5 " y+10 w80 hwndhDDL_CustomizationBuyingButtonType Choose1", "Text|Icon")
		Gui.Add("Settings", "Edit", "x+5 yp w150 R1 hwndhEDIT_CustomizationBuyingButtonName", "Button Name")
		Gui.Add("Settings", "DropDownList", "xp yp wp hwndhDDL_CustomizationBuyingButtonIcon Choose1", "Clipboard|Invite|Kick|ThumbsDown|ThumbsUp|Trade|Whisper")
		Gui.Add("Settings", "DropDownList", "x" leftMost2+20 " y+5 w200 R50 hwndhDDL_CustomizationBuyingActionType Choose2", ACTIONS_AVAILABLE)
		Gui.Add("Settings", "Edit", "x+5 yp w295 hwndhEDIT_CustomizationBuyingActionContent")
		Gui.Add("Settings", "Text", "x" leftMost2+20 " y+5 w500 R2 hwndhTEXT_CustomizationBuyingActionTypeTip")
		Gui.Add("Settings", "ListView", "x" leftMost2+20 " y+10 w500 R8 hwndhLV_CustomizationBuyingActionsList -Multi AltSubmit +LV0x10000 NoSortHdr NoSort -LV0x10", "#|Type|Content")

		/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
		*	TAB HOTKEYS ADVANCED
		*/
		Gui, Settings:Tab, Hotkeys

		Gui.Add("Settings", "ListBox", "x" leftMost2 " y" upMost2 " w130 h" downMost2-upMost2-25-3 " hwndhLB_HotkeyProfiles AltSubmit"), hkListBoxPos := Get_ControlCoords("Settings", GuiSettings_Controls.hLB_HotkeyProfiles), leftMost3 := hkListBoxPos.X+hkListBoxPos.W+10
		Gui.Add("Settings", "Button", "xp y+3 w" (130/2)-(4/2) " h25 hwndhBTN_HotkeyRemoveSelectedProfile", "-")
		Gui.Add("Settings", "Button", "x+4 yp wp hp hwndhBTN_HotkeyAddNewProfile", "+")

		centeredX := rightMost2-leftMost3-160-(160/2)-(15/2)
		Gui.Add("Settings", "Text", "x" centeredX " y" upMost2 " Center hwndhTEXT_HotkeyProfileName", "Profile name:")
		Gui.Add("Settings", "Edit", "xp y+3 w160 hwndhEDIT_HotkeyProfileName", ""), editHkProfNamePos := Get_ControlCoords("Settings", GuiSettings_Controls.hEDIT_HotkeyProfileName)
		Gui.MoveControl("Settings", "hTEXT_HotkeyProfileName", "w" editHkProfNamePos.W)
		
		Gui.Add("Settings", "Text", "x+15 y" upMost2 " Center hwndhTEXT_HotkeyProfileHotkey", "Profile hotkey:")
		Gui.Add("Settings", "Edit", "xp y+3 w160 hwndhEDIT_HotkeyProfileHotkey", ""), editHkProfHotkeyPos := Get_ControlCoords("Settings", GuiSettings_Controls.hEDIT_HotkeyProfileHotkey)
		Gui.MoveControl("Settings", "hTEXT_HotkeyProfileHotkey", "w" editHkProfHotkeyPos.W)

		availableWidth := rightMost2-leftMost3
		Gui.Add("Settings", "Text", "x" leftMost3 " y+25 w" availableWidth " Center hwndhTEXT_Actions", "Actions:")
		Gui.Add("Settings", "DropDownList", "x" leftMost3 " y+5 w" availableWidth*0.45 " R50 hwndhDDL_HotkeyActionType Choose2", ACTIONS_AVAILABLE)
		Gui.Add("Settings", "Edit", "x+3 yp w" availableWidth*0.55-3 " hwndhEDIT_HotkeyActionContent")
		Gui.Add("Settings", "Text", "x" leftMost3 " y+5 w" availableWidth " R2 hwndhTEXT_HotkeyActionTypeTip")
		Gui.Add("Settings", "ListView", "x" leftMost3 " y+10 w" availableWidth " R8 hwndhLV_HotkeyActionsList -Multi AltSubmit +LV0x10000 NoSortHdr NoSort -LV0x10", "#|Type|Content")

		GUI_Settings.TabHotkeys_SetUserSettings()

		/*
		Gui.Add("Settings", "DropDownList", "x" leftMost2+20 " y" upMost2+20 " w430 R20 hwndhDDL_HotkeyAdvExistingList")
		Gui.Add("Settings", "Button", "x+5 yp-1 w30 hp hwndhBTN_HotkeyAdvAddNewProfile", "+")
		Gui.Add("Settings", "Button", "x+5 yp w30 hp hwndhBTN_HotkeyAdvDeleteCurrentProfile", "-")
		Gui.Add("Settings", "Edit", "x" leftMost2+20 " y+16 w260 hwndhEDIT_HotkeyAdvName")

		Gui.Add("Settings", "Hotkey", "x+5 yp w165 hwndhHK_HotkeyAdvHotkey")
		Gui.Add("Settings", "Edit", "xp yp wp hp Hidden hwndhEDIT_HotkeyAdvHotkey")
		Gui.Add("Settings", "Button", "x+0 yp hp hwndhBTN_ChangeHKType", "HK Type Switch")
		coords := Get_ControlCoords("Settings", GuiSettings_Controls.hBTN_ChangeHKType)
		GuiControl, Settings:Move,% GuiSettings_Controls.hHK_HotkeyAdvHotkey,% "w" 235-coords.W
		GuiControl, Settings:Move,% GuiSettings_Controls.hEDIT_HotkeyAdvHotkey,% "w" 235-coords.W
		coords := Get_ControlCoords("Settings", GuiSettings_Controls.hEDIT_HotkeyAdvHotkey)
		GuiControl, Settings:Move,% GuiSettings_Controls.hBTN_ChangeHKType,% "x" coords.X + coords.W + 1

		Gui.Add("Settings", "DropDownList", "x" leftMost2+20 " y+7 w200 R50 hwndhDDL_HotkeyAdvActionType")
		Gui.Add("Settings", "Edit", "x+5 yp w295 hwndhEDIT_HotkeyAdvActionContent")
		Gui.Add("Settings", "Button","x" leftMost2+20 " y+7 w245 hwndhBTN_HotkeyAdvSaveChangesToAction", "Save changes to action...")
		Gui.Add("Settings", "Button","x+10 yp wp hwndhBTN_HotkeyAdvAddAsNewAction", "Add as a new action")
		Gui.Add("Settings", "ListView", "x" leftMost2+20 " y+10 w500 hwndhLV_HotkeyAdvActionsList -Multi AltSubmit +LV0x10000 R8", "#|Type|Content")
		GUI_Settings.SetDefaultListView("hLV_HotkeyAdvActionsList")
		loopIndex := 1
		Loop, Parse, ACTIONS_AVAILABLE,% "|"
		{
			if (A_LoopField && A_LoopField != " " && !IsContaining(A_LoopField, "-> ")) {
				LV_Add("", loopIndex, A_LoopField, "")
				loopIndex++
			}
		}
		Loop 3
			LV_ModifyCol(A_Index, "AutoHdr NoSort")
		LV_ModifyCol(1, "Integer")
		LV_Delete()

		GUI_Settings.TabHotkeysAdvanced_UpdateActionsList()
		GUI_Settings.TabHotkeysAdvanced_UpdateRegisteredHotkeysList()
		GuiSettings.Hotkeys_Advanced_TabControls := "hDDL_HotkeyAdvExistingList,hEDIT_HotkeyAdvName,hHK_HotkeyAdvHotkey,hDDL_HotkeyAdvActionType"
			. ",hEDIT_HotkeyAdvActionContent,hBTN_HotkeyAdvSaveChangesToAction,hBTN_HotkeyAdvAddAsNewAction,hLV_HotkeyAdvActionsList"
			. ",hBTN_HotkeyAdvAddNewProfile,hBTN_HotkeyAdvDeleteCurrentProfile,hEDIT_HotkeyAdvHotkey,hBTN_ChangeHKType"
			*/

		/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
		*	TAB MISC UPDATING
		*/
		Gui, Settings:Tab, Updating

		Gui.Add("Settings", "GroupBox", "x" leftMost2 " y" upMost2 " cBlack w525 h115 hwndhGB_UpdateCheck", "You are up to date!")

		Gui.Add("Settings", "Text", "x" leftMost2+20 " y" upMost2+20 " hwndhTEXT_YourVersion", "Your version:")
		Gui.Add("Settings", "Text", "x+30 yp BackgroundTrans hwndhTEXT_ProgramVer")
		yourVerCoords := Get_ControlCoords("Settings", GuiSettings_Controls.hTEXT_YourVersion)
		programVerCoords := Get_ControlCoords("Settings", GuiSettings_Controls.hTEXT_ProgramVer)

		Gui.Add("Settings", "Text", "x" yourVerCoords.X " y+10 hwndhTEXT_LatestStable", "Latest Stable:")
		Gui.Add("Settings", "Text", "x" programVerCoords.X " yp BackgroundTrans hwndhTEXT_LatestStableVer")
		Gui.Add("Settings", "Text", "x" yourVerCoords.X " y+5 hwndhTEXT_LatestBETA", "Latest BETA:")
		Gui.Add("Settings", "Text", "x" programVerCoords.X " yp BackgroundTrans hwndhTEXT_LatestBetaVer")
		Gui.Add("Settings", "Button", "x" yourVerCoords.X " y+10 R1 hwndhBTN_CheckForUpdates", "Check for updates manually")
		Gui.Add("Settings", "Text", "x+5 yp+7 hwndhTEXT_MinsAgo", "(x mins ago)")

		; Gui.Add("Settings", "Checkbox", "x400 y" upMost2+20 " hwndhCB_AllowToUpdateAutomaticallyOnStart", "Allow to update automatically on start?")
		; Gui.Add("Settings", "Checkbox", "xp y+5 hwndhCB_AllowPeriodicUpdateCheck", "Allow automatic update check every 2hours?")
		Gui.Add("Settings", "Text", "x380 y" upMost2+20 " hwndhTEXT_CheckForUpdatesWhen", "Check for updates... ")
		Gui.Add("Settings", "DropDownList", "x+5 yp-2 w155 hwndhDDL_CheckForUpdate AltSubmit", "Only on application start|On start + every 5 hours|On start + every day")
		Gui.Add("Settings", "Checkbox", "xp y+10 hwndhCB_UseBeta", "Use the BETA branch?")		
		Gui.Add("Settings", "Checkbox", "xp y+5 hwndhCB_DownloadUpdatesAutomatically", "Download updates`nautomatically?")
		
		ctrlSize := Get_ControlCoords("Settings", GuiSettings_Controls.hGB_UpdateCheck)
		Gui.Add("Settings", "Edit", "x" leftMost2 " y" upMost2+125 " w525 h" guiHeight-80-ctrlSize.H-ctrlSize.Y+15, Get_Changelog(removeTrails:=True) )

		Gui.Font("Settings", "Segoe UI", "8")

		GuiSettings.TabMiscUpdating_Controls := "hGB_UpdateCheck,hTEXT_LatestBetaVer,hTEXT_LatestStableVer,hTEXT_YourVersion,hBTN_CheckForUpdates,hTEXT_MinsAgo"
			. ",hDDL_CheckForUpdate,hCB_UseBeta,hBTN_CheckForUpdates,hCB_DownloadUpdatesAutomatically"
		GUI_Settings.TabMiscUpdating_SetUserSettings()

		/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
		*	TAB MISC ABOUT
		*/
		Gui, Settings:Tab, About

		Gui.Add("Settings", "GroupBox", "x" leftMost2 " y" upMost2 " cBlack w525 h115 hwndhGB_About")
		Gui.Add("Settings", "Text", "x" leftMost2+10 " y" upMost2+15 " w505 Center hwndhTEXT_About" , "POE Trades Companion is a tool meant to enhance your trading experience. "
			. "`n`nUpon receiving a trading whisper (poe.trade / poeapp.com),"
			. "`nthe most important informations from the trade will be shown in a convenient interface."
			. "`n`nUp to nine custom buttons to interact with your buyer, five special smaller buttons to do the strict minimum, and many hotkeys are available to make trading more enjoyable.")

		ctrlSize := Get_ControlCoords("Settings", GuiSettings_Controls.hGB_About)
		Gui.Add("Settings", "Edit", "x" leftMost2 " y" upMost2+125 " w525 h" guiHeight-80-ctrlSize.H-ctrlSize.Y+15 " ReadOnly Center hwndhEDIT_HallOfFame", "Hall of Fame`nThank you for your support!`n`n" "[Hall of Fame loading]")

		GUI_Settings.TabMiscAbout_UpdateAllOfFame()		

		/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
		*	TAB - ALL
		*/
		Gui, Settings:Tab

		Gui.Add("Settings", "Progress", "x0 y" guiHeight-50 " w" guiWidth " h50 c359cfc Background359cfc")

		Gui.Add("Settings", "Picture", "x3 y" guiHeight-27 " w35 h24 hwndhIMG_FlagUK BackgroundTrans", PROGRAM.IMAGES_FOLDER "\flag_uk.png")
		Gui.Add("Settings", "Picture", "x+3 yp wp hp hwndhIMG_FlagFrance BackgroundTrans", PROGRAM.IMAGES_FOLDER "\flag_france.png")
		Gui.Add("Settings", "Picture", "x+3 yp wp hp hwndhIMG_FlagChina BackgroundTrans", PROGRAM.IMAGES_FOLDER "\flag_china.png")
		Gui.Add("Settings", "Picture", "x+3 yp wp hp hwndhIMG_FlagTaiwan BackgroundTrans", PROGRAM.IMAGES_FOLDER "\flag_taiwan.png")

		Gui.Add("Settings", "Picture", "x" guiWidth-120 " y" guiHeight-45 " w115 h40 hwndhIMG_Paypal BackgroundTrans", PROGRAM.IMAGES_FOLDER "\DonatePaypal.png")
		Gui.Add("Settings", "Picture", "xp-70 yp w40 h40 hwndhIMG_Discord BackgroundTrans", PROGRAM.IMAGES_FOLDER "\Discord.png")
		Gui.Add("Settings", "Picture", "xp-45 yp w40 h40 hwndhIMG_Reddit BackgroundTrans", PROGRAM.IMAGES_FOLDER "\Reddit.png")
		Gui.Add("Settings", "Picture", "xp-45 yp w40 h40 hwndhIMG_PoE BackgroundTrans", PROGRAM.IMAGES_FOLDER "\PoE.png")
		Gui.Add("Settings", "Picture", "xp-45 yp w40 h40 hwndhIMG_GitHub BackgroundTrans", PROGRAM.IMAGES_FOLDER "\GitHub.png")

		Gui.BindFunctionToControl("GUI_Settings", "Settings", "hIMG_FlagUK", "OnLanguageChange", "english")
		Gui.BindFunctionToControl("GUI_Settings", "Settings", "hIMG_FlagFrance", "OnLanguageChange", "french")
		Gui.BindFunctionToControl("GUI_Settings", "Settings", "hIMG_FlagChina", "OnLanguageChange", "chinese_simplified")
		Gui.BindFunctionToControl("GUI_Settings", "Settings", "hIMG_FlagTaiwan", "OnLanguageChange", "chinese_traditional")

		Gui.BindFunctionToControl("GUI_Settings", "Settings", "hIMG_Paypal", "OnPictureLinkClick", "Paypal")
		Gui.BindFunctionToControl("GUI_Settings", "Settings", "hIMG_Discord", "OnPictureLinkClick", "Discord")
		Gui.BindFunctionToControl("GUI_Settings", "Settings", "hIMG_Reddit", "OnPictureLinkClick", "Reddit")
		Gui.BindFunctionToControl("GUI_Settings", "Settings", "hIMG_PoE", "OnPictureLinkClick", "PoE")
		Gui.BindFunctionToControl("GUI_Settings", "Settings", "hIMG_GitHub", "OnPictureLinkClick", "GitHub")

		/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
		*	SHOW
		*/

		GUI_Settings.TabSettingsMain_SetSubroutines()
		GUI_Settings.TabCustomizationSkins_SetSubroutines()
		GUI_Settings.TabCustomizationBuying_SetSubroutines()
		GUI_Settings.TabCustomizationSelling_SetSubroutines()
		GUI_Settings.TabHotkeys_SetSubroutines()
		; GUI_Settings.TabHotkeysBasic_EnableSubroutines()
		; GUI_Settings.TabHotkeysAdvanced_EnableSubroutines()
		; GUI_Settings.TabMiscUpdating_EnableSubroutines()

		Gui.Show("Settings", "h" guiHeight " w" guiWidth " NoActivate Hide")
		
		; Gui.Show("Settings", "h" guiHeight " w" guiWidth " x-" guiWidth+10 " y" 1010-guiHeight " NoActivate " param)
		detectHiddenWin := A_DetectHiddenWindows
		DetectHiddenWindows, On
		WinWait,% "ahk_id " GuiSettings.Handle
		DetectHiddenWindows, %detectHiddenWin%
		
		OnMessage(0x201, "WM_LBUTTONDOWN")
		OnMessage(0x202, "WM_LBUTTONUP")
		OnMessage(0x200, "WM_MOUSEMOVE")

		if (whichTab)
			Gui_Settings.OnTabBtnClick(whichTab)

		; Gui_Settings.OnTabBtnClick("Settings Main")
		; Gui_Settings.OnTabBtnClick("Customization Skins")
		; Gui_Settings.OnTabBtnClick("Hotkeys Basic")
		; Gui_Settings.OnTabBtnClick("Hotkeys Advanced")
		; Gui_Settings.OnTabBtnClick("Misc Updating")
		; Gui_Settings.OnTabBtnClick("Misc About")
		; GUI_Settings.TabMiscAbout_UpdateAllOfFame()

		GuiSettings.Is_Created := True
		Return

		GUI_Settings_Close:
		Return

		GUI_Settings_ContextMenu:
			ctrlHwnd := Get_UnderMouse_CtrlHwnd()
			GuiControlGet, ctrlName, Settings:,% ctrlHwnd

			if (ctrlHwnd = GuiSettings_Controls.hLV_CustomizationSellingActionsList)
				GUI_Settings.Customization_Selling_OnListviewRightClick()
			else if (ctrlHwnd = GuiSettings_Controls.hLV_CustomizationBuyingActionsList)
				GUI_Settings.Customization_Buying_OnListviewRightClick()
			else if (ctrlHwnd = GuiSettings_Controls.hLV_HotkeyActionsList)
				GUI_Settings.Hotkeys_OnListviewRightClick()
			else
				GUI_Settings.ContextMenu(ctrlHwnd, ctrlName)
		return
	}

	/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	*										TAB SETTINGS MAIN													 *
	* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	*/

	TabsSettingsMain_SetUserSettings() {
		global PROGRAM, GuiSettings, GuiSettings_Controls
		thisTabSettings := ObjFullyClone(PROGRAM.SETTINGS.SETTINGS_MAIN)

		controlsList := "hDDL_PoeAccounts,hDDL_BuyingInterfaceMode"
			. ",hDDL_SellingInterfaceMode,hCB_HideInterfaceWhenOutOfGame,hCB_MinimizeInterfaceToBottomLeft,hCB_CopyItemInfosOnTabChange,hCB_AutoFocusNewTabs,hCB_AutoMinimizeOnAllTabsClosed"
			. ",hCB_AutoMaximizeOnFirstNewTab,hCB_SendTradingWhisperUponCopyWhenHoldingCTRL,hCB_ItemGridHideNormalTab,hCB_ItemGridHideQuadTab,hCB_ItemGridHideNormalTabAndQuadTabForMaps"
			. ",hCB_AllowClicksToPassThroughWhileInactive,hSLIDER_NoTabsTransparency,hSLIDER_TabsOpenTransparency"
			. ",hCB_TradingWhisperSFXToggle,hEDIT_TradingWhisperSFXPath,hCB_RegularWhisperSFXToggle,hEDIT_RegularWhisperSFXPath"
			. ",hCB_BuyerJoinedAreaSFXToggle,hEDIT_BuyerJoinedAreaSFXPath,hBTN_BrowseBuyerJoinedAreaSFX,hCB_ShowTabbedTrayNotificationOnWhisper"
			. ",hEDIT_PushBulletToken,hCB_PushBulletOnTradingWhisper,hCB_PushBulletOnlyWhenAfk"

		Loop, Parse,% controlsList,% ","
		{
			ctrlName := A_LoopField, ctrlSplit := StrSplit(ctrlName, "_"), ctrlType := ctrlSplit.1, settingsKey := ctrlSplit.2

			if (ctrlType = "hCB") {
				trueFalseVal := thisTabSettings[settingsKey] = "True" ? True : False
				GuiControl, Settings:,% GuiSettings_Controls[ctrlName],% trueFalseVal
			}
			else if (ctrlName="hDDL_PoeAccounts") {
				for index, account in thisTabSettings.PoeAccounts
					ctrlVal .= "|" account
				GuiControl, Settings:,% GuiSettings_Controls[ctrlName],% ctrlVal
				GuiControl, Settings:ChooseString,% GuiSettings_Controls[ctrlName],% thisTabSettings.PoeAccounts.1
			}
			else if IsIn(ctrlName, "hDDL_BuyingInterfaceMode,hDDL_SellingInterfaceMode") {
				settingValue := ctrlName="hDDL_BuyingInterfaceMode" ? PROGRAM.SETTINGS.BUY_INTERFACE.Mode : PROGRAM.SETTINGS.SELL_INTERFACE.Mode
				GuiControl, Settings:ChooseString,% GuiSettings_Controls[ctrlName],% settingValue
			}
			else if (ctrlType = "hDDL") {
				GuiControl, Settings:ChooseString,% GuiSettings_Controls[ctrlName],% thisTabSettings[settingsKey]
			}
			else {
				GuiControl, Settings:,% GuiSettings_Controls[ctrlName],% thisTabSettings[settingsKey]
			}
		}
	}

	TabSettingsMain_SetSubroutines() {
		global GuiSettings, GuiSettings_Controls
		controlsList := "hBTN_EditPoeAccountsList,hDDL_BuyingInterfaceMode"
			. ",hDDL_SellingInterfaceMode,hCB_HideInterfaceWhenOutOfGame,hCB_MinimizeInterfaceToBottomLeft,hCB_CopyItemInfosOnTabChange,hCB_AutoFocusNewTabs,hCB_AutoMinimizeOnAllTabsClosed"
			. ",hCB_AutoMaximizeOnFirstNewTab,hCB_SendTradingWhisperUponCopyWhenHoldingCTRL,hCB_ItemGridHideNormalTab,hCB_ItemGridHideQuadTab,hCB_ItemGridHideNormalTabAndQuadTabForMaps"
			. ",hCB_AllowClicksToPassThroughWhileInactive,hSLIDER_NoTabsTransparency,hSLIDER_TabsOpenTransparency"
			. ",hCB_TradingWhisperSFXToggle,hBTN_BrowseTradingWhisperSFX,hCB_RegularWhisperSFXToggle,hBTN_BrowseRegularWhisperSFX"
			. ",hCB_BuyerJoinedAreaSFXToggle,hBTN_BrowseBuyerJoinedAreaSFX,hCB_ShowTabbedTrayNotificationOnWhisper"
			. ",hEDIT_PushBulletToken,hCB_PushBulletOnTradingWhisper,hCB_PushBulletOnlyWhenAfk"

		Loop, Parse, controlsList,% ","
		{
			ctrlName := A_LoopField, ctrlSplit := StrSplit(ctrlName, "_"), ctrlType := ctrlSplit.1, settingsKey := ctrlSplit.2

			if (ctrlType="hCB")
				Gui.BindFunctionToControl("GUI_Settings", "Settings", ctrlName, "TabSettingsMain_OnCheckboxToggle", ctrlName)
			else if (ctrlName="hBTN_EditPoeAccountsList")
				Gui.BindFunctionToControl("GUI_Settings", "Settings", ctrlName, "TabSettingsMain_EditPoeAccountsList")
			else if (ctrlName="hDDL_BuyingInterfaceMode")
				Gui.BindFunctionToControl("GUI_Settings", "Settings", ctrlName, "TabSettingsMain_OnBuyingInterfaceModeChange")
			else if (ctrlName="hDDL_SellingInterfaceMode")
				Gui.BindFunctionToControl("GUI_Settings", "Settings", ctrlName, "TabSettingsMain_OnSellingInterfaceModeChange")
			else if IsIn(ctrlName,"hSLIDER_NoTabsTransparency,hSLIDER_TabsOpenTransparency")
				Gui.BindFunctionToControl("GUI_Settings", "Settings", ctrlName, "TabSettingsMain_OnTransparencySliderMove", ctrlName)
			else if IsIn(ctrlName,"hBTN_BrowseTradingWhisperSFX,hBTN_BrowseRegularWhisperSFX,hBTN_BrowseBuyerJoinedAreaSFX")
				Gui.BindFunctionToControl("GUI_Settings", "Settings", ctrlName, "TabSettingsMain_OnSFXBrowse", ctrlName)
			else if (ctrlName="hEDIT_PushBulletToken")
				Gui.BindFunctionToControl("GUI_Settings", "Settings", ctrlName, "TabSettingsMain_OnPushBulletTokenChange")
		}
	}

	TabSettingsMain_OnBuyingInterfaceModeChange() {
		global PROGRAM
		global GuiTrades, GuiSettings, GuiSettings_Controls

		currentMode := PROGRAM.SETTINGS.BUY_INTERFACE.Mode
		mode := GUI_Settings.Submit("hDDL_BuyingInterfaceMode")
		if (currentMode=mode)
			return

		PROGRAM.SETTINGS.BUY_INTERFACE.Mode := mode
		Save_LocalSettings()
		; TO_DO_V2 remake interface for the buy tab
	}
	
	TabSettingsMain_OnSellingInterfaceModeChange() {
		global PROGRAM
		global GuiTrades, GuiSettings, GuiSettings_Controls

		currentMode := PROGRAM.SETTINGS.SELL_INTERFACE.Mode
		mode := GUI_Settings.Submit("hDDL_SellingInterfaceMode")
		if (currentMode=mode)
			return

		PROGRAM.SETTINGS.SELL_INTERFACE.Mode := mode
		Save_LocalSettings()
		; TO_DO_V2 remake interface for the sell tab
	}

	TabSettingsMain_OnCheckboxToggle(CtrlName) {	
		global PROGRAM, GuiTrades

		settingKey := SubStr(CtrlName, 5)
		cbState := GUI_Settings.Submit(CtrlName), settingValue := cbState=1?"True":"False"
		PROGRAM.SETTINGS.SETTINGS_MAIN[settingKey] := settingValue
		Save_LocalSettings()

		if (CtrlName = "hCB_AllowClicksToPassThroughWhileInactive") {
			if (settingValue = "True") {
				if (GuiTrades.Buy.Tabs_Count = 0)
					GUI_Trades_V2.Enable_ClickThrough("Buy")
				if (GuiTrades.Sell.Tabs_Count = 0)
					GUI_Trades_V2.Enable_ClickThrough("Sell")
				Menu, Tray, Check,% PROGRAM.TRANSLATIONS.TrayMenu.Clickthrough
			}
			else {
				if (GuiTrades.Buy.Tabs_Count)
					GUI_Trades_V2.Disable_ClickThrough("Buy")
				if (GuiTrades.Sell.Tabs_Count)
					GUI_Trades_V2.Disable_ClickThrough("Sell")
				Menu, Tray, UnCheck,% PROGRAM.TRANSLATIONS.TrayMenu.Clickthrough
			}
		}
	}

	TabSettingsMain_OnPushBulletTokenChange() {
		global PROGRAM
		PROGRAM.SETTINGS.SETTINGS_MAIN.PushBulletToken := GUI_Settings.Submit("hEDIT_PushBulletToken")
		Save_LocalSettings()
	}

	TabSettingsMain_EditPoeAccountsList() {
		global PROGRAM
		global GuiPoeAccounts, GuiPoeAccounts_Controls, GuiPoeAccounts_Submit

		for index, accName in PROGRAM.SETTINGS.SETTINGS_MAIN.PoeAccounts
			accList := accList?accList "`n" accName : accName

		Gui.Destroy("PoeAccounts")
		Gui.New("PoeAccounts", "+HwndhGuiPoeAccounts +LabelGuiPoeAccounts_ +AlwaysOnTop")
		Gui.Add("PoeAccounts", "Edit", "x0 y0 w100 R10 hwndhEDIT_AccountsList", accList)
		Gui.Show("PoeAccounts", "xCenter yCenter AutoSize")
		return

		GuiPoeAccounts_Close:
			Gui.Submit("PoeAccounts")
			accounts := GuiPoeAccounts_Submit.hEDIT_AccountsList
			accountsObj := []
			Loop, Parse, accounts, `n
			{
				if (A_LoopField)
					accountsObj.Push(A_LoopField)
			}
			PROGRAM.SETTINGS.SETTINGS_MAIN.PoeAccounts := ObjFullyClone(accountsObj)
			GUI_Settings.TabsSettingsMain_SetUserSettings()
			Save_LocalSettings()
			Gui.Destroy("PoeAccounts")
		return
	}

	TabSettingsMain_ToggleClickthroughCheckbox() {
		global PROGRAM, GuiSettings_Controls

		cbState := GUI_Settings.Submit("hCB_AllowClicksToPassThroughWhileInactive")
		GuiControl, Settings:,% GuiSettings_Controls["hCB_AllowClicksToPassThroughWhileInactive"],% !cbState
		GUI_Settings.TabSettingsMain_OnCheckboxToggle("hCB_AllowClicksToPassThroughWhileInactive")
	}

	TabSettingsMain_OnSFXBrowse(CtrlName) {
		global PROGRAM, GuiSettings_Controls

		FileSelectFile, soundFile, ,% PROGRAM.SFX_FOLDER,% PROGRAM.NAME " - Select an audio file",Audio (*.wav; *.mp3)
		if (!soundFile || ErrorLevel)
			Return

		EditBoxHwnd := CtrlName="hBTN_BrowseTradingWhisperSFX" ? GuiSettings_Controls.hEDIT_TradingWhisperSFXPath
			: CtrlName = "hBTN_BrowseRegularWhisperSFX" ? GuiSettings_Controls.hEDIT_RegularWhisperSFXPath
			: CtrlName = "hBTN_BrowseBuyerJoinedAreaSFX" ? GuiSettings_Controls.hEDIT_BuyerJoinedAreaSFXPath
			: ""
		GuiControl, %A_Gui%:,% EditBoxHwnd,% soundFile

		settingsKey := StrSplit(CtrlName, "hBTN_Browse").2, settingsKey .= "Path"
		PROGRAM.SETTINGS.SETTINGS_MAIN[settingsKey] := soundFile
		Save_LocalSettings()
	}

	TabSettingsMain_OnTransparencySliderMove(CtrlName) {
		global PROGRAM, GuiTrades,

		sliderValue := GUI_Settings.Submit(CtrlName)
		settingsKey := StrSplit(CtrlName, "hSLIDER_").2
		PROGRAM.SETTINGS.SETTINGS_MAIN[settingsKey] := sliderValue
		Save_LocalSettings()

		GUI_Trades_V2.SetTransparencyPercent("Buy", sliderValue)
		GUI_Trades_V2.SetTransparencyPercent("Sell", sliderValue)

		if IsIn(A_GuiControlEvent,"Normal,4") {
			buyUserTrans := GuiTrades.Buy.Tabs_Count ? PROGRAM.SETTINGS.SETTINGS_MAIN.TabsOpenTransparency : PROGRAM.SETTINGS.SETTINGS_MAIN.NoTabsTransparency
			sellUserTrans := GuiTrades.Sell.Tabs_Count ? PROGRAM.SETTINGS.SETTINGS_MAIN.TabsOpenTransparency : PROGRAM.SETTINGS.SETTINGS_MAIN.NoTabsTransparency

			GUI_Trades_V2.SetTransparencyPercent("Buy", buyUserTrans)
			GUI_Trades_V2.SetTransparencyPercent("Sell", sellUserTrans)
		}
	}




	/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	*										TAB CUSTOMIZATION SKIN												 *
	* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	*/

	TabCustomizationSkins_SetUserSettings() {
		global PROGRAM, GuiSettings, GuiSettings_Controls
		iniSettings := PROGRAM.SETTINGS.SETTINGS_CUSTOMIZATION_SKINS

		availablePresets := GUI_Settings.TabCustomizationSkins_GetAvailablePresets()
		availableSkins := GUI_Settings.TabCustomizationSkins_GetAvailableSkins()
		availableFonts := GUI_Settings.TabCustomizationSkins_GetAvailableFonts()

		GUI_Settings.TabCustomizationSkins_SetAvailablePresets(availablePresets)
		GUI_Settings.TabCustomizationSkins_SetAvailableSkins(availableSkins)
		GUI_Settings.TabCustomizationSkins_SetAvailableFonts(availableFonts)

		GUI_Settings.TabCustomizationSkins_SetPreset(iniSettings.Preset) ; This function will take care of choosing skin/font/etc based on preset
		GUI_Settings.TabCustomizationSkins_SetChangeableFontColorTypes()
	}

	TabCustomizationSkins_SetSubroutines() {
		global GuiSettings, GuiSettings_Controls
		controlsList := "hLB_SkinPreset,hLB_SkinBase,hLB_SkinFont,hCB_UseRecommendedFontSettings,hEDIT_SkinFontSize"
		. ",hUPDOWN_SkinFontSize,hEDIT_SkinFontQuality,hUPDOWN_SkinFontQuality,hEDIT_SkinScalingPercentage,hUPDOWN_SkinScalingPercentage"

		Loop, Parse, controlsList,% ","
		{
			ctrlName := A_LoopField, ctrlSplit := StrSplit(ctrlName, "_"), ctrlType := ctrlSplit.1, settingsKey := ctrlSplit.2

			if (ctrlName="hLB_SkinPreset")
				Gui.BindFunctionToControl("GUI_Settings", "Settings", ctrlName, "TabCustomizationSkins_OnPresetChange")
			if (ctrlName="hLB_SkinBase")
				Gui.BindFunctionToControl("GUI_Settings", "Settings", ctrlName, "TabCustomizationSkins_OnSkinChange")
			if (ctrlName="hLB_SkinFont")
				Gui.BindFunctionToControl("GUI_Settings", "Settings", ctrlName, "TabCustomizationSkins_OnFontChange")
			if (ctrlName="hCB_UseRecommendedFontSettings")
				Gui.BindFunctionToControl("GUI_Settings", "Settings", ctrlName, "TabCustomizationSkins_OnRecommendedFontSettingsToggle")
			if IsIn(ctrlName,"hEDIT_SkinFontSize,hUPDOWN_SkinFontSize")
				Gui.BindFunctionToControl("GUI_Settings", "Settings", ctrlName, "TabCustomizationSkins_OnFontSizeChange")
			if IsIn(ctrlName,"hEDIT_SkinFontQuality,hUPDOWN_SkinFontQuality")
				Gui.BindFunctionToControl("GUI_Settings", "Settings", ctrlName, "TabCustomizationSkins_OnFontQualityChange")
			if IsIn(ctrlName,"hEDIT_SkinScalingPercentage,hUPDOWN_SkinScalingPercentage")
				Gui.BindFunctionToControl("GUI_Settings", "Settings", ctrlName, "TabCustomizationSkins_OnScalePercentageChange")

			; TabCustomizationsSkins_OnChangeableColorTypeChange
			; TabCustomizationSkins_ShowColorPicker
			; TabCustomizationSkins_RecreateTradesGUI
		}
	}

	TabCustomizationSkins_EnableSubroutines() { ; TO_DO_V2 still needed? why not make settings:+disabled so user cant touch window at all
		Gui, Settings:-Disabled
		; GUI_Settings.TabCustomizationSkins_ToggleSubroutines("Enable")
	}

	TabCustomizationSkins_DisableSubroutines() {
		Gui, Settings:+Disabled
		; GUI_Settings.TabCustomizationSkins_ToggleSubroutines("Disable")
	}



	TabCustomizationSkins_GetSkinDefaultSettings(skinName) {
		global PROGRAM

		skinFontSettings := Ini.Get(PROGRAM.SKINS_FOLDER "\" skinName "\Settings.ini", "FONT",,1)
		skinColorSettings := Ini.Get(PROGRAM.SKINS_FOLDER "\" skinName "\Settings.ini", "COLORS",,1)

		skinDefSettings := { Skin:skinName, Font:skinFontSettings.Name, FontSize:skinFontSettings.Size
			,FontQuality:skinFontSettings.Quality, ScalingPercentage:100, UseRecommendedFontSettings:True, Colors: skinColorSettings }

		Return skinDefSettings
	}

	TabCustomizationSkins_GetPresetSettings(presetName) {
		global PROGRAM

		if (presetName = "User Defined") { ; Get settings from user ini
			userDefSettings := ObjFullyClone(PROGRAM.SETTINGS.SETTINGS_CUSTOMIZATION_SKINS_UserDefined)
			; presetSettings := {	Name: userDefSettings.Name,	Skin: userDefSettings.Skin,	Font: userDefSettings.Font,	FontSize: userDefSettings.FontSize
				; , FontQuality: userDefSettings.FontQuality, ScalingPercentage: userDefSettings.ScalingPercentage, UseRecommendedFontSettings: userDefSettings.UseRecommendedFontSettings }
			presetSettings := {}
			for iniKey, iniValue in userDefSettings
				presetSettings[iniKey] := iniValue
		}
		else { ; Get settings from fonts folder ini
			skinFontSettings := Ini.Get(PROGRAM.SKINS_FOLDER "\" presetName "\Settings.ini", "FONT",,1)
			skinColorSettings := Ini.Get(PROGRAM.SKINS_FOLDER "\" presetName "\Settings.ini", "COLORS",,1)

			presetSettings := { Name:presetName, Skin:presetName, Font:skinFontSettings.Name, FontSize:skinFontSettings.Size
				,FontQuality:skinFontSettings.Quality, ScalingPercentage:100, UseRecommendedFontSettings:True }
			for iniKey, iniValue in skinColorSettings
				presetSettings["Color_" iniKey] := iniValue
		}

		Return presetSettings
	}

	TabCustomizationSkins_GetFontRecommendedSettings(_fontName="") {
		global PROGRAM
		fontName := _fontName

		if (fontName = "")
			fontName := GUI_Settings.Submit("hLB_SkinFont")

		fontSize := INI.Get(PROGRAM.FONTS_SETTINGS_FILE, "Size", fontName,1)
		fontQuality := INI.Get(PROGRAM.FONTS_SETTINGS_FILE, "Quality", fontName,1)
		
		if !IsNum(fontSize)
			fontSize := INI.Get(PROGRAM.FONTS_SETTINGS_FILE, "Size", "Default",1)
		if !IsNum(fontQuality)
			fontQuality := INI.Get(PROGRAM.FONTS_SETTINGS_FILE, "Quality", "Default",1)

		Return {Size:fontSize,Quality:fontQuality}
	}

	TabCustomizationSkins_GetAvailablePresets() {
		global PROGRAM

		availablePresets := "User Defined|"

		Loop,% PROGRAM.SKINS_FOLDER "\*", 1, 0
		{
			if FileExist(A_LoopFileFullPath "\Assets.ini")
				availablePresets .= A_LoopFileName "|"
		}
		StringTrimRight, availablePresets, availablePresets, 1

		return availablePresets
	}

	TabCustomizationSkins_GetAvailableSkins() {
		global PROGRAM

		Loop,% PROGRAM.SKINS_FOLDER "\*", 1, 0
		{
			if FileExist(A_LoopFileFullPath "\Assets.ini")
				availableSkins .= A_LoopFileName "|"
		}
		StringTrimRight, availableSkins, availableSkins, 1

		return availableSkins
	}

	TabCustomizationSkins_GetAvailableFonts() {
		global PROGRAM

		for fontTitle, fontHandle in PROGRAM.FONTS {
			if (fontTitle != "TC_Symbols")
				availableFonts .= fontTitle "|"
		}
		StringTrimRight, availableFonts, availableFonts, 1	

		return availableFonts
	}



	TabCustomizationSkins_SetAvailablePresets(presetsList) {
		global GuiSettings_Controls
		GuiControl, Settings:,% GuiSettings_Controls.hLB_SkinPreset,% "|" presetsList
	}

	TabCustomizationSkins_SetAvailableSkins(skinsList) {
		global GuiSettings_Controls
		GuiControl, Settings:,% GuiSettings_Controls.hLB_SkinBase,% "|" skinsList	
	}

	TabCustomizationSkins_SetAvailableFonts(fontsList) {
		global GuiSettings_Controls
		GuiControl, Settings:,% GuiSettings_Controls.hLB_SkinFont,% "|" fontsList	
	}

	TabCustomizationSkins_SetChangeableFontColorTypes() {
		global GuiSettings_Controls, COLORS_TYPES

		for iniKey, typeName in COLORS_TYPES {
			if (iniKey)
				typesList .= "|" typeName
		}

		GuiControl, Settings:,% GuiSettings_Controls.hDDL_ChangeableFontColorTypes,% typesList
		GuiControl, Settings:Choose,% GuiSettings_Controls.hDDL_ChangeableFontColorTypes, 1
		GUI_Settings.TabCustomizationsSkins_OnChangeableColorTypeChange()
	}

	TabCustomizationsSkins_OnChangeableColorTypeChange() {
		global GuiSettings_Controls, COLORS_TYPES
		colType := GUI_Settings.Submit("hDDL_ChangeableFontColorTypes")

		presetSettings := GUI_Settings.TabCustomizationSkins_GetPresetSettings(GUI_Settings.Submit("hLB_SkinPreset"))
		typeShortName := GUI_Settings.Get_ColorTypeShortName_From_LongName(colType)
		GuiControl,% "Settings:+Background" presetSettings["Color_" typeShortName],% GuiSettings_Controls.hPROGRESS_ColorSquarePreview
	}

	Get_ColorTypeShortName_From_LongName(longName) {
		global COLORS_TYPES

		for sName, lName in COLORS_TYPES
			if (lName = longName)
				return sName
	}

	Get_ColorTypeLongName_From_ShortName(shortName) {
		global COLORS_TYPES
		return COLORS_TYPES[shortName]
	}

	TabCustomizationSkins_ShowColorPicker() {
		global PROGRAM, GuiSettings, GuiSettings_Controls

		colType := GUI_Settings.Submit("hDDL_ChangeableFontColorTypes")
		typeShortName := GUI_Settings.Get_ColorTypeShortName_From_LongName(colType)
		presetSettings := GUI_Settings.TabCustomizationSkins_GetPresetSettings(GUI_Settings.Submit("hLB_SkinPreset"))
		
		Colors := []
		for settingType, settingValue in presetSettings {
			if ( SubStr(settingType, 1, 6) = "Color_") && !IsIn(settingValue, colorsList) {
				colorsList := !colorsList?settingValue : colorsList "," settingValue
				Colors.Push(settingValue)
			}
		}

	    MyColor := ChooseColor(presetSettings["Color_" typeShortName], GuiSettings.Handle, , , Colors*)
		GuiControl, Settings:+Background%MyColor%,% GuiSettings_Controls.hPROGRESS_ColorSquarePreview
		if (!ErrorLevel && MyColor != presetSettings["Color_" typeShortName]) {
			GuiControl, Settings:ChooseString,% GuiSettings_Controls.hLB_SkinPreset,% "User Defined"
			PROGRAM.SETTINGS.SETTINGS_CUSTOMIZATION_SKINS_UserDefined.COLORS[typeShortName] := MyColor
			GUI_Settings.TabCustomizationSkins_SaveSettings()
			Save_LocalSettings()
		}
	}

	TabCustomizationSkins_SaveDefaultSkinSettings_To_UserDefined(skinName) {
		global PROGRAM

		if !(skinName)
			skinName := Gui_Settings.Submit(hLB_SkinBase)

		skinDefSettings := Gui_Settings.TabCustomizationSkins_GetSkinDefaultSettings(GUI_Settings.Submit("hLB_SkinBase"))
		for key, value in skinDefSettings {
			if InStr(key, "Color_") {
				PROGRAM.SETTINGS.SETTINGS_CUSTOMIZATION_SKINS_UserDefined.COLORS[key] := skinDefSettings[key]
			}
		}
		Save_LocalSettings()
	}

	TabCustomizationSkins_SaveSettings(saveAsUserDefined=False) {
		global PROGRAM
		global GuiSettings, GuiSettings_Controls, GuiSettings_Submit

		GUI_Settings.Submit()
		sub := GuiSettings_Submit

		iniSection := (saveAsUserDefined)?("SETTINGS_CUSTOMIZATION_SKINS_UserDefined"):("SETTINGS_CUSTOMIZATION_SKINS")

		PROGRAM.SETTINGS[iniSection].Preset := sub.hLB_SkinPreset
		PROGRAM.SETTINGS[iniSection].Skin := sub.hLB_SkinBase
		PROGRAM.SETTINGS[iniSection].Font := sub.hLB_SkinFont
		PROGRAM.SETTINGS[iniSection].ScalingPercentage := sub.hEDIT_SkinScalingPercentage
		PROGRAM.SETTINGS[iniSection].FontSize := sub.hEDIT_SkinFontSize
		PROGRAM.SETTINGS[iniSection].FontQuality := sub.hEDIT_SkinFontQuality
		PROGRAM.SETTINGS[iniSection].UseRecommendedFontSettings := sub.hCB_UseRecommendedFontSettings=0?"False":"True"

		if (saveAsUserDefined) {
			skinDefSettings := Gui_Settings.TabCustomizationSkins_GetSkinDefaultSettings(sub.hLB_SkinBase)
			userSkinSettings := Get_LocalSettings().SETTINGS_CUSTOMIZATION_SKINS_UserDefined
			for key, value in skinDefSettings {
				if InStr(key, "Color_") {
					presetVal := skinDefSettings[key], userVal := userSkinSettings[key]
					iniValue := IsHex(userVal) && (StrLen(userVal) = 8) ? userVal : presetVal

					PROGRAM.SETTINGS[iniSecttion][key] := iniValue
				}
			}
		}

		Save_LocalSettings()

		if (saveAsUserDefined=True)
			Return
		else if (sub.hLB_SkinPreset = "User Defined")
			GUI_Settings.TabCustomizationSkins_SaveSettings(True)
	}

	TabCustomizationSkins_SetPreset(presetName="", presetSettings="") {
		global GuiSettings, GuiSettings_Controls

		; Prevent user from switching preset while we apply current settings
		GuiSettings.Is_Changing_Preset := True
		GUI_Settings.TabCustomizationSkins_DisableSubroutines()
		GuiControl, Settings:Disable,% GuiSettings_Controls.hLB_SkinPreset

		; If no preset name specified, get current preset selected instead
		if (presetName = "")
			presetName := GUI_Settings.Submit("hLB_SkinPreset")

		; If no settings specified, get preset's settings
		if !IsObject(presetSettings) {
			presetSettings := GUI_Settings.TabCustomizationSkins_GetPresetSettings(presetName)
			for key, element in currentPresetSettings {
				if (presetSettings[key] = "")
					presetSettings[key] := element
			}
		}

		; Choose the preset and apply its settings
		GuiControl, Settings:ChooseString,% GuiSettings_Controls.hLB_SkinPreset,% presetName
		GUI_Settings.TabCustomizationSkins_SetSkin(presetSettings.Skin)
		GUI_Settings.TabCustomizationSkins_SetFont(presetSettings.Font)
		GUI_Settings.TabCustomizationSkins_SetFontSizeAndQuality(presetSettings.FontSize, presetSettings.FontQuality)
		GUI_Settings.TabCustomizationSkins_SetScalePercentage(presetSettings.ScalingPercentage)
		GUI_Settings.TabCustomizationSkins_SetRecommendedFontSettings(presetSettings.UseRecommendedFontSettings)
		GUI_Settings.TabCustomizationSkins_SetChangeableFontColorTypes()

		; Done applying settings
		; Sleep 100 ; Slight sleep to prevent subroutine from detecting IsChangingPreset change
		GUI_Settings.TabCustomizationSkins_EnableSubroutines()
		GuiControl, Settings:Enable,% GuiSettings_Controls["hLB_SkinPreset"]
		GuiControl, Settings:Focus,% GuiSettings_Controls["hLB_SkinPreset"]
		
		; Save newly applied settings
		GUI_Settings.TabCustomizationSkins_SaveSettings()
		GuiSettings.Is_Changing_Preset := False
	}

	TabCustomizationSkins_SetSkin(skinName) {
		global PROGRAM, GuiSettings, GuiSettings_Controls
		GuiControl, Settings:ChooseString,% GuiSettings_Controls.hLB_SkinBase,% skinName
	}

	TabCustomizationSkins_SetFont(fontName) {
		global PROGRAM, GuiSettings, GuiSettings_Controls
		GuiControl, Settings:ChooseString,% GuiSettings_Controls.hLB_SkinFont,% fontName
		GUI_Settings.TabCustomizationSkins_SetFontSettingsState(GUI_Settings.Submit("hCB_UseRecommendedFontSettings"))
	}

	TabCustomizationSkins_SetFontSizeAndQuality(fontSize, fontQual) {
		global PROGRAM, GuiSettings, GuiSettings_Controls
		GuiControl, Settings:,% GuiSettings_Controls.hEDIT_SkinFontSize,% fontSize
		GuiControl, Settings:,% GuiSettings_Controls.hEDIT_SkinFontQuality,% fontQual
	}

	TabCustomizationSkins_SetRecommendedFontSettings(checkState) {
		global PROGRAM, GuiSettings, GuiSettings_Controls
		checkState := checkState="True"?1 : checkState="False"?0 : checkState
		GuiControl, Settings:,% GuiSettings_Controls.hCB_UseRecommendedFontSettings,% checkState
		GUI_Settings.TabCustomizationSkins_SetFontSettingsState(GUI_Settings.Submit("hCB_UseRecommendedFontSettings"))
	}

	TabCustomizationSkins_SetScalePercentage(scalePercentage) {
		global PROGRAM, GuiSettings, GuiSettings_Controls
		GuiControl, Settings:,% GuiSettings_Controls.hEDIT_SkinScalingPercentage,% scalePercentage
	}

	TabCustomizationSkins_SetFontSettingsState(state) {
		global PROGRAM, GuiSettings_Controls 

		enableOrDisable := (state=1 || state = "Disable")?("Disable")
		: (state=0 || state = "Enable")?("Enable")
		: ("")

		if (state = "") {
			MsgBox(4096, "", "Invalid usage of " A_ThisFunc "`nParam: " state "`nenableOrDisable: " enableOrDisable)
			Return
		}

		GuiControl, Settings:%enableOrDisable%,% GuiSettings_Controls.hEDIT_SkinFontSize
		GuiControl, Settings:%enableOrDisable%,% GuiSettings_Controls.hEDIT_SkinFontQuality
		GuiControl, Settings:%enableOrDisable%,% GuiSettings_Controls.hUPDOWN_SkinFontSize
		GuiControl, Settings:%enableOrDisable%,% GuiSettings_Controls.hUPDOWN_SkinFontQuality

		if (state = "Disable") {
			selectedFont := GUI_Settings.Submit("hLB_SkinFont")
			fontSettings := GUI_Settings.TabCustomizationSkins_GetFontRecommendedSettings(selectedFont)
			GUI_Settings.TabCustomizationSkins_SetFontSizeAndQuality(selectedFont.Size, selectedFont.Quality)
		}
	}

	TabCustomizationSkins_RecreateTradesGUI() {
		global PROGRAM

		TrayNotifications.Show(PROGRAM.TRANSLATIONS.TrayNotifications.RecreatingTradesWindow_Title, PROGRAM.TRANSLATIONS.TrayNotifications.RecreatingTradesWindow_Msg)
		UpdateHotkeys()
		Declare_SkinAssetsAndSettings()
		; Gui_TradesMinimized.Create()
		GUI_Trades_V2.RecreateGUI("Buy")
		GUI_Trades_V2.RecreateGUI("Sell")
	}



	TabCustomizationSkins_OnFontChange() {
		global PROGRAM, GuiSettings, GuiSettings_Controls

		if (GuiSettings.Is_Changing_Preset)
			Return

		selectedFont := GUI_Settings.Submit("hLB_SkinFont")
		GuiControl, Settings:ChooseString,% GuiSettings_Controls.hLB_SkinPreset,% "User Defined"

		fontSettings := GUI_Settings.TabCustomizationSkins_GetFontRecommendedSettings(selectedFont)
		GUI_Settings.TabCustomizationSkins_SetFontSizeAndQuality(fontSettings.Size, fontSettings.Quality)
		GUI_Settings.TabCustomizationSkins_SetFontSettingsState(GUI_Settings.Submit("hCB_UseRecommendedFontSettings"))

		GUI_Settings.TabCustomizationSkins_SaveSettings()
	}

	TabCustomizationSkins_OnSkinChange() {
		global PROGRAM, GuiSettings, GuiSettings_Controls

		if (GuiSettings.Is_Changing_Preset)
			Return

		GuiControl, Settings:ChooseString,% GuiSettings_Controls.hLB_SkinPreset,% "User Defined"

		GUI_Settings.TabCustomizationSkins_SaveDefaultSkinSettings_To_UserDefined(GUI_Settings.Submit("hLB_SkinBase"))
		GUI_Settings.TabCustomizationSkins_SaveSettings()
		GUI_Settings.TabCustomizationSkins_SetChangeableFontColorTypes()
	}

	TabCustomizationSkins_OnPresetChange() {
		global PROGRAM, GuiSettings, GuiSettings_Controls

		if (GuiSettings.Is_Changing_Preset)
			Return

		selectedPreset := GUI_Settings.Submit("hLB_SkinPreset")
		GUI_Settings.TabCustomizationSkins_SetPreset(selectedPreset)
		GUI_Settings.TabCustomizationSkins_SaveSettings()
	}

	TabCustomizationSkins_OnScalePercentageChange() {
		global PROGRAM, GuiSettings, GuiSettings_Controls

		if (GuiSettings.Is_Changing_Preset)
			Return

		KeyWait, LButton, U
		SetTimer, GUI_Settings_TabCustomizationSkins_OnScalePercentageChange_Sub, -500

		; scalePercent := GUI_Settings.Submit("hEDIT_SkinScalingPercentage")
		; GuiControl, Settings:ChooseString,% GuiSettings_Controls.hLB_SkinPreset,% "User Defined"

		; GUI_Settings.TabCustomizationSkins_SaveSettings()
	}

	TabCustomizationSkins_OnFontQualityChange() {
		global PROGRAM, GuiSettings, GuiSettings_Controls

		if (GuiSettings.Is_Changing_Preset)
			Return

		; fontQual := GUI_Settings.Submit("hEDIT_SkinFontQuality")
		GuiControl, Settings:ChooseString,% GuiSettings_Controls.hLB_SkinPreset,% "User Defined"
		GUI_Settings.TabCustomizationSkins_SetFontSettingsState(GUI_Settings.Submit("hCB_UseRecommendedFontSettings"))

		GUI_Settings.TabCustomizationSkins_SaveSettings()
	}

	TabCustomizationSkins_OnFontSizeChange() {
		global PROGRAM, GuiSettings, GuiSettings_Controls

		if (GuiSettings.Is_Changing_Preset)
			Return

		; fontSize := GUI_Settings.Submit("hEDIT_SkinFontSize")
		GuiControl, Settings:ChooseString,% GuiSettings_Controls.hLB_SkinPreset,% "User Defined"
		GUI_Settings.TabCustomizationSkins_SetFontSettingsState(GUI_Settings.Submit("hCB_UseRecommendedFontSettings"))

		GUI_Settings.TabCustomizationSkins_SaveSettings()

	}

	TabCustomizationSkins_OnRecommendedFontSettingsToggle() {
		global PROGRAM, GuiSettings, GuiSettings_Controls

		if (GuiSettings.Is_Changing_Preset)
			Return

		; cbState := GUI_Settings.Submit("hCB_UseRecommendedFontSettings")
		GuiControl, Settings:ChooseString,% GuiSettings_Controls.hLB_SkinPreset,% "User Defined"
		GUI_Settings.TabCustomizationSkins_SetFontSettingsState(GUI_Settings.Submit("hCB_UseRecommendedFontSettings"))

		GUI_Settings.TabCustomizationSkins_SaveSettings()
	}


	

	/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	*										TAB CUSTOMIZATION BUYING SELLING									 *
	* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	*/

	TabCustomizationBuying_SetSubroutines() {
		Loop 4 {
			Gui.BindFunctionToControl("GUI_Settings", "Settings", "hBTN_CustomizationBuyingButtonMinusRow" A_Index, "Customization_Buying_RemoveOneButtonFromRow", A_Index, skipCreateStyle:=False)
			Gui.BindFunctionToControl("GUI_Settings", "Settings", "hBTN_CustomizationBuyingButtonPlusRow" A_Index, "Customization_Buying_AddOneButtonToRow", A_Index, skipCreateStyle:=False, dontActivateButton:=False)
		}
		Gui.BindFunctionToControl("GUI_Settings", "Settings", "hDDL_CustomizationBuyingButtonType", "Customization_Buying_OnButtonTypeChange") 
		Gui.BindFunctionToControl("GUI_Settings", "Settings", "hEDIT_CustomizationBuyingButtonName", "Customization_Buying_OnButtonNameChange") 
		Gui.BindFunctionToControl("GUI_Settings", "Settings", "hDDL_CustomizationBuyingButtonIcon", "Customization_Buying_OnButtonIconChange") 
		Gui.BindFunctionToControl("GUI_Settings", "Settings", "hDDL_CustomizationBuyingActionType", "Customization_Buying_OnActionTypeChange") 
		Gui.BindFunctionToControl("GUI_Settings", "Settings", "hEDIT_CustomizationBuyingActionContent", "Customization_Buying_OnActionContentChange", doAgainAfter500ms:=True) 
		Gui.BindFunctionToControl("GUI_Settings", "Settings", "hLV_CustomizationBuyingActionsList", "Customization_Buying_OnListviewClick") 
	}

	TabCustomizationSelling_SetSubroutines() {
		Loop 4 {
			Gui.BindFunctionToControl("GUI_Settings", "Settings", "hBTN_CustomizationSellingButtonMinusRow" A_Index, "Customization_Selling_RemoveOneButtonFromRow", A_Index, skipCreateStyle:=False)
			Gui.BindFunctionToControl("GUI_Settings", "Settings", "hBTN_CustomizationSellingButtonPlusRow" A_Index, "Customization_Selling_AddOneButtonToRow", A_Index, skipCreateStyle:=False, dontActivateButton:=False)
		}
		Gui.BindFunctionToControl("GUI_Settings", "Settings", "hDDL_CustomizationSellingButtonType", "Customization_Selling_OnButtonTypeChange") 
		Gui.BindFunctionToControl("GUI_Settings", "Settings", "hEDIT_CustomizationSellingButtonName", "Customization_Selling_OnButtonNameChange") 
		Gui.BindFunctionToControl("GUI_Settings", "Settings", "hDDL_CustomizationSellingButtonIcon", "Customization_Selling_OnButtonIconChange") 
		Gui.BindFunctionToControl("GUI_Settings", "Settings", "hDDL_CustomizationSellingActionType", "Customization_Selling_OnActionTypeChange") 
		Gui.BindFunctionToControl("GUI_Settings", "Settings", "hEDIT_CustomizationSellingActionContent", "Customization_Selling_OnActionContentChange", doAgainAfter500ms:=True) 
		Gui.BindFunctionToControl("GUI_Settings", "Settings", "hLV_CustomizationSellingActionsList", "Customization_Selling_OnListviewClick") 
	}

	Customization_SellingBuying_AddOneButtonToRow(whichTab, rowNum, skipCreateStyle=False, dontActivateButton=False) {
		global PROGRAM, GuiTrades, GuiSettings, GuiSettings_Controls
		_buyOrSell := whichTab="Selling"?"Sell":"Buy", _buyOrSell .= "Preview"
		GuiTrades[_buyOrSell]["PreviewRow" rowNum "_Count"] := GuiTrades[_buyOrSell]["PreviewRow" rowNum "_Count"]?GuiTrades[_buyOrSell]["PreviewRow" rowNum "_Count"]:0
		btnsCount := GuiTrades[_buyOrSell]["PreviewRow" rowNum "_Count"]
		guiIniSection := whichTab="Selling"?"SELL_INTERFACE":"BUY_INTERFACE"
		guiName := "Trades" _buyOrSell "_Slot1"
		
		if ( IsBetween(rowNum, 1, 3) && (btnsCount=10) )
		|| ( (rowNum=4) && (btnsCount=5))
			return

		GuiTrades[_buyOrSell]["PreviewRow" rowNum "_Count"]++ ; new var for buy sell TO_DO
		newBtnsCount := GuiTrades[_buyOrSell]["PreviewRow" rowNum "_Count"]
		PROGRAM.SETTINGS[guiIniSection]["CUSTOM_BUTTON_ROW_" rowNum].Buttons_Count := newBtnsCount
		Save_LocalSettings()

		if (!btnsCount) {
			; Hiding the row button
			GuiControl, %guiName%:Hide,% GuiTrades[_buyOrSell]["Slot1_Controls"]["hBTN_CustomRowSlot" rowNum]
			; Defaulting to show 1 buttons
			GuiSettings.CUSTOM_BUTTON_SELECTED_NUM := GuiSettings.CUSTOM_BUTTON_SELECTED_NUM?GuiSettings.CUSTOM_BUTTON_SELECTED_NUM:1
		}

		Loop % btnsCount ; Hiding previous buttons
			GuiControl, %guiName%:Hide,% GuiTrades[_buyOrSell]["Slot1_Controls"]["hBTN_CustomButtonRow" rowNum "Max" btnsCount "Num" A_Index]
		Loop % newBtnsCount { ; Showing new ones
			btnNum := A_Index, btnHwnd := GuiTrades[_buyOrSell]["Slot1_Controls"]["hBTN_CustomButtonRow" rowNum "Max" newBtnsCount "Num" btnNum]
			btnName := PROGRAM.SETTINGS[guiIniSection]["CUSTOM_BUTTON_ROW_" rowNum][btnNum].Text
			btnIcon := PROGRAM.SETTINGS[guiIniSection]["CUSTOM_BUTTON_ROW_" rowNum][btnNum].Icon
			styleName := "CustomButton_" _buyOrSell "_Row" rowNum "Max" newBtnsCount, styleName .= btnIcon ? "_Icon_" btnIcon : "_Text"
			if !IsObject(GuiTrades.Styles[styleName]) && (skipCreateStyle=False) {
				style%styleName%DidntExist := True
				GUI_Trades_V2.CreateGenericStyleAndUpdateButton(btnHwnd, btnIcon?"Icon":"Text", GuiTrades.Styles, styleName, btnIcon?btnIcon:btnName)
			}
			if (style%styleName%DidntExist && btnIcon)
				Gui.ImageButtonUpdate(btnHwnd, GuiTrades.Styles[styleName], PROGRAM.FONTS[GuiTrades[_buyOrSell].Font], GuiTrades[_buyOrSell].Font_Size)
			else if (style%styleName%DidntExist && btnName)
				Gui.ImageButtonChangeCaption(btnHwnd, btnName, GuiTrades.Styles[styleName], PROGRAM.FONTS[GuiTrades[_buyOrSell].Font], GuiTrades[_buyOrSell].Font_Size)
			else if (style%styleName%DidntExist && !btnIcon && !btnName)
				Gui.ImageButtonChangeCaption(btnHwnd, "", GuiTrades.Styles[styleName], PROGRAM.FONTS[GuiTrades[_buyOrSell].Font], GuiTrades[_buyOrSell].Font_Size)
				
			GuiControl, %guiName%:Show,% btnHwnd
		}

		; Make sure new button is chosen
		if IsNum(rowNum) && IsNum(newBtnsCount) && (dontActivateButton=False)
			GUI_Trades_V2.Preview_CustomizeThisCustomButton(_buyOrSell, rowNum, newBtnsCount, GuiSettings.CUSTOM_BUTTON_SELECTED_NUM)
	}
	
	Customization_SellingBuying_RemoveOneButtonFromRow(whichTab, rowNum, skipCreateStyle=False) {
		global PROGRAM, GuiTrades, GuiSettings, GuiSettings_Controls
		_buyOrSell := whichTab="Selling"?"Sell":"Buy", _buyOrSell .= "Preview"
		GuiTrades[_buyOrSell]["PreviewRow" rowNum "_Count"] := GuiTrades[_buyOrSell]["PreviewRow" rowNum "_Count"]?GuiTrades[_buyOrSell]["PreviewRow" rowNum "_Count"]:0
		btnsCount := GuiTrades[_buyOrSell]["PreviewRow" rowNum "_Count"]
		guiIniSection := whichTab="Selling"?"SELL_INTERFACE":"BUY_INTERFACE"
		guiName := "Trades" _buyOrSell "_Slot1"
		
		if (!btnsCount)
			return

		GuiTrades[_buyOrSell]["PreviewRow" rowNum "_Count"]--
		newBtnsCount := GuiTrades[_buyOrSell]["PreviewRow" rowNum "_Count"]
		PROGRAM.SETTINGS[guiIniSection]["CUSTOM_BUTTON_ROW_" rowNum].Buttons_Count := newBtnsCount
		Save_LocalSettings()

		Loop % btnsCount ; Hiding previous buttons, skipCreateStyle=False
			GuiControl, %guiName%:Hide,% GuiTrades[_buyOrSell]["Slot1_Controls"]["hBTN_CustomButtonRow" rowNum "Max" btnsCount "Num" A_Index]

		if (btnsCount=1) ; Show the row button bcs no buttons left
			GuiControl, %guiName%:Show,% GuiTrades[_buyOrSell]["Slot1_Controls"]["hBTN_CustomRowSlot" rowNum]
		else { ; Show new buttons
			Loop % newBtnsCount {
				btnNum := A_Index, btnHwnd := GuiTrades[_buyOrSell]["Slot1_Controls"]["hBTN_CustomButtonRow" rowNum "Max" newBtnsCount "Num" btnNum]
				btnName := PROGRAM.SETTINGS[guiIniSection]["CUSTOM_BUTTON_ROW_" rowNum][btnNum].Text
				btnIcon := PROGRAM.SETTINGS[guiIniSection]["CUSTOM_BUTTON_ROW_" rowNum][btnNum].Icon
				styleName := "CustomButton_" _buyOrSell "_Row" rowNum "Max" newBtnsCount, styleName .= btnIcon ? "_Icon_" btnIcon : "_Text"

				if !IsObject(GuiTrades.Styles[styleName]) && (skipCreateStyle=False) {
					style%styleName%DidntExist := True
					GUI_Trades_V2.CreateGenericStyleAndUpdateButton(btnHwnd, btnIcon?"Icon":"Text", GuiTrades.Styles, styleName, btnIcon?btnIcon:btnName)
				}
				if (style%styleName%DidntExist && btnIcon)
					Gui.ImageButtonUpdate(btnHwnd, GuiTrades.Styles[styleName], PROGRAM.FONTS[GuiTrades[_buyOrSell].Font], GuiTrades[_buyOrSell].Font_Size)
				else if (style%styleName%DidntExist && btnName)
					Gui.ImageButtonChangeCaption(btnHwnd, btnName, GuiTrades.Styles[styleName], PROGRAM.FONTS[GuiTrades[_buyOrSell].Font], GuiTrades[_buyOrSell].Font_Size)
				else if (style%styleName%DidntExist && !btnIcon && !btnName)
					Gui.ImageButtonChangeCaption(btnHwnd, "", GuiTrades.Styles[styleName], PROGRAM.FONTS[GuiTrades[_buyOrSell].Font], GuiTrades[_buyOrSell].Font_Size)

				GuiControl, %guiName%:Show,% btnHwnd
			}
		}

		; Make sure new button is chosen
		if (newBtnsCount >= GuiSettings.CUSTOM_BUTTON_SELECTED_NUM) && IsNum(rowNum) && IsNum(newBtnsCount) && (newBtnsCount > 0) { ; We can still choose same one, bcs num still exists
			GUI_Trades_V2.Preview_CustomizeThisCustomButton(_buyOrSell, rowNum, newBtnsCount, GuiSettings.CUSTOM_BUTTON_SELECTED_NUM)
		}
		else ; Choose last button, bcs our button doesn't exist anymore
			if IsNum(rowNum) && IsNum(newBtnsCount) && (newBtnsCount > 0)
				GUI_Trades_V2.Preview_CustomizeThisCustomButton(_buyOrSell, rowNum, newBtnsCount, newBtnsCount)
				
	}

	Customization_SellingBuying_SetPreviewPreferences(whichTab) {
		global PROGRAM, GuiTrades, GuiTrades_Controls, GuiSettings, GuiSettings_Controls
		_buyOrSell := whichTab="Selling"?"Sell":"Buy", _buyOrSell .= "Preview"
		guiIniSection := whichTab="Selling"?"SELL_INTERFACE":"BUY_INTERFACE"

		Loop 4 {
			rowNum := A_Index
			buttonsCount := PROGRAM.SETTINGS[guiIniSection]["CUSTOM_BUTTON_ROW_" rowNum].Buttons_Count
			Loop % buttonsCount {
				/*
				; if (A_Index = buttonsCount)
				; GUI_Settings.Customization_SellingBuying_AddOneButtonToRow(whichTab, rowNum, skipCreateStyle:=False, dontActivateButton:=True)
				*/
				GUI_Settings.Customization_SellingBuying_AddOneButtonToRow(whichTab, rowNum, skipCreateStyle:=True, dontActivateButton:=True)
			}
		}

		; Try to select the first existing button
		Loop 4 {
			if (PROGRAM.SETTINGS[guiIniSection]["CUSTOM_BUTTON_ROW_" A_Index].Buttons_Count) {
				GUI_Trades_V2.Preview_CustomizeThisCustomButton(_buyOrSell, A_Index, PROGRAM.SETTINGS[guiIniSection]["CUSTOM_BUTTON_ROW_" A_Index].Buttons_Count, 1)
				hasExistingButtons := True
				Break
			}
		}
		; Select the first row button if failure
		if (!hasExistingButtons)
			GUI_Trades_V2.Preview_CustomizeThisCustomButton(_buyOrSell, 1, 1, 1)
	}

	Customization_SellingBuying_AdjustPreviewControls(whichTab) {
		global GuiTrades, GuiSettings_Controls
		_buyOrSell := whichTab="Selling"?"Sell":"Buy", _buyOrSell .= "Preview"
		Loop 4 {
			rowIndex := A_Index
			rowPos := ControlGetPos(GuiTrades[_buyOrSell]["Slot1_Controls"]["hBTN_CustomRowSlot" rowIndex])
			btnPos := ControlGetPos(GuiSettings_Controls["hBTN_Customization" whichTab "ButtonPlusRow" rowIndex])
			guiPos := ControlGetPos(GuiTrades[_buyOrSell].Handle)

			if (rowPos.X && btnPos.X) {
				minusX := guiPos.X+guiPos.W, plusX := minusX+btnPos.W, plusY := minusY := rowPos.Y
				GuiControl, Settings:Move,% GuiSettings_Controls["hBTN_Customization" whichTab "ButtonPlusRow" rowIndex],% "x" plusX " y" plusY
				GuiControl, Settings:Move,% GuiSettings_Controls["hBTN_Customization" whichTab "ButtonMinusRow" rowIndex],% "x" minusX " y" minusY
			}
		}
	}

	Customization_SellingBuying_LoadButtonSettings(whichTab, rowNum, btnNum) {
		global PROGRAM, GuiSettings
		guiIniSection := whichTab="Selling"?"SELL_INTERFACE":"BUY_INTERFACE"
		btnSettings := ObjFullyClone(PROGRAM.SETTINGS[guiIniSection]["CUSTOM_BUTTON_ROW_" rowNum][btnNum])

		if (btnSettings.Text) {
			GUI_Settings.Customization_SellingBuying_ShowButtonNameControl(whichTab)
			GUI_Settings.Customization_SellingBuying_SetButtonType(whichTab, "Text", noTrigger:=True)
			GUI_Settings.Customization_SellingBuying_SetButtonName(whichTab, btnSettings.Text, noTrigger:=True)
		}
		else if (btnSettings.Icon) {
			GUI_Settings.Customization_SellingBuying_ShowButtonIconControl(whichTab)
			GUI_Settings.Customization_SellingBuying_SetButtonType(whichTab, "Icon", noTrigger:=True)
			GUI_Settings.Customization_SellingBuying_SeztButtonIcon(whichTab, btnSettings.Icon, noTrigger:=True)
		}

		GUI_Settings.Customization_SellingBuying_LoadButtonActions(whichTab, rowNum, btnNum)
	}

	Customization_SellingBuying_LoadButtonActions(whichTab, rowNum, btnNum) {
		return GUI_Settings.Universal_LoadActionsIntoListview(whichTab, rowNum, btnNum)
	}

	Customization_SellingBuying_SaveAllCurrentButtonActions(whichTab, isTimedSave=False) {
		return GUI_Settings.Universal_SaveAllActions(whichTab, isTimedSave)
	}

	Customization_SellingBuying_SetButtonType(whichTab, btnType, dontTriggerOnChange=False) {
		global GuiSettings_Controls
		GuiControl, Settings:ChooseString,% GuiSettings_Controls["hDDL_Customization" whichTab "ButtonType"],% btnType
		if (dontTriggerOnChange=False)
			GUI_Settings.Customization_SellingBuying_OnButtonTypeChange(whichTab)
	}

	Customization_SellingBuying_ShowButtonNameControl(whichTab) {
		global GuiSettings_Controls
		GuiControl, Settings:Show,% GuiSettings_Controls["hEDIT_Customization" whichTab "ButtonName"]
		GuiControl, Settings:Hide,% GuiSettings_Controls["hDDL_Customization" whichTab "ButtonIcon"]
	}

	Customization_SellingBuying_ShowButtonIconControl(whichTab) {
		global GuiSettings_Controls
		GuiControl, Settings:Show,% GuiSettings_Controls["hDDL_Customization" whichTab "ButtonIcon"]
		GuiControl, Settings:Hide,% GuiSettings_Controls["hEDIT_Customization" whichTab "ButtonName"]
	}

	Customization_SellingBuying_OnButtonTypeChange(whichTab) {
		global PROGRAM
		global GuiTrades, GuiSettings, GuiSettings_Controls
		ddlHwnd := GuiSettings_Controls["hDDL_Customization" whichTab "ButtonType"]
		ddlContent := GUI_Settings.Submit("hDDL_Customization" whichTab "ButtonType")

		if (ddlContent = "Text") {
			GUI_Settings.Customization_SellingBuying_ShowButtonNameControl(whichTab)
			GUI_Settings.Customization_SellingBuying_OnButtonNameChange(whichTab)
		}
		else if (ddlContent = "Icon") {
			GUI_Settings.Customization_SellingBuying_ShowButtonIconControl(whichTab)
			GUI_Settings.Customization_SellingBuying_OnButtonIconChange(whichTab)
		}
		else {
			MsgBox Something has gone wrong.`nCustomization_SellingBuying_OnButtonTypeChange`n%ddlContent%
		}
	}

	Customization_SellingBuying_SetButtonIcon(whichTab, btnIcon, dontTriggerOnChange=False) {
		global GuiSettings_Controls
		GuiControl, Settings:ChooseString,% GuiSettings_Controls["hDDL_Customization" whichTab "ButtonIcon"],% btnIcon
		if (dontTriggerOnChange=False)
			GUI_Settings.Customization_SellingBuying_OnButtonIconChange(whichTab)
	}

	Customization_SellingBuying_OnButtonIconChange(whichTab) {
		global PROGRAM
		global GuiTrades, GuiSettings, GuiSettings_Controls
		_buyOrSell := whichTab="Selling"?"Sell":"Buy", _buyOrSell .= "Preview"
		ddlHwnd := GuiSettings_Controls["hDDL_Customization" whichTab "ButtonIcon"]
		ddlContent := GUI_Settings.Submit("hDDL_Customization" whichTab "ButtonIcon")
		guiIniSection := whichTab="Selling"?"SELL_INTERFACE":"BUY_INTERFACE"

		; Getting activated button variables
		rowNum := GuiSettings.CUSTOM_BUTTON_SELECTED_ROW
		btnsCount := GuiSettings.CUSTOM_BUTTON_SELECTED_MAX
		btnNum := GuiSettings.CUSTOM_BUTTON_SELECTED_NUM
		; Couldnt save notification
		if (!rowNum || !btnsCount || !btnNum) {
			TrayNotifications.Show("", "COULDN'T SAVE BUTTON NAME"
			. "`nRow: " rowNum
			. "`nCount: " btnsCount
			. "`nNum: " btnNum
			. "`nTab: " whichTab)
			return
		}

		if !IsObject(PROGRAM.SETTINGS[guiIniSection]["CUSTOM_BUTTON_ROW_" rowNum][btnNum])
			PROGRAM.SETTINGS[guiIniSection]["CUSTOM_BUTTON_ROW_" rowNum][btnNum] := {}
		PROGRAM.SETTINGS[guiIniSection]["CUSTOM_BUTTON_ROW_" rowNum][btnNum].Icon := ddlContent
		PROGRAM.SETTINGS[guiIniSection]["CUSTOM_BUTTON_ROW_" rowNum][btnNum].Delete("Text")
		Save_LocalSettings()

		btnMax := IsBetween(rowNum, 1, 3) ? 10 : rowNum=4 ? 5 : 0
		Loop % btnMax {
			if (btnNum <= A_Index) { ; Otherwise it can't exist, eg: Num3 can't exist if Max2
				btnMax := A_Index, btnHwnd := GuiTrades[_buyOrSell]["Slot1_Controls"]["hBTN_CustomButtonRow" rowNum "Max" btnMax "Num" btnNum]
				btnIcon := ddlContent
				styleName := "CustomButton_" _buyOrSell "_Row" rowNum "Max" btnMax, styleName .= "_Icon_" btnIcon
				if !IsObject(GuiTrades.Styles[styleName]) 
					GUI_Trades_V2.CreateGenericStyleAndUpdateButton(btnHwnd, "Icon", GuiTrades.Styles, styleName, btnIcon)
				else
					Gui.ImageButtonUpdate(btnHwnd, GuiTrades.Styles[styleName], PROGRAM.FONTS[GuiTrades[_buyOrSell].Font], GuiTrades[_buyOrSell].Font_Size)
			}
		}
	}

	Customization_SellingBuying_OnButtonNameChange(whichTab) {
		global PROGRAM
		global GuiTrades, GuiSettings, GuiSettings_Controls
		_buyOrSell := whichTab="Selling"?"Sell":"Buy", _buyOrSell .= "Preview"
		editBoxHwnd := GuiSettings_Controls["hEDIT_Customization" whichTab "ButtonName"]
		editBoxContent := GUI_Settings.Submit("hEDIT_Customization" whichTab "ButtonName")
		guiIniSection := whichTab="Selling"?"SELL_INTERFACE":"BUY_INTERFACE"

		; Getting activated button variables
		rowNum := GuiSettings.CUSTOM_BUTTON_SELECTED_ROW
		btnsCount := GuiSettings.CUSTOM_BUTTON_SELECTED_MAX
		btnNum := GuiSettings.CUSTOM_BUTTON_SELECTED_NUM
		; Couldnt save notification
		if (!rowNum || !btnsCount || !btnNum) {
			TrayNotifications.Show("", "COULDN'T SAVE BUTTON NAME"
			. "`nRow: " rowNum
			. "`nCount: " btnsCount
			. "`nNum: " btnNum
			. "`nTab: " whichTab)
			return
		}

		if !IsObject(PROGRAM.SETTINGS[guiIniSection]["CUSTOM_BUTTON_ROW_" rowNum][btnNum])
			PROGRAM.SETTINGS[guiIniSection]["CUSTOM_BUTTON_ROW_" rowNum][btnNum] := {}
		PROGRAM.SETTINGS[guiIniSection]["CUSTOM_BUTTON_ROW_" rowNum][btnNum].Text := editBoxContent
		PROGRAM.SETTINGS[guiIniSection]["CUSTOM_BUTTON_ROW_" rowNum][btnNum].Delete("Icon")
		Save_LocalSettings()

		btnMax := IsBetween(rowNum, 1, 3) ? 10 : rowNum=4 ? 5 : 0
		Loop % btnMax {
			if (btnNum <= A_Index) { ; Otherwise it can't exist, eg: Num3 can't exist if Max2
				btnMax := A_Index, btnHwnd := GuiTrades[_buyOrSell]["Slot1_Controls"]["hBTN_CustomButtonRow" rowNum "Max" btnMax "Num" btnNum]
				btnName := editBoxContent
				styleName := "CustomButton_" _buyOrSell "_Row" rowNum "Max" btnMax, styleName .= "_Text"
				if !IsObject(GuiTrades.Styles[styleName])
					GUI_Trades_V2.CreateGenericStyleAndUpdateButton(btnHwnd, "Text", GuiTrades.Styles, styleName, btnName)
				else
					Gui.ImageButtonChangeCaption(btnHwnd, btnName, GuiTrades.Styles[styleName], PROGRAM.FONTS[GuiTrades[_buyOrSell].Font], GuiTrades[_buyOrSell].Font_Size)
			}
		}
	}

	Customization_SellingBuying_SetButtonName(whichTab, btnName, dontTriggerOnChange=False) {
		global GuiSettings_Controls
		if (dontTriggerOnChange=True)
			Gui.DisableControlFunction("GUI_Settings", "Settings", "hEDIT_Customization" whichTab "ButtonName")

		GuiControl, Settings:,% GuiSettings_Controls["hEDIT_Customization" whichTab "ButtonName"],% btnName
		
		if (dontTriggerOnChange=False)
			GUI_Settings.Customization_SellingBuying_OnButtonNameChange()
		else
			Gui.EnableControlFunction("GUI_Settings", "Settings", "hEDIT_Customization" whichTab "ButtonName")
	}

	Customization_SellingBuying_OnActionTypeChange(whichTab) {
		return GUI_Settings.Universal_OnActionTypeChange(whichTab)
	}
	
	Customization_SellingBuying_OnActionContentChange(whichTab, doAgainAfter500ms=False) {
		return GUI_Settings.Universal_OnActionContentChange(whichTab, doAgainAfter500ms)
	}

	Customization_SellingBuying_ListViewModifySelectedAction(whichTab, actionType="", actionContent="") {
		return GUI_Settings.Universal_ListViewModifySelectedAction(whichTab, actionType, actionContent)
	}

	Customization_SellingBuying_OnListviewRightClick(whichTab) {
		return GUI_Settings.Universal_OnListviewRightClick(whichTab)
	}

	Customization_SellingBuying_MoveActionUp(whichTab, rowNum) {
		return GUI_Settings.Universal_MoveActionUp(whichTab, rowNum)
	}

	Customization_SellingBuying_MoveActionDown(whichTab, rowNum) {
		return GUI_Settings.Universal_MoveActionDown(whichTab, rowNum)
	}

	Customization_SellingBuying_GetListviewSelectedRow(whichTab) {
		return GUI_Settings.Universal_GetListviewSelectedRow(whichTab)
	}

	Customization_SellingBuying_RemoveAction(whichTab, actionNum) {
		return GUI_Settings.Universal_RemoveAction(whichTab, actionNum)
	}

	Customization_SellingBuying_GetListViewContent(whichTab) {
		return GUI_Settings.Universal_GetListViewContent(whichTab)
	}

	Customization_SellingBuying_AddNewAction(whichTab, actionType, actionContent) {
		return GUI_Settings.Universal_AddNewAction(whichTab, actionType, actionContent)
	}

	Customization_SellingBuying_AdjustListviewHeaders(whichTab) {
		return GUI_Settings.Universal_AdjustListviewHeaders(whichTab)
	}

	Customization_SellingBuying_OnListviewClick(whichTab, params*) {
		return GUI_Settings.Universal_OnListviewClick(whichTab, params*)
	}

	Customization_SellingBuying_SetActionType(whichTab, actionType) {
		return GUI_Settings.Universal_SetActionType(whichTab, actionType)
	}

	Customization_SellingBuying_SetActionContent(whichTab, actionContent) {
		return GUI_Settings.Universal_SetActionContent(whichTab, actionContent)
	}

	Customization_SellingBuying_SelectListviewRow(whichTab, rowNum) {
		return GUI_Settings.Universal_SelectListViewRow(whichTab, rowNum)
	}

	Customization_Buying_SelectListviewRow(params*) {
		return GUI_Settings.Customization_SellingBuying_SelectListviewRow("Buying", params*)
	}
	Customization_Selling_SelectListviewRow(params*) {
		return GUI_Settings.Customization_SellingBuying_SelectListviewRow("Selling", params*)
	}
	Customization_Selling_SetActionType(params*) {
		return GUI_Settings.Customization_SellingBuying_SetActionType("Selling", params*)
	}
	Customization_Buying_SetActionType(params*) {
		return GUI_Settings.Customization_SellingBuying_SetActionType("Buying", params*)
	}
	Customization_Selling_SetActionContent(params*) {
		return GUI_Settings.Customization_SellingBuying_SetActionContent("Selling", params*)
	}
	Customization_Buying_SetActionContent(params*) {
		return GUI_Settings.Customization_SellingBuying_SetActionContent("Buying", params*)
	}
	Customization_Selling_OnListviewClick(params*) {
		return GUI_Settings.Customization_SellingBuying_OnListviewClick("Selling", params*)
	}
	Customization_Buying_OnListviewClick(params*) {
		return GUI_Settings.Customization_SellingBuying_OnListviewClick("Buying", params*)
	}
	Customization_Selling_AdjustListviewHeaders() {
		return GUI_Settings.Customization_SellingBuying_AdjustListviewHeaders("Selling")
	}
	Customization_Buying_AdjustListviewHeaders() {
		return GUI_Settings.Customization_SellingBuying_AdjustListviewHeaders("Buying")
	}
	Customization_Selling_AddNewAction(params*) {
		return GUI_Settings.Customization_SellingBuying_AddNewAction("Selling", params*)
	}
	Customization_Buying_AddNewAction(params*) {
		return GUI_Settings.Customization_SellingBuying_AddNewAction("Buying", params*)
	}
	Customization_Selling_GetListViewContent() {
		return GUI_Settings.Customization_SellingBuying_GetListViewContent("Selling")
	}
	Customization_Buying_GetListViewContent() {
		return GUI_Settings.Customization_SellingBuying_GetListViewContent("Buying")
	}
	Customization_Selling_RemoveAction(params*) {
		return GUI_Settings.Customization_SellingBuying_RemoveAction("Selling", params*)
	}
	Customization_Buying_RemoveAction(params*) {
		return GUI_Settings.Customization_SellingBuying_RemoveAction("Buying", params*)
	}
	Customization_Selling_GetListviewSelectedRow() {
		return GUI_Settings.Customization_SellingBuying_GetListviewSelectedRow("Selling")
	}
	Customization_Buying_GetListviewSelectedRow() {
		return GUI_Settings.Customization_SellingBuying_GetListviewSelectedRow("Buying")
	}
    Customization_Selling_MoveActionDown(params*) {
		return GUI_Settings.Customization_SellingBuying_MoveActionDown("Selling", params*)
	}
	Customization_Buying_MoveActionDown(params*) {
		return GUI_Settings.Customization_SellingBuying_MoveActionDown("Buy", params*)
	}
    Customization_Selling_MoveActionUp(params*) {
		return GUI_Settings.Customization_SellingBuying_MoveActionUp("Selling", params*)
	}
	Customization_Buying_MoveActionUp(params*) {
		return GUI_Settings.Customization_SellingBuying_MoveActionUp("Buying", params*)
	}
    Customization_Selling_OnListviewRightClick() {
		return GUI_Settings.Customization_SellingBuying_OnListviewRightClick("Selling")
	}
	Customization_Buying_OnListviewRightClick() {
		return GUI_Settings.Customization_SellingBuying_OnListviewRightClick("Buying")
	}
    Customization_Selling_ListViewModifySelectedAction(params*) {
		return GUI_Settings.Customization_SellingBuying_ListViewModifySelectedAction("Selling", params*)
	}
	Customization_Buying_ListViewModifySelectedAction(params*) {
		return GUI_Settings.Customization_SellingBuying_ListViewModifySelectedAction("Buying", params*)
	}
    Customization_Selling_OnActionContentChange(params*) {
		return GUI_Settings.Customization_SellingBuying_OnActionContentChange("Selling", params*)
	}
	Customization_Buying_OnActionContentChange(params*) {
		return GUI_Settings.Customization_SellingBuying_OnActionContentChange("Buying", params*)
	}
    Customization_Selling_OnActionTypeChange() {
		return GUI_Settings.Customization_SellingBuying_OnActionTypeChange("Selling")
	}
	Customization_Buying_OnActionTypeChange() {
		return GUI_Settings.Customization_SellingBuying_OnActionTypeChange("Buying")
	}
    Customization_Selling_SetButtonName(params*) {
		return GUI_Settings.Customization_SellingBuying_SetButtonName("Selling", params*)
	}
	Customization_Buying_SetButtonName(params*) {
		return GUI_Settings.Customization_SellingBuying_SetButtonName("Buying", params*)
	}
    Customization_Selling_OnButtonNameChange() {
		return GUI_Settings.Customization_SellingBuying_OnButtonNameChange("Selling")
	}
	Customization_Buying_OnButtonNameChange() {
		return GUI_Settings.Customization_SellingBuying_OnButtonNameChange("Buying")
	}
    Customization_Selling_OnButtonIconChange() {
		return GUI_Settings.Customization_SellingBuying_OnButtonIconChange("Selling")
	}
	Customization_Buying_OnButtonIconChange() {
		return GUI_Settings.Customization_SellingBuying_OnButtonIconChange("Buying")
	}
    Customization_Selling_SetButtonIcon(params*) {
		return GUI_Settings.Customization_SellingBuying_SetButtonIcon("Selling", params*)
	}
	Customization_Buying_SetButtonIcon(params*) {
		return GUI_Settings.Customization_SellingBuying_SetButtonIcon("Buying", params*)
	}
    Customization_Selling_OnButtonTypeChange() {
		return GUI_Settings.Customization_SellingBuying_OnButtonTypeChange("Selling")
	}
	Customization_Buying_OnButtonTypeChange() {
		return GUI_Settings.Customization_SellingBuying_OnButtonTypeChange("Buying")
	}
    Customization_Selling_ShowButtonNameControl() {
		return GUI_Settings.Customization_SellingBuying_ShowButtonNameControl("Selling")
	}
	Customization_Buying_ShowButtonNameControl() {
		return GUI_Settings.Customization_SellingBuying_ShowButtonNameControl("Buying")
	}
	Customization_Selling_ShowButtonIconControl() {
		return GUI_Settings.Customization_SellingBuying_ShowButtonIconControl("Selling")
	}
	Customization_Buying_ShowButtonIconControl() {
		return GUI_Settings.Customization_SellingBuying_ShowButtonIconControl("Buying")
	}
    Customization_Selling_SetButtonType(params*) {
		return GUI_Settings.Customization_SellingBuying_SetButtonType("Selling", params*)
	}
	Customization_Buying_SetButtonType(params*) {
		return GUI_Settings.Customization_SellingBuying_SetButtonType("Buying", params*)
	}
    Customization_Selling_SaveAllCurrentButtonActions(params*) {
		return GUI_Settings.Customization_SellingBuying_SaveAllCurrentButtonActions("Selling", params*)
	}
	Customization_Buying_SaveAllCurrentButtonActions(params*) {
		return GUI_Settings.Customization_SellingBuying_SaveAllCurrentButtonActions("Buying", params*)
	}
    Customization_Selling_LoadButtonActions(params*) {
		return GUI_Settings.Customization_SellingBuying_LoadButtonActions("Selling", params*)
	}
	Customization_Buying_LoadButtonActions(params*) {
		return GUI_Settings.Customization_SellingBuying_LoadButtonActions("Buying", params*)
	}
    Customization_Selling_LoadButtonSettings(params*) {
		return GUI_Settings.Customization_SellingBuying_LoadButtonSettings("Selling", params*)
	}
	Customization_Buying_LoadButtonSettings(params*) {
		return GUI_Settings.Customization_SellingBuying_LoadButtonSettings("Buying", params*)
	}
    Customization_Selling_AdjustPreviewControls() {
		return GUI_Settings.Customization_SellingBuying_AdjustPreviewControls("Selling")
	}
	Customization_Buying_AdjustPreviewControls() {
		return GUI_Settings.Customization_SellingBuying_AdjustPreviewControls("Buying")
	}
    Customization_Selling_SetPreviewPreferences(params*) {
		return GUI_Settings.Customization_SellingBuying_SetPreviewPreferences("Selling", params*)
	}
	Customization_Buying_SetPreviewPreferences(params*) {
		return GUI_Settings.Customization_SellingBuying_SetPreviewPreferences("Buying", params*)
	}
    Customization_Selling_AddOneButtonToRow(params*) {
		return GUI_Settings.Customization_SellingBuying_AddOneButtonToRow("Selling", params*)
	}
	Customization_Buying_AddOneButtonToRow(params*) {
		return GUI_Settings.Customization_SellingBuying_AddOneButtonToRow("Buying", params*)
	}
	Customization_Selling_RemoveOneButtonFromRow(params*) {
		return GUI_Settings.Customization_SellingBuying_RemoveOneButtonFromRow("Selling", params*)
	}
	Customization_Buying_RemoveOneButtonFromRow(params*) {
		return GUI_Settings.Customization_SellingBuying_RemoveOneButtonFromRow("Buying", params*)
	}




	/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	*										TAB HOTKEYS													 *
	* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	*/

	TabHotkeys_SetSubroutines() {
		global GuiSettings, GuiSettings_Controls
		controlsList := "hLB_HotkeyProfiles,hEDIT_HotkeyProfileName,hEDIT_HotkeyProfileHotkey,hDDL_HotkeyActionType"
		. ",hEDIT_HotkeyActionContent,hLV_HotkeyActionsList,hBTN_HotkeyAddNewProfile,hBTN_HotkeyRemoveSelectedProfile"

		Loop, Parse, controlsList,% ","
		{
			ctrlName := A_LoopField, ctrlSplit := StrSplit(ctrlName, "_"), ctrlType := ctrlSplit.1, settingsKey := ctrlSplit.2

			if (ctrlName="hLB_HotkeyProfiles")
				Gui.BindFunctionToControl("GUI_Settings", "Settings", ctrlName, "TabHotkeys_OnHotkeyProfileChange")
			if (ctrlName="hEDIT_HotkeyProfileName")
				Gui.BindFunctionToControl("GUI_Settings", "Settings", ctrlName, "TabHotkeys_OnHotkeyProfileNameChange", doAgainAfter500ms:=True)
			if (ctrlName="hEDIT_HotkeyProfileHotkey")
				Gui.BindFunctionToControl("GUI_Settings", "Settings", ctrlName, "TabHotkeys_OnHotkeyProfileHotkeyChange")
			if (ctrlName="hDDL_HotkeyActionType")
				Gui.BindFunctionToControl("GUI_Settings", "Settings", ctrlName, "TabHotkeys_OnActionTypeChange")
			if (ctrlName="hEDIT_HotkeyActionContent")
				Gui.BindFunctionToControl("GUI_Settings", "Settings", ctrlName, "TabHotkeys_OnActionContentChange")
			if (ctrlName="hLV_HotkeyActionsList")
				Gui.BindFunctionToControl("GUI_Settings", "Settings", ctrlName, "TabHotkeys_OnListviewClick")
			else if (ctrlName="hBTN_HotkeyAddNewProfile")
				Gui.BindFunctionToControl("GUI_Settings", "Settings", ctrlName, "TabHotkeys_AddNewHotkeyProfile")
			else if (ctrlName="hBTN_HotkeyRemoveSelectedProfile")
				Gui.BindFunctionToControl("GUI_Settings", "Settings", ctrlName, "TabHotkeys_RemoveSelectedHotkeyProfile")
		}
	}

	TabHotkeys_SetUserSettings() {
		global PROGRAM
		global GuiSettings, GuiSettings_Controls
		controlsList := "hLB_HotkeyProfiles"

		Loop, Parse,% controlsList,% ","
		{
			ctrlName := A_LoopField, ctrlSplit := StrSplit(ctrlName, "_"), ctrlType := ctrlSplit.1, settingsKey := ctrlSplit.2

			if (ctrlName="hLB_HotkeyProfiles") {
				GUI_Settings.TabHotkeys_UpdateAvailableProfiles()
				GuiControl, Settings:Choose,% GuiSettings_Controls[ctrlName], 1
				GUI_Settings.TabHotkeys_OnHotkeyProfileChange()
			}
		}
	}

	TabHotkeys_UpdateAvailableProfiles() {
		global PROGRAM, GuiSettings_Controls
		selectedHkNum := GUI_Settings.TabHotkeys_GetSelectedHotkeyProfile()
		for index, hkObj in PROGRAM.SETTINGS.HOTKEYS
			hkList := hkList ? hkList "|" hkObj.Name : hkObj.Name
		GuiControl, Settings:,% GuiSettings_Controls.hLB_HotkeyProfiles,% "|" hkList
		if (selectedHkNum)
			GuiControl, Settings:Choose,% GuiSettings_Controls.hLB_HotkeyProfiles,% selectedHkNum
	}

	TabHotkeys_AddNewHotkeyProfile() {
		global PROGRAM, GuiSettings_Controls
		hotkeysCount := PROGRAM.SETTINGS.HOTKEYS.Count()
		PROGRAM.SETTINGS.HOTKEYS[hotkeysCount+1] := {Name: "New hotkey " hotkeysCount+1, Hotkey: "", Actions: {}}
		Save_LocalSettings()
		GUI_Settings.TabHotkeys_SetUserSettings()
		GuiControl, Settings:Choose,% GuiSettings_Controls.hLB_HotkeyProfiles,% hotkeysCount+1
		GUI_Settings.TabHotkeys_OnHotkeyProfileChange()
	}

	TabHotkeys_RemoveSelectedHotkeyProfile() {
		global PROGRAM, GuiSettings_Controls
		selectedHkNum := GUI_Settings.TabHotkeys_GetSelectedHotkeyProfile()
		MsgBox(4096+4, "", PROGRAM.SETTINGS.HOTKEYS[selectedHkNum].Name
		. "Are you sure to delete this hotkey profile?")
		IfMsgBox, Yes
		{
			hotkeysCount := PROGRAM.SETTINGS.HOTKEYS.Count()
			if (selectedHkNum=hotkeysCount) ; Can just delete the last hk 
				PROGRAM.SETTINGS.HOTKEYS.Delete(selectedHkNum)
			else { ; Need to re-arrange the obj
				hotkeysCopy := ObjFullyClone(PROGRAM.SETTINGS.HOTKEYS)
				loopedHK := selectedHkNum
				Loop % hotkeysCount-selectedHkNum {
					PROGRAM.SETTINGS.HOTKEYS[loopedHK] := ObjFullyClone(hotkeysCopy[loopedHK+1])
					loopedHK++
				}
				PROGRAM.SETTINGS.HOTKEYS.Delete(hotkeysCount)
			}
			Save_LocalSettings()
			GUI_Settings.TabHotkeys_SetUserSettings()
			GuiControl, Settings:Choose,% GuiSettings_Controls.hLB_HotkeyProfiles,% (hotkeysCount > selectedHkNum ? selectedHkNum : hotkeysCount-1)
			GUI_Settings.TabHotkeys_OnHotkeyProfileChange()
		}
	}

	TabHotkeys_GetSelectedHotkeyProfile() {
		return GUI_Settings.Submit("hLB_HotkeyProfiles")
	}

	TabHotkeys_OnHotkeyProfileChange() {
		global PROGRAM, GuiSettings_Controls, GuiSettings_ControlFunctions
		Gui, Settings:+Disabled
		SetTimer, GUI_Settings_Hotkeys_OnActionContentChange, Delete
		Sleep 10
		
		selectedHkNum := GUI_Settings.TabHotkeys_GetSelectedHotkeyProfile()
		GUI_Settings.TabHotkeys_SetHotkeyProfileName(PROGRAM.SETTINGS.HOTKEYS[selectedHkNum].Name)
		GUI_Settings.TabHotkeys_LoadHotkeyActions(selectedHkNum)
		GUI_Settings.TabHotkeys_SelectListviewRow(1)
		if !(GuiSettings_ControlFunctions.hLV_HotkeyActionsList)
			GUI_Settings.TabHotkeys_OnListviewClick()

		Sleep 10
		SetTimer, GUI_Settings_Hotkeys_OnActionContentChange, Delete
		Gui, Settings:-Disabled
	}

	TabHotkeys_SetHotkeyProfileName(hkName) {
		global GuiSettings_Controls
		GuiControl, Settings:,% GuiSettings_Controls.hEDIT_HotkeyProfileName,% hkName
	}

	TabHotkeys_GetHotkeyProfileName() {
		return GUI_Settings.Submit("hEDIT_HotkeyProfileName")
	}

	TabHotkeys_OnHotkeyProfileNameChange(doAgainAfter500ms=False) {
		global PROGRAM
		selectedHkNum := GUI_Settings.TabHotkeys_GetSelectedHotkeyProfile()
		hkName := GUI_Settings.TabHotkeys_GetHotkeyProfileName()

		if (!selectedHkNum)
			return
		if (hkName="") {
			GUI_Settings.TabHotkeys_SetHotkeyProfileName("New hotkey " selectedHkNum)
			return
		}

		PROGRAM.SETTINGS.HOTKEYS[selectedHkNum].Name := hkName
		Save_LocalSettings()
		GUI_Settings.TabHotkeys_UpdateAvailableProfiles()

		if (doAgainAfter500ms=True)
			GoSub, GUI_Settings_Hotkeys_OnHotkeyProfileNameChange
	}

	TabHotkeys_OnHotkeyProfileHotkeyChange() {
		
	}

	TabHotkeys_OnActionTypeChange() {
		return GUI_Settings.Universal_OnActionTypeChange("Hotkeys")
	}

	TabHotkeys_OnActionContentChange() {
		return GUI_Settings.Universal_OnActionContentChange("Hotkeys", doAgainAfter500ms:=True)
	}

	TabHotkeys_LoadHotkeyActions(hkNum) {
		return GUI_Settings.Universal_LoadActionsIntoListview("Hotkeys", hkNum)
	}

	TabHotkeys_SelectListviewRow(rowNum) {
		return GUI_Settings.Universal_SelectListViewRow("Hotkeys", rowNum)
	}

	TabHotkeys_OnListviewClick(params*) {
		global GuiSettings_Controls
		return GUI_Settings.Universal_OnListviewClick("Hotkeys", params*)
	}

	Hotkeys_OnListviewRightClick() {
		return GUI_Settings.Universal_OnListviewRightClick("Hotkeys")
	}





	/* * * * * Subroutines toggle * * * * *
	*/
	TabHotkeysAdvanced_EnableSubroutines() {
		GUI_Settings.TabHotkeysAdvanced_ToggleSubroutines("Enable")
	}
	TabHotkeysAdvanced_DisableSubroutines() {
		GUI_Settings.TabHotkeysAdvanced_ToggleSubroutines("Disable")
	}
	TabHotkeysAdvanced_ToggleSubroutines(enableOrDisable) {
		global GuiSettings, GuiSettings_Controls
		thisTabCtrls := GuiSettings.Hotkeys_Advanced_TabControls

		Loop, Parse, thisTabCtrls,% ","
		{
			loopedCtrl := A_LoopField

			if (enableOrDisable = "Disable")
				GuiControl, Settings:-g,% GuiSettings_Controls[loopedCtrl]
			else if (enableOrDisable = "Enable") {
				if (loopedCtrl = "hDDL_HotkeyAdvExistingList")
					__f := GUI_Settings.TabHotkeysAdvanced_OnHotkeyProfileChange.bind(GUI_Settings, "")

				else if (loopedCtrl = "hBTN_HotkeyAdvAddNewProfile")
					__f := GUI_Settings.TabHotkeysAdvanced_AddNewHotkeyProfile.bind(GUI_Settings)
				else if (loopedCtrl = "hBTN_HotkeyAdvDeleteCurrentProfile")
					__f := GUI_Settings.TabHotkeysAdvanced_DeleteCurrentHotkeyProfile.bind(GUI_Settings)
				else if (loopedCtrl = "hEDIT_HotkeyAdvName")
					__f := GUI_Settings.TabHotkeysAdvanced_OnHotkeyNameChange.bind(GUI_Settings, "")
				else if (loopedCtrl = "hHK_HotkeyAdvHotkey")
					__f := GUI_Settings.TabHotkeysAdvanced_OnHotkeyKeysChange.bind(GUI_Settings, "")
				else if (loopedCtrl = "hDDL_HotkeyAdvActionType")
					__f := GUI_Settings.TabHotkeysAdvanced_OnActionTypeChange.bind(GUI_Settings, "")
				else if (loopedCtrl = "hEDIT_HotkeyAdvActionContent")
					__f := GUI_Settings.TabHotkeysAdvanced_OnActionContentChange.bind(GUI_Settings, "")
				else if (loopedCtrl = "hBTN_HotkeyAdvSaveChangesToAction")
					__f := GUI_Settings.TabHotkeysAdvanced_ShowSaveChangesMenu.bind(GUI_Settings)
				else if (loopedCtrl = "hBTN_HotkeyAdvAddAsNewAction")
					__f := GUI_Settings.TabHotkeysAdvanced_AddAction.bind(GUI_Settings, "Push", whichPos:="")
				else if (loopedCtrl = "hLV_HotkeyAdvActionsList")
					__f := GUI_Settings.TabHotkeysAdvanced_OnListClick.bind(GUI_Settings)
				else if (loopedCtrl = "hEDIT_HotkeyAdvHotkey")
					__f := GUI_Settings.TabHotkeysAdvanced_OnHotkeyKeysChange.bind(GUI_Settings)
				else if (loopedCtrl = "hBTN_ChangeHKType")
					__f := GUI_Settings.TabHotkeysAdvanced_ShowHKTypeMenu.bind(GUI_Settings)
				else 
					__f := 

				if (__f)
					GuiControl, Settings:+g,% GuiSettings_Controls[loopedCtrl],% __f 
			}
		}
	}


	/* * * * * GET * * * * *
	*/
	TabHotkeysAdvanced_GetHotkeyProfiles() {
	/* Loop through settings to get all HK profiles
	*/
		global PROGRAM

		profiles := {}
		profileIndex := 0
		Loop {
			if !(PROGRAM.SETTINGS["SETTINGS_HOTKEY_ADV_" A_Index].Name)
				Break

			profileIndex := A_Index
			profiles[profileIndex] := {}

			profiles[profileIndex].Name := PROGRAM.SETTINGS["SETTINGS_HOTKEY_ADV_" profileIndex].Name
			profiles[profileIndex].Hotkey := PROGRAM.SETTINGS["SETTINGS_HOTKEY_ADV_" profileIndex].Hotkey
			profiles[profileIndex].Hotkey_Type := PROGRAM.SETTINGS["SETTINGS_HOTKEY_ADV_" profileIndex].Hotkey_Type
			profiles.Profiles_Count := profileIndex

			actionIndex := 0
			Loop {
				if !(PROGRAM.SETTINGS["SETTINGS_HOTKEY_ADV_" profileIndex]["Action_" A_Index "_Type"])
					Break

				actionIndex := A_Index

				profiles[profileIndex]["Action_" actionIndex "_Type"] := PROGRAM.SETTINGS["SETTINGS_HOTKEY_ADV_" profileIndex]["Action_" actionIndex "_Type"]
				profiles[profileIndex]["Action_" actionIndex "_Content"] := PROGRAM.SETTINGS["SETTINGS_HOTKEY_ADV_" profileIndex]["Action_" actionIndex "_Content"]
			}
			profiles[profileIndex]["Actions_Count"] := actionIndex
		}

		return profiles
	}

	TabHotkeysAdvanced_GetActiveHotkeyProfileInfos() {
	/* Get active profile infos
	*/
		global GuiSettings, GuiSettings_Controls

		profile := GUI_Settings.Submit("hDDL_HotkeyAdvExistingList")
		name := GUI_Settings.Submit("hEDIT_HotkeyAdvName")
		hkEasy := GUI_Settings.Submit("hHK_HotkeyAdvHotkey")
		hkManual := GUI_Settings.Submit("hEDIT_HotkeyAdvHotkey")
		acType := GUI_Settings.Submit("hDDL_HotkeyAdvActionType")
		acContent := GUI_Settings.Submit("hEDIT_HotkeyAdvActionContent")

		GuiControlGet, isHKEZVisible, Settings:Visible,% GuiSettings_Controls.hHK_HotkeyAdvHotkey
		GuiControlGet, isHKManualVisible, Settings:Visible,% GuiSettings_Controls.hEDIT_HotkeyAdvHotkey
		hk := isHKEZVisible ? hkEasy : hkManual, hkType := isHKEZVisible ? "Easy" : "Manual"

		GuiControl, Settings:+AltSubmit,% GuiSettings_Controls.hDDL_HotkeyAdvExistingList
		num := GUI_Settings.Submit("hDDL_HotkeyAdvExistingList")
		GuiControl, Settings:-AltSubmit,% GuiSettings_Controls.hDDL_HotkeyAdvExistingList

		return {Profile:profile, Name:name, Hotkey:hk, Hotkey_Type:hkType, Action_Type:acType, Action_Content: acContent, Num:num}
	}

	TabHotkeysAdvanced_GetMatchingProfile(hkName, hkKeys) {
	/*	Get the matching profile ID based on its name and keys
	*/
		global PROGRAM

		hkProfiles := GUI_Settings.TabHotkeysAdvanced_GetHotkeyProfiles()
		Loop % hkProfiles.Profiles_Count {
			if (hkProfiles[A_Index].Name = hkName) && (hkProfiles[A_Index].Hotkey = hkKeys) {
				matchingID := A_Index
				Break
			}
		}

		if !(matchingID) {
				MsgBox(4096, "", "No matching num ID found for Hotkey profile with infos:`nName: """ hkNAme """`nHotkey: """ hkKeys """`n`nPlease report the issue.")
				Return
			}
		else
			return matchindID
	}

	/* * * * * SET * * * * *
	*/

	TabHotkeysAdvanced_SetHotkeyName(hkName) {
		global GuiSettings_Controls
		GuiControl, Settings:,% GuiSettings_Controls.hEDIT_HotkeyAdvName,% hkName
	}
	TabHotkeysAdvanced_SetHotkeyKeys(hkKeys) {
		global GuiSettings_Controls
		GuiControl, Settings:,% GuiSettings_Controls.hHK_HotkeyAdvHotkey,% hkKeys
		GuiControl, Settings:,% GuiSettings_Controls.hEDIT_HotkeyAdvHotkey,% hkKeys
	}
	TabHotkeysAdvanced_SetActionType(actionType) {
		global GuiSettings_Controls
		GuiControl, Settings:Choose,% GuiSettings_Controls.hDDL_HotkeyAdvActionType,% actionType
	}

	TabHotkeysAdvanced_SetActionContent(actionContent) {
		global GuiSettings_Controls
		GuiControl, Settings:,% GuiSettings_Controls.hEDIT_HotkeyAdvActionContent,% actionContent
	}
	TabHotkeysAdvanced_SetHotkeyActionsList(actionsList) {
		global GuiSettings_Controls

		GUI_Settings.SetDefaultListView("hLV_HotkeyAdvActionsList")

		Loop % LV_GetCount()
			LV_Delete()
		Loop % actionsList.Actions_Count {
			acShort := GUI_Settings.Get_ActionLongName_From_ShortName(actionsList["Action_" A_Index "_Type"])
			LV_Add("", A_Index, acShort, actionsList["Action_" A_Index "_Content"])
		}
	}

	/* * * * * UPDATE * * * * *
	*/
	TabHotkeysAdvanced_UpdateActionsList() {
		global GuiSettings, GuiSettings_Controls
		actionsList := GUI_Settings.Get_AvailableActions_With_CustomButtonsNames()

		GUI_Settings.TabHotkeysAdvanced_DisableSubroutines()
		GuiControl, Settings:,% GuiSettings_Controls["hDDL_HotkeyAdvActionType"],% "|" actionsList
		GuiControl, Settings:ChooseString,% GuiSettings_Controls["hDDL_HotkeyAdvActionType"],% " "
		GUI_Settings.TabHotkeysAdvanced_UpdateRegisteredHotkeysList()
		GUI_Settings.TabHotkeysAdvanced_EnableSubroutines()
	}

	TabHotkeysAdvanced_UpdateRegisteredHotkeysList() {
		global GuiSettings_Controls

		GuiControl, Settings:+AltSubmit,% GuiSettings_Controls.hDDL_HotkeyAdvExistingList
		chosenItemNum := GUI_Settings.Submit("hDDL_HotkeyAdvExistingList")
		GuiControl, Settings:-AltSubmit,% GuiSettings_Controls.hDDL_HotkeyAdvExistingList

		hkProfiles := GUI_Settings.TabHotkeysAdvanced_GetHotkeyProfiles()
		hkList := "|"
		Loop % hkProfiles.Profiles_Count {
			hkStr := Transform_AHKHotkeyString_Into_ReadableHotkeyString(hkProfiles[A_Index].Hotkey)
			hkList .= hkProfiles[A_Index].Name " (Hotkey: " hkStr ")|"
		}
		if (hkList != "|")
			StringTrimRight, hkList, hkList, 1

		GuiControl, Settings:,% GuiSettings_Controls.hDDL_HotkeyAdvExistingList,% hkList

		if (hkList = "|") {
			GUI_Settings.TabHotkeysAdvanced_SetHotkeyName("")
			GUI_Settings.TabHotkeysAdvanced_SetHotkeyKeys("")
			GUI_Settings.TabHotkeysAdvanced_SetActionContent("")
			GUI_Settings.TabHotkeysAdvanced_SetHotkeyActionsList("")
			GUI_Settings.TabHotkeysAdvanced_SetHkType("Easy")
		}
		else if Isnum(chosenItemNum) { ; Avoid triggering when no item is selected
			GuiControl, Settings:Choose,% GuiSettings_Controls.hDDL_HotkeyAdvExistingList,% chosenItemNum
			if (ErrorLevel) {
				GuiControl, Settings:Choose,% GuiSettings_Controls.hDDL_HotkeyAdvExistingList,% chosenItemNum-1
				GUI_Settings.TabHotkeysAdvanced_OnHotkeyProfileChange("")
			}
		}
		else if !IsNum(chosenItemNum) ; actualyl a str
		 	GuiControl, Settings:ChooseString,% GuiSettings_Controls.hDDL_HotkeyAdvExistingList,% chosenItemNum
	}

	/* * * * * On Change * * * * *
	*/

	TabHotkeysAdvanced_OnHotkeyProfileChange(_which) {
		global PROGRAM, GuiSettings, GuiSettings_Controls

		which := _which
		if (which = "") {
			which := GUI_Settings.Submit("hDDL_HotkeyAdvExistingList")
		}

		RegExMatch(which, "O)(.*) \(Hotkey: (.*)\)$", hkNamePat)		
		hkProfiles := GUI_Settings.TabHotkeysAdvanced_GetHotkeyProfiles()
		Loop % hkProfiles.Profiles_Count {
			loopedHK := hkProfiles[A_Index]
			simplifiedHK := Transform_ReadableHotkeyString_Into_AHKHotkeyString(hkNamePat.2)
			if (loopedHK.Name = hkNamePat.1) && (loopedHK.Hotkey = simplifiedHK) {
				matchFound := True
				Break
			}
		}
		if (!matchFound) {
			MsgBox(4096, "", "ERROR: Could not find matching hotkey profile with name """ hkNamePat.1 """ and hotkey """ hkNamePat.2 """")
			Return
		}

		GUI_Settings.TabHotkeysAdvanced_DisableSubroutines()
		GUI_Settings.TabHotkeysAdvanced_SetHotkeyName(loopedHK.Name)
		GUI_Settings.TabHotkeysAdvanced_SetHotkeyKeys(loopedHK.Hotkey)
		GUI_Settings.TabHotkeysAdvanced_SetHotkeyActionsList(loopedHK)
		GUI_Settings.TabHotkeysAdvanced_EnableSubroutines()
		GUI_Settings.TabHotkeysAdvanced_SetHkType(loopedHK.Hotkey_Type)
	}

	TabHotkeysAdvanced_OnHotkeyNameChange() {
		global PROGRAM, GuiSettings, GuiSettings_Controls

		hkInfos := GUI_Settings.TabHotkeysAdvanced_GetActiveHotkeyProfileInfos()
		if !(hkInfos.Num > 0)
			Return

		hkName := hkInfos.Name
		hkName := IsSpace(hkInfos.Name) || hkInfos.Name = "" ? "[ Unnamed ]"
			: hkInfos.Name ; TO_DO; If field is empty, cant remove actions using contextmenu
						   ; Actually this is fine as it forces user to set a name
		AutoTrimStr(hkName)

		PROGRAM.SETTINGS.HOTKEYS[hkInfos.Num].Name := hkName
		Save_LocalSettings()

		GUI_Settings.TabHotkeysAdvanced_UpdateRegisteredHotkeysList()
	}
	TabHotkeysAdvanced_OnHotkeyKeysChange() {
		global PROGRAM, GuiSettings, GuiSettings_Controls

		hkInfos := GUI_Settings.TabHotkeysAdvanced_GetActiveHotkeyProfileInfos()
		if !(hkInfos.Num > 0)
			Return

		PROGRAM.SETTINGS.HOTKEYS[hkInfos.Num].Hotkey := hkInfos.Hotkey
		Save_LocalSettings()

		if (hkInfos.Hotkey_Type = "Manual")
			GuiControl, Settings:,% GuiSettings_Controls.hHK_HotkeyAdvHotkey,% hkInfos.Hotkey
		else
			GuiControl, Settings:,% GuiSettings_Controls.hEDIT_HotkeyAdvHotkey,% hkInfos.Hotkey

		GUI_Settings.TabHotkeysAdvanced_UpdateRegisteredHotkeysList()
	}
	
	TabHotkeysAdvanced_OnActionTypeChange() {
		global GuiSettings_Controls
		global ACTIONS_READONLY, ACTIONS_FORCED_CONTENT

		hkInfos := GUI_Settings.TabHotkeysAdvanced_GetActiveHotkeyProfileInfos()
		if !(hkInfos.Num > 0)
			Return

		actionType := GUI_Settings.Submit("hDDL_HotkeyAdvActionType"), AutoTrimStr(actionType)
		CtrlHwnd := GuiSettings_Controls.hDDL_HotkeyAdvActionType
		ActionContentCtrlHwnd := GuiSettings_Controls.hEDIT_HotkeyAdvActionContent
		actionContent := GUI_Settings.Submit("hEDIT_HotkeyAdvActionContent")

		actionShortName := GUI_Settings.Get_ActionShortName_From_LongName(actionType)
		contentPlaceholder := GUI_Settings.Get_ActionContentPlaceholder_From_ShortName(actionShortName)
		SetEditCueBanner(GuiSettings_Controls.hEDIT_HotkeyAdvActionContent, contentPlaceholder)
		ShowToolTip(contentPlaceholder)

		if IsContaining(actionType, "-> ") || (!actionType) {
			GetKeyState, isUpArrowPressed, Up, P
			GetKeyState, isDownArrowPressed, Down, P

			GuiControl, Settings:+AltSubmit,% CtrlHwnd
			chosenItemNum := GUI_Settings.Submit("hDDL_HotkeyAdvActionType")
			GuiControl, Settings:-AltSubmit,% CtrlHwnd

			if (isUpArrowPressed = "D") {
				if (chosenItemNum = 1)
					GuiControl, Settings:Choose,% CtrlHwnd,% 2
				else GuiControl, Settings:Choose,% CtrlHwnd,% chosenItemNum-1
			}
			else ; just go down
				GuiControl, Settings:Choose,% CtrlHwnd,% chosenItemNum+1

			Sleep 10

			actionType := GUI_Settings.Submit("hDDL_HotkeyAdvActionType")
			GUI_Settings.TabHotkeysAdvanced_SetActionType(actionType)
			GUI_Settings.TabHotkeysAdvanced_OnActionTypeChange()
			Return
		}
		else {
			if (actionType)
				GuiControl, Settings:ChooseString,% CtrlHwnd,% actionType
		}

		if IsIn(actionShortName, ACTIONS_READONLY) {
			GuiControl, Settings:+ReadOnly,% ActionContentCtrlHwnd
		}
		else {
			GuiControl, Settings:-ReadOnly,% ActionContentCtrlHwnd
		}

		for sName, fContent in ACTIONS_FORCED_CONTENT {
			if (sName = actionShortName) {
				forcedContent := fContent
				Break
			}
		}
		if (forcedContent)
			GUI_Settings.TabHotkeysAdvanced_SetActionContent(forcedContent)
		else
			GUI_Settings.TabHotkeysAdvanced_SetActionContent("")
	}

	TabHotkeysAdvanced_OnActionContentChange() {
		global PROGRAM, GuiSettings, GuiSettings_Controls 

		actionType := GUI_Settings.Submit("hDDL_HotkeyAdvActionType")
		actionContent := GUI_Settings.Submit("hEDIT_HotkeyAdvActionContent")
		actionShortName := GUI_Settings.Get_ActionShortName_From_LongName(actionType)
		actionForcedContent := GUI_Settings.Get_ActionForcedContent_From_ActionShortName(actionShortName)

		GUI_Settings.TabHotkeysAdvanced_DisableSubroutines()

		if (actionForcedContent) {
			strL := StrLen(actionForcedContent)
			contentSubStr  := SubStr(actionContent, 1, strL)

			if (contentSubStr != actionForcedContent) {
				GUI_Settings.TabHotkeysAdvanced_SetActionContent(actionForcedContent)
				ShowToolTip("The string has to start with """ actionForcedContent """")
				tipWarn := True, actionContent := actionForcedContent
			}
			else if (actionShortName = "SLEEP") {
				AutoTrimStr(actionContent)

				if (actionContent) && ( !IsDigit(actionContent) || IsContaining(actionContent, ".") ) {
					GUI_Settings.TabHotkeysAdvanced_SetActionContent(100)
					ShowToolTip("This value can only be an integer.")
					tipWarn := True, actionContent := 100
				}
				else if IsDigit(actionContent) && (actionContent > 1000) {
					GUI_Settings.TabHotkeysAdvanced_SetActionContent(1000)
					ShowToolTip("Max value is 1000 milliseconds.")
					tipWarn := True, actionContent := 1000
				}
			}
		}

		if (!tipWarn) && (actionContent) && (actionContent != actionForcedContent)
			ShowToolTip(actionContent)

		GUI_Settings.TabHotkeysAdvanced_EnableSubroutines()
	}

	TabHotkeysAdvanced_OnListClick(CtrlHwnd, GuiEvent, EventInfo, GuiEvent2="") {
		global PROGRAM, GuiSettings, GuiSettings_Controls

		hkInfos := GUI_Settings.TabHotkeysAdvanced_GetActiveHotkeyProfileInfos()
		if !(hkInfos.Num > 0)
			Return

		GUI_Settings.SetDefaultListView("hLV_HotkeyAdvActionsList")

		thisFunc := "TabHotkeysAdvanced_OnListClick"

		if GuiEvent in Normal,D,I,K
		{
			GoSub %thisFunc%_Get_Selected

			GUI_Settings.TabHotkeysAdvanced_SetActionType(actionType)
			if (ErrorLevel) {
				if (rowID = 0)
					Return
				Msgbox(4096, "", "Unknown action type: """ actionType """")
				GuiControl, Settings:ChooseString,% GuiSettings_Controls.hDDL_HotkeyAdvActionType,% " "
			}
			GUI_Settings.TabHotkeysAdvanced_SetActionContent(actionContent)
		}
		if (GuiEvent = "RightClick") {
			LV_RightClick := true
			GoSub %thisFunc%_Get_Selected

			try Menu, RClickMenu, DeleteAll
			Menu, RClickMenu, Add,% PROGRAM.TRANSLATIONS.GUI_Settings.RMENU_MoveUp, GUI_Settings_TabHotkeysAdvanced_OnListClick_RClickMenu_MoveUp
			Menu, RClickMenu, Add,% PROGRAM.TRANSLATIONS.GUI_Settings.RMENU_MoveDown, GUI_Settings_TabHotkeysAdvanced_OnListClick_RClickMenu_MoveDown
			Menu, RClickMenu, Add
			Menu, RClickMenu, Add,% PROGRAM.TRANSLATIONS.GUI_Settings.RMENU_RemoveThisAction, GUI_Settings_TabHotkeysAdvanced_OnListClick_RClickMenu_Remove
			Menu, RClickMenu, Show
		}
		Return

		GUI_Settings_TabHotkeysAdvanced_OnListClick_RClickMenu_MoveUp:
			GUI_Settings.SetDefaultListView("hLV_ButtonsActions")
			GUI_Settings.TabHotkeysAdvanced_MoveAction("Up", rowID)
		return
		GUI_Settings_TabHotkeysAdvanced_OnListClick_RClickMenu_MoveDown:
			GUI_Settings.SetDefaultListView("hLV_ButtonsActions")
			GUI_Settings.TabHotkeysAdvanced_MoveAction("Down", rowID)
		return
		GUI_Settings_TabHotkeysAdvanced_OnListClick_RClickMenu_Remove:
			GUI_Settings.SetDefaultListView("hLV_ButtonsActions")
			GUI_Settings.TabHotkeysAdvanced_AddAction("Remove", GuiSettings.HotkeysAdvanced_Selected_LV_Row)
		return

		TabHotkeysAdvanced_OnListClick_Get_Selected:
		; LV_GetText(string, A_EventInfo) is unreliable. A_EventInfo will sometimes not contain the correct row ID.
		; LV_GetNext() seems to be the best alternative. Though, it rises an issue when no row is selected.
		;	Instead of retrieving a blank value, it will retrieve the same value as the previously selected row ID.
		;	As workaround, when the user does not select any row, we re-highlight the previously selected one.
		
			GUI_Settings.SetDefaultListView("hLV_HotkeyAdvActionsList")

			hkInfos := GUI_Settings.TabHotkeysAdvanced_GetActiveHotkeyProfileInfos()
			if !(hkInfos.Num > 0)
				Return

			rowID := LV_GetNext(0, "F")
			if (rowID = 0) {
				rowID := LV_GetCount()?LV_GetCount():0
			}
			LV_GetText(rowNum, rowID, 1)
			LV_GetText(actionType, rowID, 2)
			LV_GetText(actionContent, rowID, 3)

			LV_Modify(rowID, "+Select")

			GuiSettings.HotkeysAdvanced_Selected_LV_Row := rowID
		Return
	}

	/* * * * * Misc * * * * *
	*/

	TabHotkeysAdvanced_ShowSaveChangesMenu() {
		global PROGRAM, GuiSettings
		selected := GuiSettings.HotkeysAdvanced_Selected_LV_Row

		GUI_Settings.SetDefaultListView("hLV_HotkeyAdvActionsList")

		try Menu, HKAdv_SaveChangesMenu, DeleteAll
		menuTxt := StrReplace(PROGRAM.TRANSLATIONS.GUI_Settings.RMENU_CurrentlySelected, "%number%", selected)
		Menu, HKAdv_SaveChangesMenu, Add,% menuTxt, TabHotkeysAdvanced_ShowSaveChangesMenu_MenuHandler
		Loop % LV_GetCount()
			Menu, HKAdv_SaveChangesMenu, Add,% A_Index, TabHotkeysAdvanced_ShowSaveChangesMenu_MenuHandler
		Menu, HKAdv_SaveChangesMenu, Show
		return

		TabHotkeysAdvanced_ShowSaveChangesMenu_MenuHandler:
			RegExMatch(A_ThisMenuItem, "\d+", num)
			if IsNum(num)
				GUI_Settings.TabHotkeysAdvanced_AddAction("Replace", num)
			else
				Msgbox(4096, "", "An error occured when retrieveing the number from """ A_ThisMenuItem """")
		return
	}

	TabHotkeysAdvanced_AddNewHotkeyProfile() {
		global PROGRAM, GuiSettings, GuiSettings_Controls

		InputBox, newHkProf,% PROGRAM.Name,% "Input a new profile name:", , 250, 150
		if (!newHKProf)
			Return

		Loop {
			loopIndex := A_Index
			if !(PROGRAM.SETTINGS["SETTINGS_HOTKEY_ADV_" loopIndex].Name)
				Break
		}
		PROGRAM.SETTINGS.HOTKEYS[loopIndex] := {}
		PROGRAM.SETTINGS.HOTKEYS[loopIndex].Name := newHKProf
		PROGRAM.SETTINGS.HOTKEYS[loopIndex].Hotkey := ""
		PROGRAM.SETTINGS.HOTKEYS[loopIndex].Hotkey_Type := "Easy" ; TO_DO_V2 wtf? workaround pls
		Save_LocalSettings()

		GUI_Settings.TabHotkeysAdvanced_UpdateRegisteredHotkeysList()
		GUI_Settings.TabHotkeysAdvanced_DisableSubroutines()
		GuiControl, Settings:Choose,% GuiSettings_Controls.hDDL_HotkeyAdvExistingList,% loopIndex
		GUI_Settings.TabHotkeysAdvanced_EnableSubroutines()
		GUI_Settings.TabHotkeysAdvanced_OnHotkeyProfileChange("")
		Return				
	}
	
	TabHotkeysAdvanced_DeleteCurrentHotkeyProfile() {
		global GuiSettings, GuiSettings_Controls, PROGRAM

		selectedProfile := GUI_Settings.TabHotkeysAdvanced_GetActiveHotkeyProfileInfos()
		hkStr := Transform_AHKHotkeyString_Into_ReadableHotkeyString(selectedProfile.Hotkey)
		boxTxt := StrReplace(PROGRAM.TRANSLATIONS.MessageBoxes.Settings_ConfirmDeleteAdvHotkeyProfile, "%name%", selectedProfile.Name)
		boxTxt := StrReplace(boxTxt, "%hotkey%", hkStr)
		MsgBox(4096+48+4, "", boxTxt)
		IfMsgBox, Yes
		{
			hkProfiles := GUI_Settings.TabHotkeysAdvanced_GetHotkeyProfiles()
			hkSettingsCopy := ObjFullyClone(PROGRAM.SETTINGS.HOTKEYS)
			
			diff := hkProfiles.Profiles_Count-selectedProfile.Num
			if (diff) {
				fromNum := selectedProfile.Num+1, toNum := selectedProfile.Num
				Loop % diff {
					PROGRAM.SETTINGS.HOTKEYS[toNum] := {}, PROGRAM.SETTINGS.HOTKEYS[toNum] := hkSettingsCopy[fromNum]
					fromNum++, toNum++
				}
			}
			else {
				PROGRAM.SETTINGS.HOTKEYS.Remove([selectedProfile.Num])
			}

			Save_LocalSettings()
			GUI_Settings.TabHotkeysAdvanced_UpdateRegisteredHotkeysList()
		}
	}

	TabHotkeysAdvanced_SaveSelectedHotkeyActions() {
		global GuiSettings, GuiSettings_Controls, PROGRAM

		GUI_Settings.SetDefaultListView("hLV_HotkeyAdvActionsList")
		hkInfos := GUI_Settings.TabHotkeysAdvanced_GetActiveHotkeyProfileInfos()

		if !(hkInfos.Num > 0)
			Return

		PROGRAM.SETTINGS.HOTKEYS[hkInfos.Num].Actions := {}
		Loop % LV_GetCount() {
			LV_GetText(retrievedRowType, A_Index, 2)
			LV_GetText(retrievedRowContent, A_Index, 3)
			acShort := GUI_Settings.Get_ActionShortName_From_LongName(retrievedRowType)

			PROGRAM.SETTINGS.HOTKEYS[hkInfos.Num].Actions[A_Index] := {Type: """" retrievedRowContent """", Content: acShort}
		}
		Save_LocalSettings()
	}

	TabHotkeysAdvanced_AddAction(whatDo, whichPos) {
		global PROGRAM, GuiSettings, GuiSettings_Controls

		GUI_Settings.SetDefaultListView("hLV_HotkeyAdvActionsList")

		hkInfos := GUI_Settings.TabHotkeysAdvanced_GetActiveHotkeyProfileInfos()
		if !(hkInfos.Num > 0)
			Return

		actionType := GUI_Settings.Submit("hDDL_HotkeyAdvActionType"), AutoTrimStr(actionType)
		actionContent := GUI_Settings.Submit("hEDIT_HotkeyAdvActionContent")
		actionShortName := GUI_Settings.Get_ActionShortName_From_LongName(actionType)

		lvCount := LV_GetCount(), LV_GetText(lastAction, lvCount, 2)
		lastActionShortName := GUI_Settings.Get_ActionShortName_From_LongName(lastAction)

		if (whatDo = "Replace" && whichPos < lvCount)
		&& IsIn(actionShortName, "WRITE_THEN_GO_BACK,WRITE_MSG,WRITE_TO_LAST_WHISPER,WRITE_TO_BUYER,CLOSE_TAB") {
			MsgBox(4096, "", PROGRAM.TRANSLATIONS.MessageBoxes.Settings_ThisActionCanOnlyBeLast)
			Return
		}

		if (!actionType) || IsContaining(actionType, "-> ") || (!hkInfos.Name)
			Return

		if (whatDo = "Replace") {
			LV_Modify(whichPos, "" , whichPos, actionType, actionContent)
		}
		else if (whatDo = "Push") {
			allActions := GUI_Settings.TabHotkeysAdvanced_GetCurrentHotkeysActionsList()
			newAllActions := GUI_Settings.TabHotkeysAdvanced_GetCurrentHotkeysActionsList()

			if (whichPos = "") {
				if IsIn(actionShortName, "WRITE_THEN_GO_BACK,WRITE_MSG,WRITE_TO_LAST_WHISPER,WRITE_TO_BUYER,CLOSE_TAB")
				&& IsIn(lastActionShortName, "WRITE_THEN_GO_BACK,WRITE_MSG,WRITE_TO_LAST_WHISPER,WRITE_TO_BUYER") {
					boxTxt := StrReplace(PROGRAM.TRANSLATIONS.MessageBoxes.Settings_LastActionIsWrite, "%thisAction%", actionType)
					boxTxt := StrReplace(boxTxt, "%lastAction%", lastAction)
					MsgBox(4096, "", boxTxt)
					return
				}
				else if IsIn(actionShortName, "WRITE_THEN_GO_BACK,WRITE_MSG,WRITE_TO_LAST_WHISPER,WRITE_TO_BUYER,CLOSE_TAB")
				&& IsIn(lastActionShortName, "CLOSE_TAB") {
					boxTxt := StrReplace(PROGRAM.TRANSLATIONS.MessageBoxes.Settings_LastActionIsCloseTab, "%thisAction%", actionType)
					boxTxt := StrReplace(boxTxt, "%lastAction%", lastAction)
					MsgBox(4096, "", boxTxt)
					return
				}
				else if IsIn(lastActionShortName, "WRITE_THEN_GO_BACK,WRITE_MSG,WRITE_TO_LAST_WHISPER,WRITE_TO_BUYER,CLOSE_TAB")
					whichPos := lvCount
				else whichPos := lvCount+1
			}
				
			if (whichPos > lvCount) {
				newAllActions[whichPos] := {Num:whichPos, ActionType: actionType, ActionContent: actionContent}
			}
			else {
				for index, nothing in allActions {
					if (index >= whichPos) {
						diff := (index - whichPos) + 1
						newAllActions[index+diff] := allActions[index], newAllActions[index+diff].Num := index+diff
					}
				}
				newAllActions[whichPos] := {Num:whichPos, ActionType: actionType, ActionContent: actionContent}
			}

			Loop % LV_GetCount()
				LV_Delete()
			for index, nothing in newAllActions
				LV_Add("", newAllActions[index].Num, newAllActions[index].Actiontype, newAllActions[index].ActionContent)
		}
		else if (whatDo = "Remove") {
			Loop % lvCount {
				LV_GetText(retrievedRowNum, A_Index, 1)
				if (retrievedRowNum >= whichPos) {
					LV_GetText(retrievedRowType, retrievedRowNum, 2)
					LV_GetText(retrievedRowContent, retrievedRowNum, 3)
					LV_Modify(retrievedRowNum, "", retrievedRowNum-1, retrievedRowType, retrievedRowContent)
				}
			}
			LV_Delete(whichPos)
		}

		GUI_Settings.TabHotkeysAdvanced_SaveSelectedHotkeyActions()
	}

	TabHotkeysAdvanced_GetCurrentHotkeysActionsList() {
		global GuiSettings, GuiSettings_Controls

		GUI_Settings.SetDefaultListView("hLV_HotkeyAdvActionsList")
		
		actions := {}
		Loop % LV_GetCount() {			
			LV_GetText(rowNum, A_Index, 1)
			LV_GetText(actionType, A_Index, 2)
			LV_GetText(actionContent, A_Index, 3)
			actions[A_Index] := {Num:rowNum, ActionType:actionType, ActionContent:actioncontent}
		}

		return actions
	}

	TabHotkeysAdvanced_MoveAction(side, acNum) {
		global PROGRAM, GuiSettings_Controls

		GUI_Settings.SetDefaultListView("hLV_HotkeyAdvActionsList")

		LV_GetText(lastActionNum, LV_GetCount(), 1)
		LV_GetText(lastActionType, LV_GetCount(), 2)
		lastActionShortName := GUI_Settings.Get_ActionShortName_From_LongName(lastActionType)

		if IsIn(lastActionShortName, "WRITE_THEN_GO_BACK,WRITE_MSG,WRITE_TO_LAST_WHISPER,WRITE_TO_BUYER")
		&& (lastActionNum = acNum+1) && (side = "Down") {
			boxTxt := StrReplace(PROGRAM.TRANSLATIONS.MessageBoxes.Settings_CannotMoveDownBcsLastIsWrite, "%lastAction%", lastActionType)
			MsgBox(4096, "", boxTxt)
			Return
		}
		else if IsIn(lastActionShortName, "WRITE_THEN_GO_BACK,WRITE_MSG,WRITE_TO_LAST_WHISPER,WRITE_TO_BUYER")
		&& (lastActionNum = acNum) && (side = "Up") {
			MsgBox(4096, "", PROGRAM.TRANSLATIONS.MessageBoxes.Settings_CannotMoveUpBcsItsWrite)
			Return
		}
		else if (lastActionShortName = "CLOSE_TAB")
		&& (lastActionNum = acNum+1) && (side = "Down") {
			boxTxt := StrReplace(PROGRAM.TRANSLATIONS.MessageBoxes.Settings_CannotMoveDownBcsLastIsCloseTab, "%lastAction%", lastActionType)
			MsgBox(4096, "", boxTxt)
			Return
		}	
		else if (lastActionShortName = "CLOSE_TAB")
		&& (lastActionNum = acNum) && (side = "Up") {
			MsgBox(4096, "", PROGRAM.TRANSLATIONS.MessageBoxes.Settings_CannotMoveUpBcsItsCloseTab)
			Return
		}
		else if ( (acNum = LV_GetCount()) && (side = "Down") )
		|| ( (acNum = 1) && (side = "Up") )
			return

		allActions := GUI_Settings.TabHotkeysAdvanced_GetCurrentHotkeysActionsList()
		newAllActions := GUI_Settings.TabHotkeysAdvanced_GetCurrentHotkeysActionsList()
		if (side = "Up") {
			newAllActions[acNum] := allActions[acNum-1]
			newAllActions[acNum-1] := allActions[acNum]
		}
		else if (side = "Down") {
			newAllActions[acNum] := allActions[acNum+1]
			newAllActions[acNum+1] := allActions[acNum]
		}
	
		Loop % LV_GetCount()
			LV_Delete()
		for index, nothing in newAllActions
			LV_Add("", index, newAllActions[index].Actiontype, newAllActions[index].ActionContent)
	}

	TabHotkeysAdvanced_ShowHKTypeMenu() {
		global PROGRAM, GuiSettings, TabHotkeysAdvanced_SetHkType

		try Menu, HKTypeMenu, DeleteAll
		Menu, HKTypeMenu, Add,% PROGRAM.TRANSLATIONS.GUI_Settings.RMENU_HkModeEasy, HkTypeMenu_Easy
		Menu, HKTypeMenu, Add,% PROGRAM.TRANSLATIONS.GUI_Settings.RMENU_HkModeManual, HKTypeMenu_Manual
		Menu, HKTypeMenu, Show
		return

		HKTypeMenu_Easy:
			hkInfos := GUI_Settings.TabHotkeysAdvanced_GetActiveHotkeyProfileInfos()
			GUI_Settings.TabHotkeysAdvanced_SetHkType("Easy")
			if !IsNum(hkInfos.Num)
				return

			PROGRAM.SETTINGS.HOTKEYS[hkInfos.Num].Hotkey_Type := "Easy"
			Save_LocalSettings()			
		return
		HKTypeMenu_Manual:
			hkInfos := GUI_Settings.TabHotkeysAdvanced_GetActiveHotkeyProfileInfos()
			GUI_Settings.TabHotkeysAdvanced_SetHkType("Manual")
			if !IsNum(hkInfos.Num)
				return

			PROGRAM.SETTINGS.HOTKEYS[hkInfos.Num].Hotkey_Type := "Manual"
			Save_LocalSettings()
		return
	}
	TabHotkeysAdvanced_SetHkType(which) {
		global GuiSettings_Controls

		if (which="Manual") {
			GuiControl, Settings:Show,% GuiSettings_Controls.hEDIT_HotkeyAdvHotkey
			GuiControl, Settings:Hide,% GuiSettings_Controls.hHK_HotkeyAdvHotkey
		}
		else { ; Easy
			GuiControl, Settings:Hide,% GuiSettings_Controls.hEDIT_HotkeyAdvHotkey
			GuiControl, Settings:Show,% GuiSettings_Controls.hHK_HotkeyAdvHotkey
		}
	}

	/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
	*	Tab MISC UPDATING
	*/

	/* * * * * Subroutines toggle * * * * *
	*/
	TabMiscUpdating_EnableSubroutines() {
		GUI_Settings.TabMiscUpdating_ToggleSubroutines("Enable")
	}
	TabMiscUpdating_DisableSubroutines() {
		GUI_Settings.TabMiscUpdating_ToggleSubroutines("Disable")
	}
	TabMiscUpdating_ToggleSubroutines(enableOrDisable) {
		global GuiSettings, GuiSettings_Controls
		thisTabCtrls := GuiSettings.TabMiscUpdating_Controls

		Loop, Parse, thisTabCtrls,% ","
		{
			loopedCtrl := A_LoopField
			isCheckbox := SubStr(loopedCtrl, 1, 3)="hCB" ? True : False

			if (enableOrDisable = "Disable")
				GuiControl, Settings:-g,% GuiSettings_Controls[loopedCtrl]
			else if (enableOrDisable = "Enable") {
				if (loopedCtrl = "hBTN_CheckForUpdates")
					__f := GUI_Settings.TabMiscUpdating_CheckForUpdates.bind(GUI_Settings)
				else if (isCheckbox)
					__f := GUI_Settings.TabMiscUpdating_OnCheckboxToggle.bind(GUI_Settings, loopedCtrl)
				else if (loopedCtrl = "hDDL_CheckForUpdate")
					__f := GUI_Settings.TabMiscUpdating_OnCheckForUpdatesDDLChange.bind(GUI_Settings, loopedCtrl)
				else 
					__f := 

				if (__f)
					GuiControl, Settings:+g,% GuiSettings_Controls[loopedCtrl],% __f 
			}
		}
	}

	TabMiscUpdating_SetUserSettings() {
		global PROGRAM, GuiSettings_Controls
		thisTabSettings := ObjFullyClone(PROGRAM.SETTINGS.UPDATING)

		GUI_Settings.TabMiscUpdating_UpdateVersionsText()
		; Set checkbox state
		for key, value in thisTabSettings {
			if IsIn(key, "AllowToUpdateAutomaticallyOnStart,AllowPeriodicUpdateCheck,UseBeta,DownloadUpdatesAutomatically") {
				cbValue := value="True"?1 : value="False"?0 : value
				thisTabSettings[key] := cbValue
			}
			if (key = "CheckForUpdatePeriodically") {
				ddlValue := value="OnStartOnly" ? 1
					: value="OnStartAndEveryFiveHours" ? 2
					: value="OnStartAndEveryDay" ? 3
					: 1
				thisTabSettings[key] := ddlValue
			}
		}
		; GuiControl, Settings:,% GuiSettings_Controls.hCB_AllowToUpdateAutomaticallyOnStart ,% thisTabSettings.AllowToUpdateAutomaticallyOnStart
		; GuiControl, Settings:,% GuiSettings_Controls.hCB_AllowPeriodicUpdateCheck ,% thisTabSettings.AllowPeriodicUpdateCheck
		GuiControl, Settings:Choose,% GuiSettings_Controls.hDDL_CheckForUpdate,% thisTabSettings.CheckForUpdatePeriodically
		GuiControl, Settings:,% GuiSettings_Controls.hCB_UseBeta,% thisTabSettings.UseBeta
		GuiControl, Settings:,% GuiSettings_Controls.hCB_DownloadUpdatesAutomatically,% thisTabSettings.DownloadUpdatesAutomatically
	}

	TabMiscUpdating_UpdateVersionsText() {
		global PROGRAM, GuiSettings_Controls, UPDATE_TAGNAME
		thisTabSettings := ObjFullyClone(PROGRAM.SETTINGS.UPDATING)

		; Get time diff since update check
		timeDiff := timeDiffS A_Now, lastTimeChecked := thisTabSettings.LastUpdateCheck
		timeDiffS -= lastTimeChecked, Seconds
		timeDiff -= lastTimeChecked, Minutes
		timeDiff := timeDiffS < 61 ? 1 : timeDiff
		; Set groupbox title
		if (UPDATE_TAGNAME != "")
			GuiControl, Settings:,% GuiSettings_Controls.hGB_UpdateCheck,% updAvailable " is available!"
		else GuiControl, Settings:,% GuiSettings_Controls.hGB_UpdateCheck,% "You are up to date!"

		; Set field content
		GuiControl, Settings:,% GuiSettings_Controls.hTEXT_ProgramVer,% PROGRAM.VERSION
		GuiControl, Settings:,% GuiSettings_Controls.hTEXT_LatestStableVer,% thisTabSettings.LatestStable
		GuiControl, Settings:,% GuiSettings_Controls.hTEXT_LatestBetaVer,% thisTabSettings.LatestBeta
		GuiControl, Settings:,% GuiSettings_Controls.hTEXT_MinsAgo,% "(" timeDiff " mins ago)"
		; Update control size
		GuiControl, Settings:Move,% GuiSettings_Controls.hTEXT_ProgramVer,% "w" Get_TextCtrlSize(PROGRAM.VERSION, "Segoe UI", "8").W
		GuiControl, Settings:Move,% GuiSettings_Controls.hTEXT_LatestStableVer,% "w" Get_TextCtrlSize(thisTabSettings.LatestStable, "Segoe UI", "8").W
		GuiControl, Settings:Move,% GuiSettings_Controls.hTEXT_LatestBetaVer,% "w" Get_TextCtrlSize(thisTabSettings.LatestBeta, "Segoe UI", "8").W
		GuiControl, Settings:Move,% GuiSettings_Controls.hTEXT_MinsAgo,% "w" Get_TextCtrlSize("(" timeDiff " mins ago)", "Segoe UI", "8").W
	}

	TabMiscUpdating_OnCheckboxToggle(CtrlName) {
		global PROGRAM

		iniKey := SubStr(CtrlName, 5)

		val := GUI_Settings.Submit(CtrlName)
		val := val=0?"False":val=1?"True":val

		PROGRAM.SETTINGS.UPDATING[iniKey] := val
		Save_LocalSettings()
	}

	TabMiscUpdating_CheckForUpdates() {
		global PROGRAM, GuiSettings_Controls
		thisTabSettings := ObjFullyClone(PROGRAM.SETTINGS.UPDATING)

		UpdateCheck(checkType:="forced", notifOrBox:="box")
		GUI_Settings.TabMiscUpdating_UpdateVersionsText()
	}

	TabMiscUpdating_OnCheckForUpdatesDDLChange(CtrlName, CtrlHwnd) {
		global PROGRAM, GuiSettings_Controls
	
		ddlVal := GUI_Settings.Submit(CtrlName)
		valStr := ddlVal=1 ? "OnStartOnly"
			: ddlVal=2 ? "OnStartAndEveryFiveHours"
			: ddlVal=3 ? "OnStartAndEveryDay"
			: "OnStartAndEveryFiveHours"

		PROGRAM.SETTINGS.UPDATING.CheckForUpdatePeriodically := valStr
		Save_LocalSettings()
	}

	/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
	*	Tab MISC ABOUT
	*/

	TabMiscAbout_UpdateAllOfFame() {
		SetTimer, GUI_Setting_TabMiscAbout_UpdateAllOfFame_Timer, -10
		Return

		GUI_Setting_TabMiscAbout_UpdateAllOfFame_Timer:
			hof := GUI_Settings.TabMiscAbout_GetHallOfFame()
			GUI_Settings.TabMiscAbout_SetHallOfFame(hof)
		Return
	}

	TabMiscAbout_SetHallOfFame(hof) {
		global GuiSettings_Controls

		txt := "Hall of Fame`nThank you for your support!`n`n" hof
		GuiControl, Settings:,% GuiSettings_Controls.hEDIT_HallOfFame,% txt
	}

	TabMiscAbout_GetHallOfFame() {
		global PROGRAM

		url := "https://github.com/lemasato/POE-Trades-Companion/wiki/Support"
    	headers := "Content-Type: text/html, charset=UTF-8"
    	options := "TimeOut: 7"
    	. "`n"     "Charset: UTF-8"

    	WinHttpRequest(url, data:="", headers, options), html := data

		hallOfFame := ""
		if RegExMatch(html,"\<table\>(.*)\<\/table\>", match) {
			Loop, Parse, match,% "`n",% "`r"
			{
				if RegExMatch(A_LoopField,"\<td\>(.*?)\<\/td\>", name) {
					name := StrReplace(name, "<td>")
					name := StrReplace(name, "</td>")
					hallOfFame .= name "`n"
				}
			}
			Sort, hallOfFame, D`n
		}
		else 
			hallOfFame := "[Failed to retrieve Hall of Fame]"
		
		return hallOfFame		
	}

	/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	*								UNIVERSAL ACTION FUNCTIONS											 *
	* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	*/

	Universal_SelectListViewRow(whichTab, rowNum=1) {
		GUI_Settings.SetDefaultListViewBasedOnTabName(whichTab)
		LV_Modify(rowNum, "+Select +Focus")
	}

	Universal_LoadActionsIntoListview(whichTab, params*) {
		global PROGRAM, GuiSettings
		GUI_Settings.SetDefaultListViewBasedOnTabName(whichTab)

		if IsIn(whichTab, "Selling,Buying") {
			rowNum := params.1, btnNum := params.2
			guiIniSection := whichTab="Selling"?"SELL_INTERFACE":"BUY_INTERFACE"
			actionsObj := ObjFullyClone(PROGRAM.SETTINGS[guiIniSection]["CUSTOM_BUTTON_ROW_" rowNum][btnNum].Actions)
		}
		else if (whichTab="Hotkeys") {
			hkIndex := params.1
			actionsObj := ObjFullyClone(PROGRAM.SETTINGS.HOTKEYS[hkIndex].Actions)
		}

		Loop % LV_GetCount()
			LV_Delete()
		Loop % actionsObj.Count() {
			actionType := actionsObj[A_Index].Type
			if (SubStr(actionContent, 1, 1) = """") && (SubStr(actionContent, 0) = """") ; Removing quotes
				actionContent := StrTrimLeft(actionContent, 1), actionContent := StrTrimRight(actionContent, 1)
			actionContent := StrTrimLeft(actionsObj[A_Index].Content, 1), actionContent := StrTrimRight(actionContent, 1) ; Removing quotes
			actionLongName := GUI_Settings.Get_ActionLongName_From_ShortName(actionType)

			LV_Add("", A_Index, actionLongName, actionContent)
		}
		GUI_Settings.Universal_AdjustListviewHeaders(whichTab)
	}

    Universal_SaveAllActions(whichTab, isTimedSave=False) {
		global PROGRAM, GuiSettings
		static prevNum
		GUI_Settings.SetDefaultListViewBasedOnTabName(whichTab)

		; Getting activated button variables
		if IsIn(whichTab, "Selling,Buying") {
			guiIniSection := whichTab="Selling"?"SELL_INTERFACE":"BUY_INTERFACE"
			rowNum := GuiSettings.CUSTOM_BUTTON_SELECTED_ROW
			btnsCount := GuiSettings.CUSTOM_BUTTON_SELECTED_MAX
			btnNum := GuiSettings.CUSTOM_BUTTON_SELECTED_NUM
			; Couldnt save notification
			if (!rowNum || !btnsCount || !btnNum) {
				TrayNotifications.Show("", "COULDN'T SAVE BUTTON"
				. "`nRow: " rowNum
				. "`nCount: " btnsCount
				. "`nNum: " btnNum
				. "`nTab: " whichTab)
				return
			}
		}
		; Save new actions
		lvContent := GUI_Settings.Universal_GetListViewContent(whichTab)
		if IsIn(whichTab, "Buying,Selling") {
			if (isTimedSave && prevNum != rowNum btnNum)
				return
				
			if !IsObject(PROGRAM.SETTINGS[guiIniSection]["CUSTOM_BUTTON_ROW_" rowNum][btnNum])
				PROGRAM.SETTINGS[guiIniSection]["CUSTOM_BUTTON_ROW_" rowNum][btnNum] := {}
			PROGRAM.SETTINGS[guiIniSection]["CUSTOM_BUTTON_ROW_" rowNum][btnNum]["Actions"] := {}
			for index, nothing in lvContent {
				actionShortName := GUI_Settings.Get_ActionShortName_From_LongName(lvContent[index].ActionType)
				PROGRAM.SETTINGS[guiIniSection]["CUSTOM_BUTTON_ROW_" rowNum][btnNum]["Actions"][index] := {Content: """" lvContent[index].ActionContent """", Type: actionShortName}
			}
			prevNum := rowNum btnNum
		}
		else if (whichTab="Hotkeys") {
			hkIndex := GUI_Settings.TabHotkeys_GetSelectedHotkeyProfile()
			if (isTimedSave && prevNum != hkIndex)
				return

			if !IsObject(PROGRAM.SETTINGS.HOTKEYS[hkIndex])
				PROGRAM.SETTINGS.HOTKEYS[hkIndex] := {}
			PROGRAM.SETTINGS.HOTKEYS[hkIndex]["Actions"] := {}
			for index, nothing in lvContent {
				actionShortName := GUI_Settings.Get_ActionShortName_From_LongName(lvContent[index].ActionType)
				PROGRAM.SETTINGS.HOTKEYS[hkIndex]["Actions"][index] := {Content: """" lvContent[index].ActionContent """", Type: actionShortName}
			}
			prevNum := hkIndex
		}
		Save_LocalSettings()
	}

    Universal_OnActionTypeChange(whichTab) {
		global GuiSettings_Controls
		global ACTIONS_READONLY, ACTIONS_FORCED_CONTENT

		actionTypeCtrlName := whichTab="Buying"?"hDDL_CustomizationBuyingActionType"
			: whichTab="Selling"?"hDDL_CustomizationSellingActionType"
			: whichTab="Hotkeys"?"hDDL_HotkeyActionType"
			: ""
		actionContentCtrlName := whichTab="Buying"?"hEDIT_CustomizationBuyingActionContent"
			: whichTab="Selling"?"hEDIT_CustomizationSellingActionContent"
			: whichTab="Hotkeys"?"hEDIT_HotkeyActionContent"
			: ""
		actionTypeTipCtrlName := whichTab="Buying"?"hTEXT_CustomizationBuyingActionTypeTip"
			: whichTab="Selling"?"hTEXT_CustomizationSellingActionTypeTip"
			: whichTab="Hotkeys"?"hTEXT_HotkeyActionTypeTip"
			: ""

		actionTypeHwnd := GuiSettings_Controls[actionTypeCtrlName]
		actionContentHwnd := GuiSettings_Controls[actionContentCtrlName]

		; Get current action type & content
		actionType := GUI_Settings.Submit(actionTypeCtrlName), AutoTrimStr(actionType) ; Trim so space to separate sections is made empty
		actionContent := GUI_Settings.Submit(actionContentCtrlName)
		; Get infos concerning this action
		actionShortName := GUI_Settings.Get_ActionShortName_From_LongName(actionType)
		contentPlaceholder := GUI_Settings.Get_ActionContentPlaceholder_From_ShortName(actionShortName)
		GuiControl, Settings:,% GuiSettings_Controls[actionTypeTipCtrlName],% contentPlaceholder
				
		; Avoid selecting actions with -> in name or empty
		if IsContaining(actionType, "-> ") || (actionType = "") {
			; Check if one arrow was being pressed
			isUpPressed := GetKeyState("Up", "P"), isDownPressed := GetKeyState("Down", "P")
			isLeftPressed := GetKeyState("Left", "P"), isRightPressed := GetKeyState("Right", "P")
			; Retrieve the number of the ddl item
			GuiControl, Settings:+AltSubmit,% actionTypeHwnd
			chosenItemNum := GUI_Settings.Submit(actionTypeCtrlName)
			GuiControl, Settings:-AltSubmit,% actionTypeHwnd
			; Select whichever is next, based on arrow press
			if (isUpPressed || isLeftPressed) {
				if (chosenItemNum = 1)
					GuiControl, Settings:Choose,% actionTypeHwnd,% 2
				else {
					pressDiff := (actionType="") ? 1 : 2 ; 1 = difference between empty space and previous action
					GuiControl, Settings:Choose,% actionTypeHwnd,% chosenItemNum-pressDiff
				}
			}
			else {
				pressDiff := (actionType="") ? 2 : 1 ; 2 = difference between empty space and next action
				GuiControl, Settings:Choose,% actionTypeHwnd,% chosenItemNum+pressDiff
			}

			; Start the function again
			Sleep 10
			GUI_Settings.Universal_OnActionTypeChange(whichTab)
			Return
		}
		; Make read only if action is supposed to be
		if IsIn(actionShortName, ACTIONS_READONLY)
			GuiControl, Settings:+ReadOnly,% actionContentHwnd
		else
			GuiControl, Settings:-ReadOnly,% actionContentHwnd
		; Retrieve forced content if action is supposed to be
		for sName, fContent in ACTIONS_FORCED_CONTENT {
			if (sName = actionShortName) {
				forcedContent := fContent
				Break
			}
		}
		; Set the forced content if contains any, otherwise make content empty
		if (forcedContent)
			GUI_Settings.Universal_SetActionContent(whichTab, forcedContent)
		else
			GUI_Settings.Universal_SetActionContent(whichTab, "")

		; Update currently selected action
		selectedRow := GUI_Settings.Universal_GetListviewSelectedRow(whichTab)
		if IsNum(selectedRow) && (selectedRow > 0) {
			GUI_Settings.Universal_ListViewModifySelectedAction(whichTab, actionType, "")
		}
	}

    Universal_OnActionContentChange(whichTab, doAgainAfter500ms=False) {
		/* The doAgainAfter500ms trick allows to make sure that the function is ran correctly if the user typed way too fast somehow
		*/
		global PROGRAM, GuiSettings, GuiSettings_Controls

		actionTypeCtrlName := whichTab="Buying"?"hDDL_CustomizationBuyingActionType"
			: whichTab="Selling"?"hDDL_CustomizationSellingActionType"
			: whichTab="Hotkeys"?"hDDL_HotkeyActionType"
			: ""
		actionContentCtrlName := whichTab="Buying"?"hEDIT_CustomizationBuyingActionContent"
			: whichTab="Selling"?"hEDIT_CustomizationSellingActionContent"
			: whichTab="Hotkeys"?"hEDIT_HotkeyActionContent"
			: ""

		if !(actionTypeCtrlName || actionContentCtrlName) {
			MsgBox(4096, "", "Invalid use of " A_ThisFunc ". Unknown tab: """ whichTab """")
			return
		}

		; Get current action type & content
		actionType := GUI_Settings.Submit(actionTypeCtrlName), AutoTrimStr(actionType)
		actionContent := GUI_Settings.Submit(actionContentCtrlName)
		; Get infos concerning this action
		actionShortName := GUI_Settings.Get_ActionShortName_From_LongName(actionType)
		actionForcedContent := GUI_Settings.Get_ActionForcedContent_From_ActionShortName(actionShortName)

		; Make sure that forced content is within string
		if (actionForcedContent) {
			strL := StrLen(actionForcedContent)
			contentSubStr  := SubStr(actionContent, 1, strL)

			if (contentSubStr != actionForcedContent) {
				GUI_Settings.Universal_SetActionContent(whichTab, actionForcedContent)
				ShowToolTip("The string has to start with """ actionForcedContent """")
				tipWarn := True, actionContent := actionForcedContent
			}
			else if (actionShortName = "SLEEP") {
				AutoTrimStr(actionContent)

				if (actionContent) && ( !IsDigit(actionContent) || IsContaining(actionContent, ".") ) {
					GUI_Settings.Universal_SetActionContent(whichTab, 100)
					ShowToolTip("This value can only be an integer.")
					tipWarn := True, actionContent := 100
				}
				else if IsDigit(actionContent) && (actionContent > 1000) {
					GUI_Settings.Universal_SetActionContent(whichTab, 1000)
					ShowToolTip("Max value is 1000 milliseconds.")
					tipWarn := True, actionContent := 1000
				}
			}
		}

		; Update currently selected action
		selectedRow := GUI_Settings.Universal_GetListviewSelectedRow(whichTab)
		if IsNum(selectedRow) && (selectedRow > 0) {
			GUI_Settings.Universal_ListViewModifySelectedAction(whichTab, "", actionContent)
		}

		; Show a tooltip of current contet
		if (!tipWarn) && (actionContent) && (actionContent != actionForcedContent)
			ShowToolTip(actionContent)
		
		if (doAgainAfter500ms=True) {
			if (whichTab="Selling")
				GoSub, GUI_Settings_Customization_Selling_OnActionContentChange_Timer
			else if (whichTab="Buying")
				GoSub, GUI_Settings_Customization_Buying_OnActionContentChange_Timer
			else if (whichTab="Hotkeys")
				GoSub, GUI_Settings_Hotkeys_OnActionContentChange_Timer
		}
	}

    Universal_ListViewModifySelectedAction(whichTab, actionType="", actionContent="") {
		global PROGRAM, ACTIONS_WRITE

		actionTypeCtrlName := whichTab="Buying"?"hDDL_CustomizationBuyingActionType"
			: whichTab="Selling"?"hDDL_CustomizationSellingActionType"
			: whichTab="Hotkeys"?"hDDL_HotkeyActionType"
			: ""
		actionContentCtrlName := whichTab="Buying"?"hEDIT_CustomizationBuyingActionContent"
			: whichTab="Selling"?"hEDIT_CustomizationSellingActionContent"
			: whichTab="Hotkeys"?"hEDIT_HotkeyActionContent"
			: ""
			
		; Get informations about modifying this action
		actionType := actionType?actionType: GUI_Settings.Submit(actionTypeCtrlName)
		actionContent := actionContent?actionContent: GUI_Settings.Submit(actionContentCtrlName)
		actionShortName := GUI_Settings.Get_ActionShortName_From_LongName(actionType)
		selectedRow := GUI_Settings.Customization_SellingBuying_GetListviewSelectedRow(whichTab)
		; Get informations about the last action
		LV_GetText(lastActionType, LV_GetCount(), 2), LV_GetText(lastActionContent, LV_GetCount(), 3)
		lastActionShortName := GUI_Settings.Get_ActionShortName_From_LongName(lastActionType)

		; Prevent continuing if action isn't valid
		if !(actionShortName) {
			; MsgBox(4096, "Invalid action name", "Type: """ actionType """"
			; . "`nContent: """ actionContent """"
			; . "`nShort name: """ actionShortName """")
			return
		}
		; Prevent adding action if it does a write/close action and the last action is write
		else if IsIn(actionShortName, ACTIONS_WRITE ",CLOSE_TAB") && ( selectedRow != LV_GetCount() )
		&& IsIn(lastActionShortName, ACTIONS_WRITE) {
			boxTxt := StrReplace(PROGRAM.TRANSLATIONS.MessageBoxes.Settings_LastActionIsWrite, "%thisAction%", actionType)
			boxTxt := StrReplace(boxTxt, "%lastAction%", lastActionType)
			MsgBox(4096, "", boxTxt)
			return
		}
		; Prevent adding action if it does a write/close action and last action is close
		else if IsIn(actionShortName, ACTIONS_WRITE ",CLOSE_TAB") && ( selectedRow != LV_GetCount() )
		&& IsIn(lastActionShortName, "CLOSE_TAB") {
			boxTxt := StrReplace(PROGRAM.TRANSLATIONS.MessageBoxes.Settings_LastActionIsCloseTab, "%thisAction%", actionType)
			boxTxt := StrReplace(boxTxt, "%lastAction%", lastActionType)
			MsgBox(4096, "", boxTxt)
			return
		}
		else {
			LV_Modify(selectedRow, , selectedRow, actionType, actionContent) ; Replacing before last line with our action
		}
		
		GUI_Settings.Universal_AdjustListviewHeaders(whichTab)
		if (whichTab="Selling")
			GoSub, GUI_Settings_Customization_Selling_SaveAllCurrentButtonActions_Timer
		else if (whichTab="Buying")
			GoSub, GUI_Settings_Customization_Buying_SaveAllCurrentButtonActions_Timer
		else if (whichTab="Hotkeys")
			GoSub, GUI_Settings_Hotkeys_SaveAllActions_Timer
	}

    Universal_OnListviewRightClick(whichTab) {
		global ACTIONS_TEXT_NAME, ACTIONS_FORCED_CONTENT
		global GuiSettings, GuiSettings_Controls
		try Menu, RMenu, DeleteAll
		Menu, RMenu, Add, Add a new action, Universal_OnListviewRightClick_AddNewAction
		Menu, RMenu, Add, Remove this action, Universal_OnListviewRightClick_RemoveSelectedAction
		Menu, RMenu, Add
		Menu, RMenu, Add, Move this action up, Universal_OnListviewRightClick_MoveSelectedActionUp
		Menu, RMenu, Add, Move this action down, Universal_OnListviewRightClick_MoveSelectedActionDown

		selectedRow := GUI_Settings.Universal_GetListviewSelectedRow(whichTab)
		if (selectedRow = 1 || !selectedRow)
			Menu, RMenu, Disable, Move this action up
		if (selectedRow = LV_GetCount() || !selectedRow)
			Menu, RMenu, Disable, Move this action down
		if (!selectedRow)
			Menu, RMenu, Disable, Remove this action
		Menu, RMenu, Show
		return

		Universal_OnListviewRightClick_AddNewAction:
			/*
			GUI_Settings.SetDefaultListView("hLV_CustomizationSellingActionsList")
			actionType := GUI_Settings.Submit("hDDL_CustomizationSellingActionType"), AutoTrimStr(actionType)
			actionContent := GUI_Settings.Submit("hEDIT_CustomizationSellingActionContent")
			if (actionType)
			*/
				GUI_Settings.Universal_AddNewAction(whichTab, ACTIONS_TEXT_NAME.SEND_TO_BUYER, ACTIONS_FORCED_CONTENT.SEND_TO_BUYER)
		return

		Universal_OnListviewRightClick_RemoveSelectedAction:
			selectedRow := GUI_Settings.Universal_GetListviewSelectedRow(whichTab)
			if IsNum(selectedRow) && (selectedRow > 0) {
				GUI_Settings.Universal_RemoveAction(whichTab, selectedRow)
			}
		return

		Universal_OnListviewRightClick_MoveSelectedActionUp:
			selectedRow := GUI_Settings.Universal_GetListviewSelectedRow(whichTab)
			GUI_Settings.Universal_MoveActionUp(whichTab, selectedRow)
		return
		Universal_OnListviewRightClick_MoveSelectedActionDown:
			selectedRow := GUI_Settings.Universal_GetListviewSelectedRow(whichTab)
			GUI_Settings.Universal_MoveActionDown(whichTab, selectedRow)
		return
	}

    Universal_MoveActionUp(whichTab, rowNum) {
		global PROGRAM, GuiSettings_Controls, ACTIONS_WRITE
		GUI_Settings.SetDefaultListViewBasedOnTabName(whichTab)

		; Get informations about modifying this action
		lvContent := GUI_Settings.Universal_GetListViewContent(whichTab)
		actionType := lvContent[rowNum].ActionType, actionContent := lvContent[rowNum].ActionContent
		actionShortName := GUI_Settings.Get_ActionShortName_From_LongName(actionType)
		actionNum := rowNum
		; Get informations about the last action
		lastActionType := lvContent[LV_GetCount()].ActionType, lastActionContent := lvContent[LV_GetCount()].ActionContent
		lastActionShortName := GUI_Settings.Get_ActionShortName_From_LongName(lastActionType)
		lastActionNum := lvContent[LV_GetCount()].Num
		
		if IsIn(lastActionShortName, ACTIONS_WRITE)
		&& (lastActionNum = actionNum) {
			MsgBox(4096, "", PROGRAM.TRANSLATIONS.MessageBoxes.Settings_CannotMoveUpBcsItsWrite)
			Return
		}
		else if (lastActionShortName = "CLOSE_TAB")
		&& (lastActionNum = actionNum) {
			MsgBox(4096, "", PROGRAM.TRANSLATIONS.MessageBoxes.Settings_CannotMoveUpBcsItsCloseTab)
			Return
		}

		LV_Modify(rowNum-1, , rowNum-1, lvContent[rowNum].ActionType, lvContent[rowNum].ActionContent) ; Replacing above action with our action
		LV_Modify(rowNum, , rowNum, lvContent[rowNum-1].ActionType, lvContent[rowNum-1].ActionContent) ; Replacing our action with action above

		if (whichTab="Selling")
			GoSub, GUI_Settings_Customization_Selling_SaveAllCurrentButtonActions_Timer
		else if (whichTab="Buying")
			GoSub, GUI_Settings_Customization_Buying_SaveAllCurrentButtonActions_Timer
		else if (whichTab="Hotkeys")
			GoSub, GUI_Settings_Hotkeys_SaveAllActions_Timer
	}

    Universal_MoveActionDown(whichTab, rowNum) {
		global PROGRAM, GuiSettings_Controls, ACTIONS_WRITE
		GUI_Settings.SetDefaultListViewBasedOnTabName(whichTab)

		; Get informations about modifying this action
		lvContent := GUI_Settings.Universal_GetListViewContent(whichTab)
		actionType := lvContent[rowNum].ActionType, actionContent := lvContent[rowNum].ActionContent
		actionShortName := GUI_Settings.Get_ActionShortName_From_LongName(actionType)
		actionNum := rowNum
		; Get informations about the last action
		lastActionType := lvContent[LV_GetCount()].ActionType, lastActionContent := lvContent[LV_GetCount()].ActionContent
		lastActionShortName := GUI_Settings.Get_ActionShortName_From_LongName(lastActionType)
		lastActionNum := lvContent[LV_GetCount()].Num

		if IsIn(lastActionShortName, ACTIONS_WRITE)
		&& (lastActionNum = actionNum+1) {
			boxTxt := StrReplace(PROGRAM.TRANSLATIONS.MessageBoxes.Settings_CannotMoveDownBcsLastIsWrite, "%lastAction%", lastActionType)
			MsgBox(4096, "", boxTxt)
			Return
		}

		else if (lastActionShortName = "CLOSE_TAB")
		&& (lastActionNum = actionNum+1) {
			boxTxt := StrReplace(PROGRAM.TRANSLATIONS.MessageBoxes.Settings_CannotMoveDownBcsLastIsCloseTab, "%lastAction%", lastActionType)
			MsgBox(4096, "", boxTxt)
			Return
		}

		LV_Modify(rowNum+1, , rowNum+1, lvContent[rowNum].ActionType, lvContent[rowNum].ActionContent) ; Replacing under action with our action
		LV_Modify(rowNum, , rowNum, lvContent[rowNum+1].ActionType, lvContent[rowNum+1].ActionContent) ; Replacing our action with action under

		if (whichTab="Selling")
			GoSub, GUI_Settings_Customization_Selling_SaveAllCurrentButtonActions_Timer
		else if (whichTab="Buying")
			GoSub, GUI_Settings_Customization_Buying_SaveAllCurrentButtonActions_Timer
		else if (whichTab="Hotkeys")
			GoSub, GUI_Settings_Hotkeys_SaveAllActions_Timer
	}

    Universal_GetListviewSelectedRow(whichTab) {
		GUI_Settings.SetDefaultListViewBasedOnTabName(whichTab)
		return LV_GetNext(0, "F")
	}

    Universal_RemoveAction(whichTab, actionNum) {
		GUI_Settings.SetDefaultListViewBasedOnTabName(whichTab)
		lvContent := GUI_Settings.Universal_GetListViewContent(whichTab)

		newLvContent := {}
		Loop % lvContent.Count() {
			if (A_Index < actionNum) { ; If lower, just add it
				newLvContent[A_Index] := ObjFullyClone(lvContent[A_Index])
			}
			else if (A_Index > actionNum) { ; If higher, add to index minus one
				newLvContent[A_Index-1] := ObjFullyClone(lvContent[A_Index])
				newLvContent[A_Index-1].Num := lvContent[A_Index].Num - 1
			}
			; notice we don't do anything if equal, effectively skipping
		}
		; Adding new action list
		Loop % LV_GetCount()
			LV_Delete()
		Loop % newLvContent.Count()
			LV_Add("", newLvContent[A_Index].Num, newLvContent[A_Index].ActionType, newLvContent[A_Index].ActionContent)

		GUI_Settings.Universal_AdjustListviewHeaders(whichTab)
		if (whichTab="Selling")
			GoSub, GUI_Settings_Customization_Selling_SaveAllCurrentButtonActions_Timer
		else if (whichTab="Buying")
			GoSub, GUI_Settings_Customization_Buying_SaveAllCurrentButtonActions_Timer
		else if (whichTab="Hotkeys")
			GoSub, GUI_Settings_Hotkeys_SaveAllActions_Timer
	}

    Universal_GetListViewContent(whichTab) {
		GUI_Settings.SetDefaultListViewBasedOnTabName(whichTab)

		content := {}
		Loop % LV_GetCount() {			
			LV_GetText(rowNum, A_Index, 1)
			LV_GetText(actionType, A_Index, 2)
			LV_GetText(actionContent, A_Index, 3)
			content[A_Index] := {Num:rowNum, ActionType:actionType, ActionContent:actioncontent}
		}
		return content
	}

    Universal_AddNewAction(whichTab, actionType, actionContent) {
		global PROGRAM, ACTIONS_WRITE
		global GuiSettings, GuiSettings_Controls
		GUI_Settings.SetDefaultListViewBasedOnTabName(whichTab)
		actionShortName := GUI_Settings.Get_ActionShortName_From_LongName(actionType)
		LV_GetText(lastActionType, LV_GetCount(), 2), LV_GetText(lastActionContent, LV_GetCount(), 3)
		lastActionShortName := GUI_Settings.Get_ActionShortName_From_LongName(lastActionType)
		selectedRow := GUI_Settings.Universal_GetListviewSelectedRow(whichTab)

		; Prevent continuing if action isn't valid
		if !(actionShortName) {
			MsgBox(4096, "Invalid action name", "Type: """ actionType """"
			. "`nContent: """ actionContent """"
			. "`nShort name: """ actionShortName """")
			return
		}
		; Prevent adding action if it does a write/close action and the last action is write
		else if IsIn(actionShortName, ACTIONS_WRITE ",CLOSE_TAB") && ( selectedRow != LV_GetCount() )
		&& IsIn(lastActionShortName, ACTIONS_WRITE) {
			boxTxt := StrReplace(PROGRAM.TRANSLATIONS.MessageBoxes.Settings_LastActionIsWrite, "%thisAction%", actionType)
			boxTxt := StrReplace(boxTxt, "%lastAction%", lastActionType)
			MsgBox(4096, "", boxTxt)
			return
		}
		; Prevent adding action if it does a write/close action and last action is close
		else if IsIn(actionShortName, ACTIONS_WRITE ",CLOSE_TAB") && ( selectedRow != LV_GetCount() )
		&& IsIn(lastActionShortName, "CLOSE_TAB") {
			boxTxt := StrReplace(PROGRAM.TRANSLATIONS.MessageBoxes.Settings_LastActionIsCloseTab, "%thisAction%", actionType)
			boxTxt := StrReplace(boxTxt, "%lastAction%", lastActionType)
			MsgBox(4096, "", boxTxt)
			return
		}

		; Decides where to add the new action
		if IsIn(lastActionShortName, ACTIONS_WRITE ",CLOSE_TAB")
			isLastCloseOrWrite := True
		; Adding the new action
		if (isLastCloseOrWrite) { ; Adding new blank action, then modifying list to accomodate and make new action previous to last
			LV_Add("", LV_GetCount()+1, "", "") ; Adding new line
			LV_Modify(LV_GetCount()-1, , LV_GetCount()-1, actionType, actionContent) ; Replacing before last line with our action
			LV_Modify(LV_GetCount(), , LV_GetCount(), lastActionType, lastActionContent) ; Replacing last line with the old last action
		}
		else ; Just adding the new action at end of list
			LV_Add("", LV_GetCount()+1, actionType, actionContent)

		GUI_Settings.Universal_AdjustListviewHeaders(whichTab)
		if (whichTab="Selling")
			GoSub, GUI_Settings_Customization_Selling_SaveAllCurrentButtonActions_Timer
		else if (whichTab="Buying")
			GoSub, GUI_Settings_Customization_Buying_SaveAllCurrentButtonActions_Timer
		else if (whichTab="Hotkeys")
			GoSub, GUI_Settings_Hotkeys_SaveAllActions_Timer
	}

    Universal_AdjustListviewHeaders(whichTab) {
		GUI_Settings.SetDefaultListViewBasedOnTabName(whichTab)
		Loop 3
			LV_ModifyCol(A_Index, "AutoHdr NoSort")
	}

    Universal_OnListviewClick(whichTab, CtrlHwnd="", GuiEvent="", EventInfo="", GuiEvent2="") {
		GUI_Settings.SetDefaultListViewBasedOnTabName(whichTab)

		selectedRow := GUI_Settings.Universal_GetListviewSelectedRow(whichTab)
		if (!selectedRow)
			return

		lvContent := GUI_Settings.Universal_GetListViewContent(whichTab)
		GUI_Settings.Universal_SetActionType(whichTab, lvContent[selectedRow].ActionType)
		GUI_Settings.Universal_SetActionContent(whichTab, lvContent[selectedRow].ActionContent)
		GUI_Settings.Universal_OnActionTypeChange(whichTab)
	}

    Universal_SetActionType(whichTab, actionType) {
		global GuiSettings_Controls
		actionTypeCtrlName := whichTab="Buying"?"hDDL_CustomizationBuyingActionType"
			: whichTab="Selling"?"hDDL_CustomizationSellingActionType"
			: whichTab="Hotkeys"?"hDDL_HotkeyActionType"
			: ""
		ctrlHwnd := GuiSettings_Controls[actionTypeCtrlName]
		GuiControl, Settings:ChooseString,% ctrlHwnd,% actionType
	}

    Universal_SetActionContent(whichTab, actionContent) {
		global GuiSettings_Controls
		actionContentCtrlName := whichTab="Buying"?"hEDIT_CustomizationBuyingActionContent"
			: whichTab="Selling"?"hEDIT_CustomizationSellingActionContent"
			: whichTab="Hotkeys"?"hEDIT_HotkeyActionContent"
			: ""
		ctrlHwnd := GuiSettings_Controls[actionContentCtrlName]
		GuiControl, Settings:,% ctrlHwnd,% actionContent
	}

	/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
	*	GENERAL FUNCTIONS
	*/

	DragGui(GuiHwnd) {
		PostMessage, 0xA1, 2,,,% "ahk_id " GuiHwnd
	}

	Close() {
		global PROGRAM
		Gui, Settings:Hide
		GUI_Settings.TabCustomizationSkins_RecreateTradesGUI()
	}

	OnPictureLinkClick(picName) {
		global PROGRAM

		urlLink := picName="Paypal"?PROGRAM.LINK_SUPPORT
		: picName="Discord"?PROGRAM.LINK_DISCORD
		: picName="Reddit"?PROGRAM.LINK_REDDIT
		: picName="PoE"?PROGRAM.LINK_GGG
		: picName="GitHub"?PROGRAM.LINK_GITHUB
		: ""

		if (urlLink)
			Run,% urlLink
	}

	OnLanguageChange(lang) {
		global PROGRAM, GuiSettings, GuiMyStats
		static prevLang
		prevLang := prevLang?prevLang:PROGRAM.SETTINGS.GENERAL.Language

		PROGRAM.SETTINGS.GENERAL.Language := lang
		Save_LocalSettings()
		PROGRAM.TRANSLATIONS := GetTranslations(lang)
		
		TrayMenu() ; Re-creating tray menu
		settingsWinExists := WinExist("ahk_id " GuiSettings.Handle)
		if (settingsWinExists) {
			if (lang = prevLang)
				GUI_Settings.SetTranslation(lang)
			else {
				GUI_Settings.Create()
				GUI_Settings.Show()
			}
		}
		else
			GUI_Settings.Create()
		statsWinExists := WinExist("ahk_id " GuiMyStats.Handle)
		if (statsWinExists)
			GUI_MyStats.SetTranslation(lang)

		prevLang := lang
	}

	Show(whichTab="Settings") {
		global PROGRAM, GuiSettings, GuiTrades

		hiddenWin := A_DetectHiddenWindows
		DetectHiddenWindows, On
		foundHwnd := WinExist("ahk_id " GuiSettings.Handle)
		DetectHiddenWindows, %hiddenWin%

		if (foundHwnd) {
			GUI_Settings.SetTranslation(PROGRAM.SETTINGS.GENERAL.Language)
			if !(GuiTrades.SellPreview.Handle) {
				GUI_Trades_V2.Create(1, buyOrSell:="Sell", slotsOrTab:="Tabs", preview:=True)
				Parse_GameLogs("2017/06/04 17:31:02 105384166 355 [INFO Client 6416] @From SensualApples: Hi, I would like to buy your Shaped Beach Map (T6) listed for 1 chaos in Standard offer 3 alch?", preview:=True)
			}
			if !(GuiTrades.BuyPreview.Handle) {
				GUI_Trades_V2.Create(1, buyOrSell:="Buy", slotsOrTab:="Slots", preview:=True)
				Parse_GameLogs("2017/06/04 17:31:02 105384166 355 [INFO Client 6416] @To SensualApples: Hi, I would like to buy your Shaped Beach Map (T6) listed for 1 chaos in Standard offer 3 alch?", preview:=True)
			}
			Gui, Settings:Show, xCenter yCenter

			Gui_Settings.OnTabBtnClick(whichTab)
		}
		else {
			AppendToLogs("GUI_Settings.Show(" whichTab "): Non existent. Recreating.")
			GUI_Settings.Create()
			GUI_Settings.SetTranslation(PROGRAM.SETTINGS.GENERAL.Language)
			GUI_Settings.Show()
		}
	}

	ResetToDefaultSettings() {
		global PROGRAM

		boxTxt := StrReplace(PROGRAM.TRANSLATIONS.MessageBoxes.Settings_ConfirmResetToDefault, "%folder%", PROGRAM.MAIN_FOLDER)
		MsgBox(4096+48+4, "", boxTxt)

		IfMsgBox, Yes
		{
			settingsFile := PROGRAM.SETTINGS_FILE
			SplitPath, settingsFile, fileName, folder
			FileMove,% settingsFile,% folder "\" A_Now "_" fileName, 1
			Reload()
		}
	}

	Get_ActionForcedContent_From_ActionShortName(actionShortName) {
		global ACTIONS_FORCED_CONTENT

		forcedContent := ""
		for sName, fContent in ACTIONS_FORCED_CONTENT {
			if (sName = actionShortName) {
				forcedContent := fContent
				Break
			}
		}
		return forcedContent
	}

	Hotkey_OnSpecialKeyPress(CtrlHwnd, keyStr) {
		global GuiSettings, GuiSettings_Controls

		if (CtrlHwnd = GuiSettings_Controls.hHK_HotkeyAdvHotkey) {
			GUI_Settings.TabHotkeysAdvanced_SetHotkeyKeys(keyStr)
			GUI_Settings.TabHotkeysAdvanced_OnHotkeyKeysChange()
		}
		else if IsIn(CtrlHwnd, GuiSettings.TabHotkeysBasic_HotkeysCtrlList) {
			GUI_Settings.TabHotkeysBasic_SetHotkeyKeys(CtrlHwnd, keyStr)
			GUI_Settings.TabHotkeysBasic_OnHotkeyKeysChange(CtrlHwnd)
		}
		else {
			MsgBox YOU SOULD NOT SEE THIS`nFunc: %A_ThisFunc%`nCtrl: %CtrlHwnd_Or_CtrlNum%
		}
	}

	Get_ActionContentPlaceholder_From_ShortName(shortName) {
		global ACTIONS_DEFAULT_CONTENT
		return ACTIONS_DEFAULT_CONTENT[shortName]
	}

	Get_ActionLongName_From_ShortName(shortName) {
		global ACTIONS_TEXT_NAME

		return ACTIONS_TEXT_NAME[shortName]
	}

	Get_ActionShortName_From_LongName(longName) {
		global ACTIONS_TEXT_NAME

		for sName, lName in ACTIONS_TEXT_NAME
			if (lName = longName)
				return sName
	}

	OnTabBtnClick(whichTab) {
		global GuiTrades
		global GuiSettings, GuiSettings_Controls
		static prevTab

		GuiControl, Settings:ChooseString,% GuiSettings_Controls.hTab_AllTabs,% whichTab

		GuiControl, Settings:+Disabled,% GuiSettings_Controls["hBTN_Tab" whichTab]
		GuiControl, Settings:-Disabled,% GuiSettings_Controls["hBTN_Tab" prevTab]
		prevTab := whichTab
		
		if (whichTab = "Selling") {
			Gui, TradesSellPreview:+LastFound +AlwaysOnTop
			Gui, TradesSellPreview:Show, x10 y65
			GUI_Settings.Customization_Selling_AdjustPreviewControls()
		}
		else
			Gui, TradesSellPreview:Hide

		if (whichTab = "Buying") {
			Gui, TradesBuyPreview:+LastFound +AlwaysOnTop
			Gui, TradesBuyPreview:Show, x10 y65
			GUI_Settings.Customization_Buying_AdjustPreviewControls()
		}
		else
			Gui, TradesBuyPreview:Hide
	}

	Submit(CtrlName="") {
		global GuiSettings_Submit
		Gui.Submit("Settings")

		if (CtrlName) {
			Return GuiSettings_Submit[ctrlName]
		}
	}

	ContextMenu(CtrlHwnd, CtrlName) {
		global PROGRAM, GuiSettings
		
	}

	GetControlToolTip(ctrlName) {
		global PROGRAM, DEBUG
		
		_tip := (ctrlName = "hSLIDER_NoTabsTransparency") ? 	PROGRAM.TRANSLATIONS.GUI_Settings["hTEXT_NoTabsTransparency_ToolTip"]
			: (ctrlName = "hSLIDER_TabsOpenTransparency") ? 	PROGRAM.TRANSLATIONS.GUI_Settings["hTEXT_TabsOpenTransparency_ToolTip"]
			: (ctrlName = "hEDIT_TradingWhisperSFXPath") ? 		PROGRAM.TRANSLATIONS.GUI_Settings["hCB_TradingWhisperSFXToggle_ToolTip"]
			: (ctrlName = "hEDIT_RegularWhisperSFXPath") ? 		PROGRAM.TRANSLATIONS.GUI_Settings["hCB_RegularWhisperSFXToggle_ToolTip"]
			: (ctrlName = "hEDIT_BuyerJoinedAreaSFXPath") ? 	PROGRAM.TRANSLATIONS.GUI_Settings["hCB_BuyerJoinedAreaSFXToggle_ToolTip"]
			: (ctrlName = "hEDIT_PushBulletToken") ? 			PROGRAM.TRANSLATIONS.GUI_Settings["hTEXT_PushBulletToken_ToolTip"]
			: (ctrlName = "hTEXT_GetPBNotificationsFor") ? 		PROGRAM.TRANSLATIONS.GUI_Settings["hTEXT_PushBulletNotifications_ToolTip"]
			: (ctrlName = "hEDIT_PoeAccounts") ? 				PROGRAM.TRANSLATIONS.GUI_Settings["hTEXT_POEAccountsList_ToolTip"]
			: (ctrlName = "hLB_SkinPreset") ? 					PROGRAM.TRANSLATIONS.GUI_Settings["hTEXT_Preset_ToolTip"]
			: (ctrlName = "hLB_SkinBase") ? 					PROGRAM.TRANSLATIONS.GUI_Settings["hTEXT_SkinBase_ToolTip"]
			: (ctrlName = "hLB_SkinFont") ? 					PROGRAM.TRANSLATIONS.GUI_Settings["hTEXT_TextFont_ToolTip"]
			: IsIn(ctrlName, "hEDIT_SkinScalingPercentage,hUPDOWN_SkinScalingPercentage") ?		PROGRAM.TRANSLATIONS.GUI_Settings["hTEXT_ScalingSize_ToolTip"]
			: IsIn(ctrlName, "hEDIT_SkinFontSize,hUPDOWN_SkinFontSize") ? 						PROGRAM.TRANSLATIONS.GUI_Settings["hTEXT_FontSize_ToolTip"]
			: IsIn(ctrlName, "hEDIT_SkinFontQuality,hUPDOWN_SkinFontQuality") ?	 				PROGRAM.TRANSLATIONS.GUI_Settings["hTEXT_FontQuality_ToolTip"]
			: IsIn(ctrlName, "hDDL_ChangeableFontColorTypes,hPROGRESS_ColorSquarePreview") ? 	PROGRAM.TRANSLATIONS.GUI_Settings["hTEXT_TextColor_ToolTip"]
			: IsContaining(ctrlName, "hBTN_CustomBtn_") ? 			PROGRAM.TRANSLATIONS.GUI_Settings["hBTN_CustomBtn_1_ToolTip"]
			: IsContaining(ctrlName, "hTEXT_CustomBtnSlot_") ? 		PROGRAM.TRANSLATIONS.GUI_Settings["hTEXT_CustomBtnSlot_1_ToolTip"]
			: IsContaining(ctrlName, "hBTN_UnicodeBtn_") ? 			PROGRAM.TRANSLATIONS.GUI_Settings["hBTN_UnicodeBtn_1_ToolTip"]
			: IsContaining(ctrlName, "hTEXT_UnicodeBtnSlot_") ?		PROGRAM.TRANSLATIONS.GUI_Settings["hTEXT_UnicodeBtnSlot_1_ToolTip"]
			: IsContaining(ctrlName, "hDDL_HotkeyActionType") ? 	PROGRAM.TRANSLATIONS.GUI_Settings["hDDL_HotkeyActionType1_ToolTip"]
			: IsContaining(ctrlName, "hEDIT_HotkeyActionContent") ? PROGRAM.TRANSLATIONS.GUI_Settings["hEDIT_HotkeyActionContent1_ToolTip"]
			: IsContaining(ctrlName, "hCB_HotkeyToggle") ?		 	PROGRAM.TRANSLATIONS.GUI_Settings["hCB_HotkeyToggle1_ToolTip"]
			: IsContaining(ctrlName, "hHK_HotkeyKeys") ? 			PROGRAM.TRANSLATIONS.GUI_Settings["hHK_HotkeyKeys1_ToolTip"]
			: PROGRAM.TRANSLATIONS.GUI_Settings[ctrlName "_ToolTip"]

		if (DEBUG.SETTINGS.instant_settings_tooltips)
			_tip := _tip? _tip "`n`n" ctrlName : "No tooltip for this control`n`n" ctrlName

		if (DEBUG.SETTINGS.settings_copy_ctrlname && ctrlName)
			Set_Clipboard(ctrlName)

		return _tip
	}

	DestroyBtnImgList() {
		global GuiSettings_Controls

		for key, value in GuiSettings_Controls
			IsContaining(key, "hBTN_")
				try ImageButton.DestroyBtnImgList(value)
	}

	Redraw() {
		Gui, Settings: +LastFound
		WinSet, Redraw
	}

	SetDefaultListViewBasedOnTabName(tabName) {
		lvCtrlName := tabName="Selling"?"hLV_CustomizationSellingActionsList"
			: tabName="Buying"?"hLV_CustomizationBuyingActionsList"
			: tabName="Hotkeys"?"hLV_HotkeyActionsList"
			: ""
		GUI_Settings.SetDefaultListView(lvCtrlName)
	}

	SetDefaultListView(lvName) {
        global GuiSettings_Controls
        Gui, Settings:Default
        Gui, Settings:ListView,% GuiSettings_Controls[lvName]
    }

	Destroy() {
		GUI_Settings.DestroyBtnImgList()
		Gui.Destroy("Settings")
	}

	SetTranslation(_lang="english", _ctrlName="") {
		global PROGRAM, GuiSettings, GuiSettings_Controls
		return
		trans := PROGRAM.TRANSLATIONS.Gui_Settings

		GUI_Settings.DestroyBtnImgList()

		noResizeCtrls := "hBTN_CloseGUI"
		. ",hBTN_SectionSettings,hBTN_TabSettingsMain,hBTN_SectionCustomization,hBTN_TabCustomizationSkins,hBTN_TabCustomizationButtons,hBTN_SectionHotkeys,hBTN_TabHotkeysBasic,hBTN_TabHotkeysAdvanced,hBTN_SectionMisc,hBTN_TabMiscUpdating,hBTN_TabMiscAbout,hBTN_ResetToDefaultSettings"
		. ",hLV_ButtonsActions,hLV_HotkeyAdvActionsList"
		. ",hBTN_SaveChangesToAction,hBTN_AddAsNewAction"
		. ",hBTN_ChangeHKType,hBTN_HotkeyAdvSaveChangesToAction,hBTN_HotkeyAdvAddAsNewAction"
		. ",hDDL_CheckForUpdate"

		noSmallerCtrls := "hBTN_BrowseTradingWhisperSFX,hBTN_BrowseRegularWhisperSFX,hBTN_BrowseBuyerJoinedAreaSFX"
		. ",hCB_SendTradingWhisperUponCopyWhenHoldingCTRL,hCB_ShowTabbedTrayNotificationOnWhisper,hTEXT_POEAccountsList"
		. ",hCB_AllowClicksToPassThroughWhileInactive,hTEXT_NoTabsTransparency,hTEXT_TabsOpenTransparency"
		. ",hTEXT_Preset,hTEXT_SkinBase,hTEXT_TextFont,hBTN_RecreateTradesGUI"
		. ",hTEXT_ButtonsTabTopTip,hTEXT_ButtonsTabTopTip2"
		. ",hTEXT_About,hBTN_CheckForUpdates"

		needsCenterCtrls := "hCB_SendTradingWhisperUponCopyWhenHoldingCTRL,hCB_ShowTabbedTrayNotificationOnWhisper,hTEXT_POEAccountsList,hCB_AllowClicksToPassThroughWhileInactive,hTEXT_NoTabsTransparency,hTEXT_TabsOpenTransparency,hTEXT_Preset"
		. ",hTEXT_SkinBase,hTEXT_TextFont"
		. ",hTEXT_ButtonsTabTopTip,hTEXT_ButtonsTabTopTip2"
		. ",hTEXT_About"

		if (_ctrlName) {
			if (trans != "") ; selected trans
				GuiControl, Settings:,% GuiSettings_Controls[_ctrlName],% trans
		}
		else {
			for ctrlName, ctrlTranslation in trans {
				if !( SubStr(ctrlName, -7) = "_ToolTip" ) { ; if not a tooltip
					ctrlHandle := GuiSettings_Controls[ctrlName]

					ctrlType := IsContaining(ctrlName, "hCB_") ? "CheckBox"
							: IsContaining(ctrlName, "hTEXT_") ? "Text"
							: IsContaining(ctrlName, "hBTN_") ? "Button"
							: IsContaining(ctrlName, "hDDL_") ? "DropDownList"
							: IsContaining(ctrlName, "hEDIT_") ? "Edit"
							: IsContaining(ctrlName, "hGB_") ? "GroupBox"
							: IsContaining(ctrlName, "hLV_") ? "ListView"
							: "Text"	

					if !IsIn(ctrlName, noResizeCtrls) { ; Readjust size to fit translation
						txtSize := Get_TextCtrlSize(txt:=ctrlTranslation, fontName:=GuiSettings.Font, fontSize:=GuiSettings.Font_Size, maxWidth:="", params:="", ctrlType)
						txtPos := Get_ControlCoords("Settings", ctrlHandle)

						if (IsIn(ctrlName, noSmallerCtrls) && (txtSize.W > txtPos.W))
						|| !IsIn(ctrlName, noSmallerCtrls)
							GuiControl, Settings:Move,% ctrlHandle,% "w" txtSize.W
					}

					if (ctrlHandle) { ; set translation
						if (ctrlType = "DropDownList")
							ddlValue := GUI_Settings.Submit(ctrlName), ctrlTranslation := "|" ctrlTranslation

						if (ctrlTranslation != "") { ; selected trans
							if (ctrlType = "ListView") {
								GUI_Settings.SetDefaultListView(ctrlName)
								Loop, Parse, ctrlTranslation, |
									LV_ModifyCol(A_Index, Options, A_LoopField)
							}
							GuiControl, Settings:,% ctrlHandle,% ctrlTranslation
						}

						if (ctrlType = "DropDownList")
							GuiControl, Settings:Choose,% ctrlHandle,% ddlValue
					}

					if IsIn(ctrlName, needsCenterCtrls) {
						GuiControl, Settings:-Center,% ctrlHandle
						GuiControl, Settings:+Center,% ctrlHandle
					}

					if IsContaining(ctrlName, "hBTN_Section") ; Imgbtn section
						ImageButton.Create(ctrlHandle, GuiSettings.Style_Section, PROGRAM.FONTS["Segoe UI"], 8)
					else if IsContaining(ctrlName, "hBTN_Tab") ; Imgbtn tab
						ImageButton.Create(ctrlHandle, GuiSettings.Style_Tab, PROGRAM.FONTS["Segoe UI"], 8)
					else if (ctrlName = "hBTN_ResetToDefaultSettings") ; Imgbtn reset settings
						ImageButton.Create(ctrlHandle, GuiSettings.Style_ResetBtn, PROGRAM.FONTS["Segoe UI"], 8)	
				}
			}
			
			GuiControl, Settings:,% GuiSettings_Controls["hBTN_CloseGUI"],% "X"
			ImageButton.Create(GuiSettings_Controls["hBTN_CloseGUI"], GuiSettings.Style_RedBtn, PROGRAM.FONTS["Segoe UI"], 8)						
		}

		GUI_Settings.Redraw()
	}
}

/*
	Labels 
*/

GUI_Settings_Customization_Selling_SaveAllCurrentButtonActions:
	global SaveAllCurrentSellingActions_After500ms
	GUI_Settings.Customization_Selling_SaveAllCurrentButtonActions(isTimedSave:=True)
	if (SaveAllCurrentSellingActions_After500ms=True) {
		SaveAllCurrentSellingActions_After500ms := False
		GoSub GUI_Settings_Customization_Selling_SaveAllCurrentButtonActions_Timer_2
	}
return
GUI_Settings_Customization_Selling_SaveAllCurrentButtonActions_Timer:
	global SaveAllCurrentSellingActions_After500ms
	SaveAllCurrentSellingActions_After500ms := True
	SetTimer, GUI_Settings_Customization_Selling_SaveAllCurrentButtonActions, Delete
	SetTimer, GUI_Settings_Customization_Selling_SaveAllCurrentButtonActions, -500
return
GUI_Settings_Customization_Selling_SaveAllCurrentButtonActions_Timer_2:
	; Starts 500ms after saving to make sure save is ok
	global SaveAllCurrentSellingActions_After500ms
	SetTimer, GUI_Settings_Customization_Selling_SaveAllCurrentButtonActions, Delete
	SetTimer, GUI_Settings_Customization_Selling_SaveAllCurrentButtonActions, -500
return

GUI_Settings_Customization_Buying_SaveAllCurrentButtonActions:
	global SaveAllCurrentBuyingActions_After500ms
	GUI_Settings.Customization_Buying_SaveAllCurrentButtonActions(isTimedSave:=True)
	if (SaveAllCurrentBuyingActions_After500ms=True) {
		SaveAllCurrentBuyingActions_After500ms := False
		GoSub GUI_Settings_Customization_Buying_SaveAllCurrentButtonActions_Timer_2
	}
return
GUI_Settings_Customization_Buying_SaveAllCurrentButtonActions_Timer:
	global SaveAllCurrentBuyingActions_After500ms
	SaveAllCurrentBuyingActions_After500ms := True
	SetTimer, GUI_Settings_Customization_Buying_SaveAllCurrentButtonActions, Delete
	SetTimer, GUI_Settings_Customization_Buying_SaveAllCurrentButtonActions, -500
return
GUI_Settings_Customization_Buying_SaveAllCurrentButtonActions_Timer_2:
	; Starts 500ms after saving to make sure save is ok
	global SaveAllCurrentBuyingActions_After500ms
	SetTimer, GUI_Settings_Customization_Buying_SaveAllCurrentButtonActions, Delete
	SetTimer, GUI_Settings_Customization_Buying_SaveAllCurrentButtonActions, -500
return

GUI_Settings_Hotkeys_SaveAllActions:
	global SaveAllHotkeysActions_After500ms
	GUI_Settings.Universal_SaveAllActions("Hotkeys", isTimedSave:=True)
	if (SaveAllHotkeysActions_After500ms=True) {
		SaveAllHotkeysActions_After500ms := False
		GoSub GUI_Settings_Hotkeys_SaveAllActions_Timer_2
	}
return
GUI_Settings_Hotkeys_SaveAllActions_Timer:
	global SaveAllHotkeysActions_After500ms
	SaveAllHotkeysActions_After500ms := True
	SetTimer, GUI_Settings_Hotkeys_SaveAllActions, Delete
	SetTimer, GUI_Settings_Hotkeys_SaveAllActions, -500
return
GUI_Settings_Hotkeys_SaveAllActions_Timer_2:
	; Starts 500ms after saving to make sure save is ok
	global SaveAllHotkeysActions_After500ms
	SetTimer, GUI_Settings_Hotkeys_SaveAllActions, Delete
	SetTimer, GUI_Settings_Hotkeys_SaveAllActions, -500
return


GUI_Settings_Customization_Selling_OnActionContentChange:
	GUI_Settings.Customization_Selling_OnActionContentChange(doAgainAfter500ms:=False)
return
GUI_Settings_Customization_Selling_OnActionContentChange_Timer:
	SetTimer, GUI_Settings_Customization_Selling_OnActionContentChange, Delete
	SetTimer, GUI_Settings_Customization_Selling_OnActionContentChange, -500
return

GUI_Settings_Customization_Buying_OnActionContentChange:
	GUI_Settings.Customization_Buying_OnActionContentChange(doAgainAfter500ms:=False)
return
GUI_Settings_Customization_Buying_OnActionContentChange_Timer:
	SetTimer, GUI_Settings_Customization_Buying_OnActionContentChange, Delete
	SetTimer, GUI_Settings_Customization_Buying_OnActionContentChange, -500
return

GUI_Settings_Hotkeys_OnActionContentChange:
	GUI_Settings.Universal_OnActionContentChange("Hotkeys", doAgainAfter500ms:=False)
return
GUI_Settings_Hotkeys_OnActionContentChange_Timer:
	SetTimer, GUI_Settings_Hotkeys_OnActionContentChange, Delete
	SetTimer, GUI_Settings_Hotkeys_OnActionContentChange, -500
return

GUI_Settings_Hotkeys_OnHotkeyProfileNameChange:
	GUI_Settings.TabHotkeys_OnHotkeyProfileNameChange(doAgainAfter500ms:=False)
return
GUI_Settings_Hotkeys_OnHotkeyProfileNameChange_Timer:
	SetTimer, GUI_Settings_Hotkeys_OnHotkeyProfileNameChange, Delete
	SetTimer, GUI_Settings_Hotkeys_OnHotkeyProfileNameChange, -500
return


GUI_Settings_TabCustomizationSkins_OnScalePercentageChange_Sub:
	GuiControl, Settings:ChooseString,% GuiSettings_Controls.hLB_SkinPreset,% "User Defined"
	GUI_Settings.TabCustomizationSkins_SaveSettings()
return
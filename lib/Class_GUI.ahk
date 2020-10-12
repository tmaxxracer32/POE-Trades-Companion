/*	Class GUI by lemasato
	www.github.com/lemasato

	Usage example:
class CUSTOM_GUI {
    Create() {
        this.CustomGui := new GUI("CustomGui", "HwndhCustomGui", "My Custom Gui")
        this.CustomGui.Add("Button", "x5 y5 hwndhBTN_MyButton w150 h30", "My Button")
        this.CustomGui.Add("Edit", "xp y+5 hwndhEDIT_MyEdit wp R1", "Edit Field")
        this.CustomGui.BindWindowsMessage(this.__class, 0x200, "WM_MOUSEMOVE")
        this.CustomGui.BindFunctionToControl(this.__class, "hBTN_MyButton", "ShowMsgBox", "It's working!")
        this.CustomGui.BindFunctionToControl(this.__class, "hEDIT_MyEdit", "ShowEditBoxToolTip", "Edit box content:`n%content%")
        this.CustomGui.Show("xCenter yCenter")
    }

    ShowMsgBox(msg) {
        MsgBox,% msg
    }

    ShowEditBoxToolTip(str) {
        str := StrReplace(str, "%content%", this.CustomGui.GetControlContent("hEDIT_MyEdit"))
        ShowToolTip(str)
    }
    
    ShowToolTip(msg) {
        ToolTip % msg
    }

    WM_MOUSEMOVE() {
        if !(A_Gui)
            return
        static prev_mouseX, prev_MouseY
        MouseGetPos, mouseX, mouseY
        if (mouseX = prev_mouseX && mouseY = prev_mouseY)
            return

        prev_mouseX := mouseX, prev_mouseY := mouseY
        this.ShowToolTip("You are now hovering the`nmouse across GUI " A_Gui)
        __f := this["ShowToolTip"].bind(this, "")
        SetTimer,% __f, Delete
        SetTimer,% __f, -1200
        return
    }
}

	Changelogs:
	1.1		/   07 Aug 2018   / Completely adapted for usage of the "this" variable
								One benefit is that global scope with dynamic variable names is no longer neccessary
								Added ThrowError() function
								Instead of having multiple global variables for Controls,Functions,Etc... it's now all into a single nested object
	1.0.?	/ 	     ?		  / Various undocumented changes
	1.0		/ 	     ?		  / Initial release
*/

/*
    TO_DO
    Bold,Italic,Etc
*/

class GUI {

	__New(guiName, opts="", title="") {

        separated_opts := this.SeparateSpecialParamsAndValue(opts)
        normal_opts := separated_opts.NormalOpts, special_opts := separated_opts.SpecialOpts

        Loop, Parse, normal_opts,% A_Space
        {
            thisOpt := A_LoopField
            if ( SubStr(thisOpt, 1, 4) = "hwnd" ) ; Retrieve handle name for later usage
                guiHandleName := SubStr(thisOpt, 5)
            else if ( SubStr(thisOpt, 1, 1) = "w" ) && ( IsNum(SubStr(thisOpt, 2)) ) ; Retrieve width for later usage
                guiWidth := SubStr(thisOpt, 2)
            else if ( SubStr(thisOpt, 1, 1) = "h" ) && ( IsNum(SubStr(thisOpt, 2)) ) ; Retrieve height for later usage
                guiHeight := SubStr(thisOpt, 2)
        }
        if (guiHandleName = "") ; Make sure GUI has associated handle name
            guiHandleName := guiName, normal_opts .= " hwnd" guiHandleName
        if IsNum(guiWidth)
            normal_opts := StrReplace(normal_opts, "w" guiWidth), this.Width := guiWidth
        if IsNum(guiHeight)
            normal_opts := StrReplace(normal_opts, "h" guiHeight), this.Height := guiHeight

        ; ; Reset the GUI
        if ( this.Name )
		    this.Destroy()
		Gui, %guiName%:New, %normal_opts%, %title%

        ; Reset its associated arrays
        this.Controls := {}, this.ControlsContents := {}, this.BoundFunctions := {}, this.BoundWindowsMessages := {}, this.ImageButtonErrors := {}
		this.Name := guiName, this.Title := title, this.Handle := %guiHandleName%, this.Children := {}

        ; Set default stuff
        if (special_opts.Font)
            this.SetFont(special_opts.Font)
        else this.SetFont("Segoe UI")
        
        if (special_opts.FontSize)
            this.SetFontSize(special_opts.FontSize)
        else this.SetFontSize(8)
        
        if (special_opts.FontQuality)
            this.SetFontQuality(special_opts.FontQuality)
        else this.SetFontQuality(5)
	}
    
    NewChild(childName, childOpts="", childTitle="") {
        return this.Children[childName] := new GUI(this.Name childName, childOpts " +Parent" this.Name, childTitle)
    }

    SeparateSpecialParamsAndValue(opts) {
        SpecialOptsAvailable := ["FontSize", "FontQuality", "Font", "ControlChooseString", "CenterVertical", "Bold", "Italic", "Strike", "Underline"]
        SpecialOpts := {}, opts_original := opts

		; Parsing parameters
		Loop, Parse, opts_original,% A_Space
		{
			thisOpt := A_LoopField
            thisOpt_end += StrLen(A_LoopField)
            thisOpt_start := thisOpt_end - StrLen(A_LoopField) + 1
            
			; SpecialOpts
			for index, sOpt in SpecialOptsAvailable {
                
                if IsIn( SubStr(thisOpt, 1, 1), "+" ) ; Remove + or - if part of param
                    thisOpt := SubStr(thisOpt, 2)

                len := StrLen(sOpt), param := SubStr(thisOpt, 1, len)
				if (param = sOpt) {
                    if (sOpt = "Font") {
                        RegExMatch(opts_original,"iO)" param "'(.*?)'", out, thisOpt_start) ; Font name needs to be between ''
                        value := out.1, thisOpt := out.0
                    }
                    else
                        value := SubStr(thisOpt, len+1) ; Separate param and value
					opts := StrReplace(opts, thisOpt, "")
					SpecialOpts[param] := value
					Break
				}
			}
		}
        return {SpecialOpts:SpecialOpts, NormalOpts:opts}
    }

    __Delete() {
        ; this.Destroy()
    }

    AddImageButton(opts="", content="", imgBtnStyle="", imageBtnFontHandle="", imageBtnFontSize="") {
        this.Add("ImageButton", opts, content, imgBtnStyle, imageBtnFontHandle, imageBtnFontSize)
    }

    ThrowError(errors) {
        if IsObject(errors)
            if (errors.1.1)
                Loop % errors.Count()
                    msg := A_Index ". " errors[A_Index].1 " (" errors[A_Index].2 ")", fullMsg .= fullMsg ? "`n" msg : msg
            else
                fullMsg := errors.1 " (" errors.2 ")"
        else
            fullMsg := errors
        Throw Exception(fullMsg, -2)
    }

    ImageButtonUpdate(ctrlHandleName="", imageBtnStyle="", imageBtnFontHandle="", imageBtnFontSize="") {
        errorsObj := []
        if !(this.Controls[ctrlHandleName])
            errorsObj.Push(["Handle name does not refer to any existing control", ctrlHandleName])
        if !IsObject(imageBtnStyle)
            errorsObj.Push(["ImageButton Style is not an array", imageBtnStyle])
        if (imageBtnFontHandle != "" && !imageBtnFontHandle)
            errorsObj.Push(["ImageButton Font Handle is invalid", imageBtnFontHandle])
        if (imageBtnFontSize && !IsNum(imageBtnFontSize))
            errorsObj.Push(["ImageButton Font Size is not a number", imageBtnFontSize])
        if (errorsObj)
            this.ThrowError(errorsObj)

		success := ImageButton.Create(this.Controls[ctrlHandleName], imageBtnStyle, imageBtnFontHandle, imageBtnFontSize)
        if !(success)
            this.ThrowError([["ImageButton.LastError", ImageButton.LastError]
            , ["Control", ctrlHandleName]
            , ["Handle", this.Controls[ctrlHandleName]]
            , ["ImageButton Font Handle", imageBtnFontHandle]
            , ["ImageButton Font Size", imageBtnFontSize]
            , ["ImageButton Style", JSON_Dump(imageBtnStyle)]])
	}

	ImageButtonChangeCaption(ctrlHandleName="", btnCaption="", imageBtnStyle="", imageBtnFontHandle="", imageBtnFontSize="") {
        errorsObj := []
        if !(this.Controls[ctrlHandleName])
            errorsObj.Push(["Handle name does not refer to any existing control", ctrlHandleName])
        if !IsObject(imageBtnStyle)
            errorsObj.Push(["ImageButton Style is not an array", imageBtnStyle])
        if (imageBtnFontHandle != "" && !imageBtnFontHandle)
            errorsObj.Push(["ImageButton Font Handle is invalid", imageBtnFontHandle])
        if (imageBtnFontSize && !IsNum(imageBtnFontSize))
            errorsObj.Push(["ImageButton Font Size is not a number", imageBtnFontSize])
        if (errorsObj)
            this.ThrowError(errorsObj)

		ControlSetText, , %btnCaption%,% "ahk_id " this.Controls[ctrlHandleName] ; Set caption text
		while (curCaption != btnCaption) { ; Make sure that caption is changed before continuing
			ControlGetText, curCaption, ,% "ahk_id " this.Controls[ctrlHandleName]
			ControlSetText, , %btnCaption%,% "ahk_id " this.Controls[ctrlHandleName]
			Sleep 1
		}
		; Calling imagebutton to set new caption
		success := !ImageButton.Create(btnHwnd, imageBtnStyle, imageBtnFontHandle, imageBtnFontSize)
		if !(success)
            this.ThrowError([["ImageButton.LastError", ImageButton.LastError]
            , ["Control", ctrlHandleName]
            , ["Handle", this.Controls[ctrlHandleName]]
            , ["Caption", btnCaption]
            , ["ImageButton Font Handle", imageBtnFontHandle]
            , ["ImageButton Font Size", imageBtnFontSize]
            , ["ImageButton Style", JSON_Dump(imageBtnStyle)]])
	}

    Add(ctrlType="", opts="", content="", imageBtnStyle="", imageBtnFontHandle="", imageBtnFontSize="") {
        if !IsIn(ctrlType,"Text,Edit,UpDown,Picture,Button,Checkbox,Radio,DropDownList,ComboBox,ListBox,ListView,TreeView,Link,Hotkey"
        . ",DateTime,MonthCal,Slider,Progress,GroupBox,Tab,Tab2,Tab3,StatusBar,ActiveX,Custom,Picture,ImageButton")
            this.ThrowError(["Control type is not alllowed", ctrlType])

        guiName := this.Name

        separated_opts := this.SeparateSpecialParamsAndValue(opts)
        normal_opts := separated_opts.NormalOpts, special_opts := separated_opts.SpecialOpts

        Loop, Parse, normal_opts,% A_Space
        {
            thisOpt := A_LoopField
            ; Getting handle and var name for later use
            if ( SubStr(thisOpt, 1, 4) = "hwnd" )
                ctrlHandleName := SubStr(thisOpt, 5)
            else if ( SubStr(thisOpt, 1, 2) = "v" )
                ctrlVariableName := SubStr(thisOpt, 5)
        }

		; Changing font based on special opt
		if (special_opts.Font)
            font_bak := this.Font, this.SetFont(special_opts.Font)
        if (special_opts.FontSize)
            fontsize_bak := this.FontSize, this.SetFontSize(special_opts.FontSize)
        if (special_opts.FontQuality)
            fontquality_bak := this.FontQuality, this.SetFontQuality(special_opts.FontQuality)
        if (special_opts.FontQuality)
            fontquality_bak := this.FontQuality, this.SetFontQuality(special_opts.FontQuality)
        if (special_opts.FontQuality)
            fontquality_bak := this.FontQuality, this.SetFontQuality(special_opts.FontQuality)
        if (special_opts.FontQuality)
            fontquality_bak := this.FontQuality, this.SetFontQuality(special_opts.FontQuality)

        if (special_opts.CenterVertical)
            normal_opts .= " +0x200"

        if (ctrlType = "Text" && !IsContaining(normal_opts, "-BackgroundTrans"))
            normal_opts .= " +BackgroundTrans"

		; Add gui control
        try Gui, %guiName%:Add,% ctrlType="ImageButton"?"Button":ctrlType,%normal_opts%, %content%
        catch e
            this.ThrowError(e.Message "`n" e.Extra)

		; Add handle if existing
		if (ctrlHandleName)
            this.Controls[ctrlHandleName] := %ctrlHandleName%

		; Restore font
		if (special_opts.Font)
            this.SetFont(font_bak)
        if (special_opts.FontSize)
            this.SetFontSize(fontsize_bak)
        if (special_opts.FontQuality)
            this.SetFontQuality(fontquality_bak)

		; Control choose
		if (special_opts.ControlChooseString) {
			param := StrReplace(special_opts.ControlChooseString, "%A_Space%", " ")
            try GuiControl, %guiName%:ChooseString,% this.Controls[ctrlHandleName],% param
            catch e
                this.ThrowError(e.Message "`n" e.Extra)
		}

        ; Creating ImageButton
		if (ctrlType = "ImageButton") {
			success := ImageButton.Create(this.Controls[ctrlHandleName], imageBtnStyle, imageBtnFontHandle, imageBtnFontSize)
			if !(success)
                this.ThrowError([["ImageButton.LastError", ImageButton.LastError]
                , ["Control", ctrlHandleName]
                , ["Handle", this.Controls[ctrlHandleName]]
                , ["ImageButton Font Handle", imageBtnFontHandle]
                , ["ImageButton Font Size", imageBtnFontSize]
                , ["ImageButton Style", JSON_Dump(imageBtnStyle)]])
		}
	}

    GetComboBoxList(ctrlHandleName) {
        ControlGet, comboBoxList, List, , ,% "ahk_id " this.Controls[ctrlHandleName]
        comboBoxList := StrReplace(comboBoxList, "`n", "|")
        return comboBoxList
    }

    ControlChoose(ctrlHandleName, chooseWhat) {
        guiName := this.Name
        GuiControl, %guiName%:Choose,% this.Controls[ctrlHandleName],% chooseWhat
    }

    ControlChooseString(ctrlHandleName, chooseWhat) {
        guiName := this.Name
        GuiControl, %guiName%:ChooseString,% this.Controls[ctrlHandleName],% chooseWhat
    }

	GetControlContent(ctrlHandleName) {
		this.GetControlsContents()
		return this.ControlsContents[ctrlHandleName]
	}

    GetControlsContents() {
		guiName := this.Name, this.ControlsContents := {}
		for ctrlHandleName, ctrlHandle in this.Controls {
			GuiControlGet, ctrlContent,%guiName%:,% ctrlHandle
            this.ControlsContents[ctrlHandleName] := ctrlContent
		}
        return this.ControlsContents
	}

    SetControlContent(ctrlHandleName, ctrlContent) {
        guiName := this.Name
        GuiControl, %guiName%:,% this.Controls[ctrlHandleName],% ctrlContent
    }

    SetMargins(xMargin, yMargin) {
        guiName := this.Name
        try Gui,%guiName%:Margin, %xMargin%, %yMargin%
        catch e
            this.ThrowError(e.Message "`n" e.Extra)
	}

    SetBackgroundColor(bckColor) {
        guiName := this.Name
        try Gui,%guiName%:Color,%bckColor%
        catch e
            this.ThrowError(e.Message "`n" e.Extra)
        this.BackgroundColor := bckColor
    }

    SetControlsColor(ctrlColor) {
        guiName := this.Name
        try Gui,%guiName%:Color,,%ctrlColor%
        catch e
            this.ThrowError(e.Message "`n" e.Extra)
        this.ControlsColor := ctrlColor
    }

    SetFont(fontName) {
        guiName := this.Name
        try Gui,%guiName%:Font,,%fontName%
        catch e
            this.ThrowError(e.Message "`n" e.Extra)
        this.Font := fontName
    }

    SetFontSize(fontSize) {
        guiName := this.Name
        try Gui,%guiName%:Font,s%fontSize%
        catch e
            this.ThrowError(e.Message "`n" e.Extra)
        this.FontSize := fontSize
    }

    SetFontQuality(fontQuality) {
        guiName := this.Name
        try Gui,%guiName%:Font,q%fontQuality%
        catch e
            this.ThrowError(e.Message "`n" e.Extra)
        this.FontQuality := fontQuality
    }

    SetFontColor(fontColor) {
        guiName := this.Name
        try Gui,%guiName%:Font,c%fontColor%
        catch e
            this.ThrowError(e.Message "`n" e.Extra)
        this.FontColor := fontColor
    }

    GetControlPos(ctrlHandleName) {
        guiName := this.Name
		GuiControlGet, ctrlPos , %guiName%:Pos,% this.Controls[ctrlHandleName]
		return {X:ctrlPosX,Y:ctrlPosY,W:ctrlPosW,H:ctrlPosH}
	}

    AddColoredBorder(borderSize, borderColor) {
        guiName := this.Name
        size := this.GetPosition(), gui_width := size.Width, gui_height := size.Height
        
        try {
            Gui, %guiName%:Add, Progress,% "x0 y0 w" gui_width " h" borderSize " Background" borderColor ; Top
		    Gui, %guiName%:Add, Progress,% "x0 y0 w" borderSize " h" gui_height " Background" borderColor ; Left
		    Gui, %guiName%:Add, Progress,% "x" gui_width-borderSize " y0" " w" borderSize " h" gui_height " Background" borderColor ; Right
		    Gui, %guiName%:Add, Progress,% "x0 y" gui_height-borderSize " w" gui_width " h" borderSize " Background" borderColor ; Bottom
        }
        catch e
            this.ThrowError(e.Message "`n" e.Extra)
    }

    PredictControlHeight(ctrlType, ctrlOpts, ctrlContent) {
        guiName := this.Name
        predict_gui := new GUI("PredictControlHeight")
    
		predict_gui.Add(ctrlType, ctrlOpts " hwndhControlHandle", ctrlContent)
        controlPosition := predict_gui.GetControlPos("hControlHandle")
		predict_gui.Destroy()

        return controlPosition.H
    }

    GetControlText(ctrlHandleName) {
        ControlGetText, ctrlText, ,% "ahk_id " this.Controls[ctrlHandleName]
        return ctrlText
    }

    GetPosition(onlyIfVisible=False) {
        
        hw := DetectHiddenWindows("Off")
        if WinExist("ahk_id " this.Handle) {
            WinGetPos, X, Y, Width, Height,% "ahk_id " this.Handle
            DetectHiddenWindows(hw)
            return {X:X, Y:Y, Width:Width, Height:Height}
        }
        if (onlyIfVisible) {
            DetectHiddenWindows(hw)
            return
        }

        DetectHiddenWindows("On")
        WinGetPos, X, Y, Width, Height,% "ahk_id " this.Handle
        if (Width = 0 && Height = 0) {
            this.Show("AutoSize Hide")
            WinGetPos, X, Y, Width, Height,% "ahk_id " this.Handle
        }
        DetectHiddenWindows(hw)
        return {X:X, Y:Y, Width:Width, Height:Height}
    }

    MoveControl(ctrlHandleName, opts="") { 
		guiName := this.Name
		; if IsContaining(opts, "Center")
		; 	centerCtrl := True, opts := StrReplace(opts, "Center", "")
		try GuiControl, %guiName%:Move,% this.Controls[ctrlHandleName],% opts
        catch e
            this.ThrowError(e.Message "`n" e.Extra)
		; if (centerCtrl)
			; GuiControl, %guiName%:+Center,% Gui%guiName%["Controls"][ctrlName]
	}

    ; ===============================================================================================================================
    ; https://www.autohotkey.com/boards/viewtopic.php?t=70852
    ; Message ..................:  EM_SETCUEBANNER
    ; Minimum supported client .:  Windows Vista
    ; Minimum supported server .:  Windows Server 2003
    ; Links ....................:  https://docs.microsoft.com/en-us/windows/win32/controls/em-setcuebanner
    ; Description ..............:  Sets the textual cue, or tip, that is displayed by the edit control to prompt the user for information.
    ; Option ...................:  True  -> if the cue banner should show even when the edit control has focus
    ;                              False -> if the cue banner disappears when the user clicks in the control
    ; ===============================================================================================================================
    EM_SETCUEBANNER(handle, string, option := true)
    {
        static ECM_FIRST       := 0x1500 
        static EM_SETCUEBANNER := ECM_FIRST + 1
        if (DllCall("user32\SendMessage", "ptr", this.Controls[handle], "uint", EM_SETCUEBANNER, "int", option, "str", string, "int"))
            return true
        return false
    }

    ; ===============================================================================================================================
    ; https://www.autohotkey.com/boards/viewtopic.php?t=70852
    ; Message ..................:  CB_SETCUEBANNER
    ; Minimum supported client .:  Windows Vista
    ; Minimum supported server .:  Windows Server 2008
    ; Links ....................:  https://docs.microsoft.com/en-us/windows/win32/controls/cb-setcuebanner
    ; Description ..............:  Sets the cue banner text that is displayed for the edit control of a combo box.
    ; ===============================================================================================================================
    CB_SETCUEBANNER(handle, string)
    {
        static CBM_FIRST       := 0x1700
        static CB_SETCUEBANNER := CBM_FIRST + 3
        if (DllCall("user32\SendMessage", "ptr", this.Controls[handle], "uint", CB_SETCUEBANNER, "int", 0, "str", string, "int"))
            return true
        return false
    }

; ===============================================================================================================================

; ===============================================================================================================================

    Show(opts="", title="") {
        guiName := this.Name

        Loop, Parse, opts,% A_Space
        {
            thisOpt := A_LoopField
            if ( SubStr(thisOpt, 1, 1) = "w" ) && ( IsNum(SubStr(thisOpt, 2)) ) ; Retrieve width for later usage
                guiWidth := SubStr(thisOpt, 2)
            else if ( SubStr(thisOpt, 1, 1) = "h" ) && ( IsNum(SubStr(thisOpt, 2)) ) ; Retrieve height for later usage
                guiHeight := SubStr(thisOpt, 2)
            else if ( SubStr(thisOpt, 1, 1) = "x" ) && ( IsNum(SubStr(thisOpt, 2)) ) ; Retrieve x for later usage
                guiX := SubStr(thisOpt, 2)
            else if ( SubStr(thisOpt, 1, 1) = "y" ) && ( IsNum(SubStr(thisOpt, 2)) ) ; Retrieve y for later usage
                guiY := SubStr(thisOpt, 2)
        }
        this.Width := IsNum(guiWidth) ? guiWidth : this.Width
        opts .= IsNum(this.Width) ? " w" this.Width : ""
        this.Height := IsNum(guiHeight) ? guiHeight : this.Height
        opts .= IsNum(this.Height) ? " h" this.Height : ""
        ; this.X := IsNum(guiX) ? guiX : this.X
        ; opts .= IsNum(this.X) ? " h" this.X : ""
        ; this.Y := IsNum(guiY) ? guiY : this.Y
        ; opts .= IsNum(this.Y) ? " h" this.Y : ""

        ; msgbox % opts

        title := title ? title : this.Title
        this.Title := title ? title : this.Title
        
		try
			Gui, %guiName%:Show,% opts,% this.Title
		catch e
			this.ThrowError(e.Message "`n" e.Extra)
	}

    BindWindowsMessage(msgID, funcName, params*) {
        if IsContaining(funcName, ".") {
            split := StrSplit(funcName, ".")
            className := split.1
            funcName := split.2
        }

        if ( params.Count() ) {
            if (className)
                __f := ObjBindMethod(%className%, funcName, params*)
            else
                __f := Func(funcName).Bind(params*)
        }
        else {
            if (className)
                __f := ObjBindMethod(%className%, funcName)
            else
                __f := Func(funcName).Bind()
        }
            
        this.BoundWindowsMessages[msgID] := {Function: funcName, Params: [params*]}
		OnMessage(msgID, __f)
	}

    BindFunctionToControl(ctrlName, funcName, params*) {
        guiName := this.Name

        if IsContaining(funcName, ".") {
            split := StrSplit(funcName, ".")
            className := split.1
            funcName := split.2
        }

        if ( params.Count() ) {
            if (className)
                __f := ObjBindMethod(%className%, funcName, params*)
            else
                __f := Func(funcName).Bind(params*)
        }
        else {
            if (className)
                __f := ObjBindMethod(%className%, funcName)
            else
                __f := Func(funcName).Bind()
        }

        this.BoundFunctions[ctrlName] := {Function: funcName, Params: [params*]}
		GuiControl, %guiName%:+g,% this.Controls[ctrlName],% __f
	}

	DisableControlFunction(className, ctrlName) {
        guiName := this.Name
		GuiControl, %guiName%:-g,% this.Controls[ctrlName]
	}

	EnableControlFunction(className, ctrlName) {
        guiName := this.Name
        funcName := this.BoundFunctions[ctrlName].Function
        params := this.BoundFunctions[ctrlName].Params
        __f := ObjBindMethod(%className%, funcName, params*)
		GuiControl, %guiName%:+g,% this.Controls[ctrlName],% __f
	}

    Get_CtrlVarName_From_Hwnd(ctrlHwnd) {
        guiName := this.Name
		GuiControlGet, ctrlName, %guiName%:Name,% ctrlHwnd
		return ctrlName
	}

    TransColor(_color) {
        guiName := this.Name
        Gui, %guiName%:+LastFound
        WinSet, TransColor,% _color
    }
	SetDefault() {
		guiName := this.Name
		Gui,%guiName%:Default
	}

    Destroy() {
        guiName := this.Name

		Gui,%guiName%:Hide
		for msgID in this.BoundWindowsMessages
			OnMessage(msgID, this.BoundWindowsMessages[msgID], 0)
        for ctrlName, ctrlHandle in this.Controls
			if ( SubStr(ctrlName, 1, 5) = "hBTN_" )
				ImageButton.DestroyBtnImgList(value)

		Gui,%guiName%:Destroy
        this.Remove("", Chr(255))
        this.SetCapacity(0)
        this.base := ""
	}
}

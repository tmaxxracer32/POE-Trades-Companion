#SingleInstance, Off
#KeyHistory 0
#Persistent
#NoTrayIcon
#NoEnv
ListLines, Off

; SetTimer, ExitScript, -20000

cmdLineParams := Get_CmdLineParameters()
VerifyItemPrice(cmdLineParams)
ExitApp
Return

ExitScript() {
    global cmdLineParamsObj

    verifyTxt := "The request took more than 20 seconds and was canceled.", verifyColor := "Orange"
    data := "tabNum := GUI_Trades_V2.GetTabNumberFromUniqueID(Sell," paramsObj.TabUniqueID ")"
    . "`n"  "GUI_Trades_V2.SetTabVerifyColor(%tabNum%," verifyColor ")"
    . "`n"  "GUI_Trades_V2.UpdateSlotContent(Sell,%tabNum%,TradeVerify," verifyTxt ")"
    ControlSetText, ,% data,% "ahk_id " cmdLineParamsObj.IntercomSlotHandle
    ExitApp
}

VerifyItemPrice(cmdLineParams) {
    global PROGRAM, paramsObj

    ; Converting cmdLineParams into obj
    startPos := 1, paramsObj := {}
    Loop {
        foundPos := RegExMatch(cmdLineParams, "iO)/(.*?)=""(.*?)""", outMatch, startPos)
        if (!foundPos || A_Index > 100)
            Break
        startPos := foundPos+StrLen(outMatch.0), paramsObj[outMatch.1] := outMatch.2
    }
    
     ; setting cURL location bcs of how my modified library work
    PROGRAM := {"CURL_EXECUTABLE": paramsObj.cURL, "LOGS_FILE": paramsObj.ProgramLogsFile, "DATA_FOLDER": paramsObj.ProgramDataFolder}

    if (paramsObj.TradeType = "Regular") {
        Loop, Parse,% paramsObj.Accounts,% ","
        {
            accName := A_LoopField

            itemSearchObj := {Item:paramsObj.Item
                ,GemQualityMin:paramsObj.GemQuality, GemQualityMax:paramsObj.GemQuality
                ,GemLevelMin:paramsObj.GemLevel, GemLevelMax:paramsObj.GemLevel
                ,MapTierMin:paramsObj.MapTier, MapTierMax:paramsObj.MapTier
                ,League:paramsObj.League, StashTab:paramsObj.StashTab, StashX:paramsObj.StashX, StashY:paramsObj.StashY
                ,Account:accName, Online:"any", Language:paramsObj.WhisperLanguage}
            matchingListings := GGG_API_GetMatchingItemsData(itemSearchObj)

            if !IsObject(matchingListings)
                Continue ; Go with next account

            Loop % matchingListings.Count() {
                thisListing := matchingListings[A_Index].listing
                listingPriceCurrency := thisListing.price.currency, listingPriceCount := thisListing.price.amount
                priceTxt := "Online: `t " listingPriceCount " " listingPriceCurrency
                    . "\n" "Whisper: `t " paramsObj.PriceCount " " paramsObj.PriceID

                if (listingPriceCurrency = paramsObj.PriceID && listingPriceCount = paramsObj.PriceCount) {
                    verifyTxt := "Price is the same\n" priceTxt, verifyColor := "Green"
                }
                else if (listingPriceCurrency = paramsObj.PriceID && listingPriceCount < paramsObj.PriceCount) {
                    verifyTxt := "Price is higher in whisper\n" priceTxt, verifyColor := "Green"
                }
                else if (listingPriceCurrency = paramsObj.PriceID && listingPriceCount > paramsObj.PriceCount) {
                    verifyTxt := "Price is lower in whisper\n" priceTxt, verifyColor := "Red"
                }
                else if (listingPriceCurrency != paramsObj.PriceID) {
                    verifyTxt := "Currency is different\n" priceTxt, verifyColor := "Red"
                }

                if (verifyTxt)
                    Break
            }
            if (verifTxt)
                Break
        }

        if (!verifyTxt) {
            verifyTxt := "/!\ Could not find any listing matching the same item trade", verifyColor := "Orange"
        }
    }
    else if (paramsObj.TradeType = "Currency") {
        Loop, Parse,% paramsObj.Accounts,% ","
        {
            accName := A_LoopField

            exchangeSearchObj := {Want:paramsObj.WantCurrencyID, Have:paramsObj.GiveCurrencyID
                ,Account:accName, Ratio:paramsObj.SaleRatio, Online:"any", Language:paramsObj.WhisperLanguage, League:paramsObj.League}
            matchingListings := GGG_API_GetMatchingExchangeData(exchangeSearchObj)

            if !IsObject(matchingListings)
                Continue ; Go with next account

            Loop % matchingListings.Count() {
                thisListing := matchingListings[A_Index].listing
                onlineRatio := RemoveTrailingZeroes(thisListing.price.item.amount / thisListing.price.exchange.amount)
                ratioTxt := "Online: `t1 " paramsObj.WantCurrency " = " onlineRatio " " paramsObj.GiveCurrency
                    . "\n" "Whisper: `t1 " paramsObj.WantCurrency " = " paramsObj.SaleRatio " " paramsObj.GiveCurrency

                if (onlineRatio = paramsObj.SaleRatio)
                    verifyTxt := "Ratio is the same\n" ratioTxt, verifyColor := "Green"
                else if (onlineRatio > paramsObj.SaleRatio)
                    verifyTxt := "Ratio is better\n" ratioTxt, verifyColor := "Green"
                else if (onlineRatio < paramsObj.SaleRatio)
                    verifyTxt := "/!\ Ratio is lower\n" ratioTxt, verifyColor := "Red"

                if (verifyTxt)
                    Break
            }
            if (verifTxt)
                Break
        }

        if (!verifyTxt) {
            verifyTxt := "/!\ Could not find any listing matching the same currency trade", verifyColor := "Orange"
        }
    }
    
     ; Construct data string that'll be transmited to intercom
    data := "tabNum := GUI_Trades_V2.GetTabNumberFromUniqueID(Sell," paramsObj.TabUniqueID ")"
    . "`n"  "GUI_Trades_V2.SetTabVerifyColor(%tabNum%," verifyColor ")"
    . "`n"  "GUI_Trades_V2.UpdateSlotContent(Sell,%tabNum%,TradeVerify," verifyTxt ")"

    ControlSetText, ,% data,% "ahk_id " paramsObj.IntercomSlotHandle
}

#Include %A_ScriptDir%
#Include CmdLineParameters.ahk
#Include EasyFuncs.ahk
#Include Logs.ahk
#Include GGG_API.ahk
#Include PoeTrade.ahk
#Include WindowsSettings.ahk

#Include %A_ScriptDir%/third-party
#Include cURL.ahk
#Include JSON.ahk
#Include StdOutStream.ahk
#Include UriEncode.ahk
#Include WinHttpRequest.ahk

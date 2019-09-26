#SingleInstance, Off
#KeyHistory 0
#Persistent
#NoTrayIcon
#NoEnv
ListLines, Off

; SetTimer, ExitScript, -20000

cmdLineParams := Get_CmdLineParameters()
VerifyItemPrice_V2(cmdLineParams)
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

VerifyItemPrice_V2(cmdLineParams) {
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

VerifyItemPrice(cmdLineParams) {
    global PROGRAM, cmdLineParamsObj
    ; Converting cmd line params into obj
    startPos := 1, cmdLineParamsObj := {}
    Loop {
        foundPos := RegExMatch(cmdLineParams, "iO)/(.*?)=""(.*?)""", outMatch, startPos)
        if (!foundPos || A_Index > 100)
            Break

        startPos := foundPos+StrLen(outMatch.0), cmdLineParamsObj[outMatch.1] := outMatch.2
    }
    ; setting cURL location bcs of how my modified library work
    PROGRAM := {"CURL_EXECUTABLE": cmdLineParamsObj.cURL, "LOGS_FILE": cmdLineParamsObj.ProgramLogsFile}

    if (cmdLineParamsObj.TradeType = "Regular") { ; poe.trade
        Loop, Parse,% cmdLineParamsObj.Accounts,% ","
        {
            thisAccount := A_LoopField
            
            ; infos required to create search url
			searchURLObj := {"name": cmdLineParamsObj.ItemName
			, "level_min": cmdLineParamsObj.ItemLevel, "level_max": cmdLineParamsObj.ItemLevel
			, "q_min": cmdLineParamsObj.ItemQuality, "q_max": cmdLineParamsObj.ItemQuality
			, "league": cmdLineParamsObj.League, "seller": thisAccount}
			itemURL := PoeTrade_GetItemSearchUrl(searchURLObj)

            ; looking for a matching item based on data we have
            searchObj := {"seller": thisAccount, "online": ""
                , "buyout": cmdLineParamsObj.ItemPrice, "name": cmdLineParamsObj.ItemName
                , "level": cmdLineParamsObj.ItemLevel, "quality": cmdLineParamsObj.ItemQuality
                , "league": cmdLineParamsObj.League, "tab": cmdLineParamsObj.StashTab
                , "x": cmdLineParamsObj.StashX, "y" : cmdLineParamsObj.StashY}
            poeTradeObj := PoeTrade_GetMatchingItemData(searchObj, itemURL)

            if IsObject(poeTradeObj) { ; Obj means match was found
                ; split currency count and name
                RegExMatch(cmdLineParamsObj.ItemPrice, "O)(\d+) (.*)", whisperBuyoutPat), whisper_currencyCount := whisperBuyoutPat.1, whisper_currencyType := whisperBuyoutPat.2
                RegExMatch(poeTradeObj.buyout, "O)(\d+) (.*)", poeTradeBuyoutPat), poeTrade_currencyCount := poeTradeBuyoutPat.1, poeTrade_currencyType := poeTradeBuyoutPat.2

                if (cmdLineParamsObj.ItemPrice = poeTradeObj.buyout) { ; Exactly same price (OK)
                    vInfos := "Price confirmed legit"
                    . "\npoe.trade: `t" poeTradeObj.buyout
                    . "\nwhisper: `t`t" cmdLineParamsObj.ItemPrice
                    vColor := "Green"
                }
                else if (poeTrade_currencyType=whisper_currencyType && whisper_currencyCount >= poeTrade_currencyCount) { ; Whisper is higher than poeTrade (OK)
                    vInfos := "Price is higher"
                    . "\npoe.trade: `t" poeTradeObj.buyout
                    . "\nwhisper: `t`t" cmdLineParamsObj.ItemPrice
                    vColor := "Green"
                }
                else if (cmdLineParamsObj.CurrencyName = "") { ; Unpriced item 
                    vInfos := "/!\ Cannot verify unpriced items yet"
                    vColor := "Orange"
                }
                else if (!cmdLineParamsObj.CurrencyIsListed) { ; Unknown currency 
                    vInfos := "/!\ Unknown currency name: """ currencyInfos.Name """"
                    . "\nPlease report it"
                    vColor := "Orange"
                }
                else if (cmdLineParamsObj.CurrencyIsListed && cmdLineParamsObj.ItemPrice != poeTradeObj.buyout) { ; Whisper is different from poe.trade (NOTOK)
                    vInfos := "/!\ Price is different"
                    . "\npoe.trade: `t" poeTradeObj.buyout
                    . "\nwhisper: `t`t" cmdLineParamsObj.ItemPrice
                    vColor := "Red"
                }
                else {
                    vInfos := "/!\ Something unknown happened"
                    vColor := "Orange"
                }
            }
            else { ; No match was found
                if (cmdLineParamsObj.WhisperLanguage != "ENG") { ; Whisper is not eng
                    vInfos := "/!\ Cannot verify price for"
                    . "\npathofexile.com/trade translated whispers."
                    vColor := "Orange"
                }
                else { ; Couldn't find any item matching tab name and x;y pos
                    vInfos := "/!\ Could not find any item matching the same stash location"
                    . "\nIt could be that poe.trade hasn't updated yet for this item"
                    vColor := "Orange"
                }
            }
        }
    }

    else if (cmdLineParamsObj.TradeType = "Currency") { ; currency.poe.trade
        Loop, Parse,% cmdLineParamsObj.Accounts,% ","
        {
            thisAccount := A_LoopField

            ; infos required to create search url
            searchURLObj := {"league": cmdLineParamsObj.League, "online": "x"
                ,"want": cmdLineParamsObj.SellCurrencyID, "have": cmdLineParamsObj.BuyCurrencyID}
			itemURL := PoeTrade_GetCurrencySearchUrl(searchURLObj)
            ; search for currency trade with same account 
            searchObj := {"username": thisAccount, "sellBuyRatio": cmdLineParamsObj.SellBuyRatio
			    ,"sellcurrency": cmdLineParamsObj.SellCurrencyID, "sellvalue": cmdLineParamsObj.SellCurrencyCount
			    ,"buycurrency": cmdLineParamsObj.BuyCurrencyID, "buyvalue": cmdLineParamsObj.BuyCurrencyCount}
			matchingObj := PoETrade_GetMatchingCurrencyTradeData(searchObj, itemURL)

            if IsObject(matchingObj) { ; object means we have matches
                Loop % matchingObj.MaxIndex() { ; Loop through matchs

                    ratioTxt := "poe.trade: `t1 " cmdLineParamsObj.SellCurrencyFullName " = " matchingObj[A_Index].sellBuyRatio " " cmdLineParamsObj.BuyCurrencyFullName
                        . "\nwhisper: `t`t1 " cmdLineParamsObj.SellCurrencyFullName " = " cmdLineParamsObj.SellBuyRatio " " cmdLineParamsObj.BuyCurrencyFullName
                    
                    if (matchingObj[A_Index].IsSameRatio=True) { ; ratio is the same (OK)
                        vInfos := "Ratio is the same"
                        . "\n" ratioTxt
                        vColor := "Green"
                        Break
                    }
                    else if (matchingObj[A_Index].sellBuyRatio > cmdLineParamsObj.SellBuyRatio) { ; ratio is higher (OK)
                        vInfos := "Ratio is better"
                        . "\n" ratioTxt
                        vColor := "Green"
                        Break
                    }
                    else if (matchingObj[A_Index].sellBuyRatio < cmdLineParamsObj.SellBuyRatio) { ; ratio is lower (NOTOK)
                        vInfos := "/!\ Ratio is lower"
                        . "\n" ratioTxt
                        vColor := "Red"
                    }
                    else if (!cmdLineParamsObj.SellCurrencyIsListed || !cmdLineParamsObj.BuyCurrencyIsListed) { ; currency unknown
                        wantListedInfos := cmdLineParamsObj.SellCurrencyIsListed=True?"" : "/!\\nUnknown currency type: """ cmdLineParamsObj.SellCurrencyFullName """"
                        giveListedInfos := cmdLineParamsObj.BuyCurrencyIsListed=True?"" : "/!\\nUnknown currency type: """ cmdLineParamsObj.BuyCurrencyFullName """"
                        vInfos := wantListedInfos . giveListedInfos "\nPlease report it"
                        vColor := "Orange"
                    }
                    else {
                        vInfos := "/!\ Something unknown happened"
                        vColor := "Orange"    
                    }
                }
            }
            else {
                if (cmdLineParamsObj.WhisperLanguage != "ENG") {
                    vInfos := "/!\ Cannot verify price for"
                    . "\npathofexile.com/trade translated whispers."
                    vColor := "Orange"
                }
                else {
                    vInfos := "/!\ Could not find any item matching the same currency trade"
                    . "\nIt could be that poe.trade hasn't updated yet for this item"
                    vColor := "Orange"
                }
            }
        }
    }

    ; Construct data string that'll be transmited to intercom
    data := "tabNum := GUI_Trades.GetTabNumberFromUniqueID(" cmdLineParamsObj.TabUniqueID ")"
    . "`n"  "GUI_Trades.SetTabVerifyColor(%tabNum%," vColor ")"
    . "`n"  "GUI_Trades.UpdateSlotContent(%tabNum%,TradeVerifyInfos," vInfos ")"
    ControlSetText, ,% data,% "ahk_id " cmdLineParamsObj.IntercomSlotHandle
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
#Include WinHttpRequest.ahk
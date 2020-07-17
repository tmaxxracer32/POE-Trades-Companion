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

    SendDataBack({"VerifyColor": "Orange", "VerifyTxt": "The request took more than 20 seconds and was canceled."})
}

SendDataBack(obj) {
    global cmdLineParamsObj

    ; Construct data string that'll be transmited to intercom
    data := "tabNum := GUI_Trades_V2.GetTabNumberFromUniqueID(Sell," cmdLineParamsObj.TradeData.UniqueID ")"
    . "`n"  "GUI_Trades_V2.UpdateSlotContent(Sell,%tabNum%,TradeVerifyColor," obj.VerifyColor ")"
    . "`n"  "GUI_Trades_V2.UpdateSlotContent(Sell,%tabNum%,TradeVerifyText," obj.VerifyTxt ")"

    ControlSetText, ,% data,% "ahk_id " cmdLineParamsObj.Intercom.SlotHandle
}

VerifyItemPrice(cmdLineParams) {
    global PROGRAM, cmdLineParamsObj

    ; Converting cmdLineParams into obj
    startPos := 1, cmdLineParamsObj := {}
    Loop {
        foundPos := RegExMatch(cmdLineParams, "iO)/(.*?)=""(.*?)""", outMatch, startPos)
        if (!foundPos || A_Index > 100)
            Break
        startPos := foundPos+StrLen(outMatch.0), cmdLineParamsObj[outMatch.1] := outMatch.2
    }
    jsonFile := cmdLineParamsObj.CmdLineParamsJSON
    cmdLineParamsObj := "", cmdLineParamsObj := JSON_Load(jsonFile)
    FileDelete,% jsonFile

    PROGRAM := ObjFullyClone(cmdLineParamsObj.PROGRAM)
    tabInfos := cmdLineParamsObj.TradeData

    if (tabInfos.ItemCurrency && tabInfos.ItemCount) { ; Currency trade
        buyerWantsType := tabInfos.ItemCurrency, buyerWantsCount := tabInfos.ItemCount
        buyerGivesType := tabInfos.PriceCurrency, buyerGivesCount := tabInfos.PriceCount
        saleRatio := RemoveTrailingZeroes(buyerGivesCount/buyerWantsCount)

        poeStaticData := JSON_Load(PROGRAM.DATA_FOLDER "\" tabInfos.WhisperLanguage "_poeDotComStaticData.json")
        Loop % poeStaticData.Count() {
            loop1Index := A_Index
            Loop % poeStaticData[loop1Index].entries.Count() {
                thisEntry := poeStaticData[loop1Index].entries[A_Index]
                if (thisEntry.text = buyerWantsType)
                    buyerWantsID := thisEntry.id
                if (thisEntry.text = buyerGivesType)
                    buyerGivesID := thisEntry.id
                if (buyerWantsID && buyerGivesID)
                    Break 
            }
            if (buyerWantsID && buyerGivesID)
                Break
        }

        if (!buyerWantsType || !buyerWantsCount || !buyerWantsID || !buyerGivesType || !buyerGivesCount || !buyerGivesID) {
            SendDataBack({"VerifyColor": "Orange", "VerifyTxt": "/!\ Failed to retrieve informations for this trade"
                . "\nPlease contact me with the following:"
                . "\nWantCurrency: " buyerWantsType
                . "\nWantCurrencyCount: " buyerWantsCount
                . "\nWantCurrencyID: " buyerWantsID
                . "\nGiveCurrency: " buyerGivesType
                . "\nGiveCurrencyCount: " buyerGivesCount
                . "\nGiveCurrencyID: " buyerGivesID})
            return
        }

        for index, accName in cmdLineParamsObj.Accounts
        {
            exchangeSearchObj := {Want:buyerWantsID, Have:buyerGivesID
                ,Account:accName, Ratio:saleRatio, Online:"any", Language:tabInfos.WhisperLanguage, League:tabInfos.League}
            matchingListings := GGG_API_GetMatchingExchangeData(exchangeSearchObj)

            if !IsObject(matchingListings)
                Continue ; Go with next account

            Loop % matchingListings.Count() {
                thisListing := matchingListings[A_Index].listing
                onlineRatio := RemoveTrailingZeroes(thisListing.price.exchange.amount / thisListing.price.item.amount)
                ratioTxt := "Online: `t1 " buyerWantsType " = " onlineRatio " " buyerGivesType
                    . "\n" "Whisper: `t1 " buyerWantsType " = " saleRatio " " buyerGivesType

                if (onlineRatio = saleRatio)
                    SendDataBack({"VerifyColor": "Green", "VerifyTxt": "Ratio is matching\n" ratioTxt})
                else if (onlineRatio < saleRatio)
                    SendDataBack({"VerifyColor": "Green", "VerifyTxt": "Ratio is advantageous\n" ratioTxt})
                else if (onlineRatio > saleRatio)
                    SendDataBack({"VerifyColor": "Red", "VerifyTxt": "Ratio is incorrect and lower\n" ratioTxt})
            }
        }
        SendDataBack({"VerifyColor": "Orange", "VerifyTxt": "/!\ Could not find any listing matching the same currency trade"})
    }
    else { ; Regular trade
        priceType := tabInfos.PriceCurrency, priceCount := tabInfos.PriceCount
        langs := tabInfos.WhisperLanguage="ENG" ? ["ENG"] : ["ENG",tabInfos.WhisperLanguage]
        Loop % langs.Count() {
            lang := langs[A_Index]
            poeStaticData := JSON_Load(PROGRAM.DATA_FOLDER "\" lang "_poeDotComStaticData.json")
            Loop % poeStaticData.Count() {
                loop1Index := A_Index
                Loop % poeStaticData[loop1Index].entries.Count() {
                    thisEntry := poeStaticData[loop1Index].entries[A_Index]
                    if (thisEntry.text = priceType)
                        priceID := thisEntry.id
                    if (priceID)
                        Break
                }
                if (priceID)
                    Break
            }
            if (priceID)
                Break
        }

        if (!priceType || !priceCount || !priceID) {
            SendDataBack({"VerifyColor": "Orange", "VerifyTxt": "/!\ Failed to retrieve informations for this trade"
                . "\nPlease contact me with the following:"
                . "\nPriceCurrency: " priceType
                . "\nPriceCount: " priceCount
                . "\nPriceID: " priceID})
            return
        }

        for index, accName in cmdLineParamsObj.Accounts
        {
            itemSearchObj := {Item:tabInfos.Item
                ,GemQualityMin:tabInfos.GemQuality, GemQualityMax:tabInfos.GemQuality
                ,GemLevelMin:tabInfos.GemLevel, GemLevelMax:tabInfos.GemLevel
                ,MapTierMin:tabInfos.MapTier, MapTierMax:tabInfos.MapTier
                ,League:tabInfos.League, StashTab:tabInfos.StashTab, StashX:tabInfos.StashX, StashY:tabInfos.StashY
                ,Account:accName, Online:"any", Language:tabInfos.WhisperLanguage}
            matchingListings := GGG_API_GetMatchingItemsData(itemSearchObj)

            if !IsObject(matchingListings)
                Continue ; Go with next account

            Loop % matchingListings.Count() {
                thisListing := matchingListings[A_Index].listing
                listingPriceCurrency := thisListing.price.currency, listingPriceCount := thisListing.price.amount
                priceTxt := "Online: `t " listingPriceCount " " listingPriceCurrency
                    . "\n" "Whisper: `t " tabInfos.PriceCount " " priceID

                if (listingPriceCurrency = priceID && listingPriceCount = tabInfos.PriceCount) {
                    SendDataBack({"VerifyColor": "Green", "VerifyTxt": "Price is matching\n" priceTxt})
                    return
                }
                else if (listingPriceCurrency = priceID && listingPriceCount < tabInfos.PriceCount) {
                    SendDataBack({"VerifyColor": "Green", "VerifyTxt": "Price is advantageous\n" priceTxt})
                    return
                }
                else if (listingPriceCurrency = priceID && listingPriceCount > tabInfos.PriceCount) {
                    SendDataBack({"VerifyColor": "Red", "VerifyTxt": "Price is incorrect\n" priceTxt})
                    return
                }
                else if (listingPriceCurrency != priceID) {
                    SendDataBack({"VerifyColor": "Red", "VerifyTxt": "Currency is incorrect\n" priceTxt})
                    return
                }
            }
        }
        SendDataBack({"VerifyColor": "Orange", "VerifyTxt": "/!\ Could not find any listing matching the same item trade"})
    }
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

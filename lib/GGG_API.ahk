/*  TO_DO
    Some funcs to convert TC obj to API obj
    Also make better slots to Trades GUI
    Like MapTier slot or something?
*/

GGG_API_GetLastActiveCharacter(accName) {  
    if !(accName)
        return

    url := "https://www.pathofexile.com/character-window/get-characters?accountName=" UriEncode(accName)
    headers := "Content-Type: application/json"
    . "`n"     "Cache-Control: no-store, no-cache, must-revalidate"
    options := "TimeOut: 7"
    . "`n"     "Charset: UTF-8"

    WinHttpRequest_cURL(url, data:="", headers, options), charsJSON := data
    charsJSON := JSON.Load(charsJSON)

    Loop % charsJSON.Count() {
        if (charsJSON[A_Index].lastActive = True) {
            lastChar := charsJSON[A_Index].name  
            return lastChar  
        }
    }
}

GGG_API_CreateDataFiles() {
    langs := ["ENG","RUS","FRE","POR","THA","GER","SPA","KOR","TWN"]
	
	Loop % langs.Count() {
		thisLang := langs[A_Index]
		poeURL := GetPoeDotComUrlBasedOnLanguage(thisLang)
		url := poeURL "/api/trade/data/static", url2 := poeURL "/api/trade/data/items"
		headers := "Content-Type:application/json;charset=UTF-8", headers2 := headers
		options := "TimeOut: 25"
		. "`n"  "Charset: UTF-8", options2 := options
		WinHttpRequest_cURL(url, data:="", headers, options), html := data, jsonData := JSON_Load(html)
        WinHttpRequest_cURL(url2, data:="", headers2, options2), html2 := data, jsonData2 := JSON_Load(html2)

        jsonFinal := ObjFullyClone(jsonData.result), jsonFinal2 := ObjFullyClone(jsonData2.result)
        fileLocation := A_ScriptDir "/data/" thisLang "_poeDotComStaticData.json", fileLocation2 := A_ScriptDir "/data/" thisLang "_poeDotComItemsData.json"
        jsonText := JSON_Dump(jsonFinal, dontReplaceUnicode:=True), jsonText2 := JSON_Dump(jsonFinal2, dontReplaceUnicode:=True)
        hFile := FileOpen(fileLocation, "w", "UTF-8"), hFile2 := FileOpen(fileLocation2, "w", "UTF-8")
        hFile.Write(jsonText), hFile2.Write(jsonText2)
        hFile.Close(), hFile2.Close()
	}
}

GGG_API_BuildItemSearchObj(obj) {
/*  Convert POE TC slot infos into an item search obj
*/
/*  Informations when builing the search URL
    If the search is english, we can use the "term" field instead of splitting the item into "name" and "type"
    But for other languages, this doesn't seem to work. We are forced to use "name" and "type" fields
*/
/*
    Empty filter:
        {"query":{"status":{"option":"any"},"stats":[{"type":"and","filters":[],"disabled":false}]},"sort":{"price":"asc"}}
    Full filter:
        {"query":{"status":{"option":"any"},"stats":[{"type":"and","filters":[],"disabled":false}],"filters":{"type_filters":{"filters":{"category":{"option":"weapon.one"},"rarity":{"option":"normal"}}},"weapon_filters":{"filters":{"damage":{"min":1,"max":2},"aps":{"min":3,"max":4},"crit":{"min":5,"max":6},"dps":{"min":7,"max":8},"pdps":{"min":9,"max":10},"edps":{"min":11,"max":12}}},"armour_filters":{"filters":{"ar":{"min":13,"max":14},"ev":{"min":15,"max":16},"es":{"min":17,"max":18},"block":{"min":19,"max":20}}},"socket_filters":{"filters":{"sockets":{"r":21,"g":22,"b":23,"w":24,"min":25,"max":26},"links":{"r":27,"g":28,"b":29,"w":30,"min":31,"max":32}}},"req_filters":{"filters":{"lvl":{"min":33,"max":34},"str":{"min":35,"max":36},"dex":{"min":37,"max":38},"int":{"min":39,"max":40}}},"map_filters":{"filters":{"map_tier":{"min":41,"max":42},"map_packsize":{"min":43,"max":44},"map_iiq":{"min":45,"max":46},"map_iir":{"min":47,"max":48},"map_shaped":{"option":"true"},"map_elder":{"option":"true"},"map_series":{"option":"legion"}}},"misc_filters":{"filters":{"quality":{"min":49,"max":50},"ilvl":{"min":51,"max":52},"gem_level":{"min":53,"max":54},"gem_level_progress":{"min":55,"max":56},"shaper_item":{"option":"true"},"elder_item":{"option":"true"},"synthesised_item":{"option":"true"},"alternate_art":{"option":"true"},"fractured_item":{"option":"true"},"corrupted":{"option":"true"},"crafted":{"option":"true"},"enchanted":{"option":"true"},"veiled":{"option":"true"},"mirrored":{"option":"true"},"identified":{"option":"true"},"talisman_tier":{"min":57,"max":58}}},"trade_filters":{"filters":{"account":{"input":"59"},"indexed":{"option":"3days"},"sale_type":{"option":"priced"},"price":{"option":"chaos","min":60,"max":61}}}}},"sort":{"price":"asc"}}
*/
/*  
    Unique weapon       {"query":{"status":{"option":"any"},"name":"","type":"","stats":[{"type":"and","filters":[],"disabled":false}],"filters":{"trade_filters":{"filters":{"account":{"input":"z0rhawk"}},"disabled":false}}},"sort":{"price":"asc"}}
    Gem                 {"query":{"status":{"option":"any"},"type":"Faster Attacks Support","stats":[{"type":"and","filters":[],"disabled":false}],"filters":{"misc_filters":{"filters":{"quality":{"max":99,"min":1},"gem_level":{"max":99,"min":1}},"disabled":false},"trade_filters":{"filters":{"account":{"input":"z0rhawk"}},"disabled":false}}},"sort":{"price":"asc"}}
    Map                 {"query":{"status":{"option":"any"},"type":{"option":"Cemetery Map","discriminator":"warfortheatlas"},"stats":[{"type":"and","filters":[],"disabled":false}],"filters":{"trade_filters":{"filters":{"account":{"input":"z0rhawk"}},"disabled":false},"map_filters":{"filters":{"map_tier":{"min":1,"max":99}}}}},"sort":{"price":"asc"}}
    Jewel               {"query":{"status":{"option":"any"},"name":"","type":"","stats":[{"type":"and","filters":[],"disabled":false}],"filters":{"trade_filters":{"filters":{"account":{"input":"z0rhawk"}},"disabled":false}}},"sort":{"price":"asc"}}

    Unique weapon       {"query":{"status":{"option":"any"},"name":"Oro's Sacrifice","type":"Infernal Sword","stats":[{"type":"and","filters":[],"disabled":false}],"filters":{"trade_filters":{"filters":{"account":{"input":"z0rhawk"}},"disabled":false}}},"sort":{"price":"asc"}}
    (+ jewel)
    Gem                 {"query":{"status":{"option":"any"},"type":"Faster Attacks Support","stats":[{"type":"and","filters":[],"disabled":false}],"filters":{"misc_filters":{"filters":{"quality":{"max":99,"min":1},"gem_level":{"max":99,"min":1}},"disabled":false},"trade_filters":{"filters":{"account":{"input":"z0rhawk"}},"disabled":false}}},"sort":{"price":"asc"}}
    Map                 {"query":{"status":{"option":"any"},"type":{"option":"Cemetery Map","discriminator":"warfortheatlas"},"stats":[{"type":"and","filters":[],"disabled":false}],"filters":{"trade_filters":{"filters":{"account":{"input":"z0rhawk"}},"disabled":false},"map_filters":{"filters":{"map_tier":{"min":1,"max":99}}}}},"sort":{"price":"asc"}}
*/
    itemSplit := SplitItemNameAndBaseType(obj.Item, obj.Language), itemName := itemSplit.Name, itemBaseType := itemSplit.BaseType, itemCategory := itemSplit.Category
    if (itemName) {
        itemName_obj := {query:{term:itemName}}
        itemName_obj_trans := {query:{name:itemName}}
        itemName_obj := obj.Language="ENG" ? itemName_obj : itemName_obj_trans
    }
    if (itemBaseType)
        itemBaseType_obj := {"query":{"type":itemBaseType}}
    if (obj.GemQualityMin || obj.GemQualityMax)
        gemQual_obj := {"query":{"filters":{"misc_filters":{"filters":{"quality":{"min":obj.GemQualityMin,"max":obj.GemQualityMax}}}}}}
    if (obj.GemLevelMin || obj.GemLevelMax)
        gemLevel_obj := {"query":{"filters":{"misc_filters":{"filters":{"gem_level":{"min":obj.GemLevelMin,"max":obj.GemLevelMax}}}}}}
    if (obj.MapTierMin || obj.MapTierMax)
        mapTier_obj := {"query":{"filters":{"map_filters":{"filters":{"map_tier":{"min":obj.MapTierMin,"max":obj.MapTierMax}}}}}}
    if (obj.Account)
        accountName_obj := {"query":{"filters":{"trade_filters":{"filters":{"account":{"input":obj.Account}}}}}}
    if (obj.Online)
        online_obj := {"query":{"status":{"option":obj.Online}}}

    ; Building final obj
    ; baseObj := {"query":{"status":{"option":"any"},"stats":[{"type":"and","filters":[],"disabled":false}]},"sort":{"price":"asc"}}
    baseObj := {"query":{"status":{"option":"any"},"stats":[{"type":"and","filters":[],"disabled":false}]},"sort":{"price":"asc"}}
    searchObj := ObjFullyClone(baseObj)
    searchObj := ObjMerge(searchObj, itemName_obj)
    searchObj := ObjMerge(searchObj, itemBaseType_obj)
    searchObj := ObjMerge(searchObj, gemQual_obj)
    searchObj := ObjMerge(searchObj, gemLevel_obj)
    searchObj := ObjMerge(searchObj, mapTier_obj)
    searchObj := ObjMerge(searchObj, accountName_obj)
    searchObj := ObjMerge(searchObj, online_obj)
    searchObj := ObjMerge(online_obj, searchObj)

    return searchObj
}

/*
GGG_API_BuildExchangeSearchObj(obj) {
    if (obj.Account)
        account_obj := {exchange:{account:obj.Account}}
    if (obj.Online)
        online_obj := {exchange:{status:{option:obj.Online}}}
    if (obj.Fulfillable)
        fulfillable_obj := {exchange:{fulfillable:null}}
    if (obj.Minimum)
        minimum_obj := {exchange:{minimum:obj.Minimum}}
    if (obj.Want)
        if IsObject(obj.Want)
            want_obj := {exchange:{want:obj.Want}}
        else
            want_obj := {exchange:{want:[obj.Want]}}
    if (obj.Have)
        if IsObject(obj.Have)
            have_obj := {exchange:{have:obj.Have}}
        else
            have_obj := {exchange:{have:[obj.Have]}}

    ; Building final obj
    baseObj := {"exchange":{"status":{"option":"online"},"have":[],"want":[]}}
    searchObj := ObjFullyClone(baseObj)
    searchObj := ObjMerge(searchObj, account_obj)
    searchObj := ObjMerge(searchObj, online_obj)
    searchObj := ObjMerge(online_obj, searchObj) ; TO_DO param to force merge, and also inspect why it doesnt merge - does key exist already?
    searchObj := ObjMerge(searchObj, fulfillable_obj)
    searchObj := ObjMerge(searchObj, minimum_obj)
    searchObj := ObjMerge(searchObj, want_obj)
    searchObj := ObjMerge(searchObj, have_obj)

    return searchObj
}
*/

GGG_API_GetMatchingExchangeData(obj) {
    ; Building the search obj based on provided infos, then retrieving results
    poeURL := GetPoeDotComUrlBasedOnLanguage(obj.Language), poeSearchObj := GGG_API_BuildExchangeSearchObj(obj)
    url := poeURL "/api/trade/exchange/" obj.League
    headers := "Content-Type:application/json;charset=UTF-8"
    data := JSON_Dump(poeSearchObj)
    options := "TimeOut: 25"
    . "`n"  "Charset: UTF-8"
    WinHttpRequest_cURL(url, data, headers, options), html := data, jsonData := JSON_Load(html)

    ; Making result list, retrieving individual items, then parsing those
    resultsListCount := 0, resultsIDList := ""
    resultsTotalCount := jsonData.result.Count()
    matchingObj := {}, matchIndex := 0
    Loop % jsonData.result.Count() {
        resultsIndex := A_Index, thisResultID := jsonData.result[resultsIndex], resultsListCount++
        resultsIDList := resultsIDList?resultsIDList "," thisResultID : thisResultID
        if (resultsListCount=20 || resultsIndex=resultsTotalCount) {
            url := poeURL "/api/trade/fetch/" resultsIDList "?exchange=true&query=" jsonData.id
            headers := "Content-Type:application/json;charset=UTF-8"
            options := "TimeOut: 25"
            . "`n"  "Charset: UTF-8"
            WinHttpRequest_cURL(url, data:="", headers, options), html := data, resultsJson := JSON_Load(html)

            Loop % resultsListCount {
                thisResult := resultsJson.result[A_Index]
                isDataMatching := GGG_API_IsExchangeDataMatching(obj, {Ratio:thisResult.listing.price.exchange.amount / thisResult.listing.price.item.amount})
                if (isDataMatching) {
                    matchingObj := {}
                    matchingObj.1 := resultsJson.result[A_Index]
                    Break
                }
                else {
                    matchIndex++
                    matchingObj[matchIndex] := resultsJson.result[A_Index]
                }
            }

            if (isDataMatching)
                Break

            ; FileDelete, html.txt
            ; FileAppend,% JSON_Dump(resultsJson), html.txt, utf-8
            resultsIDList := 0, resultsIDList := ""
        }
    }

    return matchingObj
}

GGG_API_BuildExchangeSearchObj(obj) {
    baseObj := {"exchange":{"status":{"option":"online"},"have":[],"want":[]}}

    if (obj.Account)
        account_obj := {"exchange":{"account":obj.Account}}
    if (obj.Online)
        online_obj := {"exchange":{"status":{"option":obj.Online}}}
    if (obj.Fulfillable)
        fulfillable_obj := {"exchange":{"fulfillable":null}}
    if (obj.Minimum)
        minimum_obj := {"exchange":{"minimum":obj.Minimum}}
    if (obj.Want)
        if IsObject(obj.Want)
            want_obj := {"exchange":{"want":obj.Want}}
        else
            want_obj := {"exchange":{"want":[obj.Want]}}
    if (obj.Have)
        if IsObject(obj.Have)
            have_obj := {"exchange":{"have":obj.Have}}
        else
            have_obj := {"exchange":{"have":[obj.Have]}}

    ; Building final obj
    searchObj := ObjFullyClone(baseObj)
    searchObj := ObjMerge(searchObj, account_obj)
    searchObj := ObjMerge(searchObj, online_obj)
    searchObj := ObjMerge(online_obj, searchObj)
    searchObj := ObjMerge(searchObj, fulfillable_obj)
    searchObj := ObjMerge(searchObj, minimum_obj)
    searchObj := ObjMerge(searchObj, want_obj)
    searchObj := ObjMerge(searchObj, have_obj)

    return searchObj
}

GGG_API_IsExchangeDataMatching(obj, obj2) {
    ratio1 := obj.Ratio, ratio2 := obj2.Ratio
    AutoTrimStr(ratio1, ratio2)
    ratio1 := RemoveTrailingZeroes(ratio1)
    ratio2 := RemoveTrailingZeroes(ratio2)

    if (ratio1 = ratio2)
        return True
    else return False
}

GGG_API_GetMatchingItemsData(obj) {
    ; Building the search obj based on provided infos, then retrieving results
    poeURL := GetPoeDotComUrlBasedOnLanguage(obj.Language), poeSearchObj := GGG_API_BuildItemSearchObj(obj)
    url := poeURL "/api/trade/search/" obj.League
    data := JSON_Dump(poeSearchObj)
    headers := "Content-Type:application/json;charset=UTF-8"
    options := "TimeOut: 25"
    . "`n"  "Charset: UTF-8"
    WinHttpRequest_cURL(url, data, headers, options), html := data, jsonData := JSON_Load(html)

    ; Making result list, retrieving individual items, then parsing those
    resultsListCount := 0, resultsIDList := ""
    resultsTotalCount := jsonData.result.Count()
    matchingObj := {}, matchIndex := 0
    Loop % jsonData.result.Count() {
        resultsIndex := A_Index, thisResultID := jsonData.result[resultsIndex], resultsListCount++
        resultsIDList := resultsIDList?resultsIDList "," thisResultID : thisResultID
        if (resultsListCount=10 || resultsIndex=resultsTotalCount) {
            url := poeURL "/api/trade/fetch/" resultsIDList "?query=" jsonData.id
            headers := "Content-Type:application/json;charset=UTF-8"
            options := "TimeOut: 25"
            . "`n"  "Charset: UTF-8"
            WinHttpRequest_cURL(url, data:="", headers, options), html := data, resultsJson := JSON_Load(html)

            Loop % resultsListCount {
                loopedResult := resultsJson.result[A_Index]
                isDataMatching := GGG_API_IsItemDataMatching(obj, {StashTab:loopedResult.listing.stash.name, StashX:loopedResult.listing.stash.x+1, StashY:loopedResult.listing.stash.y+1})
                if (isDataMatching) {
                    matchingObj := {}
                    matchingObj.1 := resultsJson.result[A_Index]
                    Break
                }
                else {
                    matchIndex++
                    matchingObj[matchIndex] := resultsJson.result[A_Index]
                }
            }

            if (isDataMatching)
                Break

            ; FileDelete, html.txt
            ; FileAppend,% JSON_Dump(jsonData), html.txt, utf-8
            resultsIDList := 0, resultsIDList := ""
        }
    }
    if (isDataMatching)
        return matchingObj
}

GGG_API_IsItemDataMatching(obj, obj2) {    
    if (obj.StashTab = obj2.StashTab)
    && (obj.StashX = obj2.StashX)
    && (obj.StashY = obj2.StashY)
        return True
}

SplitItemNameAndBaseType(itemFull, LANG="ENG") {
    global PROGRAM
	if !(LANG)
		LANG:="ENG"

    ; Labels := {"Accessories":1,"Armour":2,"Cards":3,"Currency":4,"Flasks":5,"Gems":6,"Jewels":7,"Maps":8,"Weapons":9,"Leaguestones":10,"Prophecies":11,"Captured Beasts":12}
    ; ENG_Labels := ["Accessories","Armour","Cards","Currency","Flasks","Gems","Jewels","Maps","Weapons","Leaguestones","Prophecies","Captured Beasts"]
    ; FRE_Labels := ["Accessoires","Armure","Cartes divinatoires","Objets monétaires","Flacons","Gemmes","Joyaux","Cartes","Armes","Pierres de ligue","Prophéties","Bêtes capturées"]
    ; GER_Labels := ["Schmuck","Rüstung","Weissagungskarten","Währung","Fläschchen","Gemmen","Juwelen","Karten","Waffen","Liga-Steine","Prophezeiungen","Eingefangene Bestien"]
    ; KOR_Labels := ["장신구","방어구","카드","화폐","플라스크","젬","주얼","지도","무기","리그스톤","예언","포획한 야수"]
    ; POR_Labels := ["Acessórios","Armadura","Cartas","Itens Monetários","Frascos","Gemas","Joias","Mapas","Armas","Pedras de Ligas","Profecias","Bestas Capturadas"]
    ; RUS_Labels := ["Бижутерия","Броня","Гадальные карты","Валюта","Флаконы","Камни","Самоцветы","Карты","Оружие","Камни лиги","Пророчества","Пойманные животные"]
    ; SPA_Labels := ["Accesorios","Armaduras","Cartas","Moneda","Frascos","Gemas","Joyas","Mapas","Armas","Piedras de Liga","Profecías","Bestias capturadas"]
    ; THA_Labels := ["เครื่องประดับ","เกราะ","การ์ด","เคอเรนซี่","ขวดยา","Gems","Jewels","แผนที่","อาวุธ","Leaguestones","Prophecies","สัตว์ที่ถูกจับ"]

    itemsJSON := JSON_Load(PROGRAM.DATA_FOLDER "\poeDotComItemsData.json")
 
    Loop % itemsJSON[LANG].Count() {
        loop1Index := A_Index, sectName := itemsJSON[LANG][loop1Index].label
        Loop % itemsJSON[LANG][loop1Index].entries.Count() {
            entryIndex := A_Index, thisEntry := itemsJSON[LANG][loop1Index].entries[A_Index]
            isUnique := thisEntry.flags.unique = True ? True : False
            isAccessory := sectName = "Accessories" ? True : False
            isArmour := sectName = "Armour" ? True : False
            isCard := sectName = "Cards" ? True : False
            isCurrency := sectName = "Currency" ? True : False
            isFlask := sectName = "Flasks" ? True : False
            isGem := sectName = "Gems" ? True : False
            isJewel := sectName = "Jewels" ? True : False
            isMap := sectName = "Maps" ? True : False
            isWeapon := sectName = "Weapons" ? True : False
            isLeaguestone := sectName = "Leaguestones" ? True : False
            isProphecy := thisEntry.flags.prophecy = True ? True : sectName = "Prophecies" ? True : False
            isCapturedBeast := sectName = "Captured Beasts" ? True : False

            ; if (thisEntry.name " " thisEntry.type = itemFull) && ( StrLen(thisEntry.name " " thisEntry.type) = StrLen(itemFull) ) ; unique items
            ;     Return {Name:thisEntry.name, BaseType:thisEntry.type} 
            ; else if (thisEntry.type = itemFull) ; other items with base type, white
            ;     Return {Name:thisEntry.name, BaseType:thisEntry.type}
            ; else if IsContaining(itemFull, thisEntry.type) { ; other items with base type, magic or rare
            ;     longestMatch := !longestMatch ? thisEntry ; making sure to only get the longest match
            ;         : longestMatch && StrLen(longestMatch) < StrLen(thisEntry.type) ? thisEntry
            ;         : longestMatch
            ; }

            if (isUnique) { ; Unique always have full name - .name then .type
                if (thisEntry.name " " thisEntry.type = itemFull) ; if match perfectly, that's our item
                    Return {Name:thisEntry.name, BaseType:thisEntry.type, Category:sectName}
            }
            else if (isCard || isCurrency || isMap || isGem) { ; .type is actual full name
                if (thisEntry.type = itemFull)
                    Return {Name:thisEntry.name, BaseType:thisEntry.type, Category:sectName}
            }
            else if (isProphecy) {

            }

            if (!isUnique || !thisEntry.name) ; if there is no .name, means this entry is not unique
                && IsContaining(itemFull, thisEntry.type) { ; if our item contains .type, it may be the one we're looking for

                longestMatch_bak := longestMatch
                longestMatch := !longestMatch ? thisEntry.type ; making sure to only get the longest match
                    : longestMatch && StrLen(longestMatch) < StrLen(thisEntry.type) ? thisEntry.type
                    : longestMatch
                if (longestMatch != longestMatch_bak) {
                    category := sectName
                    RegExMatch(itemFull, "iO)(.*?)" longestMatch, itemPat), itemName := itemPat.1, itemType := longestMatch
                    ; itemMatchSplit := StrSplit(itemFull, longestMatch), itemName := itemMatchSplit.1, itemType := itemMatchSplit.2
                    AutoTrimStr(itemName, itemType)
                }
            }
        }
    }
    Return {Name:itemName, BaseType:itemType, Category:category}
}

GGG_API_Get_ActiveTradingLeagues() {
/*		Retrieves leagues from the API
		Parse them, to keep only non-solo or non-ssf leagues
*/
	global PROGRAM, GAME
	static timeOut

	apiLink 			:= "http://api.pathofexile.com/leagues?type=main&compact=1"
	excludedWords 		:= "SSF,Solo"
	activeLeaguesList	:= "Standard,Hardcore,Beta Standard,Beta Hardcore,Harbinger,Hardcore Harbinger"
	tradingLeagues := []
	Loop, Parse, activeLeaguesList,% ","
		tradingLeagues.Push(A_LoopField) ; In case api cannot be reached


	attempts++
	timeOut := (attempts = 1)?(10000) ; 10s
			   :(attempts = 2)?(30000) ; 30s
			   :(60000) ; 60s
	nextAttempt := (IsBetween(attempts, 1, 2))?(300000) ; 5mins
				  :(IsBetween(attempts, 3, 4))?(600000) ; 10mins
				  :(1800000)
	if (attempts > 1) {
		TrayNotifications.Show(PROGRAM.TRANSLATIONS.TrayNotifications.ReachLeaguesAPIRetry_Title, "")
	}
	Try {
;		Retrieve from online API
		WinHttpReq := ComObjCreate("WinHttp.WinHttpRequest.5.1")
		WinHttpReq.SetTimeouts(timeOut, timeOut, timeOut, timeOut)
		WinHttpReq.Open("GET", apiLink, true) ; Using true above and WaitForResponse allows the script to r'emain responsive.
		WinHttpReq.Send()
		WinHttpReq.WaitForResponse(10) ; 10 seconds
		leaguesJSON := WinHttpReq.ResponseText
	}
	Catch e { ; Cannot reach. Use internal leagues instead.
		Set_Format("Float", "0")

		AppendtoLogs("Failed to reach Leagues API. Obj.Message: """ WinHttpReq.Message """")
		trayMsg := StrReplace(PROGRAM.TRANSLATIONS.TrayNotifications.ReachLeaguesAPIFail_Msg, "%time%", (nextAttempt/1000)/60)
		TrayNotifications.Show(PROGRAM.TRANSLATIONS.TrayNotifications.ReachLeaguesAPIFail_Title, trayMsg, {Fade_Timer:10000})
		SetTimer,% A_ThisFunc, -%nextAttempt%

		Set_Format()

		Trading_Leagues := tradingLeagues
		Return
	}

	if (attempts > 1) {
		AppendtoLogs("Successfully reached Leagues API on attempt " attempts)
		trayMsg := StrReplace(PROGRAM.TRANSLATIONS.TrayNotifications.ReachLeaguesAPISuccess_Msg, "%number%", attempts)
		TrayNotifications.Show(PROGRAM.TRANSLATIONS.TrayNotifications.ReachLeaguesAPISuccess_Title, trayMsg, {Fade_Timer:5000})
		attempts := 0
	}

;	Parse the leagues (JSON)
	parsedLeagues := JSON.Load(leaguesJSON)
	Loop % parsedLeagues.MaxIndex() {
		arrID 		:= parsedLeagues[A_Index]
		leagueName 	:= arrID.ID
		if leagueName not in %activeLeagues%
		{
 			activeLeagues .= "," leagueName
		}
	}

;	Remove SSF & Solo leagues
	tradingLeagues := []
	Loop, Parse, activeLeagues,% "D," 
	{
		if A_LoopField not contains %excludedWords%
		{
			tradingLeagues.Push(A_LoopField)
		}
	}

	Return tradingLeagues
}

GetPoeDotComUrlBasedOnLanguage(lang) {
    poeUrlPrefix := lang="ENG"?"www"
        : lang = "RUS" ? "ru"
        : lang = "FRE" ? "fr"
        : lang = "POR" ? "br"
        : lang = "THA" ? "th"
        : lang = "GER" ? "de"
        : lang = "SPA" ? "es"
        : lang = "KOR" ? "" ; not needed, they use different url
        : lang = "TWN" ? "" ; same
        : "www"

    poeUrl := lang="KOR" ? "https://poe.game.daum.net"
        : lang="TWN" ? "https://web.poe.garena.tw"
        : "https://" poeUrlPrefix ".pathofexile.com"

    return poeUrl
}

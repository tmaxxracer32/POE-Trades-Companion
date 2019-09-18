PoeDotCom_GetCurrentlyLoggedCharacter(accName) {
    global PROGRAM
    lastChar := GGG_API_GetLastActiveCharacter(accName)

    if !(lastChar) {
        trayMsg := StrReplace(PROGRAM.TRANSLATIONS.TrayNotifications.FailedToRetrieveAccountCharacters_Msg, "%account%", accName)
        TrayNotifications.Show(PROGRAM.TRANSLATIONS.TrayNotifications.FailedToRetrieveAccountCharacters_Title, trayMsg)
    }
    return lastChar
}

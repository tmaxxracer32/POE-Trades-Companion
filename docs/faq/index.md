- [**How do I install this?**](#how-do-i-install-this)  
- [**How do I uninstall this?**](https://lemasato.github.io/POE-Trades-Companion/faq/#how-do-i-uninstall-this)  
- [**How can I reset my settings?**](https://lemasato.github.io/POE-Trades-Companion/faq/#how-can-i-reset-my-settings)  
- [**How can I share my settings?**](https://lemasato.github.io/POE-Trades-Companion/faq/#how-can-i-share-my-settings)  
- [**Is there any video tutorial for POE Trades Companion?**](https://lemasato.github.io/POE-Trades-Companion/faq/#is-there-any-video-tutorial-for-poe-trades-companion)  
&nbsp;  
- [**Is POE Trades Companion allowed by GGG?**](https://lemasato.github.io/POE-Trades-Companion/faq/#is-poe-trades-companion-allowed-by-ggg)  
- [**Why do I get a virus warning when using the executable?**](https://lemasato.github.io/POE-Trades-Companion/faq/#why-do-i-get-a-virus-warning-when-downloading-the-executable)  
&nbsp;  
- [**My Trades Interface disappears completely after pressing any button and never comes back**](https://lemasato.github.io/POE-Trades-Companion/faq/#my-trades-interface-disappears-completely-after-pressing-any-button-and-never-comes-back)  
- [**Holding ALT over an item in-game shows "Su   x" instead of "Suffix"**](https://lemasato.github.io/POE-Trades-Companion/faq/#holding-alt-over-an-item-in-game-shows-sux-instead-of-suffix)  
- [**Nothing happens when I receive a trading whisper or some whispers are ignored (notably Korean names)**](https://lemasato.github.io/POE-Trades-Companion/faq/#nothing-happens-when-i-receive-a-trading-whisper-or-some-whispers-are-ignored-notably-korean-names)  
&nbsp;  
***

## How do I install this?
[Refer to this page - Downloading and installing](https://lemasato.github.io/POE-Trades-Companion/#downloading-and-installing)  

## How do I uninstall this?
POE Trades Companion is a portable application.  
If you do not want to use it anymore, simply delete its folder.  

## How can I reset my settings?
The option to reset all settings back to default is available in the Settings interface.

## How can I share my settings?
Sharing settings can be done with the file `C:\Users\XXX\Documents\lemasato\POE Trades Companion\Preferences.json`

## Is there any video tutorial for POE Trades Companion?
Not as of now.

***

## Is POE Trades Companion allowed by GGG?  
GGG's stance on third party tools is "Do not use third-party programs in conjunction with Path of Exile".  
Generally, third-party tools cannot be fully approved by GGG.  

About POE Trades Companion specifically,
So far, nothing that POE Trades Companion offers falls out of the [ToS](https://www.pathofexile.com/legal/terms-of-use-and-privacy-policy).  
Some people may tell you that sending multiple chat messages using a single hotkey is against the [ToS](https://www.pathofexile.com/legal/terms-of-use-and-privacy-policy) but that's [false](https://www.pathofexile.com/legal/terms-of-use-and-privacy-policy). While Chris Wilson did say that macros should only do one server-side action, it was [way back in 2013](https://www.pathofexile.com/forum/view-thread/473902/page/5#p4197749) when AutoHotKey was rising in popularity with the player base. My opinion is that it was said in order to set a general rule. Using common sense, we can figure out that sending two chat messages (inviting the buyer then telling them the reason you invited them) does not provide any advantage.

Even so, POE Trades Companion offers a lot of customization and chat messages could be split in different hotkeys.  

## Why do I get a virus warning when downloading the executable?
Firstly, do **not** download the repository by clicking on the green "Clone or download" button. Always make sure to head to the [releases](https://github.com/lemasato/POE-Trades-Companion/releases) page and follow the instructions.  
By downloading the repository you could end up with some unnecessary files, an outdated version, or even an un-compiled project.

Now to explain about the virus warning... To put it simply, antivirus just don't like AutoHotKey scripts that were compiled by someone else. If you never used AutoHotKey scripts before, here's [How to use POE Trades Companion](https://github.com/lemasato/POE-Trades-Companion/wiki/How-to-use)

***

## My Trades Interface disappears completely after pressing any button and never comes back.
This issue is caused by a missing KB# Windows Update. Simply make sure to have an up-to-date Windows installation.

If you are on Windows 7/8.1 and you disabled Windows Update specifically because it would get stuck forever or hog up your CPU/RAM, click on [this link](http://wu.krelay.de/en/) and install the latest updates corresponding to your version then restart your computer.

## Holding ALT over an item in-game shows "Su&nbsp;&nbsp;&nbsp;x" instead of "Suffix".  
This is caused by the Fontin SmallCaps font.  
Uninstall the font from C:\Windows\Fonts, restart your computer, install the version of the font included with POE Trades Companion in `\POE-Trades-Companion\resources\fonts\Fontin-SmallCaps.ttf` and restart again.  

## Nothing happens when I receive a trading whisper or some whispers are ignored (notably Korean names).  
Try whispering yourself from poe.trade.

1. If nothing happens, then close your game and POE Trades Companion. Then, in your Path of Exile folder, delete the `\Path of Exile\logs\Client.txt` file. You can now restart your game and POE Trades Companion.

2. If whispering yourself works but some players whispers are still being "ignored", then it's highly likely that they are Korean.  
To quote Chris, `"Any message originating from a Kakao client isn't logged (regardless of whether it's a Korean or non-Korean user seeing the message)."`  
This is an issue on GGG side and there is nothing I can do about it. Due to privacy laws in Korea, GGG is not allowed to log any whisper received by a Korean player. Since the whispers are not logged, POE Trades Companion cannot create a new tab for the whisper.
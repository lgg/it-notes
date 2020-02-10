# WebView remote debug with Chrome DevTools

## Remote debug for iOS WebKit

* [ios-webkit-debug-proxy](https://github.com/google/ios-webkit-debug-proxy)
* [remotedebug-ios-webkit-adapter](https://github.com/RemoteDebug/remotedebug-ios-webkit-adapter)
    * For latest iOS you need to install [`@next version`](https://github.com/RemoteDebug/remotedebug-ios-webkit-adapter/issues/180#issuecomment-581134939)
    * `npm i -g remotedebug-ios-webkit-adapter@next`
* Open [chrome://inspect](chrome://inspect) and `Configure` -> add network target (`localhost:9000`)
 
## Remote Debug for Android WebKit

* `Enable USB Debugging` in your Android phone Settings
* install ADB or Anrdoid Studio
    * `sudo apt install adb`
* plug in your phone
* select trust device for debugging on your phone's popup
* Open [chrome://inspect](chrome://inspect)
* Useful links:
    * https://developer.chrome.com/devtools/docs/remote-debugging-legacy
    * https://developer.android.com/studio/command-line

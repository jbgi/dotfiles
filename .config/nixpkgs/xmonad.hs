
import           Control.Concurrent           (forkIO, threadDelay)
import           Control.Monad                (forever)
import           System.Exit
import           System.IO
import           System.Posix.Process         (getProcessID)
import           System.Posix.Signals         (sigTERM, signalProcess)

import           Graphics.X11.ExtraTypes.XF86
import           Graphics.X11.Types

import           XMonad

import           XMonad.Actions.CycleWS
import           XMonad.Actions.GridSelect
import           XMonad.Actions.Volume

import           XMonad.Hooks.DynamicLog
import           XMonad.Hooks.EwmhDesktops as EWMH
import           XMonad.Hooks.FadeInactive
import           XMonad.Hooks.ManageDocks
import           XMonad.Hooks.ManageHelpers
import           XMonad.Hooks.SetWMName

import XMonad.Layout.AutoMaster
import XMonad.Layout.Column
import XMonad.Layout.Renamed
import XMonad.Layout.Accordion
import XMonad.Layout.Maximize
import XMonad.Layout.Spacing

import           XMonad.Layout.Fullscreen as Fullscreen
import           XMonad.Layout.NoBorders
import           XMonad.Layout.Spiral
import           XMonad.Layout.Tabbed
import           XMonad.Layout.ThreeColumns

import           XMonad.Util.EZConfig         (additionalKeys)
import           XMonad.Util.Run              (spawnPipe)

import           XMonad.Config.Bepo
import           XMonad.Config.Kde

import qualified Data.Map                     as M
import qualified XMonad.StackSet              as W

import System.Environment (setEnv)


myTerminal = "gnome-terminal"
myModMask = mod4Mask


-- Colors for text and backgrounds of each tab when in "Tabbed" layout.
tabConfig = defaultTheme {
    activeBorderColor = "#7C7C7C",
    activeTextColor = "#CEFFAC",
    activeColor = "#000000",
    inactiveBorderColor = "#7C7C7C",
    inactiveTextColor = "#EEEEEE",
    inactiveColor = "#000000"
}

-- Color of current window title in xmobar.
xmobarTitleColor = "#FFB6B0"

-- Color of current workspace in xmobar.
xmobarCurrentWorkspaceColor = "#CEFFAC"

myLayout = smartBorders $ maximize $ avoidStruts (
    autoMasterLayout Accordion |||
    tabs |||
    Tall 1 (3/100) (1/3) |||
    Column 1.6
    )
    where threeCol = ThreeColMid 1 (3/100) (1/2)
          tabs = tabbedBottom shrinkText tabConfig
          autoMasterLayout otherLayout = renamed [Replace "Auto Master"] (autoMaster 1 (1/100) otherLayout)



myManageHook = composeAll [
                 className =? "kmix" --> doFloat
               , className =? "plasma-desktop" --> doFloat
               , className =? "Plasma-desktop" --> doFloat
               , className =? "plasmashell" --> doFloat
               ]

myGSConfig = defaultGSConfig


rofi = "@rofi@ -show run -fg '#505050' -bg '#000000' -hlfg '#ffb964' -hlbg '#000000' -hide-scrollbar"


myKeys conf@(XConfig {XMonad.modMask = modm}) =
    M.fromList [
  ((modm               , xK_p)    , spawn rofi)
  , ((modm .|. mod1Mask       , xK_Return), withFocused (sendMessage . maximizeRestore))
  , ((modm               , xK_f    ), sendMessage ToggleStruts)
  , ((modm               , xK_Right), nextWS)
  , ((modm               , xK_Left) , prevWS)
  , ((modm .|. shiftMask , xK_Right), shiftToNext >> nextWS)
  , ((modm .|. shiftMask , xK_Left) , shiftToPrev >> prevWS)
  , ((modm               , xK_g)    , goToSelected myGSConfig)
  , ((modm               , xK_d)    , spawn "emacsclient -c")
  , ((modm               , xK_b)    , spawn "@browser@")
  , ((noModMask, xF86XK_MonBrightnessUp)    , spawn "xbacklight +1")
  , ((noModMask, xF86XK_MonBrightnessDown)  , spawn "xbacklight -1")
  , ((noModMask, xF86XK_AudioRaiseVolume) , spawn "amixer set 'Master' 1%+")
  , ((noModMask, xF86XK_AudioLowerVolume) , spawn "amixer set 'Master' 1%-")
  , ((noModMask, xF86XK_AudioMute) , spawn "amixer set 'Master' toggle")
  , ((modm               , xK_l), spawn "@lockCmd@")
  ]


configuration =
  let cfg = defaultConfig
  in cfg {
    -- simple stuff
    terminal           = myTerminal
  , modMask            = myModMask

  -- hooks, layouts
  , layoutHook = smartBorders $ myLayout
  , manageHook = manageDocks <+> myManageHook <+> manageHook cfg
  , startupHook = ewmhDesktopsStartup >> ewmhDesktopsLogHook
  , handleEventHook = Fullscreen.fullscreenEventHook <+> EWMH.fullscreenEventHook <+> ewmhDesktopsEventHook <+> docksEventHook <+> handleEventHook cfg

  -- key bindings
  , keys = myKeys <+> keys cfg
  }
  
tray = unwords [
  "trayer"
  , "--edge top"
  ,  "--align center"
  ,  "--expand true"
  ,  "--width 10 --height 15"
  ,  "--transparent true"
  ,  "--alpha 0"
  ,  "--tint 0x000000"
  ,  "--SetDockType true"
  ,  "--SetPartialStrut true"
  ]

main = do 
  xmobarProc <- spawnPipe "@xmobar@ ~/.xmobar.hs"
  spawn tray

  -- fix java applications
  -- https://wiki.haskell.org/Xmonad/Frequently_asked_questions#Preferred_Method
  setEnv "_JAVA_AWT_WM_NONREPARENTING" "1"

  xmonad $ ewmh configuration {
    logHook = (fadeInactiveLogHook 0.8) >> (dynamicLogWithPP $ xmobarPP {
      ppOutput = \s -> hPutStrLn xmobarProc s
    , ppTitle = xmobarColor xmobarTitleColor "" . shorten 100
    , ppCurrent = xmobarColor xmobarCurrentWorkspaceColor ""
    , ppSep = "    "
    })
  , borderWidth = 3
  -- , keys = \c -> bepoKeys c `M.union` keys defaults c 
  }


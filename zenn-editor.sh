#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title zenn-editor

# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🤖

current_space=2

osascript -e 'tell application "System Events" to key code 19 using control down'
sleep 0.8

/Applications/Ghostty.app/Contents/MacOS/ghostty -e zsh -lc "
    cd ~/src/github.com/nematatu/zenn &&
    npx zenn preview > /dev/null 2>&1 &
    nvim" > /dev/null 2>&1 & disown

sleep 1

ghostty_id=$(yabai -m query --windows | jq '.[] | select(.app=="Ghostty" and (.title | test("zenn"))) | .id')

sleep 0.5 

osascript <<'APPLESCRIPT'
tell application "Google Chrome"
    activate
    set newWindow to make new window
    tell newWindow
        set URL of active tab to "http://localhost:8000"
    end tell
    set winID to id of newWindow
    do shell script "/bin/bash -c \"echo " & winID & " > /Users/nematatu/.zenn_chrome_id\""
end tell
APPLESCRIPT

sleep 1 

chrome_id=$(yabai -m query --windows | jq '.[] | select(.app=="Google Chrome" and .title =="Zenn Editor - Google Chrome - 辰樹") | .id')

if [ -n "$ghostty_id" ] && [ -n "$chrome_id" ]; then
  yabai -m window $chrome_id --grid 1:2:1:0:1:1
  yabai -m window $ghostty_id --grid 1:2:0:0:1:1      
elif [ -n "$ghostty_id" ]; then
  echo "⚠️ Chrome window not found"
elif [ -n "$chrome_id" ]; then
  echo "⚠️ Ghostty window not found"
else
  echo "❌ Both windows not found"
fi

osascript -e 'tell application "System Events" to key code 19 using control down'

#mac-configure.sh VNC_USER_PASSWORD VNC_PASSWORD NGROK_AUTH_TOKEN

#disable spotlight indexing
 mdutil -i off -a

#Create new account
 dscl . -create /Users/vncuser
 dscl . -create /Users/vncuser UserShell /bin/bash
 dscl . -create /Users/vncuser RealName "VNC User"
 dscl . -create /Users/vncuser UniqueID 1001
 dscl . -create /Users/vncuser PrimaryGroupID 80
 dscl . -create /Users/vncuser NFSHomeDirectory /Users/vncuser
 dscl . -passwd /Users/vncuser $1
dscl . -passwd /Users/vncuser $1
createhomedir -c -u vncuser > /dev/null

#Enable VNC
 /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -allowAccessFor -allUsers -privs -all
 /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -clientopts -setvnclegacy -vnclegacy yes 

#VNC password - http://hints.macworld.com/article.php?story=20071103011608872
echo $2 | perl -we 'BEGIN { @k = unpack "C*", pack "H*", "1734516E8BA8C5E2FF1C39567390ADCA"}; $_ = <>; chomp; s/^(.{8}).*/$1/; @p = unpack "C*", $_; foreach (@k) { printf "%02X", $_ ^ (shift @p || 0) }; print "\n"' | sudo tee /Library/Preferences/com.apple.VNCSettings.txt

#Start  /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kico /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate

#install ngrok
brew install --cask ngrok

#configure ngrok and start it
ngrok authtoken $3
ngrok tcp 5900 &

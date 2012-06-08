#!/bin/bash -x
TARG="$1"
APP="$TARG/Products/Applications/TapToggle.app"
WD="$APP/Contents"
if [ -e "$WD/_CodeSignature" ] ; then
	rm -fr "$WD/_CodeSignature"
fi

buildNumber=$(/usr/libexec/PlistBuddy -c "Print BuildMachineOSBuild" "$WD/Info.plist")
buildNumber=${buildNumber%*[a-z]}
/usr/libexec/PlistBuddy -c "Set :BuildMachineOSBuild $buildNumber" "$WD/Info.plist"

codesign -s "3rd Party Mac Developer Application: polyMicro Systems" -fv "$APP"
codesign -s "3rd Party Mac Developer Application: polyMicro Systems" -fv "$WD/Resources/relaunch"
#!bin/bash

flutter build macos

appdmg config.json output.dmg

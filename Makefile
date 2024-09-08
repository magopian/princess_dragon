
DATE:=$(shell date "+%Y-%m-%d %H:%M")

update_version:
	sed -i '' 's/config\/version=".*"/config\/version="$(DATE)"/' project.godot

git_bump_version:
	git add project.godot && git commit -m "Bump version number"

export_from_godot:
	/Applications/Godot.app/Contents/MacOS/Godot --headless --export-release "Princess Dragon" exports/index.html

upload_to_itch:
	../butler-darwin-amd64/butler push exports/Archive.zip magopian/princess-dragon:html

export: update_version git_bump_version export_from_godot upload_to_itch
	cd exports && rm -rf Archive.zip && zip Archive *



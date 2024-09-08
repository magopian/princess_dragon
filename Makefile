
DATE:=$(shell date "+%Y-%m-%d %H:%M")

update_version:
	sed -i '' 's/config\/version=".*"/config\/version="$(DATE)"/' project.godot

git_bump_version:
	git add project.godot && git commit -m "Bump version number"

export_from_godot:
	/Applications/Godot.app/Contents/MacOS/Godot --headless --export-release "Princess Dragon" exports/index.html

export: update_version git_bump_version export_from_godot
	cd exports && rm -rf Archive.zip && zip Archive *

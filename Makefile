# Makefile to install, config and update our dependencies.

# TODO: split the etherpad stuff into it's own makefile that goes in vendor?

all: etherpad git2changelog

vendor/git2changelog/git2changelog.py:
	@mkdir -p vendor bin
	rm -rf vendor/git2changelog
	git clone git://github.com/jvasile/git2changelog.git vendor/git2changelog
	rm -rf bin/git2changelog.py
	ln -s ../vendor/git2changelog/git2changelog.py bin/git2changelog.py

vendor/etherpad-lite:
	@mkdir -p vendor var
	git clone 'git://github.com/Pita/etherpad-lite.git' vendor/etherpad-lite
	mv vendor/etherpad-lite/var var/wiki_pages
	ln -s ../../var/wiki_pages vendor/etherpad-lite/var
	ln -s ../../etc/etherpad-lite.json vendor/etherpad-lite/settings.json
	cd vendor/etherpad-lite; npm install sqlite3 node-gyp ep-linkify

vendor/etherpad-lite/node_modules/ep_linkify: vendor/etherpad-lite 
	cd vendor/etherpad-lite; npm install ep_linkify

vendor/etherpad-lite/node_modules/node-gyp: vendor/etherpad-lite
	cd vendor/etherpad-lite; npm install node-gyp

vendor/etherpad-lite/node_modules/sqlite3: vendor/etherpad-lite
	if `dpkg -l | grep -q libsqlite3-dev`; then echo libsqlite3-dev found... good; else echo "Need to install libsqlite3-dev"; exit 1; fi
	cd vendor/etherpad-lite; npm install sqlite3
	cd vendor/etherpad-lite/node_modules/sqlite3; npm install node-gyp
	cd vendor/etherpad-lite/node_modules/sqlite3; node_modules/node-gyp/bin/node-gyp.js configure;
	cd vendor/etherpad-lite/node_modules/sqlite3; node_modules/node-gyp/bin/node-gyp.js build

git2changelog: vendor/git2changelog/git2changelog.py

etherpad: vendor/etherpad-lite vendor/etherpad-lite/node_modules/ep_linkify vendor/etherpad-lite/node_modules/sqlite3

update: etherpad
	echo "Updating depends (not updating hackfest-in-a-box itself)"
	cd vendor/etherpad-lite; git pull
	cd vendor/etherpad-lite; npm update ep_linkify sqlite3

clean-sqlite:
	rm -rf vendor/etherpad/node_modules/sqlite3

clean:
	rm -rf vendor var 
	rm -rf \#* .\#*

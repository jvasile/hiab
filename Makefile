# Makefile to install, config and update our dependencies.

# TODO: split the etherpad stuff into it's own makefile that goes in vendor?

all: etherpad

etc:
	mkdir -p etc

vendor:
	mkdir -p vendor

vendor/etherpad-lite: vendor etc
	git clone 'git://github.com/Pita/etherpad-lite.git' vendor/etherpad-lite
	mv vendor/etherpad-lite/var wiki_pages
	ln -s ../../wiki_pages vendor/etherpad-lite/var
	ln -s ../../etc/etherpad-lite.json vendor/etherpad-lite/settings.json

vendor/etherpad-lite/node_modules/sqlite3: vendor/etherpad-lite
	cd vendor/etherpad-lite; npm install sqlite3

vendor/etherpad-lite/node_modules/ep_linkify: vendor/etherpad-lite 
	cd vendor/etherpad-lite; npm install ep_linkify

etherpad: vendor/etherpad-lite vendor/etherpad-lite/node_modules/ep_linkify vendor/etherpad-lite/node_modules/sqlite3

update: etherpad
	echo "Updating depends (not updating hackfest-in-a-box itself)"
	cd vendor/etherpad-lite; git pull
	cd vendor/etherpad-lite; npm update ep_linkify


clean:
	rm -rf vendor
	rm -rf \#* .\#*

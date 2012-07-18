# Makefile to install, config and update our dependencies.

all: vendor/etherpad-lite

vendor:
	mkdir -p vendor

vendor/etherpad-lite: vendor
	git clone 'git://github.com/Pita/etherpad-lite.git' vendor/etherpad-lite
	mv vendor/etherpad-lite/var wiki_pages
	ln -s wiki_pages vendor/etherpad-lite/var

vendor/etherpad-lite/node_modules/ep_linkify: vendor/etherpad-lite
	cd vendor/etherpad-lite; npm install ep_linkify

etherpad: vendor/etherpad-lite vendor/etherpad-lite/node_modules/ep_linkify

update: etherpad
	echo "Updating depends (not updating hackfest-in-a-box itself)"
	cd vendor/etherpad-lite; git pull
	cd vendor/etherpad-lite; npm update ep_linkify


clean:
	rm -rf vendor
	rm -rf \#* .\#*

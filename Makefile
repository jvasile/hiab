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

vendor/etherpad-lite/node_modules/ep_linkify: vendor/etherpad-lite 
	cd vendor/etherpad-lite; npm install ep_linkify

git2changelog: vendor/git2changelog/git2changelog.py
etherpad: vendor/etherpad-lite vendor/etherpad-lite/node_modules/ep_linkify

update: etherpad
	echo "Updating depends (not updating hackfest-in-a-box itself)"
	cd vendor/etherpad-lite; git pull
	cd vendor/etherpad-lite; npm update ep_linkify


clean:
	rm -rf vendor var 
	rm -rf \#* .\#*

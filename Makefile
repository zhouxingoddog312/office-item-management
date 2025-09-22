desktop=oim.desktop
lib=functions
main=oim.sh
icons=
target=office-item-management-0.1.0.deb
.PHONY:release clean
release:
	cp $(main) ./release/usr/local/bin/oim
	cp $(lib) ./release/usr/local/bin/
	cp $(desktop) ./release/usr/share/office-item-management/oim.desktop
	dpkg --build ./release
	mv ./release.deb $(target)
clean:
	rm $(target)

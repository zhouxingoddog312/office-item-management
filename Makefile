desktop=oim.desktop
lib=functions
main=oim.sh
icons=src/icons/*.png
target=office-item-management-0.1.0.deb
.PHONY:release clean
release:
	cp $(main) ./release/usr/local/bin/oim
	cp $(lib) ./release/usr/local/bin/
	cp $(desktop) ./release/usr/share/office-item-management/oim.desktop
	cp $(icons) ./release/usr/share/office-item-management/icons
	dpkg-deb --build ./release
	mv ./release.deb $(target)
clean:
	rm $(target)
	rm ./release/usr/local/bin/oim
	rm ./release/usr/local/bin/$(lib)
	rm ./release/usr/share/office-item-management/$(desktop)
	rm ./release/usr/share/office-item-management/icons/*.png

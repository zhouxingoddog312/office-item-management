.PHONY:release clean
release:
	cp ./oim.sh ./release/usr/local/bin/oim
	cp ./oim.desktop ./release/usr/local/bin/
	dpkg --build ./release
	mv ./release.deb office-item-management-0.01.deb
clean:
	rm ./office-item-management-0.01.deb

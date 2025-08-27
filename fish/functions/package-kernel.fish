function package-kernel --description 'install kernel into temp-dir and package using tar'
	set -f tmpdir (mktemp -u -p ./)
	set -f kver (cat ./include/config/kernel.release)

	mkdir -p "$tmpdir/usr" "$tmpdir/lib"
	ln -s ../lib "$tmpdir/usr/lib"
	make -j (nproc --ignore=1) INSTALL_MOD_PATH="$tmpdir" modules_install
	make -j (nproc --ignore=1) INSTALL_PATH="$tmpdir/lib/modules/$kver" install

	tar -I pigz -cf "kernel-$kver.tgz" -C "$tmpdir" lib

	rm -rf "$tmpdir"
end


#!/usr/bin/env bash
set -e
make extraclean || true
# rm -rf ../build
./autogen.sh
export CFLAGS='-O3 -mtune=native -march=native -pipe'
# export CFLAGS='-O0 -g -ggdb -pipe'

./configure --prefix=$(realpath ../build) \
	--enable-link-time-optimization \
	--with-mailutils \
	--with-imagemagick \
	--with-tree-sitter --with-dbus --without-x --with-x-toolkit=no --with-pgtk \
	--with-xwidgets \
  --with-native-compilation=no --without-compress-install
make -j20 install

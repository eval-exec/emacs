let
  nixpkgs = import <nixpkgs> { };
  libwpe-fdo = nixpkgs.libwpe-fdo.overrideAttrs (old: rec {
    version = "1.16.1";
    src = nixpkgs.fetchurl {
      url = "https://wpewebkit.org/releases/wpebackend-fdo-${version}.tar.xz";
      sha256 = "sha256-VErhQBL45+QmuMtSLrCqqsgxrXw1YB0c8x03Zw4Ouzs=";
    };
  });
  wpewebkit =
    nixpkgs.callPackage /home/exec/Projects/github.com/eval-exec/nixos-configuration/pkgs/wpewebkit
      {
        # inherit libwpe-fdo;
      };
in
with nixpkgs;
mkShell {
  buildInputs = [
    gcc
    pkg-config
    imagemagick
    gtk3
    glib
    glib.bin
    mps
    libotf
    libwpe-fdo
    libwpe
    libsoup_3
    wpewebkit
    libepoxy
    libgccjit
    gnutls
    glib-networking
    gsettings-desktop-schemas
    libepoxy
    cacert
    tree-sitter
    librsvg
    ncurses5
    xorg.libXaw
    xorg.libXpm
    libxml2
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-vaapi
    xdg-dbus-proxy
    bubblewrap
    mesa
    libva
    intel-media-driver
    libdrm
    libinput
    wayland
    wayland-protocols
    wayland-scanner
    libgbm
    libxkbcommon
    libglvnd
    giflib
  ];
  LIBRARY_PATH = "${stdenv.cc.libc}/lib:${libgccjit}/lib:${stdenv.cc.cc.lib}/lib";
  NIX_ENFORCE_NO_NATIVE = 0;
  shellHook = ''
    export GIO_EXTRA_MODULES=${glib-networking}/lib/gio/modules
    export GSETTINGS_SCHEMA_DIR=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}/glib-2.0/schemas
    export SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt
    export SSL_CERT_DIR=${cacert}/etc/ssl/certs
    export G_TLS_CA_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt

    export WEBKIT_DISABLE_SANDBOX_THIS_IS_DANGEROUS=1
    export WEBKIT_PLATFORM=wayland
    export WEBKIT_BACKEND=fdo
    export WEBKIT_DEBUG=all
    export WAYLAND_DEBUG=0

    export WPE_BACKEND_LIBRARY=${libwpe-fdo}/lib/libWPEBackend-fdo-1.0.so.1
    export WPE_BACKEND_LIBDIR="$PWD/.wpe-backend"
    mkdir -p "$WPE_BACKEND_LIBDIR"
    ln -sf ${libwpe-fdo}/lib/libWPEBackend-fdo-1.0.so.1 \
      "$WPE_BACKEND_LIBDIR/libWPEBackend-default.so"
    export LD_LIBRARY_PATH="$WPE_BACKEND_LIBDIR:${libwpe-fdo}/lib:$LD_LIBRARY_PATH"
  '';
}

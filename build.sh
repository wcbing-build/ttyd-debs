#!/bin/sh

PACKAGE="ttyd"
REPO="tsl0922/ttyd"

VERSION="$(cat tag)"

ARCH="amd64 arm64"
AMD64_FILENAME="ttyd.x86_64"
ARM64_FILENAME="ttyd.aarch64"

get_url_by_arch() {
    case $1 in
    "amd64") echo "https://github.com/$REPO/releases/latest/download/$AMD64_FILENAME" ;;
    "arm64") echo "https://github.com/$REPO/releases/latest/download/$ARM64_FILENAME" ;;
    esac
}

build() {
    BASE_DIR="$PACKAGE"_"$VERSION"-1_"$1"
    cp -r "$PACKAGE"_version_arch "$BASE_DIR"
    sed -i "s/Architecture: arch/Architecture: $1/" "$BASE_DIR/DEBIAN/control"
    sed -i "s/Version: version/Version: $VERSION-1/" "$BASE_DIR/DEBIAN/control"
    curl -sLo "$BASE_DIR/usr/bin/$PACKAGE" "$(get_url_by_arch $1)"
    chmod 755 "$BASE_DIR/usr/bin/$PACKAGE"
    dpkg-deb --build --root-owner-group "$BASE_DIR"
}

for i in $ARCH; do
    echo "Building $i package..."
    build "$i"
done

# Create repo files
apt-ftparchive packages . > Packages
apt-ftparchive release . > Release

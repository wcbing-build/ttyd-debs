#!/bin/sh

PACKAGE="ttyd"
AMD64_URL="https://github.com/tsl0922/ttyd/releases/latest/download/ttyd.x86_64"
ARM64_URL="https://github.com/tsl0922/ttyd/releases/latest/download/ttyd.aarch64"

LOCAL_VERSION=$(curl -sI "https://github.com/wcbing/ttyd-debs/releases/latest" | grep location | sed -E 's#.*/releases/tag/[vV]*([^_\r]*).*#\1#')

if [ -z "$LOCAL_VERSION" ]; then
    LOCAL_VERSION='0'
fi

VERSION=$(curl -sI "https://github.com/tsl0922/ttyd/releases/latest" | grep location | sed -E 's#.*/releases/tag/[vV]*([^_\r]*).*#\1#')

if [ -z "$VERSION" ]; then
    echo "Error: VERSION is not set."
    echo 0 > tag
    exit 1
elif [ "$LOCAL_VERSION" = "$VERSION" ]; then
    echo "No update."
    echo 0 > tag
    exit 0
fi

echo "$VERSION" > tag
echo "Update to "$VERSION" from "$LOCAL_VERSION

build() {
    AMD64_DIR="$PACKAGE"_"$VERSION"_"$1"
    cp -r "$PACKAGE"_version_arch $AMD64_DIR
    sed -i "s/Architecture: arch/Architecture: "$1"/g" "$AMD64_DIR/DEBIAN/control"
    sed -i "s/Version: version/Version: $VERSION/g" "$AMD64_DIR/DEBIAN/control"
    curl -sLo "$AMD64_DIR"/usr/bin/"$PACKAGE" "$AMD64_URL"
    chmod 755 "$AMD64_DIR"/usr/bin/"$PACKAGE"
    dpkg-deb --build --root-owner-group "$AMD64_DIR"
}

# build amd64
echo "building amd64 package..."
build amd64

# build arm64
build arm64
echo "building arm64 package..."

# create repo file
apt-ftparchive packages . > Packages
apt-ftparchive release . > Release

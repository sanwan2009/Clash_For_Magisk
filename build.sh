#!/bin/sh

git submodule update --init --recursive

cd ./clash

VERSION=$(git describe --tags || echo "unknown version")

GOARCH=arm64 GOOS=android CGO_ENABLED=0 go build -trimpath -ldflags '-X "github.com/Dreamacro/clash/constant.Version=$(VERSION)" -X "github.com/Dreamacro/clash/constant.BuildTime=$(date -u)" -w -s -buildid=' -o bin/clash-android-arm64

cd ..

cp -f ./clash/bin/clash-android-arm64 ./system/bin/clash

zip -r -o -X -ll -q Clash_For_Magisk_${VERSION}.zip system clash.config customize.sh META-INF scripts template module.prop service.sh uninstall.sh README.md yacd-gh-pages
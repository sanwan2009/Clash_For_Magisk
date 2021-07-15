#!/bin/sh

git submodule update --init --recursive

cd ./clash

VERSION=$(git describe --tags || echo "unknown version")

GOARCH=arm64 GOOS=android CGO_ENABLED=0 go build -trimpath -ldflags '-X "github.com/Dreamacro/clash/constant.Version=$(VERSION)" -X "github.com/Dreamacro/clash/constant.BuildTime=$(date -u)" -w -s -buildid=' -o bin/clash-android-arm64

cd ..

cp -f ./clash/bin/clash-android-arm64 ./system/bin/clash

echo "id=Clash_For_Magisk" > ./module.prop
echo "name=Clash For Magisk" >> ./module.prop
echo "version=${VERSION}" >> ./module.prop
echo "versionCode=$(date +%Y%m%d)" >> ./module.prop
echo "author=kalasutra" >> ./module.prop
echo "description=利用tproxy支持Clash的透明代理.Clash内核为https://github.com/ClashDotNetFramework/experimental-clash版本以期支持providers.默认禁用ipv6." >> ./module.prop

zip -r -o -X -ll -q Clash_For_Magisk_${VERSION}.zip system clash.config customize.sh META-INF scripts template module.prop service.sh uninstall.sh README.md yacd-gh-pages
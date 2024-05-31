#!/bin/bash

CACHE_DIR="$HOME/.cache/sailfishos"

mkdir -p "$CACHE_DIR" &>/dev/null

function dl() {
    basename=$(basename $1)
    if [[ -f "$basename" ]];
    then
        echo "file $basename exists, skipping download"
        return
    fi
    wget $@
}

function importSfos() {
    # DOWNLOAD
    version="$1"
    shift
    download_cache="$CACHE_DIR/$version/dl"
    mkdir -p "$download_cache"
    pushd "$download_cache"
        dl https://releases.sailfishos.org/sdk/targets/Sailfish_OS-"$version"-Sailfish_SDK_Tooling-i486.tar.7z
        for arch in $@
        do
            dl https://releases.sailfishos.org/sdk/targets/Sailfish_OS-"$version"-Sailfish_SDK_Target-$arch.tar.7z
        done
    popd

    # EXTRACT
    build_cache="$CACHE_DIR/$version/extract"
    mkdir -p "$build_cache/tooling_i486"
    pushd "$build_cache/tooling_i486"
        if [[ ! -f "Sailfish_OS-$version-Sailfish_SDK_Tooling-i486.tar" ]];
        then
            7z x $download_cache/Sailfish_OS-"$version"-Sailfish_SDK_Tooling-i486.tar.7z
        fi
        tar -xvf "Sailfish_OS-$version-Sailfish_SDK_Tooling-i486.tar" \
            ./etc/os-release
    popd
    pushd "$build_cache"
        cat <<EOF > Dockerfile_tooling_i486 
FROM scratch

ADD tooling_i486/Sailfish_OS-$version-Sailfish_SDK_Tooling-i486.tar /

SHELL [ "/usr/bin/bash" ]
EOF
        $SUDO docker build --platform linux/i486 --tag ghcr.io/mrcyjanek/sailfishos:${version}_tooling_i486 --file Dockerfile_tooling_i486 .
    popd
    for arch in $@
    do
        mkdir -p "$build_cache/target_$arch"
        pushd "$build_cache/target_$arch"
            if [[ ! -f "Sailfish_OS-$version-Sailfish_SDK_Target-$arch.tar" ]];
            then
                7z x "$download_cache/Sailfish_OS-"$version"-Sailfish_SDK_Target-$arch.tar.7z"
            fi
        popd
        pushd "$build_cache"
        cat <<EOF > Dockerfile_target_$arch
FROM scratch

ADD target_$arch/Sailfish_OS-$version-Sailfish_SDK_Target-$arch.tar /

SHELL [ "/usr/bin/bash" ]
EOF
        $SUDO docker build --platform linux/$arch --tag ghcr.io/mrcyjanek/sailfishos:${version}_target_$arch --file Dockerfile_target_$arch .
        popd
    done


}

set -e

importSfos 2.1.3.7  i486 armv7hl
importSfos 2.1.4.13 i486 armv7hl
importSfos 2.2.0.29 i486 armv7hl
importSfos 2.2.1.18 i486 armv7hl
importSfos 3.0.0.8  i486 armv7hl
importSfos 3.0.1.11 i486 armv7hl
importSfos 3.0.2.8  i486 armv7hl
importSfos 3.0.3.8  i486 armv7hl
importSfos 3.0.3.9  i486 armv7hl
importSfos 3.1.0.12 i486 armv7hl
importSfos 3.2.0.12 i486 armv7hl
importSfos 3.2.1.19 i486 armv7hl
importSfos 3.2.1.20 i486 armv7hl
importSfos 3.3.0.14 i486 armv7hl
importSfos 3.3.0.16 i486 armv7hl
importSfos 3.4.0.22 i486 armv7hl
importSfos 3.4.0.24 i486 armv7hl aarch64
importSfos 4.0.1.45 i486 armv7hl aarch64
importSfos 4.0.1.48 i486 armv7hl aarch64
importSfos 4.1.0.23 i486 armv7hl aarch64
importSfos 4.1.0.24 i486 armv7hl aarch64
importSfos 4.2.0.19 i486 armv7hl aarch64
importSfos 4.2.0.21 i486 armv7hl aarch64
importSfos 4.3.0.12 i486 armv7hl aarch64
importSfos 4.3.0.15 i486 armv7hl aarch64
importSfos 4.4.0.58 i486 armv7hl aarch64
importSfos 4.5.0.16 i486 armv7hl aarch64
importSfos 4.5.0.18 i486 armv7hl aarch64
importSfos 4.6.0.11 i486 armv7hl aarch64
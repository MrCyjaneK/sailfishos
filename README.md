# SailfishOS docker images

All images are named in the following way: `ghcr.io/mrcyjanek/sailfishos/<version>_<target|tooling>_<arch>`. Versions from 2.1.3.7 to 3.4.0.22 support i486 tooling and i486, armv7hl target and images from 3.4.0.24 to 4.6.0.11 support i486 tooling and i486, armv7hl and aarch64 tooling. Images are single-arch, so you can trick badly written software that says it doesn't support qemu emulation into using it if you have docker configured properly (woodpecker - I am looking at you).

You can find the downloads here: https://ghcr.io/mrcyjanek/sailfishos if you need help then idk, open an issue or blame jolla and come to https://t.me/SFOSFanclub and ask about it.
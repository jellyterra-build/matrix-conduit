#/bin/bash

NAME=conduit
VER=$1

sudo apt update -qq
sudo apt install -qq g++-aarch64-linux-gnu g++-riscv64-linux-gnu g++-x86-64-linux-gnu

git clone -q --depth 1 --branch $VER https://gitlab.com/famedly/conduit $NAME

mkdir -p ~/build $NAME/.cargo
cat config.toml >> $NAME/.cargo/config.toml
cd $NAME

for ARCH in aarch64 riscv64gc x86_64
do
	rustup target add $ARCH-unknown-linux-gnu
	cargo build --release --target $ARCH-unknown-linux-gnu || exit 1
	mv target/$ARCH-unknown-linux-gnu/release/$NAME ~/build/$NAME-linux-$ARCH
done

cd ~/build
zstd *
sha256sum *.zst > SHA256SUMS.txt
cat SHA256SUMS.txt

#!/bin/bash

sudo pacman -S \
	fish \
	neovim \
	ghostty \
	go \
	npm \
	nodejs \
	python \
	pyenv \
	rustup \
	discord \
	docker \
	docker-buildx \
	fzf \
	nvtop \
	shotwell \
	viewnior \
	feh \
	mupdf \
	gallery-dl \
	gnome-keyring \
	noto-fonts-cjk \
	noto-fonts-emoji \
	noto-fonts \
	pulseaudio-bluetooth \
	lazygit \
	zig zls \
	ffmpegthumbnailer \
	ffmpeg \
	tumbler \
	blueman \
	vlc \
	7zip \
	noto-fonts-extra \
	cargo \
	tmux \
	noto-fonts \
	noto-fonts-emoji \
	unzip \
	git \
	base-devel \
	archlinux-xdg-menu

mkdir opt
cd opt

git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

yay install google-chrome


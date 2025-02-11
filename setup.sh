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
	zip \
	unzip \
	git \
	base-devel \
	archlinux-xdg-menu \
	grim \
	slurp \
	xdg-desktop-portal-hyprland \
	pipewire \
	wireplumber \
	xorg-xrandr \
	ark \
	qt6-svg \
	qt6-declarative \
	qt5-quickcontrols2 \
	rofi-wayland \
	nwg-drawer \
	btop \
	gucharmap \
	man \
	neofetch \
	kvantum \
	qt6ct \
	nwg-look \
	wl-clipboard \
	hyprpicker \
	ttf-font-awesome \
	hypridle \
	pavucontrol \
	hyprlock \
	waybar \
	hyprpaper

mkdir opt
cd opt

git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

yay install google-chrome



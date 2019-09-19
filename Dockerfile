FROM archlinux/base

RUN pacman -Sy
RUN pacman -S --noconfirm base-devel git

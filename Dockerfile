FROM archlinux/base

RUN pacman -Sy
RUN pacman -S base-devel git

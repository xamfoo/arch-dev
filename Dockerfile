FROM archlinux/base

RUN pacman -Sy
RUN pacman -S --noconfirm base-devel git &&
  git clone https://aur.archlinux.org/xorgxrdp.git &&
  cd xorgxrdp &&
  makepkg -si

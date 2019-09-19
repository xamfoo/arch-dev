FROM archlinux/base

RUN pacman -Sy
RUN pacman -S --noconfirm sudo
RUN useradd nonroot && \
  echo "nonroot ALL = (ALL) NOPASSWD: ALL" > /etc/sudoers.d/nonroot && \
  chmod 0440 /etc/sudoers.d/nonroot
RUN pacman -S --noconfirm base-devel git && \
  git clone https://aur.archlinux.org/xorgxrdp.git && \
  cd xorgxrdp && \
  runuser -l nonroot -c 'id' && \
  runuser -l  nonroot -c 'makepkg -si'

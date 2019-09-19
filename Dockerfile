FROM archlinux/base

RUN pacman -Sy
RUN pacman -S --noconfirm sudo
RUN useradd -m nonroot && \
  echo "nonroot ALL = (ALL) NOPASSWD: ALL" > /etc/sudoers.d/nonroot && \
  chmod 0440 /etc/sudoers.d/nonroot
RUN pacman -S --noconfirm base-devel git && \
  cd /tmp && \
  runuser nonroot -c 'git clone https://aur.archlinux.org/xrdp.git && cd xrdp && makepkg -si' && \
  runuser nonroot -c 'git clone https://aur.archlinux.org/xorgxrdp.git && cd xorgxrdp && makepkg -si'

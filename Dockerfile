FROM archlinux/base

RUN pacman -Sy
RUN pacman -S --noconfirm sudo base-devel git
RUN useradd -m nonroot && \
  echo "nonroot ALL = (ALL) NOPASSWD: ALL" > /etc/sudoers.d/nonroot && \
  chmod 0440 /etc/sudoers.d/nonroot
RUN cd /tmp && \
  runuser nonroot -c 'git clone https://aur.archlinux.org/xrdp.git && cd xrdp && makepkg --noconfirm -si'
RUN cd /tmp && \
  runuser nonroot -c 'git clone https://aur.archlinux.org/xorgxrdp.git && cd xorgxrdp && gpg --recv-keys 9F72CDBC01BF10EB && makepkg --noconfirm -si'
RUN pacman -Sc --noconfirm

FROM archlinux/base

RUN pacman -Sy
RUN pacman -S --noconfirm sudo base base-devel git
RUN useradd -m nonroot && \
  echo "nonroot ALL = (ALL) NOPASSWD: ALL" > /etc/sudoers.d/nonroot && \
  chmod 0440 /etc/sudoers.d/nonroot
RUN cd /tmp && \
  runuser nonroot -c 'git clone https://aur.archlinux.org/yay.git && cd yay && makepkg --noconfirm -si'
RUN gpg --recv-keys 9F72CDBC01BF10EB && \
  runuser nonroot -c 'yay -S --noconfirm xorgxrdp'
RUN pacman -S --noconfirm openssh xorg
RUN pacman -Sc --noconfirm
RUN systemctl enable sshd xrdp xrdp-sesman
ENV container docker
STOPSIGNAL SIGRTMIN+3

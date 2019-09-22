FROM archlinux/base

RUN pacman -Sy
RUN pacman -S --noconfirm sudo base base-devel git
RUN useradd -m nonroot && \
  echo "nonroot ALL = (ALL) NOPASSWD: ALL" > /etc/sudoers.d/nonroot && \
  chmod 0440 /etc/sudoers.d/nonroot && \
  cd /tmp && \
  runuser nonroot -c 'git clone https://aur.archlinux.org/yay.git && cd yay && makepkg --noconfirm -si' && \
  gpg --recv-keys 9F72CDBC01BF10EB && \
  runuser nonroot -c 'yay -S --noconfirm xorgxrdp' && \
  pacman -S --noconfirm openssh xorg xorg-xinit ttf-dejavu && \
  pacman -Sc --noconfirm
RUN echo "allowed_users=anybody" >> /etc/X11/Xwrapper.config && \
  echo 'Defaults env_keep += "http_proxy"' >> /etc/sudoers.d/11-forward-proxy && \
  echo 'Defaults env_keep += "HTTP_PROXY"' >> /etc/sudoers.d/11-forward-proxy && \
  echo 'Defaults env_keep += "https_proxy"' >> /etc/sudoers.d/11-forward-proxy && \
  echo 'Defaults env_keep += "HTTPS_PROXY"' >> /etc/sudoers.d/11-forward-proxy && \
  echo 'Defaults env_keep += "ftp_proxy"' >> /etc/sudoers.d/11-forward-proxy && \
  echo 'Defaults env_keep += "FTP_PROXY"' >> /etc/sudoers.d/11-forward-proxy && \
  echo 'Defaults env_keep += "no_proxy"' >> /etc/sudoers.d/11-forward-proxy && \
  echo 'Defaults env_keep += "NO_PROXY"' >> /etc/sudoers.d/11-forward-proxy && \
  systemctl enable sshd xrdp xrdp-sesman
ENV container docker
STOPSIGNAL SIGRTMIN+3

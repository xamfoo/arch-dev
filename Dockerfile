FROM archlinux/base

RUN pacman -Sy
RUN pacman -S --noconfirm sudo base base-devel git
RUN useradd -m nonroot && \
  echo "nonroot ALL = (ALL) NOPASSWD: ALL" > /etc/sudoers.d/nonroot && \
  chmod 0440 /etc/sudoers.d/nonroot && \
  cd /tmp && \
  runuser nonroot -c 'git clone https://aur.archlinux.org/yay.git && cd yay && makepkg --noconfirm -si' && \
  gpg --recv-keys 9F72CDBC01BF10EB && \
  runuser nonroot -c 'yay -S --noconfirm xorgxrdp'
RUN pacman -S --noconfirm openssh xorg xorg-xinit ttf-dejavu socat && \
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
  echo '#!/usr/bin/env bash\
if ! [ -e /dev/console ] ; then\
  socat -u pty,link=/dev/console stdout &\
fi\
exec /usr/lib/systemd/systemd "$@"' > /sbin/init-console && \
  chmod a+x /sbin/init-console && \
  systemctl enable sshd xrdp xrdp-sesman
ENV container docker
STOPSIGNAL SIGRTMIN+3

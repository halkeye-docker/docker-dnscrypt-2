FROM alpine
EXPOSE 53/tcp 53/udp

RUN apk add --no-cache wget ca-certificates

# Since the musl and glibc so are compatible, you can make this symlink and it will fix the missing dependency.
RUN mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2

RUN wget -O /etc/dnscrypt-proxy.toml https://raw.githubusercontent.com/jedisct1/dnscrypt-proxy/2dcf5fe01a5d90e37b6b2d35ce228fba4b2a1332/dnscrypt-proxy/example-dnscrypt-proxy.toml && \
			wget -O - https://github.com/jedisct1/dnscrypt-proxy/releases/download/2.0.8/dnscrypt-proxy-linux_x86_64-2.0.8.tar.gz | tar xvz -C /usr/bin --strip-components=1 && \
      sed -i -e "s/# server_names = .*$/server_names = [\'cloudflare\']/" /etc/dnscrypt-proxy.toml && \
      sed -i -e "s/^listen_addresses = .*$/listen_addresses = [\'127.0.0.1:53\']/" /etc/dnscrypt-proxy.toml

CMD ["/usr/bin/dnscrypt-proxy", "-config", "/etc/dnscrypt-proxy.toml"]

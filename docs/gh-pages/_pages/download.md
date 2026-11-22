---
title: "Download"
permalink: /download/
excerpt: "Download dosh for Debian, Ubuntu, Raspberry Pi OS, Fedora, Asahi Linux, and Windows."
---

<p id="dosh-os" class="notice--info" hidden></p>

## Linux

Install [Docker Engine], and download the package of your distribution:

<div class="dosh-grid dosh-packages">
  <article class="dosh-card">
    <i class="dosh-card__icon fab fa-debian" aria-hidden="true"></i>
    <h3>Debian, Ubuntu, Raspberry Pi OS</h3>
    <p>Debian package<br><code>dosh_9_all.deb</code></p>
    <div class="dosh-card__actions">
      <a class="btn btn--primary btn--small" href="https://github.com/gportay/dosh/releases/download/9/dosh_9_all.deb">Download</a>
      <a class="dosh-sig" href="https://github.com/gportay/dosh/releases/download/9/dosh_9_all.deb.sig">Signature</a>
    </div>
  </article>
  <article class="dosh-card">
    <i class="dosh-card__icon fab fa-fedora" aria-hidden="true"></i>
    <h3>Fedora, Asahi Linux</h3>
    <p>RPM package<br><code>dosh-9-1.noarch.rpm</code></p>
    <div class="dosh-card__actions">
      <a class="btn btn--primary btn--small" href="https://github.com/gportay/dosh/releases/download/9/dosh-9-1.noarch.rpm">Download</a>
      <a class="dosh-sig" href="https://github.com/gportay/dosh/releases/download/9/dosh-9-1.noarch.rpm.sig">Signature</a>
    </div>
  </article>
  <article class="dosh-card">
    <i class="dosh-card__icon fab fa-linux" aria-hidden="true"></i>
    <h3>Other distributions</h3>
    <p>Source archive<br><code>dosh-9.tar.gz</code></p>
    <div class="dosh-card__actions">
      <a class="btn btn--primary btn--small" href="https://github.com/gportay/dosh/archive/refs/tags/9.tar.gz">Download</a>
    </div>
  </article>
</div>

Then, install it from a terminal:

```console
$ sudo apt install ~/Downloads/dosh_9_all.deb
$ sudo dnf install ~/Downloads/dosh-9-1.noarch.rpm
```

Or, for other distributions, extract the archive, and install it:

```console
$ tar xf ~/Downloads/dosh-9.tar.gz
$ cd dosh-9
$ sudo make install
```

## Windows

Install Ubuntu with `wsl --install`, and [Docker Desktop] with **Settings** ›
**Resources** › **WSL integration** turned on. Then, in **Ubuntu**:

```console
$ curl -LO https://github.com/gportay/dosh/releases/download/9/dosh_9_all.deb
$ sudo apt install ./dosh_9_all.deb
```

[Docker Engine]: https://docs.docker.com/engine/install/
[Docker Desktop]: https://docs.docker.com/desktop/features/wsl/

<script>
  // Propose the section of the visitor's operating system.
  (function () {
    var ua = navigator.userAgent || "";
    var platform = ua + " " + ((navigator.userAgentData &&
                                navigator.userAgentData.platform) ||
                               navigator.platform || "");
    var os;
    if (/android|iphone|ipad|ipod/i.test(ua))
      return;
    if (/win/i.test(platform))
      os = { id: "windows", name: "Windows" };
    else if (/linux|x11|cros/i.test(platform))
      os = { id: "linux", name: "Linux" };
    if (!os || !document.getElementById(os.id))
      return;
    var notice = document.getElementById("dosh-os");
    notice.innerHTML = 'It looks like you are using ' + os.name +
      '. <a href="#' + os.id + '">Install dosh on ' + os.name + '</a>.';

    // Some browsers tell the Linux distribution in their user agent.
    var distros = [
      { re: /raspbian|raspberry/i, name: "Raspberry Pi OS", pkg: ".deb" },
      { re: /ubuntu/i, name: "Ubuntu", pkg: ".deb" },
      { re: /debian/i, name: "Debian", pkg: ".deb" },
      { re: /fedora/i, name: "Fedora", pkg: ".rpm" }
    ];
    for (var i = 0; os.id === "linux" && i < distros.length; i++) {
      if (!distros[i].re.test(ua))
        continue;
      var link = document.querySelector('.dosh-packages a[href$="' + distros[i].pkg + '"]');
      if (!link)
        break;
      notice.innerHTML = 'It looks like you are using ' + distros[i].name +
        '. <a href="' + link.href + '">Download ' + link.href.split("/").pop() +
        '</a>, and <a href="#linux">install it</a>.';
      break;
    }
    notice.hidden = false;
  })();
</script>

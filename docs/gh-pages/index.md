---
layout: splash
title: "A <mark>shell</mark> for Docker!"
excerpt: >-
  Use Docker containers as naturally as your local shell.<br>
  dosh runs your shell, as you, in a throwaway container
  defined by your Dockerfile. Your working directory is shared;
  the rest of your host stays untouched.<br>
  <small>Free software, licensed under the
  [LGPL-2.1-or-later](https://github.com/gportay/dosh/blob/master/LICENSE).</small>
header:
  overlay_color: "#F3F3F3"
  actions:
    - label: "Download"
      url: "/download/"
    - label: "Documentation"
      url: "https://dosh.readthedocs.io/"
    - label: "<i class='fab fa-fw fa-github'></i> Visit on GitHub"
      url: "https://github.com/gportay/dosh"
feature_row:
  - title: "Keep your <mark>host clean</mark>"
    icon: "fas fa-broom"
    excerpt: "Install your project dependencies in the image, not on your machine. Your host stays free of toolchains, libraries and conflicting versions; delete the image, and they are gone."
  - title: "Keep your build <mark>environment close</mark>"
    icon: "fas fa-toolbox"
    excerpt: "Define your dependencies in a minimal Dockerfile, just as you would when setting up a development machine. dosh builds the image when needed and starts a shell in the ready-to-use environment."
  - title: "Build the <mark>same way</mark>, everywhere"
    icon: "fas fa-users"
    excerpt: "Share a common environment across developers and CI pipelines. Everyone works with the same dependencies, avoiding inconsistencies and the dreaded “It works on my machine!”"
logos:
  - name: "Docker"
    logo: "/assets/images/docker.svg"
    url: "https://www.docker.com/"
  - name: "Podman"
    logo: "/assets/images/podman.svg"
    url: "https://podman.io/"
use_cases:
  - title: "Compile for <mark>another distribution</mark>"
    icon: "fas fa-layer-group"
    excerpt: "Compile your application with the toolchain and the libraries of the distribution it targets, such as an older Ubuntu release, without installing that distribution."
    url: "/other-distributions/"
  - title: "Build <mark>embedded Linux</mark> systems"
    icon: "fas fa-microchip"
    excerpt: "Build Yocto, OpenEmbedded and Buildroot projects directly inside containers, without the overhead of a virtual machine or changes to your existing build workflow."
    url: "/embedded-linux/"
  - title: "Package for <mark>multiple architectures</mark>"
    icon: "fas fa-boxes-stacked"
    excerpt: "Build Debian and RPM packages for different target architectures using multi-platform container images."
    url: "/multi-architecture/"
---

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@splidejs/splide@4.1.4/dist/css/splide-core.min.css">

<section class="dosh-features">
  <h2>How does dosh help you?</h2>
  <div class="dosh-grid">
    {% for item in page.feature_row %}
      <article class="dosh-card">
        <i class="dosh-card__icon {{ item.icon }}" aria-hidden="true"></i>
        <h3>{{ item.title }}</h3>
        <p>{{ item.excerpt }}</p>
      </article>
    {% endfor %}
  </div>
</section>

<section class="dosh-use-cases">
  <h2>What can you do with dosh?</h2>
  <div class="dosh-grid">
    {% for item in page.use_cases %}
      <article class="dosh-card">
        <i class="dosh-card__icon {{ item.icon }}" aria-hidden="true"></i>
        <h3>{{ item.title }}</h3>
        <p>{{ item.excerpt }}</p>
        <a class="btn btn--primary btn--small" href="{{ item.url | relative_url }}">Learn more</a>
      </article>
    {% endfor %}
  </div>
</section>

<section class="dosh-community">
  <div>
    <h2>How would you use dosh?</h2>
    <p>Have another use case in mind? Share your ideas, workflows and feedback. We'd love to hear how you use dosh.</p>
  </div>
  <a class="btn btn--primary" href="https://github.com/gportay/dosh/issues">Share your ideas on GitHub</a>
</section>

<section class="dosh-logos splide" aria-label="Container engines supported by dosh">
  <div class="splide__track">
    <ul class="splide__list">
      {% for logo in page.logos %}
        <li class="splide__slide">
          <a href="{{ logo.url }}"><img src="{{ logo.logo | relative_url }}" alt="{{ logo.name }}"></a>
        </li>
      {% endfor %}
    </ul>
  </div>
</section>

<script src="https://cdn.jsdelivr.net/npm/@splidejs/splide@4.1.4/dist/js/splide.min.js"></script>
<script>
  // Scroll the logos, as the carousels of www.rtone.fr.
  new Splide(".dosh-logos", {
    type: "loop",
    autoplay: true,
    interval: 2500,
    perPage: 4,
    perMove: 1,
    focus: "center",
    padding: "2rem",
    arrows: false,
    pagination: false,
    drag: "free",
    snap: false,
    breakpoints: {
      768: { perPage: 3, autoplay: false },
      576: { perPage: 2, autoplay: false }
    }
  }).mount();
</script>

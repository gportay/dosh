# Copyright (c) 2026 Gaël PORTAY
# SPDX-License-Identifier: LGPL-2.1-or-later
class Dosh < Formula
  desc "Run a user shell in a container with the working directory bind mounted"
  homepage "https://gportay.github.io/dosh/"
  url "https://github.com/gportay/dosh/archive/refs/tags/9.tar.gz"
  sha256 "d77234b61da824bd1d2db8998b14d3248bf6fc16d7810d0fbc876d0650f9efb8"
  license "LGPL-2.1-or-later"
  head "https://github.com/gportay/dosh.git", branch: "master"

  depends_on "asciidoctor" => :build
  depends_on "coreutils" => :build
  depends_on "bash"

  def install
    # macOS comes with bash 3.2; dosh requires bash 4.2 or later
    inreplace "dosh", %r{\A#!/(bin/bash|usr/bin/env bash)$}, "#!#{formula_opt_bin("bash")}/bash"
    # Look for the rc files installed by Homebrew
    inreplace "dosh", "/usr/local/share/dosh/rc.d:", "#{opt_pkgshare}/rc.d:/usr/local/share/dosh/rc.d:"

    # GNU install supports the option -D used by the Makefile
    ENV.prepend_path "PATH", formula_opt_libexec("coreutils")/"gnubin"
    system "make", "dosh.1.gz"
    system "make", "install-all",
                   "PREFIX=#{prefix}", "BASHCOMPLETIONSDIR=#{bash_completion}"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/dosh --version").strip unless version.head?
    (testpath/"Dockerfile").write "FROM scratch\n"
    ENV["DOSH_DOCKER"] = "echo docker"
    assert_match "docker run --rm", shell_output("#{bin}/dosh -c true")
  end
end

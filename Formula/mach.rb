# Homebrew formula template for the mach tap (TevaServices/homebrew-mach).
#
# Rendered by scripts/brew-bump.sh from the goreleaser artifacts of a
# release run — NEVER hand-edited in the tap. The service block is the
# Homebrew service DSL (docs.brew.sh, "Service Configuration"): it generates
# the launchd plist on macOS and a systemd unit on Linuxbrew.
#
# keep_alive successful_exit: false is the supervision contract
# (AGENTS.md invariant 22): only a FAILURE restarts; a clean exit (a
# retire, or an update handoff) stops the service. Same semantic as
# packaging/systemd/machd.service's Restart=on-failure.
#
# Placeholders (substituted, kept off a templating DSL on purpose: brew
# formulas are Ruby, {{ }} would collide):
#   0.12.5            the release version (no leading v)
#   v0.12.5          the release tag (v-prefixed)
#   bb1f64e7e32447eed13950eb8175531623c94630501c3b7de3a59ee7d932a71e  d1695ef56566ba8b54fd101177692e3f3d8bc5ec6e1df93d4ebdf0f48b0abc6d  0dac10efd5ff6dcee4be9ba1cce1010c5a12dbfab7e4603f67c5d40c0c3b91a2  d3f71810a7fc3bfda6a0a27eae3798745747cd9bc9aa25fe4302ba4e9ff656b7
class Mach < Formula
  desc "mach agent — outbound-only remote access daemon (remote CLI access to enrolled machines)"
  homepage "https://github.com/TevaServices/mach"
  version "0.12.5"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/TevaServices/mach/releases/download/v0.12.5/mach_0.12.5_darwin_amd64.zip"
      sha256 "0dac10efd5ff6dcee4be9ba1cce1010c5a12dbfab7e4603f67c5d40c0c3b91a2"
    end
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/TevaServices/mach/releases/download/v0.12.5/mach_0.12.5_darwin_arm64.zip"
      sha256 "d3f71810a7fc3bfda6a0a27eae3798745747cd9bc9aa25fe4302ba4e9ff656b7"
    end
  end

  on_linux do
    if Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
      url "https://github.com/TevaServices/mach/releases/download/v0.12.5/mach_0.12.5_linux_amd64.zip"
      sha256 "bb1f64e7e32447eed13950eb8175531623c94630501c3b7de3a59ee7d932a71e"
    end
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/TevaServices/mach/releases/download/v0.12.5/mach_0.12.5_linux_arm64.zip"
      sha256 "d1695ef56566ba8b54fd101177692e3f3d8bc5ec6e1df93d4ebdf0f48b0abc6d"
    end
  end

  def install
    bin.install "mach"
  end

  service do
    run [opt_bin/"mach", "run"]
    keep_alive successful_exit: false
    log_path var/"log/mach.log"
    error_log_path var/"log/mach.log"
    environment_variables MACH_STATE_DIR: "#{var}/mach"
  end

  test do
    system "#{bin}/mach", "version"
  end
end
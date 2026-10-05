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
#   0.12.4            the release version (no leading v)
#   v0.12.4          the release tag (v-prefixed)
#   5505ce3dda287dc068e9fa70d84b3932881188443c286350dcc2ddcc8b319c1a  cdfcd9e2cf16e91d31774170a2a3163c5392aac1e35cf8ee4a1aef50efe53443  283570891c290a93becc37d9786427a6863a660959fa48853e8ec4922b5beba0  40e27924babc147d2569cc18235a717fb5614d5c5f34568855ea20282f4510b7
class Mach < Formula
  desc "mach agent — outbound-only remote access daemon (remote CLI access to enrolled machines)"
  homepage "https://github.com/TevaServices/mach"
  version "0.12.4"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/TevaServices/mach/releases/download/v0.12.4/mach_0.12.4_darwin_amd64.zip"
      sha256 "283570891c290a93becc37d9786427a6863a660959fa48853e8ec4922b5beba0"
    end
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/TevaServices/mach/releases/download/v0.12.4/mach_0.12.4_darwin_arm64.zip"
      sha256 "40e27924babc147d2569cc18235a717fb5614d5c5f34568855ea20282f4510b7"
    end
  end

  on_linux do
    if Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
      url "https://github.com/TevaServices/mach/releases/download/v0.12.4/mach_0.12.4_linux_amd64.zip"
      sha256 "5505ce3dda287dc068e9fa70d84b3932881188443c286350dcc2ddcc8b319c1a"
    end
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/TevaServices/mach/releases/download/v0.12.4/mach_0.12.4_linux_arm64.zip"
      sha256 "cdfcd9e2cf16e91d31774170a2a3163c5392aac1e35cf8ee4a1aef50efe53443"
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
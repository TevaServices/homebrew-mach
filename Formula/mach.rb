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
#   0.12.3            the release version (no leading v)
#   v0.12.3          the release tag (v-prefixed)
#   864c1f429c513eecd93c455c2498ed7b0d046ffb491e054f37f0fbed665528a0  fbb4dfcf611211df97fb4949a3bcf031b3b86a2250c43dd9ee25d0742a6ed5ce  d8f1c30e08820147b6e8ebe738e3c8b0030e6725b663dbea10b63544358e979e  0ed40e9190fdec2bb0b2bb254e02a6e34d67a0e3bea8dd4633227d9effca9161
class Mach < Formula
  desc "mach agent — outbound-only remote access daemon (remote CLI access to enrolled machines)"
  homepage "https://github.com/TevaServices/mach"
  version "0.12.3"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/TevaServices/mach/releases/download/v0.12.3/mach_0.12.3_darwin_amd64.zip"
      sha256 "d8f1c30e08820147b6e8ebe738e3c8b0030e6725b663dbea10b63544358e979e"
    end
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/TevaServices/mach/releases/download/v0.12.3/mach_0.12.3_darwin_arm64.zip"
      sha256 "0ed40e9190fdec2bb0b2bb254e02a6e34d67a0e3bea8dd4633227d9effca9161"
    end
  end

  on_linux do
    if Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
      url "https://github.com/TevaServices/mach/releases/download/v0.12.3/mach_0.12.3_linux_amd64.zip"
      sha256 "864c1f429c513eecd93c455c2498ed7b0d046ffb491e054f37f0fbed665528a0"
    end
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/TevaServices/mach/releases/download/v0.12.3/mach_0.12.3_linux_arm64.zip"
      sha256 "fbb4dfcf611211df97fb4949a3bcf031b3b86a2250c43dd9ee25d0742a6ed5ce"
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
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
#   0.13.5            the release version (no leading v)
#   v0.13.5          the release tag (v-prefixed)
#   6fbdc64414d4c74254883294189f0323082baabfb4d60e8963aa05334c19ec75  37eb50e909a2953c828cb146c8a7ca8e483a7b4620989a4cba1e81c53e94b4a1  c1568087f31251e6bb53409b531588c5eebe9486132677d060e6d628e7813ccd  992e93f1ae2d9cadb68321e10784289af32b70eeaa40b78b2dd04086ae4981bb
class Mach < Formula
  desc "mach agent — outbound-only remote access daemon (remote CLI access to enrolled machines)"
  homepage "https://github.com/TevaServices/mach"
  version "0.13.5"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/TevaServices/mach/releases/download/v0.13.5/mach_0.13.5_darwin_amd64.zip"
      sha256 "c1568087f31251e6bb53409b531588c5eebe9486132677d060e6d628e7813ccd"
    end
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/TevaServices/mach/releases/download/v0.13.5/mach_0.13.5_darwin_arm64.zip"
      sha256 "992e93f1ae2d9cadb68321e10784289af32b70eeaa40b78b2dd04086ae4981bb"
    end
  end

  on_linux do
    if Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
      url "https://github.com/TevaServices/mach/releases/download/v0.13.5/mach_0.13.5_linux_amd64.zip"
      sha256 "6fbdc64414d4c74254883294189f0323082baabfb4d60e8963aa05334c19ec75"
    end
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/TevaServices/mach/releases/download/v0.13.5/mach_0.13.5_linux_arm64.zip"
      sha256 "37eb50e909a2953c828cb146c8a7ca8e483a7b4620989a4cba1e81c53e94b4a1"
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
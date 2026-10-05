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
#   0.12.7            the release version (no leading v)
#   v0.12.7          the release tag (v-prefixed)
#   9fd7074f4e5ae7d96c15ae0dd285adada2a183b3aec1f06f012f8913fd67af7b  15206167ab46db55defebfdf98d1bb26c860c125c607b4075575bca30fb4fe68  da9101b01629ee25b49fce72a2d78409f91b822d2cb8448e58638b4de3e65f05  95f532ea9ba69e94ba9ec45330dc6ea83748c6e9a43aba2e598a850ba0a077e5
class Mach < Formula
  desc "mach agent — outbound-only remote access daemon (remote CLI access to enrolled machines)"
  homepage "https://github.com/TevaServices/mach"
  version "0.12.7"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/TevaServices/mach/releases/download/v0.12.7/mach_0.12.7_darwin_amd64.zip"
      sha256 "da9101b01629ee25b49fce72a2d78409f91b822d2cb8448e58638b4de3e65f05"
    end
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/TevaServices/mach/releases/download/v0.12.7/mach_0.12.7_darwin_arm64.zip"
      sha256 "95f532ea9ba69e94ba9ec45330dc6ea83748c6e9a43aba2e598a850ba0a077e5"
    end
  end

  on_linux do
    if Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
      url "https://github.com/TevaServices/mach/releases/download/v0.12.7/mach_0.12.7_linux_amd64.zip"
      sha256 "9fd7074f4e5ae7d96c15ae0dd285adada2a183b3aec1f06f012f8913fd67af7b"
    end
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/TevaServices/mach/releases/download/v0.12.7/mach_0.12.7_linux_arm64.zip"
      sha256 "15206167ab46db55defebfdf98d1bb26c860c125c607b4075575bca30fb4fe68"
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
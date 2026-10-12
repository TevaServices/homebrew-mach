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
#   0.13.8            the release version (no leading v)
#   v0.13.8          the release tag (v-prefixed)
#   60f6054affd96876fbc9c75097ec067d61c63a1a5cea3c848db616de1eb196e4  9e37f6acf67f524009decf16b6e4a3c0fb9f797435869f27f936e6bb6a573a4c  cb3dd9ae752a3fb5bee07caec521e57a65123ae34d4df0650cb89cdb55968c65  1582cb2e4ca6353b20328efc6135ac045fe81bc6b6dbce9c56daade9b3942871
class Mach < Formula
  desc "mach agent — outbound-only remote access daemon (remote CLI access to enrolled machines)"
  homepage "https://github.com/TevaServices/mach"
  version "0.13.8"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/TevaServices/mach/releases/download/v0.13.8/mach_0.13.8_darwin_amd64.zip"
      sha256 "cb3dd9ae752a3fb5bee07caec521e57a65123ae34d4df0650cb89cdb55968c65"
    end
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/TevaServices/mach/releases/download/v0.13.8/mach_0.13.8_darwin_arm64.zip"
      sha256 "1582cb2e4ca6353b20328efc6135ac045fe81bc6b6dbce9c56daade9b3942871"
    end
  end

  on_linux do
    if Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
      url "https://github.com/TevaServices/mach/releases/download/v0.13.8/mach_0.13.8_linux_amd64.zip"
      sha256 "60f6054affd96876fbc9c75097ec067d61c63a1a5cea3c848db616de1eb196e4"
    end
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/TevaServices/mach/releases/download/v0.13.8/mach_0.13.8_linux_arm64.zip"
      sha256 "9e37f6acf67f524009decf16b6e4a3c0fb9f797435869f27f936e6bb6a573a4c"
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
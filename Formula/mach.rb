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
#   0.13.1            the release version (no leading v)
#   v0.13.1          the release tag (v-prefixed)
#   c863a403b46405c0480cd0d30f0eb1cec06bc8fc5f3c5f28887a8b182fad92a4  0e447ae5740c2c3604be9d5aad13a2469401132df1b2d5f462737cb79196a08a  49dc83b77f6be12c4e57e19a275ff4bf0b46445e8579254b5ca864b6c2f11459  31bf1905e5c266bca4b3b6dbdbaf4ea58477155071f6dc5fc355f1d5d1e153a8
class Mach < Formula
  desc "mach agent — outbound-only remote access daemon (remote CLI access to enrolled machines)"
  homepage "https://github.com/TevaServices/mach"
  version "0.13.1"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/TevaServices/mach/releases/download/v0.13.1/mach_0.13.1_darwin_amd64.zip"
      sha256 "49dc83b77f6be12c4e57e19a275ff4bf0b46445e8579254b5ca864b6c2f11459"
    end
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/TevaServices/mach/releases/download/v0.13.1/mach_0.13.1_darwin_arm64.zip"
      sha256 "31bf1905e5c266bca4b3b6dbdbaf4ea58477155071f6dc5fc355f1d5d1e153a8"
    end
  end

  on_linux do
    if Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
      url "https://github.com/TevaServices/mach/releases/download/v0.13.1/mach_0.13.1_linux_amd64.zip"
      sha256 "c863a403b46405c0480cd0d30f0eb1cec06bc8fc5f3c5f28887a8b182fad92a4"
    end
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/TevaServices/mach/releases/download/v0.13.1/mach_0.13.1_linux_arm64.zip"
      sha256 "0e447ae5740c2c3604be9d5aad13a2469401132df1b2d5f462737cb79196a08a"
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
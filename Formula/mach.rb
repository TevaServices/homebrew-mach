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
#   0.13.4            the release version (no leading v)
#   v0.13.4          the release tag (v-prefixed)
#   cc65ef06a60dd2d2a675f439c8fa33918efbaf13a680be3546c87b562898025a  e4958be4b5a64a67114cf90d6c15a38c3f939679e8cb66e05f6eeb3ce425fef6  fc1d2a6530e27caf1dfcc34de4a52a8ff2dc161d04438087ae21043bb2efcd28  6ae5ecceb4d3009eeaa3baed1f0075cfdc66ecb9b283f2afda1a4fb288332e7d
class Mach < Formula
  desc "mach agent — outbound-only remote access daemon (remote CLI access to enrolled machines)"
  homepage "https://github.com/TevaServices/mach"
  version "0.13.4"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/TevaServices/mach/releases/download/v0.13.4/mach_0.13.4_darwin_amd64.zip"
      sha256 "fc1d2a6530e27caf1dfcc34de4a52a8ff2dc161d04438087ae21043bb2efcd28"
    end
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/TevaServices/mach/releases/download/v0.13.4/mach_0.13.4_darwin_arm64.zip"
      sha256 "6ae5ecceb4d3009eeaa3baed1f0075cfdc66ecb9b283f2afda1a4fb288332e7d"
    end
  end

  on_linux do
    if Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
      url "https://github.com/TevaServices/mach/releases/download/v0.13.4/mach_0.13.4_linux_amd64.zip"
      sha256 "cc65ef06a60dd2d2a675f439c8fa33918efbaf13a680be3546c87b562898025a"
    end
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/TevaServices/mach/releases/download/v0.13.4/mach_0.13.4_linux_arm64.zip"
      sha256 "e4958be4b5a64a67114cf90d6c15a38c3f939679e8cb66e05f6eeb3ce425fef6"
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
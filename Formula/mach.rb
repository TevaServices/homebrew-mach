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
#   0.12.2            the release version (no leading v)
#   v0.12.2          the release tag (v-prefixed)
#   3640aeb98c1f85cdbda61f0485a6bf74b581e641d436527b20697aec7d1ff322  e1521f3e513efad4d7fa4ed81129eee3498d55da1eb9c5ff08f8ae7905d68dba  6950e5857193c5b46eacf47474e3696f5a7bc89e75ea6c587737146d81277649  a1c00564f8bdb3b9e51e0ca47f32eee977786dcec1f85b1a32f082c28a1b8b71
class Mach < Formula
  desc "mach agent — outbound-only remote access daemon (remote CLI access to enrolled machines)"
  homepage "https://github.com/TevaServices/mach"
  version "0.12.2"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/TevaServices/mach/releases/download/v0.12.2/mach_0.12.2_darwin_amd64.zip"
      sha256 "6950e5857193c5b46eacf47474e3696f5a7bc89e75ea6c587737146d81277649"
    end
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/TevaServices/mach/releases/download/v0.12.2/mach_0.12.2_darwin_arm64.zip"
      sha256 "a1c00564f8bdb3b9e51e0ca47f32eee977786dcec1f85b1a32f082c28a1b8b71"
    end
  end

  on_linux do
    if Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
      url "https://github.com/TevaServices/mach/releases/download/v0.12.2/mach_0.12.2_linux_amd64.zip"
      sha256 "3640aeb98c1f85cdbda61f0485a6bf74b581e641d436527b20697aec7d1ff322"
    end
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/TevaServices/mach/releases/download/v0.12.2/mach_0.12.2_linux_arm64.zip"
      sha256 "e1521f3e513efad4d7fa4ed81129eee3498d55da1eb9c5ff08f8ae7905d68dba"
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
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
#   0.12.6            the release version (no leading v)
#   v0.12.6          the release tag (v-prefixed)
#   c92f144fa32f3e746a08833cc0dac00c8e6c60d31e620346cdc2406d30176b09  e09bf738e7c9eb9fcd9acc9d6375e75d430a265a36107f7294a55109d9b83be0  54d35f6969f6923c7541e0486b3b339fc23e6536f5cd5776ba6ec74a3f952496  4ad624ab51b3d39c477558720c572d135567d320549155d3212b273d006cff4c
class Mach < Formula
  desc "mach agent — outbound-only remote access daemon (remote CLI access to enrolled machines)"
  homepage "https://github.com/TevaServices/mach"
  version "0.12.6"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/TevaServices/mach/releases/download/v0.12.6/mach_0.12.6_darwin_amd64.zip"
      sha256 "54d35f6969f6923c7541e0486b3b339fc23e6536f5cd5776ba6ec74a3f952496"
    end
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/TevaServices/mach/releases/download/v0.12.6/mach_0.12.6_darwin_arm64.zip"
      sha256 "4ad624ab51b3d39c477558720c572d135567d320549155d3212b273d006cff4c"
    end
  end

  on_linux do
    if Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
      url "https://github.com/TevaServices/mach/releases/download/v0.12.6/mach_0.12.6_linux_amd64.zip"
      sha256 "c92f144fa32f3e746a08833cc0dac00c8e6c60d31e620346cdc2406d30176b09"
    end
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/TevaServices/mach/releases/download/v0.12.6/mach_0.12.6_linux_arm64.zip"
      sha256 "e09bf738e7c9eb9fcd9acc9d6375e75d430a265a36107f7294a55109d9b83be0"
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
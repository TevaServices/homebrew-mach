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
#   0.13.6            the release version (no leading v)
#   v0.13.6          the release tag (v-prefixed)
#   9cf7c3558830eb4467f710248f6068ee07d6102e1934da435cf773fc2cba69e6  0476bc3ee5fd92d341cae086be2b6c69d5021eb284d81cfc39f89f0f89a7c0dc  4bfdb515853c6ffb2fde2746b27fee19c8bed5144d8167cdd3abe157c620bf7a  519b4cdc3c156356a7c7e49f6793f104ea182346d477961ae058713462059adf
class Mach < Formula
  desc "mach agent — outbound-only remote access daemon (remote CLI access to enrolled machines)"
  homepage "https://github.com/TevaServices/mach"
  version "0.13.6"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/TevaServices/mach/releases/download/v0.13.6/mach_0.13.6_darwin_amd64.zip"
      sha256 "4bfdb515853c6ffb2fde2746b27fee19c8bed5144d8167cdd3abe157c620bf7a"
    end
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/TevaServices/mach/releases/download/v0.13.6/mach_0.13.6_darwin_arm64.zip"
      sha256 "519b4cdc3c156356a7c7e49f6793f104ea182346d477961ae058713462059adf"
    end
  end

  on_linux do
    if Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
      url "https://github.com/TevaServices/mach/releases/download/v0.13.6/mach_0.13.6_linux_amd64.zip"
      sha256 "9cf7c3558830eb4467f710248f6068ee07d6102e1934da435cf773fc2cba69e6"
    end
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/TevaServices/mach/releases/download/v0.13.6/mach_0.13.6_linux_arm64.zip"
      sha256 "0476bc3ee5fd92d341cae086be2b6c69d5021eb284d81cfc39f89f0f89a7c0dc"
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
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
#   0.13.2            the release version (no leading v)
#   v0.13.2          the release tag (v-prefixed)
#   e8121b9e5c24041ac34d03738aa6c2d134a84d51e7c9c0861bd6367ecf9f2343  9bb03fab5c0fd99313850855e43b219e42d9bdd8a593e6b63bea2ea686456ed2  aaa77f7922d6e8d5cdb3daf0ab9ba050d91d7eafb9749359d0cf10d82b748785  fbb1119c310bb67f710e9df217a5d482edd92d71cf2cf62b8233563e2be6907e
class Mach < Formula
  desc "mach agent — outbound-only remote access daemon (remote CLI access to enrolled machines)"
  homepage "https://github.com/TevaServices/mach"
  version "0.13.2"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/TevaServices/mach/releases/download/v0.13.2/mach_0.13.2_darwin_amd64.zip"
      sha256 "aaa77f7922d6e8d5cdb3daf0ab9ba050d91d7eafb9749359d0cf10d82b748785"
    end
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/TevaServices/mach/releases/download/v0.13.2/mach_0.13.2_darwin_arm64.zip"
      sha256 "fbb1119c310bb67f710e9df217a5d482edd92d71cf2cf62b8233563e2be6907e"
    end
  end

  on_linux do
    if Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
      url "https://github.com/TevaServices/mach/releases/download/v0.13.2/mach_0.13.2_linux_amd64.zip"
      sha256 "e8121b9e5c24041ac34d03738aa6c2d134a84d51e7c9c0861bd6367ecf9f2343"
    end
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/TevaServices/mach/releases/download/v0.13.2/mach_0.13.2_linux_arm64.zip"
      sha256 "9bb03fab5c0fd99313850855e43b219e42d9bdd8a593e6b63bea2ea686456ed2"
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
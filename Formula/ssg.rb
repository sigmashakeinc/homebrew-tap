# Homebrew formula for ssg — AI Agent Governance CLI
# Hosted in: sigmashakeinc/homebrew-tap
# Install: brew install sigmashakeinc/tap/ssg
#
# To update this formula for a new release, run:
#   bash sigmashake-dist/homebrew/update-formula.sh
#
# Then copy the updated formula to the tap repo:
#   cp sigmashake-dist/homebrew/ssg.rb <path-to-homebrew-tap>/Formula/ssg.rb

class Ssg < Formula
  desc "AI Agent Governance CLI — evaluate tool calls against rules, block dangerous operations"
  homepage "https://sigmashake.com"
  # ssg is proprietary — sigmashake-gov/LICENSE is "All rights reserved",
  # not MIT. :cannot_represent is the documented Homebrew DSL value for
  # non-OSI-approved licenses. The tap will only ship if the formula's
  # license matches reality, and an MIT claim on a proprietary binary
  # would expose the project to license-misrepresentation risk.
  license :cannot_represent
  version "1.1.5"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sigmashakeinc/ssg/releases/download/v1.1.5/ssg-darwin-arm64.tar.gz"
      sha256 "6f377d8401159833b67b07663263c64b6181fa306020071354f646f25c69baf9"
    else
      url "https://github.com/sigmashakeinc/ssg/releases/download/v1.1.5/ssg-darwin-x64.tar.gz"
      sha256 "9c9fc5dae472b5b96a96b4d4593d135d5d46476fbb4f71178cf3de079cb5c398"
    end
  end

  on_linux do
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/sigmashakeinc/ssg/releases/download/v1.1.5/ssg-linux-arm64.tar.gz"
      sha256 "bdfb3a09aa55dad85835061402531b21a9b4bbc66dfd0c240c6b5c890ef33bd3"
    else
      url "https://github.com/sigmashakeinc/ssg/releases/download/v1.1.5/ssg-linux-x64.tar.gz"
      sha256 "7d53e3f174ec16323b5a8f71dbceadca41469e2f7ac23fb704b043741467162f"
    end
  end

  def install
    bin.install "ssg"
    bin.install "ssg-hook-fast" if File.exist?("ssg-hook-fast")
    # The dashboard SPA must sit at <execDir>/public/ so ssg serve's
    # publicDir resolver (candidate #3 in src/commands/serve.ts) finds it.
    # Without this, `ssg serve` renders a "Dashboard client not built"
    # placeholder. Matches the install.sh + Electrobun bundle layout.
    if File.directory?("public")
      (bin/"public").mkpath
      cp_r Dir["public/*"], bin/"public"
    end
  end

  test do
    output = shell_output("#{bin}/ssg --version 2>&1")
    assert_match version.to_s, output
  end
end

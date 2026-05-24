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
  version "0.29.117"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sigmashakeinc/ssg/releases/download/v0.29.117/ssg-darwin-arm64.tar.gz"
      sha256 "b4679e5033cfc99c5cd03fdd960e3baaa855b842cf21a77ed9e837065884df8a"
    else
      url "https://github.com/sigmashakeinc/ssg/releases/download/v0.29.117/ssg-darwin-x64.tar.gz"
      sha256 "fd3b84ba17e36e2c3c8a61cbbc0a2c6586d5dc18f86e76c5bc031fcefd380772"
    end
  end

  on_linux do
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/sigmashakeinc/ssg/releases/download/v0.29.117/ssg-linux-arm64.tar.gz"
      sha256 "d065176b2479bdb2ac0f143f0e9fbc255ec03380ace03e93084a34e8fe8eb393"
    else
      url "https://github.com/sigmashakeinc/ssg/releases/download/v0.29.117/ssg-linux-x64.tar.gz"
      sha256 "41fd04ee93a3e0e60e0270ae5a9717cc51da46b42d2061de24e441459e660080"
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

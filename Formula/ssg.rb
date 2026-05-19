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
  version "0.29.98"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sigmashakeinc/ssg/releases/download/v0.29.98/ssg-darwin-arm64.tar.gz"
      sha256 "c2573c1ebe3355fcc0618bafc77ce554d2263d7276d08ff3073d1d3dd27cdc62"
    else
      url "https://github.com/sigmashakeinc/ssg/releases/download/v0.29.98/ssg-darwin-x64.tar.gz"
      sha256 "1f585f1689f133011395ef012b5345eea302ef646a0c6b54a803704f6969e874"
    end
  end

  on_linux do
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/sigmashakeinc/ssg/releases/download/v0.29.98/ssg-linux-arm64.tar.gz"
      sha256 "ed2ac3542951e5bb4c5f74a44f1f6276a84d150e80c4fff745cbf4de6342c82a"
    else
      url "https://github.com/sigmashakeinc/ssg/releases/download/v0.29.98/ssg-linux-x64.tar.gz"
      sha256 "60adcc04d9ce73f276941fa3e6f960689fb89e17d85e85c9c3d27f133ddcf85b"
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

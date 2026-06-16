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
  version "1.0.1"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sigmashakeinc/ssg/releases/download/v1.0.1/ssg-darwin-arm64.tar.gz"
      sha256 "5c11e16841cf0dbce3d22514e7d5a58e34e52569fb6384c4b91f23182b998c06"
    else
      url "https://github.com/sigmashakeinc/ssg/releases/download/v1.0.1/ssg-darwin-x64.tar.gz"
      sha256 "4e4be05958e070cb0767e7469cb1131c7693ec999943680a17607615c2b79b67"
    end
  end

  on_linux do
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/sigmashakeinc/ssg/releases/download/v1.0.1/ssg-linux-arm64.tar.gz"
      sha256 "b6eb08784aa4b9ad4ddb3627ac64c8f5043525dabd14fbd6e439db780f270a56"
    else
      url "https://github.com/sigmashakeinc/ssg/releases/download/v1.0.1/ssg-linux-x64.tar.gz"
      sha256 "a5ad5b56fc113ce9c078cb1c69344e81d9bed166b676e56cb8c49bb9e813242b"
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

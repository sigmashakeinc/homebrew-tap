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
  version "1.2.1"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sigmashakeinc/ssg/releases/download/v1.2.1/ssg-darwin-arm64.tar.gz"
      sha256 "bcb2e8596281fa953b7ad5b95557fae65bde76a6ed23f464e50e675a18a5e4d8"
    else
      url "https://github.com/sigmashakeinc/ssg/releases/download/v1.2.1/ssg-darwin-x64.tar.gz"
      sha256 "0610bebd3ae1be14b436f103fd5ee119f04b9e23c6a0b85dcac03ef86eb68e1c"
    end
  end

  on_linux do
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/sigmashakeinc/ssg/releases/download/v1.2.1/ssg-linux-arm64.tar.gz"
      sha256 "1a8c042e34804ad6ee7aeac0257de2d6f89a62f9ca7d25f74f2102e397299bb5"
    else
      url "https://github.com/sigmashakeinc/ssg/releases/download/v1.2.1/ssg-linux-x64.tar.gz"
      sha256 "bb32cfa97132dc8f0e6a9cbff7ec0c519bd375281b3fca5b1c123946d7f06bfc"
    end
  end

  def install
    bin.install "ssg"
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

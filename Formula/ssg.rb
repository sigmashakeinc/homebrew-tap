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
  version "0.29.110"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sigmashakeinc/ssg/releases/download/v0.29.110/ssg-darwin-arm64.tar.gz"
      sha256 "fbb30a30ff1658b2d014710881105bc1cfeb44251d93c22b97b3a6b00485eddb"
    else
      url "https://github.com/sigmashakeinc/ssg/releases/download/v0.29.110/ssg-darwin-x64.tar.gz"
      sha256 "8854287cb6d8675d629e93e532cd75b47772f40b34ad39453c0bd4bb858c8952"
    end
  end

  on_linux do
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/sigmashakeinc/ssg/releases/download/v0.29.110/ssg-linux-arm64.tar.gz"
      sha256 "be9facea169525aad94c6deca33c2044fbc5a1c1c42c0fb49f537aadcc65fd5f"
    else
      url "https://github.com/sigmashakeinc/ssg/releases/download/v0.29.110/ssg-linux-x64.tar.gz"
      sha256 "b0727f3087d0e2eff1d308840ee66a3d353483f73928eb75fa42edd1f2911cd4"
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

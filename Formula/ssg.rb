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
  version "0.29.152"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sigmashakeinc/ssg/releases/download/v0.29.152/ssg-darwin-arm64.tar.gz"
      sha256 "9817d7873644c1ccff19eeba3d5f67d91106f899f7b851530485b1014bbf421e"
    else
      url "https://github.com/sigmashakeinc/ssg/releases/download/v0.29.152/ssg-darwin-x64.tar.gz"
      sha256 "fc688248241b709184e596cc1e8fa00327d731d8d28dcd0413c802a9b6b00a48"
    end
  end

  on_linux do
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/sigmashakeinc/ssg/releases/download/v0.29.152/ssg-linux-arm64.tar.gz"
      sha256 "8af683e98f24233d4cfcbe5083e46ea2c91e21448e707518aa4e991ab3326e8a"
    else
      url "https://github.com/sigmashakeinc/ssg/releases/download/v0.29.152/ssg-linux-x64.tar.gz"
      sha256 "5fc8b3cec2a3790754f6153ee77772f42f7706b534035fdf06a2968f8f6acf12"
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

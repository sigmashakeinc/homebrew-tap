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
  version "1.2.2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sigmashakeinc/ssg/releases/download/v1.2.2/ssg-darwin-arm64.tar.gz"
      sha256 "1a357c7ba00d67599353149cd4e5f15f5b025d5535d690e66b84ef1c8e205208"
    else
      url "https://github.com/sigmashakeinc/ssg/releases/download/v1.2.2/ssg-darwin-x64.tar.gz"
      sha256 "286c2d8d365dcdf524b569962fb684f57a481f00c5d27c954e69f5ccf9c64f4d"
    end
  end

  on_linux do
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/sigmashakeinc/ssg/releases/download/v1.2.2/ssg-linux-arm64.tar.gz"
      sha256 "fd9c93b730c161561eead0c1c3a66f9b52fc589524d87cf01cc3fae0e3b6c687"
    else
      url "https://github.com/sigmashakeinc/ssg/releases/download/v1.2.2/ssg-linux-x64.tar.gz"
      sha256 "0bec8267d2f6a5885d9d85cc832ea549071f9296614ff80e351e852c953fffc8"
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

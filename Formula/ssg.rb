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
  version "0.29.136"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sigmashakeinc/ssg/releases/download/v0.29.136/ssg-darwin-arm64.tar.gz"
      sha256 "b491b2f0ba1416bb0fa3a9337811567dd6faa84a31dc2737b695393878347399"
    else
      url "https://github.com/sigmashakeinc/ssg/releases/download/v0.29.136/ssg-darwin-x64.tar.gz"
      sha256 "3016c568042f689b1c42615224ef4d8c88744fef6c39ccca8e927ad6cff70631"
    end
  end

  on_linux do
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/sigmashakeinc/ssg/releases/download/v0.29.136/ssg-linux-arm64.tar.gz"
      sha256 "18149f72a14328479447f410dd0583199b4adfccfb8f835036698611e1a5daaa"
    else
      url "https://github.com/sigmashakeinc/ssg/releases/download/v0.29.136/ssg-linux-x64.tar.gz"
      sha256 "672c18187cdbf51c35dbf5247a93f43fa40ce9195bbd2fed5309931149625f84"
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

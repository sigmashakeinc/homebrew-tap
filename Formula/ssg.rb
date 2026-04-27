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
  license "MIT"
  version "0.29.19"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sigmashakeinc/ssg/releases/download/v0.29.19/ssg-darwin-arm64.tar.gz"
      sha256 "ffedf78e49d939ceaefbd470e65b00628f8fa36f1d701cdc0bdcca6229916577"
    else
      url "https://github.com/sigmashakeinc/ssg/releases/download/v0.29.19/ssg-darwin-x64.tar.gz"
      sha256 "bb8c0ed1468ff283fd6609dd64eb9c3a76b5a1a892775d80142b69b11602c20f"
    end
  end

  on_linux do
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/sigmashakeinc/ssg/releases/download/v0.29.19/ssg-linux-arm64.tar.gz"
      sha256 "39eddec987b2ec7ff05b2d64147a9f110627a485317b8023db1ce9cc3e619211"
    else
      url "https://github.com/sigmashakeinc/ssg/releases/download/v0.29.19/ssg-linux-x64.tar.gz"
      sha256 "dd739fad2dd33f2a1aa5a54bc6acd4634a8f175c37a3a8a460635d3f7cfacc44"
    end
  end

  def install
    bin.install "ssg"
    bin.install "ssg-hook-fast" if File.exist?("ssg-hook-fast")
  end

  test do
    output = shell_output("#{bin}/ssg --version 2>&1")
    assert_match version.to_s, output
  end
end

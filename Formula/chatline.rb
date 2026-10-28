class Chatline < Formula
  desc "Command-line client that gives agents and scripts a bot on a Chatto server"
  homepage "https://beardicus.tngl.io/chatline/"
  url "https://tangled.org/beardic.us/chatline.git",
      tag:      "v0.1.0",
      revision: "9724512d581236b54e5db04ae478f7c647bb6670"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    chatto = (buildpath/"proto/CHATTO_VERSION").read[/^tag: (\S+)/, 1]
    commit = stable.specs[:revision].to_s[0, 7]
    ldflags = %W[
      -s -w
      -X main.version=v#{version}
      -X main.commit=#{commit}
      -X main.chattoVersion=#{chatto}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/chatline"
    generate_completions_from_executable(bin/"chatline", "completion")
  end

  test do
    assert_match "chatline v#{version}", shell_output("#{bin}/chatline version")
  end
end

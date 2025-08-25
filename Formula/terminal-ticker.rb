class TerminalTicker < Formula
  desc "Always-visible crypto price in your Zsh prompt (Powerlevel10k)"
  homepage "https://github.com/mertkaradayi/terminal-ticker"
  head "https://github.com/mertkaradayi/terminal-ticker.git", branch: "main"

  depends_on :macos
  uses_from_macos "python"
  depends_on "jq"

  def install
    bin.install "scripts/btc_fetcher.py" => "btc-fetcher"
    bin.install "scripts/btc_fetcher_daemon.sh" => "btc-fetcher-daemon"
    bin.install "scripts/sticky_ticker_config.sh" => "sticky-ticker"
    bin.install "scripts/terminal_ticker_cli.sh" => "terminal-ticker"
    (pkgshare/"p10k").install "p10k/prompt_btc_ticker.zsh"
  end

  def caveats
    <<~EOS
      Finish setup:
        terminal-ticker setup
        p10k reload

      Customize:
        terminal-ticker set-coin eth
        terminal-ticker set-vs usd,eur
        terminal-ticker set-interval 120

      Prerequisites:
        Zsh + Powerlevel10k (https://github.com/romkatv/powerlevel10k#getting-started)
    EOS
  end

  service do
    run [opt_bin/"btc-fetcher-daemon"]
    keep_alive true
    log_path var/"log/terminal-ticker.log"
    error_log_path var/"log/terminal-ticker.log"
  end
end


alias tmux='tmux -2'

alias cbcopy='xclip -selection clipboard'
alias cbpaste='xclip -o -selection clipboard'

alias respec="xclip -o | awk '{ print \$2 }' | sed s/:in// | xargs bundle exec rspec"

alias gh='git config --get remote.origin.url | ruby -ne "puts %{https://github.com/#{\$_.split(/.com[\:\/]/)[-1].gsub(%{.git},%{})}}"| xargs open'

if [ $(uname -s) == "Darwin" ]; then
  alias vi=vim
fi

slackops() { open "https://slack.com/app_redirect?channel=$(fixops apps get -fcsv -a $1 | sed -n 2p | tr , '\n' | tail -1 | sed s/\#//)"; }

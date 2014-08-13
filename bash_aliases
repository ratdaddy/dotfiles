alias tmux='tmux -2'

alias cbcopy='xclip -selection clipboard'
alias cbpaste='xclip -o -selection clipboard'

alias respec="xclip -o | awk '{ print \$2 }' | sed s/:in// | xargs bundle exec rspec"

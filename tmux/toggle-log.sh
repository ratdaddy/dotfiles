#!/bin/bash
pane=$(tmux list-panes -a -F '#{pane_id} #{pane_title}' | awk '$2=="log"{print $1}')
[ -z "$pane" ] && exit 0
h=$(tmux display-message -p -t "$pane" '#{pane_height}')
if [ "$h" -le 5 ]; then
    tmux resize-pane -t "$pane" -y 25
    tmux select-pane -t "$pane"
    tmux copy-mode -t "$pane"
else
    tmux resize-pane -t "$pane" -y 3
    tmux send-keys -t "$pane" q
fi

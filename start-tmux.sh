#!/bin/bash

cd

# open the session
SESSION="NAME"
tmux has-session -t $SESSION 2> /dev/null

if [ $? != 0 ]; then
    tmux new-session -d -s $SESSION

    # window 1 for notes in VS Code
    tmux rename-window -t 1 'notes'
    tmux send-keys -t 'notes' 'zsh' C-m 'cd ~/p/notes' C-m 'code .' C-m 'clear' C-m

    # window 2 for my perso dev
    tmux new-window -t $SESSION:2 -n 'dev'
    tmux send-keys -t 'dev' 'zsh' C-m 'cd ~/p/dev' C-m 'ls -l' C-m
    
    # window 3 for ipython
    tmux new-window -t $SESSION:3 -n 'ipython'
    tmux send-keys -t 'ipython' 'zsh' C-m 'clear' C-m 'conda activate py311' C-m 'ipython' C-m
fi

# attach session on window 3
tmux attach-session -t $SESSION:2


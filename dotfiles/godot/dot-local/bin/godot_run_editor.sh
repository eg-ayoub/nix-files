#!/usr/bin/env bash

# inputs: {project} {file} {line} {column}

term_exec="kitty"
nvim_exec="nvim"

server_path="$1/godot-server.pipe"
server_startup_delay=0.1

start_server() {
    "$term_exec" -e "$nvim_exec" --listen "$server_path"
}

open_file_in_server() {
    filename=$(printf %q "$1")
    "$nvim_exec" --server "$server_path" --remote-send "<C-\><C-n>:n $filename<CR>:call cursor($2)<CR>"
}

if ! [ -e "$server_path" ]; then
    start_server &
    sleep $server_startup_delay
fi
open_file_in_server "$2" "$3,$4"

notify-send -t 1000 "Godot Editor" "Opened file $2 at line $3,$4"

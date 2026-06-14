#!/usr/bin/env bash

# inputs: {project} {file} {line} {column}

nvim_exec="nvim"

start_server() {
    "$nvim_exec" --listen "$1" "$PWD"
}

find_server_path() {
    local project_file="project.godot"
    local current_dir="$1"

    while true; do
        if [[ -f "$current_dir/$project_file" ]]; then
            echo "$current_dir/godot-server.pipe"
            return
        fi

        if [[ "$current_dir" == "$HOME/Projects/" ]]; then
            echo "$1"
            return
        fi

        current_dir=$(dirname "$current_dir")
    done
}

start_server "$(find_server_path "$1")"

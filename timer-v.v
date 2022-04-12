module main

import os
import json

struct Result {
	result string
	index  int
}

struct Cmd {
	interval int
	cmd      string
}

struct Config {
	separator string
	cmds      []Cmd
}

fn get_config_path() string {
	if os.args.len > 1 {
		return os.args[1]
	}

	// TODO: get from "$HOME/.config/timer.json"
	return './example.json'
}

fn read_config(path string) ?Config {
	raw := os.read_file(path) or {
		return error('Failed to read config file at path "$path": $err')
	}

	return Config{}
}

fn main() {
	config_path := get_config_path()
	config := read_config(config_path) ?

	println(config)
}

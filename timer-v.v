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
	if os.args.len > 0 {
		return os.args[0]
	}

	// TODO: get from "$HOME/.config/timer.json"
	return './example.json'
}

fn read_config(path string) Config {
	raw := os.read_file(path) or {
		eprintln('Failed to read config file at path $path: $err')
		return Config{}
	}

	return Config{}
}

fn main() {
	config_path := get_config_path()
	config := read_config(config_path)

	println('Hello World!')
}

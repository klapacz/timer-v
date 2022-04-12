module main

import os
import json
import time

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

	return os.join_path(os.home_dir(), '.config', 'timer.json')
}

fn read_config(path string) ?Config {
	raw := os.read_file(path) or {
		return error('Failed to read config file at path "$path": $err')
	}
	config := json.decode(Config, raw) or {
		return error('Failed to parse config file at path "$path": $err')
	}

	return config
}

fn run(ch chan Result, cmd Cmd, index int) {
	for {
		result := os.execute(cmd.cmd)
		ch <- Result{
			result: if result.exit_code == 0 { result.output } else { 'command failed' }
			index: index
		} ?
		time.sleep(cmd.interval * time.second)
	}
}

fn main() {
	config_path := get_config_path()
	config := read_config(config_path) ?

	ch := chan Result{}
	mut results := []string{len: config.cmds.len, init: 'loading…'}

	for i, cmd in config.cmds {
		go run(ch, cmd, i)
	}

	for {
		result := <-ch
		results[result.index] = result.result.replace('\n', '')
		println(results.join(config.separator))
	}
}

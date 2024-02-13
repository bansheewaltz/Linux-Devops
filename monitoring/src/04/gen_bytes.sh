#!/bin/bash

function gen_bytes {
	# Minimum ethernet frame size
	local min_body_bytes_sent=64
	# Most web servers have a limit of 8192 body_bytes_sent, whick is usually configurable in the server configuration
	local max_body_bytes_sent=8192
	local body_bytes_sent=$(shuf -i $min_body_bytes_sent-$max_body_bytes_sent -n 1)
	echo $body_bytes_sent	
}

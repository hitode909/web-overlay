#! /usr/bin/env phantomjs

WebOverlay = require '../lib/WebOverlay'

read_config = (path) ->
  fs = require "fs"
  file = fs.open path, "r"
  content = do file.read
  JSON.parse content

if phantom.args.length < 1
  console.log "Usage: phantom.js script/web-overlay.coffee CONFIG_JSON_PATH (OUTPUT_PATH)"
  phantom.exit 1

config = read_config phantom.args[0]
output_path = phantom.args[1] || "out.png"

WebOverlay.run config, output_path

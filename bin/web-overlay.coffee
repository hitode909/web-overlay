#! /usr/bin/env phantomjs

WebOverlay = require '../lib/WebOverlay'

if phantom.args.length < 1
  console.log "Usage: bin/web-overlay.coffee CONFIG_PATH (OUTPUT_PATH)"
  phantom.exit 1

config = try
    WebOverlay.loadConfig phantom.args[0]
  catch error
    console.log "failed to load config: #{error}"
    phantom.exit 1

output_path = phantom.args[1] || "out.png"

WebOverlay.run config, output_path

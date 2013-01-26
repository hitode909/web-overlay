error = (message) ->
  console.error message
  phantom.exit 1

create_page = ->
  page = do require('webpage').create
  page.onConsoleMessage = (msg) ->
    console.log "in page context: #{msg}"
  page.viewportSize =
    width: 1280
    height: 800

  page

inject_jquery = (page) ->
  system = require 'system'
  jquery_path = (system.args[0].split '/')[0...-1].join("/") + "/../lib/jquery.min.js"
  error "failed to inject jQuery" unless page.injectJs jquery_path

overlay = (page, rule) ->
  page.evaluate (rule) ->
    selector = rule.selector
    label = rule.label
    type = rule.type || "all"

    addOverlay = (left, top, width, height, label) ->
      console.log "appending overlay: #{label}, (#{left}, #{top}), #{width}x#{height}"
      $base = $ '<div>'
      $base.css
        zIndex: 10000
        position: 'absolute'
        border: '2px solid red'
        background: 'rgba(0,0,0,0.05)'
        left: left
        top: top
        width: width
        height: height

      $label = $ '<span>'
      $label.text label
      $label.css
        position: 'absolute'
        right: '0px'
        bottom: '0px'
        color: 'white'
        background: '#333'
        fontWeight: 'bold'
        padding: '3px'
        fontSize: '12px'

      $base.append $label
      ($ document.body).append $base

    handlers =

      # add overlays to each elements
      all: (selector, label) ->
        $targets = ($ selector)
        return unless $targets.length

        for target in $targets
          $target = $ target

          $target = do $target.parent while $target.height() == 0
          offset = do $target.offset
          addOverlay offset.left, offset.top, do $target.width, do $target.height, label

      # wrap all elements in an overlay
      wrap: (selector, label) ->
        $targets = ($ selector)
        return unless $targets.length

        x_from = null
        x_to = null
        y_from = null
        y_to = null

        for target in $targets
          $target = $ target

          offset = do $target.offset

          current_x_from = offset.left
          current_x_to = current_x_from + do $target.width
          current_y_from = offset.top
          current_y_to = current_y_from + do $target.height

          x_from = current_x_from unless x_from? and x_from < current_x_from
          x_to = current_x_to unless x_to? and x_to > current_x_to
          y_from = current_y_from unless y_from? and y_from < current_y_from
          y_to = current_y_to unless y_to? and y_to > current_y_to

        return unless x_from? and x_to? and y_from? and y_to?
        left = x_from
        top = y_from
        width = x_to - x_from
        height = y_to - y_from
        addOverlay left, top, width, height, label

    handler = handlers[type]

    unless handler
      console.log "error: unrecognized type: #{type}"
      return

    handler selector, label

  , rule

render = (page, output_path) ->
  console.log "render page to #{output_path}"
  page.render output_path

# config:
#   url
#   overlays
run = (config, output_path) ->

  url       = config.url
  error "url required" unless url?
  overlays = config.overlays
  error "overlays required" unless overlays?

  page = do create_page

  console.log "open #{url}"
  page.open url, (status) ->
    error "Unable to load the address!" if status isnt "success"
    console.log "open #{url} done"
    inject_jquery page
    overlay page, rule for rule in overlays
    render page, output_path
    do phantom.exit

loadConfig = (config_path) ->
  fs = require "fs"
  file = fs.open config_path, "r"
  content = do file.read
  try
    JSON.parse content
  catch error
    # eval allows last comma
    eval "(#{content})"

module.exports =
  run: run
  loadConfig: loadConfig

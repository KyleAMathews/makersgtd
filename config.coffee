exports.config =
  # Edit the next line to change default build path.
  buildPath: 'public'

  files:
    javascripts:
      # Defines what file will be generated with `brunch generate`.
      defaultExtension: 'coffee'
      # Describes how files will be compiled & joined together.
      # Available formats:
      # * 'outputFilePath'
      # * map of ('outputFilePath': /regExp that matches input path/)
      # * map of ('outputFilePath': function that takes input path)
      joinTo:
        'javascripts/app.js': /^app/
        'javascripts/vendor.js': /^vendor/
      # Defines compilation order.
      # `vendor` files will be compiled before other ones
      # even if they are not present here.
      order:
        before: [
          'vendor/scripts/console-helper.js'
          'vendor/scripts/jquery-1.7.2.js'
          'vendor/scripts/underscore-1.3.1.js'
          'vendor/scripts/backbone-0.9.2.js'
          'vendor/scripts/Markdown.Converter.js'
          'vendor/scripts/fuzzymatcher.js'
          'vendor/scripts/jquery.hoverIntent.js'
          'vendor/scripts/expanding.js'
          'vendor/scripts/jquery.timeago.js'
          'vendor/scripts/jQuery.fastClick.js'
        ]

    templates:
      defaultExtension: 'eco'
      joinTo: 'javascripts/app.js'

  # Change this if you're using something other than backbone (e.g. 'ember').
  # Content of files, generated with `brunch generate` depends on the setting.
  # framework: 'backbone'

  # Enable or disable minifying of result js / css files.
  minify: no

  #Settings of web server that will run with `brunch watch [--server]`.
  server:
    # Path to your server node.js module.
    # If it's commented-out, brunch will use built-in express.js server.
    path: 'server.coffee'
    port: 3000
    # Run even without `--server` option?
    #run: yes

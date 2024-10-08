# file: config.py
# config for qutebrowser
#config.load_autoconfig()

# Allow connections despite SSL/TLS handshake errors
#config.set('content.tls.certificate_errors', 'load-insecurely')

# Disable sandboxing completely
#config.set('qt.chromium.sandboxing', 'disable-all')

# Enable debug mode
#config.set('content.default_encoding', 'utf-8')

# Example: Set other debugging-related configurations
# config.set('qt.args', ['--enable-logging=stderr', '--v=1'])

# Enable logging of Chromium's debug information
# config.set('qt.chromium.flags', [
#     '--no-sandbox',
#     '--enable-logging=stderr',
#     '--v=1',
# ])#


# Define constants
# border_size = 5
# border_double_size = 2 * border_size

# base00 = '#{{base00-hex}}'
# base01 = '#{{base01-hex}}'
# base02 = '#{{base02-hex}}'
# base03 = '#{{base03-hex}}'
# base04 = '#{{base04-hex}}'
# base05 = '#{{base05-hex}}'
# base06 = '#{{base06-hex}}'
# base07 = '#{{base07-hex}}'
# base08 = '#{{base08-hex}}'
# base09 = '#{{base09-hex}}'
# base0A = '#{{base0A-hex}}'
# base0B = '#{{base0B-hex}}'
# base0C = '#{{base0C-hex}}'
# base0D = '#{{base0D-hex}}'
# base0E = '#{{base0E-hex}}'
# base0F = '#{{base0F-hex}}'

# #config.load_autoconfig()

# config.set('aliases',                           {'q': 'quit', 'w': 'session-save', 'wq': 'quit --save'})
# config.set('confirm_quit',                      ['multiple-tabs', 'downloads'])
# config.set('content.default_encoding',          'utf-8')
# config.set('content.media.audio_capture',       True)
# config.set('content.media.audio_video_capture', True)
# config.set('content.media.video_capture',       True)
config.set('content.tls.certificate_errors', 'load-insecurely')
config.set('content.default_encoding', 'utf-8')
c.qt.args = [ 'no-sandbox' ]
# config.set('content.notifications.enabled',     True)
# config.set('downloads.location.directory',      '~/Downloads')
# config.set('editor.command',                    ['{{terminal}}', '-e', 'vim', '-f', '{file}', '-c', 'normal {line}G{column0}l'])
# config.set('fileselect.handler',                'external')
# config.set('fileselect.multiple_files.command', ['{{terminal}}', '-e', 'nnn', '-p', '{}'])
# config.set('fileselect.single_file.command',    ['{{terminal}}', '-e', 'nnn', '-p', '{}'])
# #config.set('fonts.completion.entry',            '{{font-size}}pt "{{font}}"')
# config.set('fonts.contextmenu',                 '{{font-size}}pt "{{font}}"')
# config.set('fonts.debug_console',               '{{font-size}}pt "{{font}}"')
# config.set('fonts.default_family',              '"{{font}}"')
# config.set('fonts.default_size',                '{{font-size}}pt')
# config.set('fonts.prompts',                     '{{font-size}}pt "{{font}}"')
# config.set('fonts.statusbar',                   '{{font-size}}pt "{{font}}"')
# # config.set('hints.border',                      'none')
# # config.set('hints.radius',                      {{border-size}})
# # config.set('statusbar.padding',                 {'bottom': {{border-size}}, 'left': {{border-size}}, 'right': {{border-size}}, 'top': {{border-size}}})
# config.set('tabs.favicons.show',                'never')
# config.set('tabs.indicator.width',              0)
# config.set('tabs.last_close',                   'close')
# config.set('tabs.mousewheel_switching',         False)
# # config.set('tabs.padding',                      {'bottom': {{border-size}}, 'left': {{border-double-size}}, 'right': {{border-double-size}}, 'top': {{border-size}}})
# config.set('tabs.show',                         'always')
# config.set('tabs.title.format',                 '{index}{audio} | {current_title}')
# config.set('tabs.tooltips',                     False)
# config.set('window.title_format',               '{current_title}')

# config.set('url.searchengines', {
#   'DEFAULT': 'https://www.google.com/search?q={}',
#   'allegro': 'https://allegro.pl/listing?string={}',
#   'alpha':   'http://www.wolframalpha.com/input/?i={}',
#   'ang':     'https://context.reverso.net/t%C5%82umaczenie/polski-angielski/{}',
#   'duck':    'https://duckduckgo.com/?q={}',
#   'stack':   'https://stackexchange.com/search?q={}',
#   'd':       'https://hub.docker.com/search?q={}&type=image',
#   'h':       'https://hoogle.haskell.org/?hoogle={}',
#   'm':       'http://maps.google.com/maps?q={}',
#   'nm':      'https://nixos.org/manual/nix/stable/introduction.html?search={}',
#   'np':      'https://search.nixos.org/packages?query={}',
#   'npv':     'https://lazamar.co.uk/nix-versions/?channel=nixpkgs-unstable&package={}',
#   'p':       'https://getpocket.com/my-list/search?query={}',
#   'rb':      'https://ruby-doc.com/search.html?q={}',
#   'we':      'https://en.wikipedia.org/wiki/{}',
#   'wp':      'https://pl.wikipedia.org/wiki/{}',
#   'yt':      'https://www.youtube.com/results?search_query={}'
# })

# config.bind(';D', 'hint links spawn {{terminal}} -e aria2c {hint-url} -d Downloads')
# config.bind(';m', 'hint links spawn {{terminal}} -e youtube-dl -x {hint-url} -o Downloads/%(title)s.%(ext)s')
# config.bind(';v', 'hint links spawn {{terminal}} -e youtube-dl {hint-url} -o Downloads/%(title)s.%(ext)s')
# config.bind('<Ctrl+w>', 'mode-enter passthrough')
# config.bind('I', 'hint inputs');
# config.bind(',s', 'open -t https://getpocket.com/edit?url={url}')

# config.unbind('<Ctrl+Shift+w>')
# config.unbind('<Ctrl+t>')
# config.unbind('<Ctrl+n>')
# config.unbind('<Ctrl+Shift+n>')

# c.colors.completion.fg                          = base0F
# c.colors.completion.odd.bg                      = base08
# c.colors.completion.even.bg                     = base00
# c.colors.completion.category.fg                 = base07
# c.colors.completion.category.bg                 = base00
# c.colors.completion.category.border.top         = base00
# c.colors.completion.category.border.bottom      = base00
# c.colors.completion.item.selected.fg            = base00
# c.colors.completion.item.selected.bg            = base0B
# c.colors.completion.item.selected.border.top    = base03
# c.colors.completion.item.selected.border.bottom = base03
# c.colors.completion.item.selected.match.fg      = base00
# c.colors.completion.match.fg                    = base03
# c.colors.completion.scrollbar.fg                = base0F
# c.colors.completion.scrollbar.bg                = base00

# # c.colors.contextmenu.disabled.bg                = base00
# # c.colors.contextmenu.disabled.fg                = base08
# c.colors.contextmenu.menu.bg                    = base00
# c.colors.contextmenu.menu.fg                    = base0F
# c.colors.contextmenu.selected.bg                = base0B
# c.colors.contextmenu.selected.fg                = base00

# c.colors.downloads.bar.bg                       = base00
# c.colors.downloads.start.fg                     = base00
# c.colors.downloads.start.bg                     = base04
# c.colors.downloads.stop.fg                      = base00
# c.colors.downloads.stop.bg                      = base02
# c.colors.downloads.error.fg                     = base01

# c.colors.hints.fg                               = base00
# c.colors.hints.bg                               = base0B
# c.colors.hints.match.fg                         = base05

# c.colors.keyhint.fg                             = base07
# c.colors.keyhint.suffix.fg                      = base0F
# c.colors.keyhint.bg                             = base00

# c.colors.messages.error.fg                      = base00
# c.colors.messages.error.bg                      = base01
# c.colors.messages.error.border                  = base00
# c.colors.messages.warning.fg                    = base00
# c.colors.messages.warning.bg                    = base03
# c.colors.messages.warning.border                = base00
# c.colors.messages.info.fg                       = base00
# c.colors.messages.info.bg                       = base04
# c.colors.messages.info.border                   = base00

# c.colors.prompts.fg                             = base0F
# c.colors.prompts.border                         = base00
# c.colors.prompts.bg                             = base00
# c.colors.prompts.selected.fg                    = base00
# c.colors.prompts.selected.bg                    = base0B

# c.colors.statusbar.normal.fg                    = base0B
# c.colors.statusbar.normal.bg                    = base00
# c.colors.statusbar.insert.fg                    = base00
# c.colors.statusbar.insert.bg                    = base0D
# c.colors.statusbar.passthrough.fg               = base00
# c.colors.statusbar.passthrough.bg               = base0D
# c.colors.statusbar.private.fg                   = base00
# c.colors.statusbar.private.bg                   = base08
# c.colors.statusbar.command.fg                   = base0F
# c.colors.statusbar.command.bg                   = base00
# c.colors.statusbar.command.private.fg           = base0F
# c.colors.statusbar.command.private.bg           = base00
# c.colors.statusbar.caret.fg                     = base00
# c.colors.statusbar.caret.bg                     = base0D
# c.colors.statusbar.caret.selection.fg           = base00
# c.colors.statusbar.caret.selection.bg           = base0D
# c.colors.statusbar.progress.bg                  = base02
# c.colors.statusbar.url.fg                       = base0F
# c.colors.statusbar.url.error.fg                 = base01
# c.colors.statusbar.url.hover.fg                 = base0F
# c.colors.statusbar.url.success.http.fg          = base0C
# c.colors.statusbar.url.success.https.fg         = base0B
# c.colors.statusbar.url.warn.fg                  = base0E

# c.colors.tabs.bar.bg                            = base00
# c.colors.tabs.indicator.start                   = base0D
# c.colors.tabs.indicator.stop                    = base0C
# c.colors.tabs.indicator.error                   = base08
# c.colors.tabs.odd.fg                            = base0F
# c.colors.tabs.odd.bg                            = base08
# c.colors.tabs.even.fg                           = base0F
# c.colors.tabs.even.bg                           = base00
# c.colors.tabs.pinned.odd.fg                     = base0F
# c.colors.tabs.pinned.odd.bg                     = base08
# c.colors.tabs.pinned.even.fg                    = base0F
# c.colors.tabs.pinned.even.bg                    = base00
# c.colors.tabs.pinned.selected.odd.fg            = base0B
# c.colors.tabs.pinned.selected.odd.bg            = base08
# c.colors.tabs.pinned.selected.even.fg           = base0B
# c.colors.tabs.pinned.selected.even.bg           = base00
# c.colors.tabs.selected.odd.fg                   = base0B
# c.colors.tabs.selected.odd.bg                   = base08
# c.colors.tabs.selected.even.fg                  = base0B
# c.colors.tabs.selected.even.bg                  = base00
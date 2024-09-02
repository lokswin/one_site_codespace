# file: config.py
# config for qutebrowser
config.load_autoconfig()

# Allow connections despite SSL/TLS handshake errors
config.set('content.tls.certificate_errors', 'load-insecurely')

# Disable sandboxing completely
config.set('qt.chromium.sandboxing', 'disable-all')

# Enable debug mode
config.set('content.default_encoding', 'utf-8')

# Example: Set other debugging-related configurations
# config.set('qt.args', ['--enable-logging=stderr', '--v=1'])

# Enable logging of Chromium's debug information
# config.set('qt.chromium.flags', [
#     '--no-sandbox',
#     '--enable-logging=stderr',
#     '--v=1',
# ])
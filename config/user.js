// Optimize CPU usage
user_pref("layers.acceleration.disabled", true); // Disable GPU acceleration
user_pref("gfx.webrender.force-disabled", true); // Force WebRender off
user_pref("dom.ipc.processCount", 8); // Allow more content processes
user_pref("dom.ipc.processCount.webLargeAllocation", 8); // For large web pages

// Optimize Network Usage
user_pref("network.http.max-connections", 900); // Increase simultaneous connections
user_pref("network.http.max-persistent-connections-per-server", 10); // Persistent connections per server
user_pref("network.http.pipelining", true); // Enable HTTP pipelining
user_pref("network.http.pipelining.maxrequests", 8); // Max pipelined requests
user_pref("network.http.accept-encoding", "gzip, deflate, br"); // Enable compression
user_pref("network.dns.max_concurrent", 100); // Increase DNS lookup concurrency
user_pref("network.dns.disablePrefetch", true); // Disable DNS prefetching

// Caching Optimization
user_pref("browser.cache.memory.enable", true); // Enable memory caching
user_pref("browser.cache.memory.capacity", -1); // Allow unlimited memory caching
user_pref("browser.cache.disk.enable", false); // Disable disk cache

// Reduce Animations and Overhead
user_pref("toolkit.cosmeticAnimations.enabled", false); // Disable animations
user_pref("browser.tabs.animate", false); // Disable tab animations
user_pref("browser.stopReloadAnimation.enabled", false); // Disable reload animations

// Privacy and Ephemeral Mode
user_pref("browser.privatebrowsing.autostart", true); // Always start in private mode
user_pref("browser.sessionstore.privacy_level", 2); // Do not save form data in private mode
user_pref("privacy.clearOnShutdown.cache", true); // Clear cache on shutdown
user_pref("privacy.clearOnShutdown.cookies", true); // Clear cookies on shutdown
user_pref("privacy.clearOnShutdown.history", true); // Clear history on shutdown
user_pref("privacy.clearOnShutdown.sessions", true); // Clear session data on shutdown
user_pref("privacy.firstparty.isolate", true); // Isolate first-party data

// Disable Unnecessary Features
user_pref("extensions.enabledScopes", 0); // Disable extensions
user_pref("media.ffmpeg.vaapi.enabled", false); // Disable hardware video decoding

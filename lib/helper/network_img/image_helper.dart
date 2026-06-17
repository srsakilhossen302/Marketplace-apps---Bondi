class ImageHelper {
  static String formatImageUrl(String? url) {
    if (url == null || url.trim().isEmpty) {
      // Safe placeholder fallback
      return 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?q=80&w=800&auto=format&fit=crop';
    }

    final trimmed = url.trim();

    // If already absolute URL
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }

    // If starts with localhost or IP address
    if (trimmed.startsWith('localhost') || trimmed.startsWith('127.0.0.1')) {
      return 'http://$trimmed';
    }

    // Default server base host
    const String host = "https://bondi-dev.nasimmondal.dev";

    // Clean path and join
    final cleanPath = trimmed.startsWith('/') ? trimmed : '/$trimmed';
    return '$host$cleanPath';
  }
}

class CloudinaryImageUrl {
  const CloudinaryImageUrl._();

  static const int minimumWidth = 320;
  static const int maximumWidth = 1600;
  static const int defaultWidth = 960;

  static String optimized(String source, {int maxWidth = defaultWidth}) {
    final normalizedSource = source.trim();

    if (normalizedSource.isEmpty) {
      return normalizedSource;
    }

    final uri = Uri.tryParse(normalizedSource);

    if (uri == null ||
        (uri.scheme != 'http' && uri.scheme != 'https') ||
        !_isCloudinaryHost(uri.host)) {
      return normalizedSource;
    }

    const marker = '/image/upload/';
    final markerIndex = normalizedSource.indexOf(marker);

    if (markerIndex < 0) {
      return normalizedSource;
    }

    final suffixStart = markerIndex + marker.length;
    final suffix = normalizedSource.substring(suffixStart);

    if (suffix.isEmpty || _alreadyTransformed(suffix)) {
      return normalizedSource;
    }

    final normalizedWidth = maxWidth.clamp(minimumWidth, maximumWidth);

    const optimization = 'f_auto/q_auto';
    final resize = 'c_limit,w_$normalizedWidth';

    return '${normalizedSource.substring(0, suffixStart)}'
        '$resize/$optimization/$suffix';
  }

  static bool _isCloudinaryHost(String host) {
    final normalizedHost = host.toLowerCase();

    return normalizedHost == 'res.cloudinary.com' ||
        normalizedHost.endsWith('.res.cloudinary.com');
  }

  static bool _alreadyTransformed(String suffix) {
    final firstSegment = suffix
        .split('/')
        .first
        .split('?')
        .first
        .split('#')
        .first;

    if (RegExp(r'^v\d+$').hasMatch(firstSegment)) {
      return false;
    }

    const prefixes = <String>[
      'a_',
      'ar_',
      'b_',
      'bo_',
      'c_',
      'dpr_',
      'e_',
      'f_',
      'fl_',
      'g_',
      'h_',
      'q_',
      'r_',
      't_',
      'w_',
      'x_',
      'y_',
      'z_',
    ];

    return firstSegment
        .split(',')
        .any((component) => prefixes.any(component.startsWith));
  }
}

import 'package:flutter_test/flutter_test.dart';
import 'package:kedai_ayam_nina/core/images/cloudinary_image_url.dart';

void main() {
  group('CloudinaryImageUrl', () {
    test('adds stable delivery transformation', () {
      const source =
          'https://res.cloudinary.com/demo/image/upload/'
          'v123/menu/ayam.jpg';

      expect(
        CloudinaryImageUrl.optimized(source, maxWidth: 640),
        'https://res.cloudinary.com/demo/image/upload/'
        'c_limit,w_640/f_auto/q_auto/'
        'v123/menu/ayam.jpg',
      );
    });

    test('does not duplicate an existing transformation', () {
      const source =
          'https://res.cloudinary.com/demo/image/upload/'
          'c_limit,w_640/f_auto/q_auto/'
          'v123/menu/ayam.jpg';

      expect(CloudinaryImageUrl.optimized(source), source);
    });

    test('does not alter non Cloudinary URLs', () {
      const source = 'https://example.com/menu/ayam.jpg';

      expect(CloudinaryImageUrl.optimized(source), source);
    });

    test('preserves query parameters', () {
      const source =
          'https://res.cloudinary.com/demo/image/upload/'
          'v1/menu.jpg?token=abc';

      expect(
        CloudinaryImageUrl.optimized(source, maxWidth: 960),
        endsWith('v1/menu.jpg?token=abc'),
      );
    });

    test('clamps oversized delivery width', () {
      const source =
          'https://res.cloudinary.com/demo/image/upload/'
          'v1/menu.jpg';

      expect(
        CloudinaryImageUrl.optimized(source, maxWidth: 99999),
        contains('c_limit,w_1600'),
      );
    });
  });
}

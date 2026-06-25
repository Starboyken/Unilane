import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';

import 'package:unilane/features/main/data/listing_media_repository.dart';

class FirebaseStorageListingMediaRepository implements ListingMediaRepository {
  FirebaseStorageListingMediaRepository({FirebaseStorage? storage})
    : _storage = storage ?? FirebaseStorage.instance;

  final FirebaseStorage _storage;

  @override
  Future<String> resolveListingImageUrl({
    required String imageUrl,
    required String listingTitle,
    required String listingCategory,
    required String ownerId,
  }) async {
    if (!imageUrl.startsWith('data:image/')) {
      return imageUrl;
    }

    final commaIndex = imageUrl.indexOf(',');
    if (commaIndex == -1) {
      return imageUrl;
    }

    try {
      final header = imageUrl.substring('data:'.length, commaIndex);
      final mimeType = header.split(';').first;
      final base64Content = imageUrl.substring(commaIndex + 1);
      final bytes = base64Decode(base64Content);
      final safeOwnerId = _slugify(ownerId);
      final safeCategory = _slugify(listingCategory);
      final safeTitle = _slugify(listingTitle);
      final fileName = '${DateTime.now().microsecondsSinceEpoch}.jpg';
      final ref = _storage
          .ref()
          .child('listing_images')
          .child(safeOwnerId)
          .child(safeCategory)
          .child('$safeTitle-$fileName');

      await ref.putData(bytes, SettableMetadata(contentType: mimeType));
      return await ref.getDownloadURL();
    } catch (_) {
      return imageUrl;
    }
  }

  String _slugify(String value) {
    final cleaned = value.trim().toLowerCase();
    if (cleaned.isEmpty) {
      return 'unknown';
    }

    return cleaned
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'-+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');
  }
}

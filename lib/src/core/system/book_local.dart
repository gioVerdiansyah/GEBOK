import 'package:get_storage/get_storage.dart';

class StorageKeyConstant {
  static const String wishlistKey = 'wishlistBookIds';
}

class BooksLocal {
  final GetStorage _storage = GetStorage();

  Future<void> addToWishlist(String volumeId) async {
    final List<String> currentWishlist = getWishlist();
    if (!currentWishlist.contains(volumeId)) {
      currentWishlist.add(volumeId);
      await _storage.write(StorageKeyConstant.wishlistKey, currentWishlist);
    }
  }

  Future<void> removeFromWishlist(String volumeId) async {
    final List<String> currentWishlist = getWishlist();
    currentWishlist.remove(volumeId);
    await _storage.write(StorageKeyConstant.wishlistKey, currentWishlist);
  }

  List<String> getWishlist() {
    final data = _storage.read<List<dynamic>>(StorageKeyConstant.wishlistKey);
    return data?.map((e) => e.toString()).toList() ?? [];
  }

  bool isInWishlist(String volumeId) {
    return getWishlist().contains(volumeId);
  }

  Future<void> clearWishlist() async {
    await _storage.remove(StorageKeyConstant.wishlistKey);
  }
}

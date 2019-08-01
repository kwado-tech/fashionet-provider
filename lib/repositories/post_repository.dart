import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashionet_provider/models/models.dart';
import 'package:meta/meta.dart';

class PostRepository {
  // final Firestore _firestore;
  final FieldValue _firestoreTimestamp;
  final CollectionReference _postCollection;
  final CollectionReference _profileCollection;

  PostRepository()
      : _firestoreTimestamp = FieldValue.serverTimestamp(),
        _postCollection = Firestore.instance.collection('posts'),
        _profileCollection = Firestore.instance.collection('profiles');

  Future<bool> isBookmarked(
      {@required String postId, @required String userId}) async {
    final DocumentSnapshot snapshot = await _postCollection
        .document(postId)
        .collection('bookmarks')
        .document(userId)
        .get();

    return snapshot.exists;
  }

  Future<void> addToBookmark(
      {@required String postId, @required String userId}) {
    return _postCollection
        .document(postId)
        .collection('bookmarks')
        .document(userId)
        .setData({'isBookmarked': true});
  }

  Future<void> removeFromBookmark(
      {@required String postId, @required String userId}) {
    return _postCollection
        .document(postId)
        .collection('bookmarks')
        .document(userId)
        .delete();
  }

  Future<bool> isFollowing(
      {@required String postUserId, @required String userId}) async {
    final DocumentSnapshot snapshot = await _profileCollection
        .document(postUserId)
        .collection('followers')
        .document(userId)
        .get();

    return snapshot.exists;
  }

  Future<void> addToFollowers(
      {@required String postUserId, @required String userId}) {
    return _profileCollection
        .document(postUserId)
        .collection('followers')
        .document(userId)
        .setData({'isFollowing': true});
  }

  Future<void> removeFromFollowers(
      {@required String postUserId, @required String userId}) {
    return _profileCollection
        .document(postUserId)
        .collection('followers')
        .document(userId)
        .delete();
  }

  Future<QuerySnapshot> fetchPosts({@required Post lastVisiblePost}) {
    return lastVisiblePost == null
        ? _postCollection
            .orderBy('lastUpdate', descending: true)
            .limit(5)
            .getDocuments()
        : _postCollection
            .orderBy('lastUpdate', descending: true)
            .startAfter([lastVisiblePost.lastUpdate])
            .limit(5)
            .getDocuments();
  }

  Future<DocumentReference> createPost(
      {@required List<String> imageUrls,
      @required String userId,
      @required String title,
      @required String description,
      @required double price,
      @required bool isAvailable,
      @required List<String> categories}) {
    return _postCollection.add({
      'imageUrls': imageUrls,
      'userId': userId,
      'title': title,
      'description': description,
      'price': price,
      'isAvailable': isAvailable,
      'category': categories,
      'created': _firestoreTimestamp,
      'lastUpdate': _firestoreTimestamp,
    });
  }
}

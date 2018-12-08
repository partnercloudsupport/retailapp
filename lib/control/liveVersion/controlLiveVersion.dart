import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> save(String document) async {
  try {
    String _version = DateTime.now().millisecondsSinceEpoch.toString();

    await Firestore.instance
        .collection('liveVersion')
        .document(document)
        .updateData({"version": _version});

    await Firestore.instance
        .collection('liveVersion')
        .document('all')
        .updateData({"version": _version});

    return true;
  } catch (e) {}

  return false;
}

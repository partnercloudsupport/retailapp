import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> save(String document) async {
  try {
    await Firestore.instance
        .collection('liveVersion')
        .document(document)
        .updateData(
            {"version": DateTime.now().millisecondsSinceEpoch.toString()});
    return true;
  } catch (e) {}

  return false;
}

class MyDouble {
  static double toMe(String v) {
    try {
      return double.parse(v);
    } catch (e) {}

    return 0;
  }
}

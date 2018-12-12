double to(String v) {
  try {
    return double.parse(v);
  } catch (e) {}

  return 0;
}

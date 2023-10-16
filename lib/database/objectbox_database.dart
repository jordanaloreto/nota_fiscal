import 'package:nota_fiscal/database/objectbox.g.dart';

class ObjectBoxDatabase {
  static Store? _store;

  static Future<Store> getStore() async {
    return _store ??= await openStore();
  }
}

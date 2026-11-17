import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// ID baris baru. SPEC P3: ID dibuat di klien, bukan di server.
String newId() => _uuid.v4();

/// ID deterministik untuk data yang boleh dimuat berulang.
///
/// Memakai UUID v5, jadi mengimpor file yang sama dua kali tidak membuat
/// duplikat dan tetap idempoten saat sinkron (SPEC P3).
String stableId(String scope, String key) =>
    _uuid.v5(Namespace.url.value, 'petshop.v1/$scope/$key');

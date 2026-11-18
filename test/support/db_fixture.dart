import 'package:drift/drift.dart' show Value;
import 'package:petshop_pos/core/db/app_database.dart';

const storeId = 'store-1';
const deviceId = 'device-1';
const deviceCode = 'T1';
const ownerId = 'user-owner';
const staffId = 'user-staff';
const productA = 'prod-a';
const productB = 'prod-b';
const unitPcsA = 'unit-a-pcs';
const unitDusA = 'unit-a-dus';
const unitPcsB = 'unit-b-pcs';
const customerId = 'cust-1';

final testNow = DateTime.utc(2026, 11, 18, 9);

/// Mengisi satu toko uji dengan dua produk, satu pelanggan, dan dua pengguna.
Future<AppDatabase> makeTestDb() async {
  final db = AppDatabase.memory();
  await seedTestDb(db);
  return db;
}

/// Mengisi database yang sudah dibuka. Dipakai tes host dan tes perangkat.
Future<void> seedTestDb(AppDatabase db) async {
  await db
      .into(db.stores)
      .insert(
        StoresCompanion.insert(
          id: storeId,
          name: 'Toko Uji',
          code2: '01',
          createdAt: testNow,
          updatedAt: testNow,
        ),
      );
  await db
      .into(db.profiles)
      .insert(
        ProfilesCompanion.insert(
          userId: ownerId,
          storeId: storeId,
          role: UserRole.owner,
          createdAt: testNow,
          updatedAt: testNow,
        ),
      );
  await db
      .into(db.profiles)
      .insert(
        ProfilesCompanion.insert(
          userId: staffId,
          storeId: storeId,
          role: UserRole.staff,
          createdAt: testNow,
          updatedAt: testNow,
        ),
      );
  await db
      .into(db.customers)
      .insert(
        CustomersCompanion.insert(
          id: customerId,
          storeId: storeId,
          name: 'Pelanggan Uji',
          createdAt: testNow,
          updatedAt: testNow,
        ),
      );
  await db
      .into(db.products)
      .insert(
        ProductsCompanion.insert(
          id: productA,
          storeId: storeId,
          name: 'Pakan A',
          baseUnit: 'pcs',
          createdAt: testNow,
          updatedAt: testNow,
        ),
      );
  await db
      .into(db.products)
      .insert(
        ProductsCompanion.insert(
          id: productB,
          storeId: storeId,
          name: 'Pakan B',
          baseUnit: 'pcs',
          createdAt: testNow,
          updatedAt: testNow,
        ),
      );
  await db
      .into(db.productUnits)
      .insert(
        ProductUnitsCompanion.insert(
          id: unitPcsA,
          storeId: storeId,
          productId: productA,
          unitName: 'pcs',
          factorToBase: 1,
          sellPrice: const Value(10000),
          createdAt: testNow,
          updatedAt: testNow,
        ),
      );
  await db
      .into(db.productUnits)
      .insert(
        ProductUnitsCompanion.insert(
          id: unitDusA,
          storeId: storeId,
          productId: productA,
          unitName: 'dus isi 10',
          factorToBase: 10,
          sellPrice: const Value(95000),
          createdAt: testNow,
          updatedAt: testNow,
        ),
      );
  await db
      .into(db.productUnits)
      .insert(
        ProductUnitsCompanion.insert(
          id: unitPcsB,
          storeId: storeId,
          productId: productB,
          unitName: 'pcs',
          factorToBase: 1,
          sellPrice: const Value(5000),
          createdAt: testNow,
          updatedAt: testNow,
        ),
      );
}

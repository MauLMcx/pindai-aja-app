import 'package:flutter_test/flutter_test.dart';
import 'package:petshop_pos/core/db/app_database.dart';
import 'package:petshop_pos/features/customers/debt_service.dart';

import '../../support/db_fixture.dart';

void main() {
  late AppDatabase db;
  late DebtService service;

  setUp(() async {
    db = await makeTestDb();
    service = DebtService(db, storeId: storeId, deviceId: deviceId);
  });

  tearDown(() => db.close());

  test('saldo utang = jumlah ledger dan pembayaran mengurangi', () async {
    await service.adjust(
      customerId: customerId,
      delta: 50000,
      at: testNow,
      note: 'kasbon awal',
    );

    final balance = await service.pay(
      customerId: customerId,
      amount: 20000,
      method: PayMethod.cash,
      at: testNow.add(const Duration(days: 1)),
    );

    expect(balance, 30000);
    expect(await service.balance(customerId), 30000);

    final history = await service.history(customerId);
    expect(history, hasLength(2));
    expect(history.first.delta, 50000);
    expect(history.last.delta, -20000);
    expect(history.last.type, DebtType.payment);
  });

  test('pembayaran nol atau metode kredit ditolak', () async {
    await expectLater(
      service.pay(
        customerId: customerId,
        amount: 0,
        method: PayMethod.cash,
      ),
      throwsArgumentError,
    );
    await expectLater(
      service.pay(
        customerId: customerId,
        amount: 1000,
        method: PayMethod.credit,
      ),
      throwsArgumentError,
    );
  });

  test('penyesuaian nol ditolak', () async {
    await expectLater(
      service.adjust(customerId: customerId, delta: 0),
      throwsArgumentError,
    );
  });
}

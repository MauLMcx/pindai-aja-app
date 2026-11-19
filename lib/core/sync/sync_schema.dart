// Daftar tabel yang ikut sinkron, beserta aturan konversi nilainya.
//
// Nama tabel dan kolom sama dengan PostgreSQL (snake_case). Kolom `server_seq`
// hanya disimpan di `stock_movements` karena tabel lain memakai
// `sync_state.last_pulled_seq`.

enum SyncMode {
  /// Baris baru menang bila `updated_at` lebih baru (SPEC §8).
  lastWriteWins,

  /// Data yang dibuat sekali; perubahan hanya lewat status/baris baru.
  upsert,

  /// Ledger append-only: konflik diabaikan.
  appendOnly,
}

class SyncTableSpec {
  const SyncTableSpec({
    required this.name,
    required this.columns,
    required this.conflictTarget,
    required this.mode,
    this.dateColumns = const {},
    this.boolColumns = const {},
    this.realColumns = const {},
    this.enumColumns = const {},
  });

  final String name;
  final List<String> columns;

  /// Kolom kunci konflik, contoh `id` atau `user_id`.
  final String conflictTarget;
  final SyncMode mode;
  final Set<String> dateColumns;
  final Set<String> boolColumns;
  final Set<String> realColumns;

  /// nama kolom -> {nilai server: nilai Drift}
  final Map<String, Map<String, String>> enumColumns;

  bool get storesServerSeq => name == 'stock_movements';
}

const Map<String, String> _movementTypes = {
  'purchase_in': 'purchaseIn',
  'sale_out': 'saleOut',
  'return_in': 'returnIn',
  'purchase_return_out': 'purchaseReturnOut',
  'opname_adjust': 'opnameAdjust',
  'void_in': 'voidIn',
  'manual_adjust': 'manualAdjust',
  'initial': 'initial',
};

const Map<String, String> _payMethods = {
  'cash': 'cash',
  'qris': 'qris',
  'ewallet': 'ewallet',
  'transfer': 'transfer',
  'card': 'card',
  'credit': 'credit',
};

const Map<String, String> _saleStatuses = {
  'completed': 'completed',
  'void': 'voided',
  'hold': 'hold',
};

const Map<String, String> _debtTypes = {
  'sale_credit': 'saleCredit',
  'payment': 'payment',
  'return_offset': 'returnOffset',
  'adjustment': 'adjustment',
};

const Map<String, String> _returnKinds = {
  'sale': 'sale',
  'purchase': 'purchase',
};

const Map<String, String> _opnameStatuses = {
  'open': 'open',
  'finished': 'finished',
};

const Map<String, String> _paymentStatuses = {
  'confirmed': 'confirmed',
  'pending': 'pending',
};

const Map<String, String> _barcodeSources = {
  'factory': 'factory',
  'internal': 'internal',
};

const Map<String, String> _priceKinds = {'buy': 'buy', 'sell': 'sell'};

const Set<String> _created = {'created_at'};
const Set<String> _createdUpdated = {'created_at', 'updated_at', 'deleted_at'};

/// Urutan penting: master dulu, lalu transaksi, lalu ledger.
///
/// Tanpa foreign key di SQLite, urutan ini hanya membantu pembacaan data.
final List<SyncTableSpec> syncTableSpecs = [
  SyncTableSpec(
    name: 'stores',
    columns: const [
      'id',
      'name',
      'code2',
      'created_at',
      'updated_at',
      'deleted_at',
      'device_id',
    ],
    conflictTarget: 'id',
    mode: SyncMode.lastWriteWins,
    dateColumns: _createdUpdated,
  ),
  SyncTableSpec(
    name: 'profiles',
    columns: const [
      'user_id',
      'store_id',
      'role',
      'display_name',
      'created_at',
      'updated_at',
      'deleted_at',
      'device_id',
    ],
    conflictTarget: 'user_id',
    mode: SyncMode.lastWriteWins,
    dateColumns: _createdUpdated,
    enumColumns: const {
      'role': {'owner': 'owner', 'staff': 'staff'},
    },
  ),
  SyncTableSpec(
    name: 'devices',
    columns: const [
      'id',
      'store_id',
      'code',
      'name',
      'created_at',
      'updated_at',
      'deleted_at',
      'device_id',
    ],
    conflictTarget: 'id',
    mode: SyncMode.lastWriteWins,
    dateColumns: _createdUpdated,
  ),
  SyncTableSpec(
    name: 'suppliers',
    columns: const [
      'id',
      'store_id',
      'name',
      'phone',
      'note',
      'created_at',
      'updated_at',
      'deleted_at',
      'device_id',
    ],
    conflictTarget: 'id',
    mode: SyncMode.lastWriteWins,
    dateColumns: _createdUpdated,
  ),
  SyncTableSpec(
    name: 'categories',
    columns: const [
      'id',
      'store_id',
      'name',
      'default_margin_pct',
      'created_at',
      'updated_at',
      'deleted_at',
      'device_id',
    ],
    conflictTarget: 'id',
    mode: SyncMode.lastWriteWins,
    dateColumns: _createdUpdated,
    realColumns: const {'default_margin_pct'},
  ),
  SyncTableSpec(
    name: 'products',
    columns: const [
      'id',
      'store_id',
      'name',
      'brand',
      'variant',
      'category_id',
      'base_unit',
      'min_stock_base',
      'shelf_location',
      'main_supplier_id',
      'needs_price_review',
      'is_active',
      'note',
      'created_at',
      'updated_at',
      'deleted_at',
      'device_id',
    ],
    conflictTarget: 'id',
    mode: SyncMode.lastWriteWins,
    dateColumns: _createdUpdated,
    boolColumns: const {'needs_price_review', 'is_active'},
  ),
  SyncTableSpec(
    name: 'product_units',
    columns: const [
      'id',
      'store_id',
      'product_id',
      'unit_name',
      'factor_to_base',
      'barcode',
      'barcode_source',
      'sell_price',
      'is_default_sale',
      'is_default_purchase',
      'created_at',
      'updated_at',
      'deleted_at',
      'device_id',
    ],
    conflictTarget: 'id',
    mode: SyncMode.lastWriteWins,
    dateColumns: _createdUpdated,
    boolColumns: const {'is_default_sale', 'is_default_purchase'},
    enumColumns: {'barcode_source': _barcodeSources},
  ),
  SyncTableSpec(
    name: 'price_history',
    columns: const [
      'id',
      'store_id',
      'product_unit_id',
      'kind',
      'price',
      'effective_at',
      'source_ref',
      'created_at',
      'device_id',
    ],
    conflictTarget: 'id',
    mode: SyncMode.appendOnly,
    dateColumns: {..._created, 'effective_at'},
    enumColumns: {'kind': _priceKinds},
  ),
  SyncTableSpec(
    name: 'purchases',
    columns: const [
      'id',
      'store_id',
      'supplier_id',
      'doc_no',
      'purchased_at',
      'total',
      'note',
      'status',
      'created_at',
      'updated_at',
      'deleted_at',
      'device_id',
    ],
    conflictTarget: 'id',
    mode: SyncMode.upsert,
    dateColumns: {..._createdUpdated, 'purchased_at'},
  ),
  SyncTableSpec(
    name: 'purchase_items',
    columns: const [
      'id',
      'store_id',
      'purchase_id',
      'product_id',
      'unit_id',
      'qty',
      'unit_cost',
      'qty_base',
      'cost_per_base',
      'created_at',
      'updated_at',
      'deleted_at',
      'device_id',
    ],
    conflictTarget: 'id',
    mode: SyncMode.appendOnly,
    dateColumns: _createdUpdated,
    realColumns: const {'cost_per_base'},
  ),
  SyncTableSpec(
    name: 'stock_movements',
    columns: const [
      'id',
      'store_id',
      'product_id',
      'qty_base_delta',
      'type',
      'ref_type',
      'ref_id',
      'cost_per_base',
      'occurred_at',
      'note',
      'device_id',
      'server_seq',
    ],
    conflictTarget: 'id',
    mode: SyncMode.appendOnly,
    dateColumns: const {'occurred_at'},
    realColumns: const {'cost_per_base'},
    enumColumns: {'type': _movementTypes},
  ),
  SyncTableSpec(
    name: 'putaway_log',
    columns: const [
      'id',
      'store_id',
      'product_id',
      'from_location',
      'to_location',
      'occurred_at',
      'device_id',
    ],
    conflictTarget: 'id',
    mode: SyncMode.appendOnly,
    dateColumns: const {'occurred_at'},
  ),
  SyncTableSpec(
    name: 'customers',
    columns: const [
      'id',
      'store_id',
      'name',
      'phone',
      'note',
      'credit_limit',
      'created_at',
      'updated_at',
      'deleted_at',
      'device_id',
    ],
    conflictTarget: 'id',
    mode: SyncMode.lastWriteWins,
    dateColumns: _createdUpdated,
  ),
  SyncTableSpec(
    name: 'debt_ledger',
    columns: const [
      'id',
      'store_id',
      'customer_id',
      'delta',
      'type',
      'ref_id',
      'method',
      'occurred_at',
      'note',
      'device_id',
    ],
    conflictTarget: 'id',
    mode: SyncMode.appendOnly,
    dateColumns: const {'occurred_at'},
    enumColumns: {'type': _debtTypes, 'method': _payMethods},
  ),
  SyncTableSpec(
    name: 'sales',
    columns: const [
      'id',
      'store_id',
      'receipt_no',
      'cashier_id',
      'customer_id',
      'sold_at',
      'subtotal',
      'discount_total',
      'total',
      'paid_total',
      'change_amount',
      'status',
      'note',
      'created_at',
      'updated_at',
      'deleted_at',
      'device_id',
    ],
    conflictTarget: 'id',
    mode: SyncMode.upsert,
    dateColumns: {..._createdUpdated, 'sold_at'},
    enumColumns: {'status': _saleStatuses},
  ),
  SyncTableSpec(
    name: 'sale_items',
    columns: const [
      'id',
      'store_id',
      'sale_id',
      'product_id',
      'unit_id',
      'qty',
      'qty_base',
      'unit_price',
      'discount',
      'line_total',
      'cost_per_base',
      'created_at',
      'updated_at',
      'deleted_at',
      'device_id',
    ],
    conflictTarget: 'id',
    mode: SyncMode.appendOnly,
    dateColumns: _createdUpdated,
    realColumns: const {'cost_per_base'},
  ),
  SyncTableSpec(
    name: 'payments',
    columns: const [
      'id',
      'store_id',
      'sale_id',
      'method',
      'amount',
      'status',
      'reference',
      'paid_at',
      'created_at',
      'updated_at',
      'deleted_at',
      'device_id',
    ],
    conflictTarget: 'id',
    mode: SyncMode.upsert,
    dateColumns: {..._createdUpdated, 'paid_at'},
    enumColumns: {'method': _payMethods, 'status': _paymentStatuses},
  ),
  SyncTableSpec(
    name: 'returns',
    columns: const [
      'id',
      'store_id',
      'kind',
      'sale_id',
      'purchase_id',
      'customer_id',
      'returned_at',
      'refund_method',
      'refund_total',
      'reason',
      'created_at',
      'updated_at',
      'deleted_at',
      'device_id',
    ],
    conflictTarget: 'id',
    mode: SyncMode.appendOnly,
    dateColumns: {..._createdUpdated, 'returned_at'},
    enumColumns: {'kind': _returnKinds, 'refund_method': _payMethods},
  ),
  SyncTableSpec(
    name: 'return_items',
    columns: const [
      'id',
      'store_id',
      'return_id',
      'product_id',
      'unit_id',
      'qty',
      'qty_base',
      'amount',
      'cost_per_base',
      'created_at',
      'updated_at',
      'deleted_at',
      'device_id',
    ],
    conflictTarget: 'id',
    mode: SyncMode.appendOnly,
    dateColumns: _createdUpdated,
    realColumns: const {'cost_per_base'},
  ),
  SyncTableSpec(
    name: 'stock_opnames',
    columns: const [
      'id',
      'store_id',
      'started_at',
      'finished_at',
      'status',
      'scope',
      'note',
      'created_at',
      'updated_at',
      'deleted_at',
      'device_id',
    ],
    conflictTarget: 'id',
    mode: SyncMode.upsert,
    dateColumns: {..._createdUpdated, 'started_at', 'finished_at'},
    enumColumns: {'status': _opnameStatuses},
  ),
  SyncTableSpec(
    name: 'stock_opname_items',
    columns: const [
      'id',
      'store_id',
      'opname_id',
      'product_id',
      'expected_base',
      'counted_base',
      'diff_base',
      'created_at',
      'updated_at',
      'deleted_at',
      'device_id',
    ],
    conflictTarget: 'id',
    mode: SyncMode.appendOnly,
    dateColumns: _createdUpdated,
  ),
  SyncTableSpec(
    name: 'expenses',
    columns: const [
      'id',
      'store_id',
      'category',
      'amount',
      'spent_at',
      'note',
      'created_at',
      'updated_at',
      'deleted_at',
      'device_id',
    ],
    conflictTarget: 'id',
    mode: SyncMode.lastWriteWins,
    dateColumns: {..._createdUpdated, 'spent_at'},
  ),
];

SyncTableSpec? syncSpecFor(String table) {
  for (final spec in syncTableSpecs) {
    if (spec.name == table) return spec;
  }
  return null;
}

/// Nama tabel bisnis untuk backup (tanpa outbox/sync_state, dengan app_settings).
List<String> get backupTableNames => [
  ...syncTableSpecs.map((spec) => spec.name),
  'app_settings',
];

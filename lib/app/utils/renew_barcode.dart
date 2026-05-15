class RenewBarcode {
  static final String _kRenewPrefix = 'ZV';

  String barcode;
  int version;
  String id;

  RenewBarcode(this.barcode, this.id, this.version);

  static RenewBarcode? parse(String rawValue) {
    final parts = rawValue.split(' ');
    final isRenewBarcode = (parts.elementAtOrNull(0) ?? '').startsWith(_kRenewPrefix);

    if (!isRenewBarcode) return null;

    final version = int.tryParse(parts[0].substring(2));
    final id = parts.elementAtOrNull(1);

    if (rawValue.length == 1) return null;
    if (version == null || id == null) return null;

    return RenewBarcode(rawValue, id, version);
  }

  int? get intId => int.tryParse(id);
}

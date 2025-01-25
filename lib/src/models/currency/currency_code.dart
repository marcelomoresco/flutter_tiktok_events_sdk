// ignore_for_file: constant_identifier_names

enum CurrencyCode {
  AED,
  ARS,
  AUD,
  BDT,
  BHD,
  BIF,
  BOB,
  BRL,
  CAD,
  CHF,
  CLP,
  CNY,
  COP,
  CRC,
  CZK,
  DKK,
  DZD,
  EGP,
  EUR,
  GBP,
  GTQ,
  HKD,
  HNL,
  HUF,
  IDR,
  ILS,
  INR,
  ISK,
  JPY,
  KES,
  KHR,
  KRW,
  KWD,
  KZT,
  MAD,
  MOP,
  MXN,
  MYR,
  NGN,
  NIO,
  NOK,
  NZD,
  OMR,
  PEN,
  PHP,
  PKR,
  PLN,
  PYG,
  QAR,
  RON,
  RUB,
  SAR,
  SEK,
  SGD,
  THB,
  TRY,
  TWD,
  UAH,
  USD,
  VES,
  VND,
  ZAR,
  BGN,
  IQD,
  JOD,
  LBP,
  TZS;

  String get value => name;

  static CurrencyCode? fromString(String? value) {
    if (value == null) return null;

    try {
      return CurrencyCode.values.firstWhere((currency) => currency.name == value);
    } catch (_) {
      return null;
    }
  }
}

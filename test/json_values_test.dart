import 'package:flutter_test/flutter_test.dart';
import 'package:icms_app/Model/CustomersDataModel/customer_detail_response_model.dart';
import 'package:icms_app/Model/VehicleMakeModel/vehicle_make_response_model.dart';
import 'package:icms_app/utils/json_values.dart';

void main() {
  Map<String, dynamic> identity(Map<String, dynamic> json) => json;

  test('plain list', () {
    final items = readJsonList([
      {'id': 1, 'name': 'A'},
      {'id': 2, 'name': 'B'},
    ], identity);

    expect(items, [
      {'id': 1, 'name': 'A'},
      {'id': 2, 'name': 'B'},
    ]);
  });

  test('null and empty object are empty lists', () {
    expect(readJsonList(null, identity), isEmpty);
    expect(readJsonList(<String, dynamic>{}, identity), isEmpty);
  });

  test('paginator uses the nested data list', () {
    final items = readJsonList({
      'current_page': 1,
      'data': [
        {'id': 1, 'name': 'Toyota'},
      ],
      'first_page_url': 'https://example.test?page=1',
      'total': 40,
    }, identity);

    expect(items, [
      {'id': 1, 'name': 'Toyota'},
    ]);
  });

  test('wrapped resource uses the nested data list', () {
    final items = readJsonList({
      'data': [
        {'id': 2, 'name': 'Honda'},
      ],
    }, identity);

    expect(items.single['name'], 'Honda');
  });

  test('id-keyed map of objects', () {
    final items = readJsonList({
      '10': {'id': 10, 'name': 'Honda'},
      '11': {'id': 11, 'name': 'Suzuki'},
    }, identity);

    expect(items.map((item) => item['name']).toList(), ['Honda', 'Suzuki']);
  });

  test('non-map nested object is ignored', () {
    expect(readJsonObject(<dynamic>[], identity), isNull);
    expect(readJsonObject('nope', identity), isNull);
    expect(readJsonMap(1), isNull);
    expect(readJsonObject({'id': 4}, identity)?['id'], 4);
  });

  test('vehicle makes parse the full-list response', () {
    final model = VehicleMakeResponseModel.fromJson({
      'success': true,
      'data': [
        {'id': 1, 'name': 'Toyota', 'uuid': 'abc', 'created_at': '2026-01-01'},
        {'id': '2', 'name': 'Honda'},
      ],
      'error': null,
    });

    expect(model.data?.map((item) => item.name).toList(), ['Toyota', 'Honda']);
    expect(model.data?.last.id, 2);
  });

  test('vehicle makes parse a paginator and a wrapped collection', () {
    final paged = VehicleMakeResponseModel.fromJson({
      'success': true,
      'data': {
        'current_page': 1,
        'data': [
          {'id': 1, 'name': 'Toyota'},
        ],
      },
    });
    expect(paged.data?.single.name, 'Toyota');

    final wrapped = VehicleMakeResponseModel.fromJson({
      'success': true,
      'data': {
        'data': [
          {'id': 2, 'name': 'Honda'},
        ],
      },
    });
    expect(wrapped.data?.single.name, 'Honda');
  });

  test('claim relations survive an empty object list and a non-map object', () {
    final detail = CustomerDetailData.fromJson({
      'labours': <String, dynamic>{},
      'vehicle': <dynamic>[],
    });

    expect(detail.labours, isEmpty);
    expect(detail.vehicle, isNull);
  });
}

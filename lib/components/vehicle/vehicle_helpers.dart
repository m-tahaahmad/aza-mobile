import 'package:icms_app/constants/globals.dart';

String vehicleScreenTitle({required bool isItemsChecked}) =>
    isItemsChecked ? 'Items Checked' : 'Vehicle';

String vehicleScreenSubtitle({required bool isItemsChecked}) =>
    isItemsChecked ? 'Inspection items confirmed' : 'Vehicle details captured';

bool vehicleFieldsReadOnly() =>
    claimsType == 'Waiting for approval' ||
    claimsType == 'Docs Pending' ||
    claimsType == 'Reports Pending';

const List<String> kVehicleDiagramParts = [
  'Right Front Fender',
  'Right View Mirror',
  'Right Front Door',
  'Right Rear Door',
  'Right Rear Fender',
  'Right Head Light',
  'Right Tail Light',
  'Front Bumper',
  'Bonnet',
  'Front Wind Screen Fitting',
  'Roof',
  'Rear Wind Screen Fitting',
  'Dickey',
  'Rear Bumper',
  'Left Head Light',
  'Left Tail Light',
  'Left Front Fender',
  'Left View Mirror',
  'Left Front Door',
  'Left Rear Door',
  'Left Rear Fender',
];

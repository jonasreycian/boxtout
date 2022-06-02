import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../app/app.logger.dart';
import '../constants/app_keys.dart';

/// Returns values from the environment read from the .env file
class EnvironmentService {
  final log = getLogger('EnvironmentService');

  Future initialise() async {
    log.i('Load environment');
    await dotenv.load(fileName: ".env");
    log.v('Environement loaded');
  }

  /// Returns the value associated with the key
  String getValue(String key, {bool verbose = false}) {
    String? value = dotenv.maybeGet(key, fallback: NoKey);
    if (verbose) log.v('key:$key value:$value');
    return value!;
  }
}

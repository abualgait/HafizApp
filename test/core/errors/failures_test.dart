import 'package:flutter_test/flutter_test.dart';
import 'package:hafiz_app/core/errors/failures.dart';

void main() {
  const tErrorMessage = 'testErrorMessage';

  group("ServerFailure", () {
    test("make sure toString return true results", () {
      expect(ServerFailure(tErrorMessage).toString(),
          "ServerFailure{errorMessage: $tErrorMessage}");
    });

    test("make sure ServerFailure props return [tErrorMessage]", () {
      expect(ServerFailure(tErrorMessage).props, [tErrorMessage]);
    });
  });

  group("ConnectionFailure", () {
    test("make sure ConnectionFailure toString return true results", () {
      expect(ConnectionFailure().toString(),
          "ConnectionFailure{errorMessage: $messageConnectionFailure}");
    });

    test("make sure ConnectionFailure props return [tErrorMessage]", () {
      expect(ConnectionFailure().props, [messageConnectionFailure]);
    });
  });
}

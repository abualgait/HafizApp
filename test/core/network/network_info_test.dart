import 'package:flutter_test/flutter_test.dart';
import 'package:hafiz_app/core/app_export.dart';
import 'package:mocktail/mocktail.dart';

// Mock the Connectivity class for testing
class MockConnectivity extends Mock implements Connectivity {}

void main() {
  group('NetworkInfo', () {
    late NetworkInfo networkInfo;
    late MockConnectivity mockConnectivity;

    setUp(() {
      mockConnectivity = MockConnectivity();
      networkInfo = NetworkInfo(mockConnectivity);
    });

    group('isConnected', () {
      test('should return true when connectivity is not none', () async {
        when(() => mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => ConnectivityResult.wifi);
        var result = await networkInfo.isConnected();

        expect(result, true);
      });

      test('should return false when connectivity is none', () async {
        // Arrange
        when(() => mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => ConnectivityResult.none);

        // Act
        final result = await networkInfo.isConnected();

        // Assert
        expect(result, false);
      });
    });

    group('ConnectivityResult', () {
      test('should return wifi when connectivity is ConnectivityResult.wifi',
          () async {
        when(() => mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => ConnectivityResult.wifi);
        var result = await networkInfo.connectivityResult;

        expect(result, ConnectivityResult.wifi);
      });
    });
  });
}

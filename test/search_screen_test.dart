import 'package:area_film_uas/screens/search/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Search screen shows search input and empty state', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SearchScreen()));

    expect(find.text('Cari Film'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });
}

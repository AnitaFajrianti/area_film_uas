import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:area_film_uas/main.dart';

void main() {
  testWidgets('App loads successfully smoke test', (WidgetTester tester) async {
    // Membangun aplikasi menggunakan class yang benar sesuai main.dart kamu
    await tester.pumpWidget(const AreaFilmApp());

    // Memastikan bahwa MaterialApp berhasil dirender tanpa crash
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
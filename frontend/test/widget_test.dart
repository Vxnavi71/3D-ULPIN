import 'package:flutter_test/flutter_test.dart';
import 'package:lunara_3d_property/main.dart';
void main(){testWidgets('LUNARA shell renders', (tester) async {await tester.pumpWidget(const LunaraApp());expect(find.text('LUNARA'), findsOneWidget);expect(find.text('DEMO MODE'), findsWidgets);});}

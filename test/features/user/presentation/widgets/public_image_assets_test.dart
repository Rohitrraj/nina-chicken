import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kedai_ayam_nina/core/assets.dart';
import 'package:kedai_ayam_nina/core/theme.dart';
import 'package:kedai_ayam_nina/features/user/presentation/widgets/about/about_family_story_section.dart';
import 'package:kedai_ayam_nina/features/user/presentation/widgets/about/about_intro_section.dart';
import 'package:kedai_ayam_nina/features/user/presentation/widgets/about/about_testimonials_section.dart';
import 'package:kedai_ayam_nina/features/user/presentation/widgets/home/home_about_preview.dart';
import 'package:kedai_ayam_nina/features/user/presentation/widgets/home/home_hero_section.dart';

Finder findAsset(String assetName) {
  return find.byWidgetPredicate((widget) {
    if (widget is! Image) {
      return false;
    }

    final provider = widget.image;

    return provider is AssetImage && provider.assetName == assetName;
  });
}

Future<void> pumpSection(WidgetTester tester, Widget section) async {
  tester.view.physicalSize = const Size(1440, 3200);
  tester.view.devicePixelRatio = 1;

  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.lightTheme(),
      home: Scaffold(body: SingleChildScrollView(child: section)),
    ),
  );

  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Home Hero uses logo and final homepage image', (tester) async {
    await pumpSection(tester, HomeHeroSection(onViewMenu: () {}));

    expect(findAsset(Assets.logoC1), findsOneWidget);
    expect(findAsset(Assets.ninaHomeHero), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Home About uses final lower homepage image', (tester) async {
    await pumpSection(tester, HomeAboutPreview(onReadMore: () {}));

    expect(findAsset(Assets.ninaHomeAbout), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('About Intro uses final interior image', (tester) async {
    await pumpSection(tester, const AboutIntroSection());

    expect(findAsset(Assets.ninaAboutIntro), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Family Story uses final illustration', (tester) async {
    await pumpSection(tester, const AboutFamilyStorySection());

    expect(findAsset(Assets.ninaFamilyStory), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('testimonials do not use an image', (tester) async {
    await pumpSection(tester, const AboutTestimonialsSection());

    expect(find.byType(Image), findsNothing);
    expect(tester.takeException(), isNull);
  });
}

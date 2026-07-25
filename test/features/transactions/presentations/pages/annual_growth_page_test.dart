import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kedai_ayam_nina/core/theme.dart';
import 'package:kedai_ayam_nina/features/transactions/domain/entities/annual_growth.dart';
import 'package:kedai_ayam_nina/features/transactions/domain/entities/transaction.dart';
import 'package:kedai_ayam_nina/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:kedai_ayam_nina/features/transactions/domain/usecases/create_transaction.dart';
import 'package:kedai_ayam_nina/features/transactions/domain/usecases/delete_transaction.dart';
import 'package:kedai_ayam_nina/features/transactions/domain/usecases/get_annual_growth.dart';
import 'package:kedai_ayam_nina/features/transactions/domain/usecases/update_transaction.dart';
import 'package:kedai_ayam_nina/features/transactions/presentations/bloc/transaction_bloc.dart';
import 'package:kedai_ayam_nina/features/transactions/presentations/pages/annual_growth_page.dart';
import 'package:visibility_detector/visibility_detector.dart';

class _FakeTransactionRepository implements TransactionRepository {
  _FakeTransactionRepository({this.result, this.error});

  final AnnualGrowth? result;
  final Object? error;

  int annualGrowthRequestCount = 0;

  @override
  Future<AnnualGrowth> getAnnualGrowth(int year) async {
    annualGrowthRequestCount += 1;

    if (error != null) {
      throw error!;
    }

    final value = result;

    if (value == null) {
      throw StateError('Fake annual growth result belum disediakan.');
    }

    return value;
  }

  @override
  Future<List<Transaction>> getTransactions() async {
    return <Transaction>[];
  }

  @override
  Future<Transaction> getTransaction(String id) {
    throw UnimplementedError();
  }

  @override
  Future<void> createTransaction(Transaction transaction) async {}

  @override
  Future<void> updateTransaction(Transaction transaction) async {}

  @override
  Future<void> deleteTransaction(String id) async {}
}

TransactionBloc _createBloc(TransactionRepository repository) {
  return TransactionBloc(
    createTransaction: CreateTransaction(repository),
    deleteTransaction: DeleteTransaction(repository),
    getAnnualGrowth: GetAnnualGrowth(repository),
    updateTransaction: UpdateTransaction(repository),
  );
}

AnnualGrowth _growthWithData(int year) {
  return AnnualGrowth(
    year: year,
    totalPemasukan: 3500000,
    pemasukanGrowth: 250,
    totalPengeluaran: 45000,
    pengeluaranGrowth: 100,
    profitBersih: 3455000,
    profitGrowth: 245.5,
    monthlyData: List<MonthlyDataEntity>.generate(12, (index) {
      final month = index + 1;

      if (month == 6) {
        return MonthlyDataEntity(
          month: month,
          pemasukan: 1000000,
          pengeluaran: 0,
          profit: 1000000,
        );
      }

      if (month == 7) {
        return MonthlyDataEntity(
          month: month,
          pemasukan: 2500000,
          pengeluaran: 45000,
          profit: 2455000,
        );
      }

      return MonthlyDataEntity(
        month: month,
        pemasukan: 0,
        pengeluaran: 0,
        profit: 0,
      );
    }),
  );
}

AnnualGrowth _growthWithoutData(int year) {
  return AnnualGrowth(
    year: year,
    totalPemasukan: 0,
    pemasukanGrowth: 0,
    totalPengeluaran: 0,
    pengeluaranGrowth: 0,
    profitBersih: 0,
    profitGrowth: 0,
    monthlyData: List<MonthlyDataEntity>.generate(12, (index) {
      return MonthlyDataEntity(
        month: index + 1,
        pemasukan: 0,
        pengeluaran: 0,
        profit: 0,
      );
    }),
  );
}

Future<void> _pumpDashboard(
  WidgetTester tester, {
  required _FakeTransactionRepository repository,
  required Size viewportSize,
}) async {
  tester.view.physicalSize = viewportSize;
  tester.view.devicePixelRatio = 1;

  addTearDown(tester.view.resetPhysicalSize);

  addTearDown(tester.view.resetDevicePixelRatio);

  VisibilityDetectorController.instance.updateInterval = Duration.zero;

  final bloc = _createBloc(repository);

  addTearDown(bloc.close);

  await tester.pumpWidget(
    BlocProvider<TransactionBloc>.value(
      value: bloc,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme(),
        home: const AnnualGrowthPage(),
      ),
    ),
  );

  await tester.pump();
  await tester.pumpAndSettle();
}

void main() {
  final currentYear = DateTime.now().year;

  testWidgets('renders loaded analytics dashboard on mobile '
      'without overflow', (tester) async {
    final repository = _FakeTransactionRepository(
      result: _growthWithData(currentYear),
    );

    await _pumpDashboard(
      tester,
      repository: repository,
      viewportSize: const Size(390, 844),
    );

    expect(find.text('Analitik Keuangan'), findsOneWidget);

    expect(find.byKey(const Key('analytics-income-card')), findsOneWidget);

    expect(find.byKey(const Key('analytics-expense-card')), findsOneWidget);

    expect(find.byKey(const Key('analytics-profit-card')), findsOneWidget);

    expect(find.byKey(const Key('analytics-bar-chart')), findsOneWidget);

    expect(find.byKey(const Key('analytics-line-chart')), findsOneWidget);

    expect(find.byKey(const Key('analytics-monthly-detail')), findsOneWidget);

    expect(find.text('Januari'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('renders desktop analytics table without overflow', (
    tester,
  ) async {
    final repository = _FakeTransactionRepository(
      result: _growthWithData(currentYear),
    );

    await _pumpDashboard(
      tester,
      repository: repository,
      viewportSize: const Size(1440, 900),
    );

    expect(find.text('Pemasukan vs Pengeluaran'), findsOneWidget);

    expect(find.text('Tren Profit Bulanan'), findsOneWidget);

    expect(find.text('Detail Bulanan'), findsOneWidget);

    expect(find.text('Pengeluaran'), findsWidgets);

    expect(tester.takeException(), isNull);
  });

  testWidgets('shows empty state when selected year has no activity', (
    tester,
  ) async {
    final repository = _FakeTransactionRepository(
      result: _growthWithoutData(currentYear),
    );

    await _pumpDashboard(
      tester,
      repository: repository,
      viewportSize: const Size(390, 844),
    );

    expect(find.byKey(const Key('analytics-empty-state')), findsOneWidget);

    expect(find.text('Belum ada aktivitas keuangan'), findsOneWidget);

    expect(find.byKey(const Key('analytics-bar-chart')), findsNothing);

    expect(tester.takeException(), isNull);
  });

  testWidgets('shows safe error state without exposing raw error', (
    tester,
  ) async {
    final repository = _FakeTransactionRepository(
      error: Exception('permission-denied: internal firestore detail'),
    );

    await _pumpDashboard(
      tester,
      repository: repository,
      viewportSize: const Size(390, 844),
    );

    expect(find.byKey(const Key('analytics-error-state')), findsOneWidget);

    expect(find.text('Data analitik belum dapat dimuat'), findsOneWidget);

    expect(find.textContaining('permission-denied'), findsNothing);

    expect(find.textContaining('firestore'), findsNothing);
  });

  testWidgets('disables next-year action for the current year', (tester) async {
    final repository = _FakeTransactionRepository(
      result: _growthWithData(currentYear),
    );

    await _pumpDashboard(
      tester,
      repository: repository,
      viewportSize: const Size(390, 844),
    );

    final nextYearButton = tester.widget<IconButton>(
      find.byKey(const Key('analytics-next-year')),
    );

    expect(nextYearButton.onPressed, isNull);
  });

  testWidgets('year selector exposes semantics and adequate tap target', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();

    final repository = _FakeTransactionRepository(
      result: _growthWithData(currentYear),
    );

    await _pumpDashboard(
      tester,
      repository: repository,
      viewportSize: const Size(390, 844),
    );

    final yearSelectorSemantics = tester.getSemantics(
      find.byKey(const Key('analytics-year-selector-semantics')),
    );

    expect(
      yearSelectorSemantics.label,
      contains('Tahun analitik $currentYear'),
    );

    final previousButtonSize = tester.getSize(
      find.byKey(const Key('analytics-previous-year')),
    );

    final nextButtonSize = tester.getSize(
      find.byKey(const Key('analytics-next-year')),
    );

    expect(previousButtonSize.width, greaterThanOrEqualTo(48));

    expect(previousButtonSize.height, greaterThanOrEqualTo(48));

    expect(nextButtonSize.width, greaterThanOrEqualTo(48));

    expect(nextButtonSize.height, greaterThanOrEqualTo(48));

    semantics.dispose();
  });
}

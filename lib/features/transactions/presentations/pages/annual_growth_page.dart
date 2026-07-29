import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kedai_ayam_nina/core/design_system/design_system.dart';
import 'package:kedai_ayam_nina/core/utils/rupiah_formatter.dart';
import 'package:kedai_ayam_nina/features/transactions/domain/entities/annual_growth.dart';
import 'package:kedai_ayam_nina/features/transactions/presentations/bloc/transaction_bloc.dart';
import 'package:visibility_detector/visibility_detector.dart';

class AnnualGrowthPage extends StatefulWidget {
  const AnnualGrowthPage({super.key});

  @override
  State<AnnualGrowthPage> createState() => _AnnualGrowthPageState();
}

class _AnnualGrowthPageState extends State<AnnualGrowthPage> {
  int _selectedYear = DateTime.now().year;

  bool _wasVisible = false;
  bool _hasLoaded = false;

  void _handleVisibilityChanged(VisibilityInfo visibilityInfo) {
    final isVisible = visibilityInfo.visibleFraction > 0;

    if (isVisible && (!_wasVisible || !_hasLoaded)) {
      _hasLoaded = true;
      _fetchData();
    }

    _wasVisible = isVisible;
  }

  void _fetchData() {
    context.read<TransactionBloc>().add(
      GetAnnualGrowthEvent(year: _selectedYear),
    );
  }

  void _changeYear(int delta) {
    final nextYear = _selectedYear + delta;

    if (nextYear > DateTime.now().year) {
      return;
    }

    setState(() {
      _selectedYear = nextYear;
    });

    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('annual-growth-page-visibility'),
      onVisibilityChanged: _handleVisibilityChanged,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: LayoutBuilder(
          builder: (context, constraints) {
            final contentPadding = constraints.maxWidth < 600
                ? AppSpacing.md
                : constraints.maxWidth < 1100
                ? AppSpacing.lg
                : AppSpacing.xl;

            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                contentPadding,
                AppSpacing.lg,
                contentPadding,
                AppSpacing.xxl,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1440),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _DashboardHeader(
                        selectedYear: _selectedYear,
                        canSelectNextYear: _selectedYear < DateTime.now().year,
                        onPreviousYear: () {
                          _changeYear(-1);
                        },
                        onNextYear: () {
                          _changeYear(1);
                        },
                        onRefresh: _fetchData,
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      BlocBuilder<TransactionBloc, TransactionState>(
                        builder: (context, state) {
                          if (state is TransactionLoading) {
                            return const _LoadingState();
                          }

                          if (state is TransactionError) {
                            return _ErrorState(onRetry: _fetchData);
                          }

                          if (state is AnnualGrowthLoaded) {
                            return _AnalyticsContent(data: state.annualGrowth);
                          }

                          return const _LoadingState();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader({
    required this.selectedYear,
    required this.canSelectNextYear,
    required this.onPreviousYear,
    required this.onNextYear,
    required this.onRefresh,
  });

  final int selectedYear;
  final bool canSelectNextYear;
  final VoidCallback onPreviousYear;
  final VoidCallback onNextYear;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontal = constraints.maxWidth >= 760;

        final heading = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              decoration: const BoxDecoration(
                color: AppColors.primary50,
                borderRadius: AppRadius.pill,
              ),
              child: Text(
                'DASHBOARD KEUANGAN',
                style: AppTypography.sectionEyebrow,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Analitik Keuangan',
              style: theme.textTheme.displaySmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
                height: 1.12,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Pantau pemasukan, pengeluaran, '
              'dan profit Kedai Ayam Nina.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        );

        final controls = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _YearSelector(
              selectedYear: selectedYear,
              canSelectNextYear: canSelectNextYear,
              onPreviousYear: onPreviousYear,
              onNextYear: onNextYear,
            ),
            const SizedBox(width: AppSpacing.sm),
            Tooltip(
              message: 'Muat ulang analitik',
              child: IconButton(
                onPressed: onRefresh,
                icon: const Icon(Icons.refresh_rounded),
                style: IconButton.styleFrom(
                  minimumSize: const Size(48, 48),
                  backgroundColor: AppColors.surface,
                  foregroundColor: AppColors.primary700,
                  side: const BorderSide(color: AppColors.border),
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadius.md,
                  ),
                ),
              ),
            ),
          ],
        );

        if (horizontal) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(child: heading),
              const SizedBox(width: AppSpacing.lg),
              controls,
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            heading,
            const SizedBox(height: AppSpacing.lg),
            controls,
          ],
        );
      },
    );
  }
}

class _YearSelector extends StatelessWidget {
  const _YearSelector({
    required this.selectedYear,
    required this.canSelectNextYear,
    required this.onPreviousYear,
    required this.onNextYear,
  });

  final int selectedYear;
  final bool canSelectNextYear;
  final VoidCallback onPreviousYear;
  final VoidCallback onNextYear;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      key: const Key('analytics-year-selector-semantics'),
      container: true,
      label: 'Tahun analitik $selectedYear',
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.md,
          border: Border.all(color: AppColors.border),
          boxShadow: AppShadows.sm,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              key: const Key('analytics-previous-year'),
              tooltip: 'Tahun sebelumnya',
              onPressed: onPreviousYear,
              icon: const Icon(Icons.chevron_left_rounded),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Tahun',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                  Text(
                    '$selectedYear',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              key: const Key('analytics-next-year'),
              tooltip: 'Tahun berikutnya',
              onPressed: canSelectNextYear ? onNextYear : null,
              icon: const Icon(Icons.chevron_right_rounded),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnalyticsContent extends StatelessWidget {
  const _AnalyticsContent({required this.data});

  final AnnualGrowth data;

  bool get _hasActivity {
    if (data.totalPemasukan != 0 ||
        data.totalPengeluaran != 0 ||
        data.profitBersih != 0) {
      return true;
    }

    return data.monthlyData.any(
      (month) =>
          month.pemasukan != 0 || month.pengeluaran != 0 || month.profit != 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SummarySection(data: data),
        const SizedBox(height: AppSpacing.xl),
        if (!_hasActivity)
          _EmptyState(year: data.year)
        else ...[
          _ChartsSection(data: data),
          const SizedBox(height: AppSpacing.xl),
          _MonthlyDetailSection(data: data),
        ],
      ],
    );
  }
}

class _SummarySection extends StatelessWidget {
  const _SummarySection({required this.data});

  final AnnualGrowth data;

  @override
  Widget build(BuildContext context) {
    final cards = [
      _SummaryCard(
        key: const Key('analytics-income-card'),
        title: 'Total Pemasukan',
        value: formatRupiah(data.totalPemasukan),
        growth: data.pemasukanGrowth,
        icon: Icons.south_west_rounded,
        color: _DashboardColors.income,
        surfaceColor: _DashboardColors.incomeSurface,
      ),
      _SummaryCard(
        key: const Key('analytics-expense-card'),
        title: 'Total Pengeluaran',
        value: formatRupiah(data.totalPengeluaran),
        growth: data.pengeluaranGrowth,
        icon: Icons.north_east_rounded,
        color: _DashboardColors.expense,
        surfaceColor: _DashboardColors.expenseSurface,
        expenseGrowth: true,
      ),
      _SummaryCard(
        key: const Key('analytics-profit-card'),
        title: 'Profit Bersih',
        value: formatRupiah(data.profitBersih),
        growth: data.profitGrowth,
        icon: Icons.account_balance_wallet_outlined,
        color: _DashboardColors.profit,
        surfaceColor: _DashboardColors.profitSurface,
      ),
    ];

    return LayoutBuilder(
      key: const Key('analytics-summary-section'),
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 980
            ? 3
            : constraints.maxWidth >= 620
            ? 2
            : 1;

        const gap = AppSpacing.md;

        final baseWidth =
            (constraints.maxWidth - (gap * (columns - 1))) / columns;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: List.generate(cards.length, (index) {
            final useFullWidth = columns == 2 && index == 2;

            return SizedBox(
              width: useFullWidth ? constraints.maxWidth : baseWidth,
              child: cards[index],
            );
          }),
        );
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.growth,
    required this.icon,
    required this.color,
    required this.surfaceColor,
    this.expenseGrowth = false,
  });

  final String title;
  final String value;
  final double growth;
  final IconData icon;
  final Color color;
  final Color surfaceColor;
  final bool expenseGrowth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final growthStatus = _GrowthStatus.fromValue(
      growth: growth,
      expenseGrowth: expenseGrowth,
    );

    return Container(
      constraints: const BoxConstraints(minHeight: 172),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.lg,
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: AppRadius.md,
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const Spacer(),
              _GrowthBadge(status: growthStatus),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              maxLines: 1,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'dibandingkan tahun sebelumnya',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _GrowthBadge extends StatelessWidget {
  const _GrowthBadge({required this.status});

  final _GrowthStatus status;

  @override
  Widget build(BuildContext context) {
    final percentage = status.value
        .abs()
        .toStringAsFixed(1)
        .replaceAll('.', ',');

    return Semantics(
      label: '${status.semanticLabel} $percentage persen',
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: status.surfaceColor,
          borderRadius: AppRadius.pill,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(status.icon, size: 14, color: status.color),
            const SizedBox(width: 3),
            Text(
              '$percentage%',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: status.color,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartsSection extends StatelessWidget {
  const _ChartsSection({required this.data});

  final AnnualGrowth data;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontal = constraints.maxWidth >= 1050;

        if (horizontal) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: _IncomeExpenseChart(data: data)),
              const SizedBox(width: AppSpacing.md),
              Expanded(flex: 2, child: _ProfitTrendChart(data: data)),
            ],
          );
        }

        return Column(
          children: [
            _IncomeExpenseChart(data: data),
            const SizedBox(height: AppSpacing.md),
            _ProfitTrendChart(data: data),
          ],
        );
      },
    );
  }
}

class _IncomeExpenseChart extends StatelessWidget {
  const _IncomeExpenseChart({required this.data});

  final AnnualGrowth data;

  @override
  Widget build(BuildContext context) {
    return _DashboardCard(
      key: const Key('analytics-bar-chart'),
      title: 'Pemasukan vs Pengeluaran',
      subtitle: 'Perbandingan arus kas setiap bulan.',
      icon: Icons.bar_chart_rounded,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 520;

          final maxY = _maximumCashFlow(data);

          return Semantics(
            label:
                'Grafik pemasukan dan pengeluaran bulanan tahun ${data.year}',
            child: SizedBox(
              height: compact ? 270 : 320,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxY,
                  minY: 0,
                  groupsSpace: compact ? 5 : 12,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final label = rodIndex == 0
                            ? 'Pemasukan'
                            : 'Pengeluaran';

                        return BarTooltipItem(
                          '$label\n'
                          '${formatRupiah(rod.toY.toInt())}',
                          const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();

                          if (index < 0 || index >= 12) {
                            return const SizedBox();
                          }

                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              compact
                                  ? _monthLetters[index]
                                  : _monthShortNames[index],
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: AppColors.textMuted,
                                    fontSize: compact ? 9 : 11,
                                  ),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: compact ? 42 : 58,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            _formatCompact(value),
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: AppColors.textMuted,
                                  fontSize: compact ? 9 : 10,
                                ),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) {
                      return const FlLine(
                        color: AppColors.border,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(12, (index) {
                    final month = _monthData(data, index + 1);

                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: month.pemasukan.toDouble(),
                          color: _DashboardColors.income,
                          width: compact ? 5 : 8,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(3),
                            topRight: Radius.circular(3),
                          ),
                        ),
                        BarChartRodData(
                          toY: month.pengeluaran.toDouble(),
                          color: _DashboardColors.expense,
                          width: compact ? 5 : 8,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(3),
                            topRight: Radius.circular(3),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          );
        },
      ),
      footer: const _ChartLegend(
        items: [
          _ChartLegendItem(label: 'Pemasukan', color: _DashboardColors.income),
          _ChartLegendItem(
            label: 'Pengeluaran',
            color: _DashboardColors.expense,
          ),
        ],
      ),
    );
  }
}

class _ProfitTrendChart extends StatelessWidget {
  const _ProfitTrendChart({required this.data});

  final AnnualGrowth data;

  @override
  Widget build(BuildContext context) {
    return _DashboardCard(
      key: const Key('analytics-line-chart'),
      title: 'Tren Profit Bulanan',
      subtitle: 'Perubahan profit bersih setiap bulan.',
      icon: Icons.show_chart_rounded,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 520;

          final bounds = _profitBounds(data);

          return Semantics(
            label: 'Grafik tren profit bulanan tahun ${data.year}',
            child: SizedBox(
              height: compact ? 270 : 320,
              child: LineChart(
                LineChartData(
                  minY: bounds.min,
                  maxY: bounds.max,
                  lineTouchData: LineTouchData(
                    enabled: true,
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (spots) {
                        return spots
                            .map(
                              (spot) => LineTooltipItem(
                                formatRupiah(spot.y.toInt()),
                                const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                            .toList();
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();

                          if (index < 0 || index >= 12) {
                            return const SizedBox();
                          }

                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              compact
                                  ? _monthLetters[index]
                                  : _monthShortNames[index],
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: AppColors.textMuted,
                                    fontSize: compact ? 9 : 11,
                                  ),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: compact ? 42 : 55,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            _formatCompact(value),
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: AppColors.textMuted,
                                  fontSize: compact ? 9 : 10,
                                ),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) {
                      if (value == 0) {
                        return const FlLine(
                          color: AppColors.textMuted,
                          strokeWidth: 1,
                          dashArray: [5, 5],
                        );
                      }

                      return const FlLine(
                        color: AppColors.border,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(12, (index) {
                        final month = _monthData(data, index + 1);

                        return FlSpot(
                          index.toDouble(),
                          month.profit.toDouble(),
                        );
                      }),
                      isCurved: true,
                      curveSmoothness: 0.25,
                      color: _DashboardColors.profit,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: compact ? 3 : 4,
                            color: AppColors.surface,
                            strokeWidth: 2,
                            strokeColor: _DashboardColors.profit,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            _DashboardColors.profit.withValues(alpha: 0.18),
                            _DashboardColors.profit.withValues(alpha: 0.01),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  const _DashboardCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.child,
    this.footer,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Widget child;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.lg,
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.primary50,
                  borderRadius: AppRadius.sm,
                ),
                child: Icon(icon, color: AppColors.primary700, size: 21),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textMuted,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (footer != null) ...[
            const SizedBox(height: AppSpacing.md),
            footer!,
          ],
          const SizedBox(height: AppSpacing.lg),
          child,
        ],
      ),
    );
  }
}

class _ChartLegend extends StatelessWidget {
  const _ChartLegend({required this.items});

  final List<_ChartLegendItem> items;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.xs,
      children: items
          .map(
            (item) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: item.color,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  item.label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          )
          .toList(),
    );
  }
}

class _ChartLegendItem {
  const _ChartLegendItem({required this.label, required this.color});

  final String label;
  final Color color;
}

class _MonthlyDetailSection extends StatelessWidget {
  const _MonthlyDetailSection({required this.data});

  final AnnualGrowth data;

  @override
  Widget build(BuildContext context) {
    return _DashboardCard(
      key: const Key('analytics-monthly-detail'),
      title: 'Detail Bulanan',
      subtitle: 'Rincian arus kas selama tahun ${data.year}.',
      icon: Icons.table_chart_outlined,
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 720) {
            return _MobileMonthlyList(data: data);
          }

          return _DesktopMonthlyTable(data: data);
        },
      ),
    );
  }
}

class _DesktopMonthlyTable extends StatelessWidget {
  const _DesktopMonthlyTable({required this.data});

  final AnnualGrowth data;

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1.6),
        1: FlexColumnWidth(1.7),
        2: FlexColumnWidth(1.7),
        3: FlexColumnWidth(1.7),
      },
      children: [
        TableRow(
          decoration: const BoxDecoration(
            color: AppColors.surfaceMuted,
            borderRadius: AppRadius.sm,
          ),
          children: const [
            _TableCell(text: 'Bulan', header: true),
            _TableCell(text: 'Pemasukan', header: true),
            _TableCell(text: 'Pengeluaran', header: true),
            _TableCell(text: 'Profit', header: true),
          ],
        ),
        ...List.generate(12, (index) {
          final month = _monthData(data, index + 1);

          return TableRow(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            children: [
              _TableCell(text: _monthFullNames[index]),
              _TableCell(
                text: formatRupiah(month.pemasukan),
                color: _DashboardColors.income,
              ),
              _TableCell(
                text: formatRupiah(month.pengeluaran),
                color: _DashboardColors.expense,
              ),
              _TableCell(
                text: formatRupiah(month.profit),
                color: month.profit >= 0
                    ? _DashboardColors.income
                    : _DashboardColors.expense,
                bold: true,
              ),
            ],
          );
        }),
      ],
    );
  }
}

class _TableCell extends StatelessWidget {
  const _TableCell({
    required this.text,
    this.header = false,
    this.bold = false,
    this.color,
  });

  final String text;
  final bool header;
  final bool bold;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color:
              color ??
              (header ? AppColors.textSecondary : AppColors.textPrimary),
          fontWeight: header || bold ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
    );
  }
}

class _MobileMonthlyList extends StatelessWidget {
  const _MobileMonthlyList({required this.data});

  final AnnualGrowth data;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(12, (index) {
        final month = _monthData(data, index + 1);

        return Container(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          decoration: BoxDecoration(
            border: index == 11
                ? null
                : const Border(bottom: BorderSide(color: AppColors.border)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _monthFullNames[index],
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: _MobileMetric(
                      label: 'Pemasukan',
                      value: formatRupiah(month.pemasukan),
                      color: _DashboardColors.income,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _MobileMetric(
                      label: 'Pengeluaran',
                      value: formatRupiah(month.pengeluaran),
                      color: _DashboardColors.expense,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _MobileMetric(
                      label: 'Profit',
                      value: formatRupiah(month.profit),
                      color: month.profit >= 0
                          ? _DashboardColors.income
                          : _DashboardColors.expense,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _MobileMetric extends StatelessWidget {
  const _MobileMetric({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.textMuted,
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 3),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            maxLines: 1,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('analytics-loading-state'),
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 300),
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.lg,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Memuat data analitik...',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('analytics-error-state'),
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.lg,
        border: Border.all(color: AppColors.error),
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.errorSurface,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.error_outline_rounded,
              color: AppColors.error,
              size: 28,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Data analitik belum dapat dimuat',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Periksa koneksi internet, lalu '
            'muat ulang data.',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.year});

  final int year;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('analytics-empty-state'),
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.lg,
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.sm,
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.primary50,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.insights_outlined,
              color: AppColors.primary700,
              size: 30,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Belum ada aktivitas keuangan',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Transaksi tahun $year belum '
            'tersedia. Data akan tampil setelah '
            'pemasukan atau pengeluaran dicatat.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _GrowthStatus {
  const _GrowthStatus({
    required this.value,
    required this.icon,
    required this.color,
    required this.surfaceColor,
    required this.semanticLabel,
  });

  final double value;
  final IconData icon;
  final Color color;
  final Color surfaceColor;
  final String semanticLabel;

  factory _GrowthStatus.fromValue({
    required double growth,
    required bool expenseGrowth,
  }) {
    if (growth == 0) {
      return const _GrowthStatus(
        value: 0,
        icon: Icons.remove_rounded,
        color: AppColors.textMuted,
        surfaceColor: AppColors.surfaceMuted,
        semanticLabel: 'Tidak berubah',
      );
    }

    final increasing = growth > 0;

    final favorable = expenseGrowth ? !increasing : increasing;

    return _GrowthStatus(
      value: growth,
      icon: increasing
          ? Icons.arrow_upward_rounded
          : Icons.arrow_downward_rounded,
      color: favorable ? _DashboardColors.income : _DashboardColors.expense,
      surfaceColor: favorable
          ? _DashboardColors.incomeSurface
          : _DashboardColors.expenseSurface,
      semanticLabel: increasing ? 'Naik' : 'Turun',
    );
  }
}

class _ProfitBounds {
  const _ProfitBounds({required this.min, required this.max});

  final double min;
  final double max;
}

class _DashboardColors {
  const _DashboardColors._();

  static const Color income = Color(0xFF2E7D32);

  static const Color incomeSurface = Color(0xFFE8F5E9);

  static const Color expense = Color(0xFFC62828);

  static const Color expenseSurface = Color(0xFFFFEBEE);

  static const Color profit = Color(0xFFF57C00);

  static const Color profitSurface = Color(0xFFFFF3E0);
}

MonthlyDataEntity _monthData(AnnualGrowth data, int month) {
  for (final item in data.monthlyData) {
    if (item.month == month) {
      return item;
    }
  }

  return MonthlyDataEntity(
    month: month,
    pemasukan: 0,
    pengeluaran: 0,
    profit: 0,
  );
}

double _maximumCashFlow(AnnualGrowth data) {
  double maximum = 0;

  for (var month = 1; month <= 12; month++) {
    final item = _monthData(data, month);

    if (item.pemasukan > maximum) {
      maximum = item.pemasukan.toDouble();
    }

    if (item.pengeluaran > maximum) {
      maximum = item.pengeluaran.toDouble();
    }
  }

  if (maximum <= 0) {
    return 100000;
  }

  return maximum * 1.20;
}

_ProfitBounds _profitBounds(AnnualGrowth data) {
  double minimum = 0;
  double maximum = 0;

  for (var month = 1; month <= 12; month++) {
    final profit = _monthData(data, month).profit.toDouble();

    if (profit < minimum) {
      minimum = profit;
    }

    if (profit > maximum) {
      maximum = profit;
    }
  }

  if (minimum == 0 && maximum == 0) {
    return const _ProfitBounds(min: -100000, max: 100000);
  }

  final adjustedMinimum = minimum < 0 ? minimum * 1.20 : 0.0;

  var adjustedMaximum = maximum > 0 ? maximum * 1.20 : 0.0;

  if (adjustedMaximum == adjustedMinimum) {
    adjustedMaximum = adjustedMinimum + 100000;
  }

  return _ProfitBounds(min: adjustedMinimum, max: adjustedMaximum);
}

String _formatCompact(double value) {
  final absolute = value.abs();

  if (absolute >= 1000000000) {
    return '${(value / 1000000000).toStringAsFixed(1)}M';
  }

  if (absolute >= 1000000) {
    return '${(value / 1000000).toStringAsFixed(1)}jt';
  }

  if (absolute >= 1000) {
    return '${(value / 1000).toStringAsFixed(0)}rb';
  }

  return value.toStringAsFixed(0);
}

const List<String> _monthLetters = [
  'J',
  'F',
  'M',
  'A',
  'M',
  'J',
  'J',
  'A',
  'S',
  'O',
  'N',
  'D',
];

const List<String> _monthShortNames = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'Mei',
  'Jun',
  'Jul',
  'Agu',
  'Sep',
  'Okt',
  'Nov',
  'Des',
];

const List<String> _monthFullNames = [
  'Januari',
  'Februari',
  'Maret',
  'April',
  'Mei',
  'Juni',
  'Juli',
  'Agustus',
  'September',
  'Oktober',
  'November',
  'Desember',
];

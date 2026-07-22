import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    setState(() {
      _selectedYear += delta;
    });

    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return VisibilityDetector(
      key: const Key('annual-growth-page-visibility'),
      onVisibilityChanged: _handleVisibilityChanged,
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text("Kitchen Analytics", style: theme.textTheme.displayMedium),
              const SizedBox(height: 4),
              Text(
                "Pantau pertumbuhan keuangan Dapur Ayam Nina",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 24),

              // Year Selector
              _buildYearSelector(theme),
              const SizedBox(height: 24),

              // Content
              BlocBuilder<TransactionBloc, TransactionState>(
                builder: (context, state) {
                  if (state is TransactionLoading) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(64),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (state is TransactionError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(64),
                        child: Column(
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 48,
                              color: Colors.red.shade300,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              state.message,
                              style: theme.textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _fetchData,
                              child: const Text("Coba Lagi"),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (state is AnnualGrowthLoaded) {
                    return _buildDashboard(context, theme, state.annualGrowth);
                  }

                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildYearSelector(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () => _changeYear(-1),
            icon: const Icon(Icons.chevron_left),
            tooltip: "Tahun Sebelumnya",
          ),
          const SizedBox(width: 8),
          Column(
            children: [
              Text(
                "Tahun",
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.grey.shade500,
                ),
              ),
              Text(
                "$_selectedYear",
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: _selectedYear < DateTime.now().year
                ? () => _changeYear(1)
                : null,
            icon: const Icon(Icons.chevron_right),
            tooltip: "Tahun Berikutnya",
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard(
    BuildContext context,
    ThemeData theme,
    AnnualGrowth data,
  ) {
    final isSmallScreen = MediaQuery.of(context).size.width < 800;

    final summaryCards = [
      _SummaryCard(
        title: "Total Pemasukan",
        value: _formatCurrency(data.totalPemasukan),
        growth: data.pemasukanGrowth,
        icon: Icons.trending_up,
        color: const Color(0xFF2E7D32),
        bgColor: const Color(0xFFE8F5E9),
      ),
      _SummaryCard(
        title: "Total Pengeluaran",
        value: _formatCurrency(data.totalPengeluaran),
        growth: data.pengeluaranGrowth,
        icon: Icons.trending_down,
        color: const Color(0xFFC62828),
        bgColor: const Color(0xFFFFEBEE),
        isExpense: true,
      ),
      _SummaryCard(
        title: "Profit Bersih",
        value: _formatCurrency(data.profitBersih),
        growth: data.profitGrowth,
        icon: Icons.account_balance_wallet,
        color: const Color(0xFFF57C00),
        bgColor: const Color(0xFFFFF3E0),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Summary Cards
        if (isSmallScreen)
          Column(
            children: [
              summaryCards[0],
              const SizedBox(height: 16),
              summaryCards[1],
              const SizedBox(height: 16),
              summaryCards[2],
            ],
          )
        else
          Row(
            children: [
              Expanded(child: summaryCards[0]),
              const SizedBox(width: 16),
              Expanded(child: summaryCards[1]),
              const SizedBox(width: 16),
              Expanded(child: summaryCards[2]),
            ],
          ),
        const SizedBox(height: 32),

        // Charts Row
        if (isSmallScreen)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildBarChart(theme, data),
              const SizedBox(height: 16),
              _buildLineChart(theme, data),
            ],
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: _buildBarChart(theme, data)),
              const SizedBox(width: 16),
              Expanded(flex: 2, child: _buildLineChart(theme, data)),
            ],
          ),

        const SizedBox(height: 32),

        // Monthly Table
        _buildMonthlyTable(theme, data),
      ],
    );
  }

  Widget _buildBarChart(ThemeData theme, AnnualGrowth data) {
    final monthNames = [
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

    // Find max value for Y axis
    double maxY = 0;
    for (final m in data.monthlyData) {
      if (m.pemasukan > maxY) maxY = m.pemasukan.toDouble();
      if (m.pengeluaran > maxY) maxY = m.pengeluaran.toDouble();
    }
    maxY = maxY == 0 ? 100000 : maxY * 1.2;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bar_chart, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                "Pemasukan vs Pengeluaran",
                style: theme.textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Legend
          Row(
            children: [
              _legendDot(const Color(0xFF2E7D32), "Pemasukan"),
              const SizedBox(width: 16),
              _legendDot(const Color(0xFFC62828), "Pengeluaran"),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 320,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxY,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final label = rodIndex == 0 ? "Pemasukan" : "Pengeluaran";
                      return BarTooltipItem(
                        "$label\n${_formatCurrency(rod.toY.toInt())}",
                        const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
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
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= 12) return const SizedBox();
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            monthNames[idx],
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        );
                      },
                      reservedSize: 30,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 60,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          _formatCompact(value),
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade500,
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
                  getDrawingHorizontalLine: (value) =>
                      FlLine(color: Colors.grey.shade200, strokeWidth: 1),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(12, (i) {
                  final monthly = data.monthlyData
                      .where((m) => m.month == i + 1)
                      .firstOrNull;
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: monthly?.pemasukan.toDouble() ?? 0,
                        color: const Color(0xFF2E7D32),
                        width: 10,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                      BarChartRodData(
                        toY: monthly?.pengeluaran.toDouble() ?? 0,
                        color: const Color(0xFFC62828),
                        width: 10,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLineChart(ThemeData theme, AnnualGrowth data) {
    double maxY = 0;
    double minY = 0;
    for (final m in data.monthlyData) {
      if (m.profit > maxY) maxY = m.profit.toDouble();
      if (m.profit < minY) minY = m.profit.toDouble();
    }
    if (maxY == 0 && minY == 0) {
      maxY = 100000;
      minY = -100000;
    } else {
      maxY = maxY * 1.3;
      minY = minY * 1.3;
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.show_chart, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text("Tren Profit Bulanan", style: theme.textTheme.titleLarge),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 320,
            child: LineChart(
              LineChartData(
                minY: minY,
                maxY: maxY,
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (spots) {
                      return spots.map((spot) {
                        return LineTooltipItem(
                          _formatCurrency(spot.y.toInt()),
                          const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final monthShort = [
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
                        final idx = value.toInt();
                        if (idx < 0 || idx >= 12) return const SizedBox();
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            monthShort[idx],
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        );
                      },
                      reservedSize: 30,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 55,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          _formatCompact(value),
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade500,
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
                      return FlLine(
                        color: Colors.grey.shade400,
                        strokeWidth: 1.5,
                        dashArray: [5, 5],
                      );
                    }
                    return FlLine(color: Colors.grey.shade200, strokeWidth: 1);
                  },
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(12, (i) {
                      final monthly = data.monthlyData
                          .where((m) => m.month == i + 1)
                          .firstOrNull;
                      return FlSpot(
                        i.toDouble(),
                        monthly?.profit.toDouble() ?? 0,
                      );
                    }),
                    isCurved: true,
                    curveSmoothness: 0.3,
                    color: const Color(0xFFF57C00),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: Colors.white,
                          strokeWidth: 2.5,
                          strokeColor: const Color(0xFFF57C00),
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFFF57C00).withValues(alpha: 0.2),
                          const Color(0xFFF57C00).withValues(alpha: 0.02),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyTable(ThemeData theme, AnnualGrowth data) {
    final monthNames = [
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

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.table_chart, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text("Detail Bulanan", style: theme.textTheme.titleLarge),
            ],
          ),
          const SizedBox(height: 16),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(2),
              3: FlexColumnWidth(2),
            },
            children: [
              // Header
              TableRow(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                children: [
                  _tableCell("Bulan", isHeader: true),
                  _tableCell("Pemasukan", isHeader: true),
                  _tableCell("Pengeluaran", isHeader: true),
                  _tableCell("Profit", isHeader: true),
                ],
              ),
              // Data rows
              ...List.generate(12, (i) {
                final monthly = data.monthlyData
                    .where((m) => m.month == i + 1)
                    .firstOrNull;
                final profit = monthly?.profit ?? 0;
                return TableRow(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  children: [
                    _tableCell(monthNames[i]),
                    _tableCell(
                      _formatCurrency(monthly?.pemasukan ?? 0),
                      color: const Color(0xFF2E7D32),
                    ),
                    _tableCell(
                      _formatCurrency(monthly?.pengeluaran ?? 0),
                      color: const Color(0xFFC62828),
                    ),
                    _tableCell(
                      _formatCurrency(profit),
                      color: profit >= 0
                          ? const Color(0xFF2E7D32)
                          : const Color(0xFFC62828),
                      isBold: true,
                    ),
                  ],
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tableCell(
    String text, {
    bool isHeader = false,
    Color? color,
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: isHeader || isBold ? FontWeight.w600 : FontWeight.w400,
          color: color ?? (isHeader ? Colors.grey.shade700 : Colors.black87),
        ),
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  String _formatCurrency(int value) {
    final isNegative = value < 0;
    final absValue = value.abs();
    final str = absValue.toString();
    final result = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      result.write(str[i]);
      count++;
      if (count % 3 == 0 && i != 0) {
        result.write('.');
      }
    }
    final formatted = result.toString().split('').reversed.join();
    return "${isNegative ? '-' : ''}Rp $formatted";
  }

  String _formatCompact(double value) {
    final absVal = value.abs();
    if (absVal >= 1000000) {
      return "${(value / 1000000).toStringAsFixed(1)}M";
    } else if (absVal >= 1000) {
      return "${(value / 1000).toStringAsFixed(0)}K";
    }
    return value.toStringAsFixed(0);
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final double growth;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final bool isExpense;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.growth,
    required this.icon,
    required this.color,
    required this.bgColor,
    this.isExpense = false,
  });

  @override
  Widget build(BuildContext context) {
    // For expenses, growth UP is bad, growth DOWN is good
    final isPositiveGrowth = growth > 0;
    final growthColor = isExpense
        ? (isPositiveGrowth ? const Color(0xFFC62828) : const Color(0xFF2E7D32))
        : (isPositiveGrowth
              ? const Color(0xFF2E7D32)
              : const Color(0xFFC62828));
    final growthIcon = isPositiveGrowth
        ? Icons.arrow_upward
        : Icons.arrow_downward;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: growthColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(growthIcon, size: 14, color: growthColor),
                    const SizedBox(width: 2),
                    Text(
                      "${growth.abs().toStringAsFixed(1)}%",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: growthColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "vs tahun lalu",
            style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }
}

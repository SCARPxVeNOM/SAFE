import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../app/theme.dart';
import '../../core/models/document.dart';
import '../document_detail/document_detail_screen.dart';
import '../scan/scan_screen.dart';
import 'locker_controller.dart';

class LockerScreen extends ConsumerWidget {
  const LockerScreen({super.key});

  static const routePath = '/locker';
  static const routeName = 'locker';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lockerState = ref.watch(lockerControllerProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // Ambient Background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: isDark 
                    ? [SafeBillTheme.indigo500.withOpacity(0.1), SafeBillTheme.slate950, SafeBillTheme.slate950]
                    : [SafeBillTheme.slate50, SafeBillTheme.slate50, SafeBillTheme.slate50],
                ),
              ),
            ),
          ),
          // Blur Orb
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                color: isDark ? SafeBillTheme.indigo500.withOpacity(0.1) : Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(200),
                backgroundBlendMode: BlendMode.screen,
              ),
            ),
          ),

          // Main Content
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => ref.read(lockerControllerProvider.notifier).refresh(),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 100),
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(context, isDark),
                          _buildQuickStats(context, isDark, lockerState),
                          _buildCategories(context, isDark),
                          _buildExpiringSoon(context, isDark, lockerState),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark 
                      ? [SafeBillTheme.indigo600, SafeBillTheme.slate800]
                      : [SafeBillTheme.slate800, Colors.black],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
                  ],
                ),
                alignment: Alignment.center,
                child: const Text(
                  'SB',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isDark ? SafeBillTheme.slate400 : SafeBillTheme.slate500,
                    ),
                  ),
                  Text(
                    'SafeBill User',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : SafeBillTheme.slate900,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Quick Scan Button
          GestureDetector(
            onTap: () => context.push(ScanScreen.routePath),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark ? SafeBillTheme.slate800 : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isDark ? SafeBillTheme.slate700 : SafeBillTheme.slate200),
              ),
              child: Icon(LucideIcons.scanLine, size: 20, color: isDark ? SafeBillTheme.slate300 : SafeBillTheme.slate600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context, bool isDark, AsyncValue<List<Document>> lockerState) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: lockerState.when(
        data: (documents) {
          final activeCount = documents.where((d) => !d.primaryItem.isExpired).length;
          final totalValue = documents.fold<double>(
            0, (sum, doc) => sum + (doc.primaryItem.purchasePrice ?? 0),
          );
          
          return Row(
            children: [
              Expanded(
                child: _StatCard(
                  isDark: isDark,
                  icon: LucideIcons.shieldCheck,
                  iconColor: SafeBillTheme.emerald500,
                  label: 'Active',
                  value: '$activeCount',
                  subValue: 'Warranties',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  isDark: isDark,
                  icon: LucideIcons.wallet,
                  iconColor: SafeBillTheme.indigo500,
                  label: null,
                  value: '₹${(totalValue / 1000).toStringAsFixed(1)}k',
                  subValue: 'Asset Value',
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildCategories(BuildContext context, bool isDark) {
    final categories = [
      {'icon': LucideIcons.smartphone, 'label': 'Gadgets'},
      {'icon': LucideIcons.tv, 'label': 'Appliances'},
      {'icon': LucideIcons.car, 'label': 'Vehicle'},
      {'icon': LucideIcons.watch, 'label': 'Others'},
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Digital Locker',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : SafeBillTheme.slate900,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final cat = categories[index];
              return Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: isDark ? SafeBillTheme.slate800 : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: isDark ? SafeBillTheme.slate700 : SafeBillTheme.slate200),
                      boxShadow: [
                        if (!isDark)
                          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5),
                      ],
                    ),
                    child: Icon(cat['icon'] as IconData, size: 24, color: isDark ? SafeBillTheme.slate300 : SafeBillTheme.slate600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    cat['label'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isDark ? SafeBillTheme.slate400 : SafeBillTheme.slate600,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildExpiringSoon(BuildContext context, bool isDark, AsyncValue<List<Document>> lockerState) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Expiring Soon',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : SafeBillTheme.slate900,
            ),
          ),
          const SizedBox(height: 12),
          lockerState.when(
            data: (documents) {
              if (documents.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      "No documents found.\nScan your first invoice!",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: SafeBillTheme.slate400),
                    ),
                  ),
                );
              }
              
              final sortedDocs = List<Document>.from(documents)
                ..sort((a, b) {
                  final endA = a.primaryItem.warrantyEnd ?? DateTime.now().add(const Duration(days: 999));
                  final endB = b.primaryItem.warrantyEnd ?? DateTime.now().add(const Duration(days: 999));
                  return endA.compareTo(endB);
                });

              return Column(
                children: sortedDocs.take(5).map((doc) => _ExpiringItem(
                  isDark: isDark, 
                  document: doc,
                  onTap: () => context.push(DocumentDetailScreen.routePath.replaceFirst(':id', doc.docId)),
                )).toList(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text("Error: $e"),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final bool isDark;
  final IconData icon;
  final Color iconColor;
  final String? label;
  final String value;
  final String subValue;

  const _StatCard({
    required this.isDark,
    required this.icon,
    required this.iconColor,
    this.label,
    required this.value,
    required this.subValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? SafeBillTheme.slate800 : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? SafeBillTheme.slate700 : SafeBillTheme.slate200),
        boxShadow: [
          if (!isDark) BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, size: 20, color: iconColor),
              if (label != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    label!,
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: iconColor),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : SafeBillTheme.slate900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subValue,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isDark ? SafeBillTheme.slate400 : SafeBillTheme.slate500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpiringItem extends StatelessWidget {
  final bool isDark;
  final Document document;
  final VoidCallback onTap;

  const _ExpiringItem({
    required this.isDark,
    required this.document,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final item = document.primaryItem;
    final now = DateTime.now();
    final end = item.warrantyEnd;
    
    int daysLeft = 0;
    double progress = 0.0;
    
    if (end != null) {
      daysLeft = end.difference(now).inDays;
      if (item.warrantyStart != null) {
        final totalDuration = end.difference(item.warrantyStart!).inDays;
        if (totalDuration > 0) {
          final elapsed = now.difference(item.warrantyStart!).inDays;
          progress = (elapsed / totalDuration).clamp(0.0, 1.0);
        }
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? SafeBillTheme.slate800 : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isDark ? SafeBillTheme.slate700 : SafeBillTheme.slate200),
          boxShadow: [
            if (!isDark) BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isDark ? SafeBillTheme.slate700 : SafeBillTheme.slate100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(LucideIcons.fileText, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.productName ?? document.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : SafeBillTheme.slate900,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (end != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: daysLeft < 0 
                                ? SafeBillTheme.slate700.withOpacity(0.1) 
                                : SafeBillTheme.rose500.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            daysLeft < 0 ? 'Expired' : '$daysLeft Days left',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: daysLeft < 0 ? SafeBillTheme.slate500 : SafeBillTheme.rose500,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: isDark ? SafeBillTheme.slate700 : SafeBillTheme.slate100,
                      valueColor: AlwaysStoppedAnimation(
                        daysLeft < 0 ? SafeBillTheme.slate500 : SafeBillTheme.rose500,
                      ),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/models/document.dart';
import '../chat/chat_screen.dart';
import 'document_detail_controller.dart';
import '../../app/theme.dart';

class DocumentDetailScreen extends ConsumerWidget {
  const DocumentDetailScreen({required this.docId, super.key});

  final String docId;

  static const routePath = '/document/:id';
  static const routeName = 'document-detail';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final documentState = ref.watch(documentProvider(docId));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? SafeBillTheme.slate950 : SafeBillTheme.slate50,
      body: documentState.when(
        data: (document) {
          if (document == null) {
            return const Center(child: Text('Document not found'));
          }
          return _DocumentDetailContent(document: document, isDark: isDark);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }
}

class _DocumentDetailContent extends ConsumerWidget {
  final Document document;
  final bool isDark;

  const _DocumentDetailContent({required this.document, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = document.primaryItem;
    final dateFormat = DateFormat('d MMM y'); // 12 Oct 2023

    return Column(
      children: [
        // Custom AppBar
        Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 10, bottom: 16, left: 24, right: 24),
          decoration: BoxDecoration(
            color: isDark ? SafeBillTheme.slate900 : Colors.white,
            border: Border(bottom: BorderSide(color: isDark ? SafeBillTheme.slate800 : SafeBillTheme.slate100)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _IconButton(
                icon: LucideIcons.arrowLeft, 
                onTap: () => context.pop(),
                isDark: isDark,
              ),
              Text(
                'Warranty Details',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : SafeBillTheme.slate900,
                ),
              ),
              _IconButton(
                icon: LucideIcons.share2, 
                onTap: () {}, // Implement share
                isDark: isDark,
              ),
            ],
          ),
        ),

        // Body
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Product Card
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isDark ? SafeBillTheme.slate900 : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: isDark ? SafeBillTheme.slate800 : SafeBillTheme.slate200),
                    boxShadow: [
                      if (!isDark) BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image Section
                      Stack(
                        children: [
                          Container(
                            height: 192, // 48 * 4
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: isDark ? SafeBillTheme.slate800 : SafeBillTheme.slate100,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            // Placeholder image or actual if available
                            child: Icon(LucideIcons.image, size: 64, color: isDark ? SafeBillTheme.slate700 : SafeBillTheme.slate300),
                          ),
                          Positioned(
                            top: 12,
                            left: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: SafeBillTheme.emerald500.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4),
                                ],
                              ),
                              child: const Row(
                                children: [
                                  Icon(LucideIcons.shieldCheck, size: 12, color: Colors.white),
                                  SizedBox(width: 4),
                                  Text(
                                    'WARRANTY ACTIVE',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.productName ?? document.title,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : SafeBillTheme.slate900,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Purchased from ${document.sellerName ?? 'Unknown Seller'}',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? SafeBillTheme.slate400 : SafeBillTheme.slate500,
                              ),
                            ),
                            const SizedBox(height: 24),
                            
                            // Dates Grid
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'PURCHASE DATE',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: SafeBillTheme.slate400,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item.purchaseDate != null ? dateFormat.format(item.purchaseDate!) : 'N/A',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: isDark ? SafeBillTheme.slate200 : SafeBillTheme.slate900,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'EXPIRY DATE',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: SafeBillTheme.slate400,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item.warrantyEnd != null ? dateFormat.format(item.warrantyEnd!) : 'N/A',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: SafeBillTheme.rose500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Timeline
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Start',
                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: SafeBillTheme.slate400),
                                ),
                                const Text(
                                  '12 Days Left', // Dynamic logic needed
                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: SafeBillTheme.rose500),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 8,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: isDark ? SafeBillTheme.slate700 : SafeBillTheme.slate100,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: 0.92,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    gradient: const LinearGradient(
                                      colors: [SafeBillTheme.emerald500, SafeBillTheme.rose500],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // AI Chat Section
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? SafeBillTheme.indigo500.withOpacity(0.1) : SafeBillTheme.indigo500.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: isDark ? SafeBillTheme.indigo500.withOpacity(0.2) : SafeBillTheme.indigo500.withOpacity(0.1)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: SafeBillTheme.indigo600,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(LucideIcons.sparkles, size: 14, color: Colors.white),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Ask AI Assistant',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isDark ? SafeBillTheme.indigo500 : SafeBillTheme.indigo600.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark ? SafeBillTheme.slate900.withOpacity(0.8) : Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: isDark ? SafeBillTheme.indigo500.withOpacity(0.2) : SafeBillTheme.indigo500.withOpacity(0.1)),
                        ),
                        child: Text.rich(
                          TextSpan(
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? SafeBillTheme.slate300 : SafeBillTheme.slate700,
                              height: 1.5,
                            ),
                            children: [
                              const TextSpan(text: '"Based on your scanned bill, this warranty '),
                              TextSpan(
                                text: 'covers',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? SafeBillTheme.emerald500 : SafeBillTheme.emerald500,
                                ),
                              ),
                              const TextSpan(text: ' hardware defects but '),
                              TextSpan(
                                text: 'excludes',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? SafeBillTheme.rose500 : SafeBillTheme.rose500,
                                ),
                              ),
                              const TextSpan(text: ' liquid damage."'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _AiQueryButton(text: 'How do I claim a repair?', isDark: isDark, onTap: () => context.push(ChatScreen.routePath)),
                      const SizedBox(height: 8),
                      _AiQueryButton(text: 'Does it cover screen cracks?', isDark: isDark, onTap: () => context.push(ChatScreen.routePath)),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Consumer Rights
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 4, bottom: 12),
                      child: Text(
                        'Your Rights',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : SafeBillTheme.slate900,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: isDark ? SafeBillTheme.slate900 : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: isDark ? SafeBillTheme.slate800 : SafeBillTheme.slate200),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(LucideIcons.scale, size: 20, color: SafeBillTheme.slate400),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Consumer Protection Act, 2019',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: isDark ? SafeBillTheme.slate100 : SafeBillTheme.slate900,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'If service is denied without valid reason, you can file a complaint with the National Consumer Helpline (1915).',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: isDark ? SafeBillTheme.slate400 : SafeBillTheme.slate500,
                                          height: 1.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: isDark ? SafeBillTheme.slate800.withOpacity(0.5) : SafeBillTheme.slate50,
                              border: Border(top: BorderSide(color: isDark ? SafeBillTheme.slate800 : SafeBillTheme.slate100)),
                              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(LucideIcons.fileWarning, size: 14, color: isDark ? SafeBillTheme.slate300 : SafeBillTheme.slate600),
                                const SizedBox(width: 8),
                                Text(
                                  'Draft Legal Notice',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: isDark ? SafeBillTheme.slate300 : SafeBillTheme.slate600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Actions Grid
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(color: isDark ? SafeBillTheme.slate700 : SafeBillTheme.slate200),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          backgroundColor: isDark ? SafeBillTheme.slate800 : Colors.white,
                          foregroundColor: isDark ? SafeBillTheme.slate200 : SafeBillTheme.slate700,
                        ),
                        icon: const Icon(LucideIcons.fileText, size: 16),
                        label: const Text('View Bill', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: isDark ? SafeBillTheme.indigo600 : SafeBillTheme.slate900,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 5,
                          shadowColor: isDark ? SafeBillTheme.indigo500.withOpacity(0.3) : SafeBillTheme.slate200,
                        ),
                        icon: const Icon(LucideIcons.phoneCall, size: 16),
                        label: const Text('Call Support', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isDark;

  const _IconButton({required this.icon, required this.onTap, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(icon, size: 20, color: isDark ? SafeBillTheme.slate300 : SafeBillTheme.slate600),
      ),
    );
  }
}

class _AiQueryButton extends StatelessWidget {
  final String text;
  final bool isDark;
  final VoidCallback onTap;

  const _AiQueryButton({required this.text, required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? SafeBillTheme.slate900 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDark ? SafeBillTheme.indigo500.withOpacity(0.2) : SafeBillTheme.indigo500.withOpacity(0.1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isDark ? SafeBillTheme.indigo500.withOpacity(0.9) : SafeBillTheme.indigo600,
              ),
            ),
            Icon(LucideIcons.chevronRight, size: 14, color: isDark ? SafeBillTheme.indigo500.withOpacity(0.5) : SafeBillTheme.indigo200),
          ],
        ),
      ),
    );
  }
}

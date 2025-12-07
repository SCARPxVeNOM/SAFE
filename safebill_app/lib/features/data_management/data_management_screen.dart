import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../app/theme.dart';
import '../../app/widgets/bouncing_button.dart';

class DataManagementScreen extends ConsumerStatefulWidget {
  const DataManagementScreen({super.key});

  static const routePath = '/data-management';
  static const routeName = 'data-management';

  @override
  ConsumerState<DataManagementScreen> createState() => _DataManagementScreenState();
}

class _DataManagementScreenState extends ConsumerState<DataManagementScreen> {
  bool _isExporting = false;
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Management'),
        backgroundColor: isDark ? SafeBillTheme.slate900 : Colors.white,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: isDark
                      ? [
                          SafeBillTheme.indigo500.withOpacity(0.1),
                          SafeBillTheme.slate950,
                        ]
                      : [
                          SafeBillTheme.slate50,
                          SafeBillTheme.slate50,
                        ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildExportSection(context, isDark),
                  const SizedBox(height: 24),
                  _buildDeleteSection(context, isDark),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExportSection(BuildContext context, bool isDark) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  LucideIcons.download,
                  color: SafeBillTheme.indigo500,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Export Your Data',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Download all your documents, reminders, and data in JSON or CSV format.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDark ? SafeBillTheme.slate400 : SafeBillTheme.slate600,
                  ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: BouncingButton(
                    onTap: _isExporting
                        ? null
                        : () => _exportData(context, format: 'json'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: SafeBillTheme.indigo500,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: _isExporting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Text(
                                'Export as JSON',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: BouncingButton(
                    onTap: _isExporting
                        ? null
                        : () => _exportData(context, format: 'csv'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: isDark ? SafeBillTheme.slate800 : SafeBillTheme.slate200,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark ? SafeBillTheme.slate700 : SafeBillTheme.slate300,
                        ),
                      ),
                      child: Center(
                        child: _isExporting
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    isDark ? Colors.white : SafeBillTheme.slate700,
                                  ),
                                ),
                              )
                            : Text(
                                'Export as CSV',
                                style: TextStyle(
                                  color: isDark ? Colors.white : SafeBillTheme.slate700,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeleteSection(BuildContext context, bool isDark) {
    return Card(
      color: isDark ? SafeBillTheme.slate900 : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  LucideIcons.trash2,
                  color: SafeBillTheme.rose500,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Delete Your Data',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: SafeBillTheme.rose500,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Permanently delete all your data from SafeBill. This action cannot be undone.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDark ? SafeBillTheme.slate400 : SafeBillTheme.slate600,
                  ),
            ),
            const SizedBox(height: 24),
            BouncingButton(
              onTap: _isDeleting ? null : () => _showDeleteConfirmation(context),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: SafeBillTheme.rose500,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: _isDeleting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Delete All Data',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportData(BuildContext context, {required String format}) async {
    setState(() => _isExporting = true);
    
    // TODO: Implement actual export API call
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data exported as $format'),
          backgroundColor: SafeBillTheme.emerald500,
        ),
      );
    }
    
    setState(() => _isExporting = false);
  }

  Future<void> _showDeleteConfirmation(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text(
          'Are you sure you want to delete all your data? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: SafeBillTheme.rose500),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _isDeleting = true);
      // TODO: Implement actual delete API call
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All data has been deleted'),
            backgroundColor: SafeBillTheme.rose500,
          ),
        );
      }
      
      setState(() => _isDeleting = false);
    }
  }
}


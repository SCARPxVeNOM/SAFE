import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../app/theme.dart';
import '../../app/widgets/bouncing_button.dart';

class ServiceBookingScreen extends ConsumerStatefulWidget {
  const ServiceBookingScreen({
    super.key,
    required this.docId,
    this.serviceCenterId,
  });

  final String docId;
  final String? serviceCenterId;

  static const routePath = '/service-booking/:docId';
  static const routeName = 'service-booking';

  @override
  ConsumerState<ServiceBookingScreen> createState() => _ServiceBookingScreenState();
}

class _ServiceBookingScreenState extends ConsumerState<ServiceBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  String? _selectedTime;
  final _phoneController = TextEditingController();
  bool _isBooking = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Service'),
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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  LucideIcons.calendar,
                                  color: SafeBillTheme.indigo500,
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Select Date & Time',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            _buildDatePicker(context, isDark),
                            const SizedBox(height: 16),
                            _buildTimeSelector(context, isDark),
                            const SizedBox(height: 24),
                            TextFormField(
                              controller: _phoneController,
                              decoration: InputDecoration(
                                labelText: 'Contact Phone (Optional)',
                                prefixIcon: const Icon(LucideIcons.phone),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              keyboardType: TextInputType.phone,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    BouncingButton(
                      onTap: _isBooking ? null : _bookService,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: SafeBillTheme.indigo500,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: _isBooking
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Text(
                                  'Book Service',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context, bool isDark) {
    return BouncingButton(
      onTap: () => _selectDate(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? SafeBillTheme.slate800 : SafeBillTheme.slate100,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? SafeBillTheme.slate700 : SafeBillTheme.slate300,
          ),
        ),
        child: Row(
          children: [
            Icon(
              LucideIcons.calendar,
              color: SafeBillTheme.indigo500,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _selectedDate != null
                    ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                    : 'Select Preferred Date',
                style: TextStyle(
                  color: isDark ? Colors.white : SafeBillTheme.slate700,
                ),
              ),
            ),
            Icon(
              LucideIcons.chevronRight,
              color: isDark ? SafeBillTheme.slate400 : SafeBillTheme.slate500,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSelector(BuildContext context, bool isDark) {
    final timeSlots = ['09:00 AM', '10:00 AM', '11:00 AM', '02:00 PM', '03:00 PM', '04:00 PM'];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: timeSlots.map((time) {
        final isSelected = _selectedTime == time;
        return BouncingButton(
          onTap: () => setState(() => _selectedTime = time),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? SafeBillTheme.indigo500
                  : (isDark ? SafeBillTheme.slate800 : SafeBillTheme.slate100),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? SafeBillTheme.indigo500
                    : (isDark ? SafeBillTheme.slate700 : SafeBillTheme.slate300),
              ),
            ),
            child: Text(
              time,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.white : SafeBillTheme.slate700),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );

    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  Future<void> _bookService() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date')),
      );
      return;
    }

    setState(() => _isBooking = true);

    // TODO: Implement actual booking API call
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Service booking request submitted!'),
          backgroundColor: SafeBillTheme.emerald500,
        ),
      );
      Navigator.pop(context);
    }

    setState(() => _isBooking = false);
  }
}


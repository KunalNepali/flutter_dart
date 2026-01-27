import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import '../services/storage_service.dart';
import '../widgets/primary_button.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isResetting = false;
  bool _isExporting = false;
  String _exportData = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // App Info
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'App Information',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow('Version', '1.0.0'),
                  _buildInfoRow('Total Questions', '250'),
                  _buildInfoRow('Categories', '5'),
                  _buildInfoRow('Last Updated', '2024'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Data Management
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Data Management',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Manage your quiz data and progress',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Export Data Button
                  PrimaryButton(
                    text: 'Export Data',
                    onPressed: _exportAppData,
                    icon: Icons.download,
                    isLoading: _isExporting,
                  ),
                  const SizedBox(height: 12),

                  // Reset All Data Button
                  OutlinedButton(
                    onPressed: _showResetConfirmation,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      foregroundColor: Colors.red,
                      side: BorderSide(color: Colors.red.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isResetting
                        ? SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.red,
                              strokeWidth: 2,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.delete, color: Colors.red),
                              const SizedBox(width: 8),
                              Text(
                                'Reset All Data',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Export Data Display
          if (_exportData.isNotEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Exported Data',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy),
                          onPressed: _copyExportData,
                          tooltip: 'Copy to clipboard',
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SelectableText(
                        _exportData,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Copy this data to backup or import later',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 24),

          // Instructions
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'How to Use',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInstruction(
                    Icons.star,
                    'Complete all categories to track your progress',
                  ),
                  _buildInstruction(
                    Icons.replay,
                    'You can retake quizzes to improve your score',
                  ),
                  _buildInstruction(
                    Icons.save,
                    'Export your data regularly for backup',
                  ),
                  _buildInstruction(
                    Icons.warning,
                    'Resetting data cannot be undone',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstruction(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _exportAppData() async {
    setState(() => _isExporting = true);
    
    try {
      final data = await StorageService.exportData();
      final jsonString = jsonEncode(data);
      
      setState(() {
        _exportData = jsonString;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Data exported successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error exporting data: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isExporting = false);
    }
  }

  Future<void> _copyExportData() async {
    if (_exportData.isNotEmpty) {
      await Clipboard.setData(ClipboardData(text: _exportData));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Copied to clipboard'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _showResetConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset All Data'),
        content: const Text(
          'This will delete all your quiz progress, scores, and results. '
          'This action cannot be undone. Are you sure?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _resetAllData();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Reset All Data'),
          ),
        ],
      ),
    );
  }

  Future<void> _resetAllData() async {
    setState(() => _isResetting = true);
    
    try {
      await StorageService.resetAllData();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All data has been reset successfully'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      
      // Clear export data display
      setState(() {
        _exportData = '';
      });
      
      // Navigate back to home after a delay
      await Future.delayed(const Duration(seconds: 1));
      Navigator.pop(context);
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error resetting data: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isResetting = false);
    }
  }
}
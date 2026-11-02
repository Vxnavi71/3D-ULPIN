import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class RegistrationScreen extends StatefulWidget {
  final VoidCallback onRegistered;
  final VoidCallback onCancel;

  const RegistrationScreen({
    super.key,
    required this.onRegistered,
    required this.onCancel,
  });

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _nameCtrl = TextEditingController(text: 'test1');
  final _emailCtrl = TextEditingController(text: 'test@gmail.com');
  final _pwdCtrl = TextEditingController(text: 'lunara2026');
  final _confirmPwdCtrl = TextEditingController(text: 'lunara2026');
  String _role = 'Surveyor / Cadastral Officer';

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _pwdCtrl.dispose();
    _confirmPwdCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Account registered in Demo Session. Welcome to LUNARA!'),
        backgroundColor: AppTheme.green,
      ),
    );
    widget.onRegistered();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 480,
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(36),
            decoration: BoxDecoration(
              color: AppTheme.panel,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.line),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Cadastral Registration',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.text,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20, color: AppTheme.textMuted),
                      onPressed: widget.onCancel,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'SIH PS-26011 Prototype Access Portal',
                  style: TextStyle(color: AppTheme.cyan, fontSize: 12, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 16),

                // Amber Notice
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.amber.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.amber.withOpacity(0.3)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline, size: 16, color: AppTheme.amber),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'PROTOTYPE REGISTRATION: Frontend demo account authentication.',
                          style: TextStyle(color: AppTheme.amber, fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Fields
                _field('Full Name', _nameCtrl, Icons.person_outline),
                const SizedBox(height: 14),
                _field('Official Email Address', _emailCtrl, Icons.email_outlined),
                const SizedBox(height: 14),

                // Role Dropdown
                const Text('User Role', style: TextStyle(color: AppTheme.textSecondary, fontSize: 11, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: AppTheme.panelElevated,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.line),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _role,
                      isExpanded: true,
                      dropdownColor: AppTheme.panelElevated,
                      items: [
                        'Surveyor / Cadastral Officer',
                        'SIH Judge / Evaluator',
                        'Urban Planner / Architect',
                        'Citizen / Property Owner',
                      ].map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 13)))).toList(),
                      onChanged: (v) => setState(() => _role = v ?? _role),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                _field('Password', _pwdCtrl, Icons.lock_outline, obscure: true),
                const SizedBox(height: 14),
                _field('Confirm Password', _confirmPwdCtrl, Icons.lock_clock_outlined, obscure: true),
                const SizedBox(height: 24),

                // Action Buttons
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _submit,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppTheme.cyan,
                      foregroundColor: const Color(0xFF042F2E),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    icon: const Icon(Icons.check_circle_outline, size: 18),
                    label: const Text(
                      'CREATE ACCOUNT & ENTER',
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: TextButton(
                    onPressed: widget.onCancel,
                    child: const Text(
                      'Continue as Guest / Skip to Demo',
                      style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl, IconData icon, {bool obscure = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11, fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          obscureText: obscure,
          style: const TextStyle(fontSize: 13, color: AppTheme.text),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 17, color: AppTheme.textSecondary),
            filled: true,
            fillColor: AppTheme.panelElevated,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.line),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.line),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.cyan),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:unilane/features/main/models/campus_mart_models.dart';
import 'package:unilane/features/main/presentation/providers/campus_mart_provider.dart';

class PostRoommateRequestScreen extends StatefulWidget {
  const PostRoommateRequestScreen({super.key});

  @override
  State<PostRoommateRequestScreen> createState() =>
      _PostRoommateRequestScreenState();
}

class _PostRoommateRequestScreenState extends State<PostRoommateRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _areaController = TextEditingController(text: 'Rumuolumeni');
  final _budgetController = TextEditingController();
  final _aboutController = TextEditingController();
  final _interestsController = TextEditingController();
  bool _didPrefillFromProfile = false;

  late String _selectedLevel;
  late String _selectedMoveIn;
  late String _selectedGenderPreference;
  bool _isVerifiedStudent = true;

  static const List<String> _levels = <String>[
    '100-level',
    '200-level',
    '300-level',
    '400-level',
    'Final year',
    'Postgraduate',
  ];

  static const List<String> _moveInOptions = <String>[
    'Immediate',
    'This month',
    'August',
    'September',
    'Next semester',
  ];

  static const List<String> _genderOptions = <String>[
    'Any student roommate',
    'Female roommate',
    'Male roommate',
  ];

  @override
  void initState() {
    super.initState();
    _selectedLevel = _levels[2];
    _selectedMoveIn = _moveInOptions[0];
    _selectedGenderPreference = _genderOptions[0];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_didPrefillFromProfile) {
      return;
    }

    final profile = context.read<CampusMartProvider>().currentUserProfile;
    if (profile != null) {
      if (_nameController.text.trim().isEmpty) {
        _nameController.text = profile.displayName;
      }

      _isVerifiedStudent = profile.isVerifiedStudent;
    }

    _didPrefillFromProfile = true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _areaController.dispose();
    _budgetController.dispose();
    _aboutController.dispose();
    _interestsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text('Post Roommate Request'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7C3AED), Color(0xFF2563EB)],
                  ),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Find a roommate on UniLane',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Share your budget, area, and move-in date so students can reach you faster.',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildField(
                fieldKey: const Key('roommateNameField'),
                controller: _nameController,
                label: 'Your name',
                hint: 'e.g. Blessing Okafor',
                validator: _requiredValidator,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _selectedLevel,
                decoration: _inputDecoration('Level'),
                items: _levels
                    .map(
                      (level) =>
                          DropdownMenuItem(value: level, child: Text(level)),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;

                  setState(() {
                    _selectedLevel = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              _buildField(
                fieldKey: const Key('roommateAreaField'),
                controller: _areaController,
                label: 'Area near campus',
                hint: 'e.g. Rumuolumeni or off campus',
                validator: _requiredValidator,
              ),
              const SizedBox(height: 12),
              _buildField(
                fieldKey: const Key('roommateBudgetField'),
                controller: _budgetController,
                label: 'Budget',
                hint: 'e.g. Up to N180k/year',
                validator: _requiredValidator,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _selectedMoveIn,
                decoration: _inputDecoration('Move-in time'),
                items: _moveInOptions
                    .map(
                      (option) =>
                          DropdownMenuItem(value: option, child: Text(option)),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;

                  setState(() {
                    _selectedMoveIn = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _selectedGenderPreference,
                decoration: _inputDecoration('Roommate preference'),
                items: _genderOptions
                    .map(
                      (option) =>
                          DropdownMenuItem(value: option, child: Text(option)),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;

                  setState(() {
                    _selectedGenderPreference = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              _buildField(
                fieldKey: const Key('roommateInterestsField'),
                controller: _interestsController,
                label: 'Interests',
                hint: 'e.g. cooking, quiet study, fitness',
                validator: _requiredValidator,
              ),
              const SizedBox(height: 12),
              _buildField(
                fieldKey: const Key('roommateAboutField'),
                controller: _aboutController,
                label: 'About you',
                hint: 'Tell students what kind of roommate you want',
                maxLines: 5,
                validator: _requiredValidator,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Verified student',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF111827),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Mark this if you have been verified by UniLane.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _isVerifiedStudent,
                      onChanged: (value) {
                        setState(() {
                          _isVerifiedStudent = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text('Post Request'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final name = _nameController.text.trim();
    final profile = RoommateProfileItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      initials: _buildInitials(name),
      name: name,
      level: _selectedLevel,
      area: _areaController.text.trim(),
      budget: _budgetController.text.trim(),
      moveIn: _selectedMoveIn,
      genderPreference: _selectedGenderPreference,
      interests: _interestsController.text
          .split(',')
          .map((interest) => interest.trim())
          .where((interest) => interest.isNotEmpty)
          .toList(),
      about: _aboutController.text.trim(),
      isVerifiedStudent: _isVerifiedStudent,
    );

    await context.read<CampusMartProvider>().addRoommateProfile(profile);

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop(profile);
  }

  String _buildInitials(String fullName) {
    final parts = fullName
        .split(' ')
        .where((part) => part.trim().isNotEmpty)
        .take(2)
        .toList();

    if (parts.isEmpty) {
      return 'U';
    }

    return parts.map((part) => part[0].toUpperCase()).join();
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }

    return null;
  }

  Widget _buildField({
    Key? fieldKey,
    required TextEditingController controller,
    required String label,
    required String hint,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      key: fieldKey,
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      decoration: _inputDecoration(label, hintText: hint),
    );
  }

  InputDecoration _inputDecoration(String label, {String? hintText}) {
    return InputDecoration(labelText: label, hintText: hintText);
  }
}

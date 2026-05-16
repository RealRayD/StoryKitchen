import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/character.dart';
import '../providers/character_provider.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/custom_button.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';

class CharacterCreationScreen extends StatefulWidget {
  final Character? character;

  const CharacterCreationScreen({super.key, this.character});

  @override
  _CharacterCreationScreenState createState() =>
      _CharacterCreationScreenState();
}

class _CharacterCreationScreenState extends State<CharacterCreationScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _backgroundController;
  late TabController _tabController;
  
  String _selectedGender = 'Male';
  final List<String> _genders = ['Male', 'Female', 'Non-binary', 'Other', 'Alien', 'Mystical'];
  
  final Map<String, List<String>> _traitCategories = {
    'Personality': ['Brave', 'Shy', 'Curious', 'Stoic', 'Witty', 'Rebellious', 'Loyal', 'Arrogant', 'Kind', 'Eccentric'],
    'Physical': ['Strong', 'Graceful', 'Scarred', 'Nimble', 'Towering', 'Fragile', 'Imposing', 'Mysterious', 'Vibrant'],
    'Moral': ['Heroic', 'Villainous', 'Mercenary', 'Peaceful', 'Ambitious', 'Honorable', 'Deceptive', 'Altruistic'],
  };
  
  final Set<String> _selectedTraits = {};

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.character?.name ?? '');
    _ageController =
        TextEditingController(text: widget.character?.age.toString() ?? '');
    _backgroundController =
        TextEditingController(text: widget.character?.backgroundStory ?? '');
    _selectedGender = widget.character?.gender ?? 'Male';
    _tabController = TabController(length: _traitCategories.length, vsync: this);
    
    if (widget.character?.personality != null) {
      _selectedTraits.addAll(widget.character!.personality);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _backgroundController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _saveCharacter() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final age = int.tryParse(_ageController.text) ?? 20;
      final background = _backgroundController.text;
      final personality = _selectedTraits.toList();

      final characterProvider =
          Provider.of<CharacterProvider>(context, listen: false);

      try {
        if (widget.character == null) {
          final newCharacter = Character(
            id: const Uuid().v4(),
            userId: '', // Set by FirestoreService
            name: name,
            age: age,
            gender: _selectedGender,
            personality: personality,
            backgroundStory: background,
          );
          await characterProvider.addCharacter(newCharacter);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(backgroundColor: AppColors.success, content: Text('Character created!')),
            );
          }
        } else {
          final updatedCharacter = widget.character!.copyWith(
            name: name,
            age: age,
            gender: _selectedGender,
            personality: personality,
            backgroundStory: background,
          );
          await characterProvider.updateCharacter(updatedCharacter);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(backgroundColor: AppColors.success, content: Text('Character updated!')),
            );
          }
        }
        if (mounted) Navigator.pop(context);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(backgroundColor: AppColors.error, content: Text('Failed to save: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(widget.character == null ? 'New Hero' : 'Edit Hero', style: AppStyles.h2),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildAvatarSection(),
              const SizedBox(height: 24),
              _buildSection(
                title: 'Core Identity',
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _nameController,
                      labelText: 'Character Name',
                      prefixIcon: Icons.badge_outlined,
                      validator: (value) => value!.isEmpty ? 'Enter a name' : null,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: CustomTextField(
                            controller: _ageController,
                            labelText: 'Age',
                            keyboardType: TextInputType.number,
                            validator: (value) => value!.isEmpty ? 'Age' : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: _buildGenderDropdown(),
                        ),
                      ],
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 100.ms),
              const SizedBox(height: 16),
              
              // New Tabbed Traits Section
              _buildSection(
                title: 'Characteristics',
                child: Column(
                  children: [
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.cardBg.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppColors.primary,
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.white,
                        labelStyle: AppStyles.bodySmall.copyWith(fontWeight: FontWeight.bold),
                        tabs: _traitCategories.keys.map((name) => Tab(text: name)).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 150, // Fixed height for the traits area to prevent jumping
                      child: TabBarView(
                        controller: _tabController,
                        children: _traitCategories.values.map((traits) {
                          return SingleChildScrollView(
                            child: Wrap(
                              spacing: 8.0,
                              runSpacing: 8.0,
                              children: traits.map((trait) {
                                final isSelected = _selectedTraits.contains(trait);
                                return ChoiceChip(
                                  label: Text(trait),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    setState(() {
                                      if (selected) _selectedTraits.add(trait);
                                      else _selectedTraits.remove(trait);
                                    });
                                  },
                                  selectedColor: AppColors.primary,
                                  backgroundColor: AppColors.cardBg.withOpacity(0.8),
                                  labelStyle: AppStyles.bodySmall.copyWith(
                                    color: isSelected ? Colors.white : Colors.white,
                                    fontSize: 11,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  ),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  side: BorderSide(color: isSelected ? Colors.white : Colors.white24),
                                );
                              }).toList(),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 200.ms),
              
              const SizedBox(height: 16),
              _buildSection(
                title: 'Origin Story',
                child: CustomTextField(
                  controller: _backgroundController,
                  labelText: 'Background Details',
                  maxLines: 3,
                  validator: (value) => value!.isEmpty ? 'Enter background' : null,
                ),
              ).animate().fadeIn(delay: 300.ms),
              const SizedBox(height: 32),
              CustomButton(
                text: widget.character == null ? 'Create Character' : 'Save Changes',
                icon: Icons.check_circle_outline,
                onPressed: _saveCharacter,
              ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppStyles.glassDecoration.copyWith(
        color: AppColors.cardBg.withOpacity(0.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppStyles.h3.copyWith(color: AppColors.primary, fontSize: 12, letterSpacing: 1.2)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildAvatarSection() {
    return Center(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 1.5),
            ),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.cardBg,
              child: Text(
                _nameController.text.isNotEmpty ? _nameController.text[0] : '?',
                style: AppStyles.h1.copyWith(fontSize: 40, color: AppColors.primary),
              ),
            ),
          ),
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.primary,
            child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
          ),
        ],
      ),
    ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack);
  }

  Widget _buildGenderDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text('Gender', style: AppStyles.bodySmall.copyWith(fontWeight: FontWeight.bold, fontSize: 11)),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.cardBg.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedGender,
              isExpanded: true,
              dropdownColor: AppColors.cardBg,
              style: AppStyles.bodyLarge.copyWith(fontSize: 14),
              items: _genders.map((String gender) {
                return DropdownMenuItem<String>(
                  value: gender,
                  child: Text(gender),
                );
              }).toList(),
              onChanged: (newValue) => setState(() => _selectedGender = newValue!),
            ),
          ),
        ),
      ],
    );
  }
}

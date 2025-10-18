// views/team_members_list_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saloony/core/models/team_member.dart';
import 'package:saloony/features/TeamManagement/viewmodels/team_viewmodel.dart';

class TeamMembersListView extends StatefulWidget {
  @override
  _TeamMembersListViewState createState() => _TeamMembersListViewState();
}

class _TeamMembersListViewState extends State<TeamMembersListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
        title: Text(
          'Membres d...',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: () => _showAddMemberDialog(context),
              icon: Icon(Icons.add),
              label: Text('Ajouter un nouveau'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFB84EFF),
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher un nom, un email, un téléphone...',
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Consumer<TeamViewModel>(
                  builder: (context, viewModel, _) => Text(
                    'Membres (${viewModel.memberCount})',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.sort),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text('Tous les membres'),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text('Nouveau'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Barrières'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFB84EFF),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<TeamViewModel>(
              builder: (context, viewModel, _) {
                return GridView.builder(
                  padding: EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: viewModel.members.length,
                  itemBuilder: (context, index) {
                    return TeamMemberCard(
                      member: viewModel.members[index],
                      onEdit: () => _showEditMemberDialog(
                        context,
                        viewModel.members[index],
                      ),
                      onDelete: () => _showDeleteConfirmDialog(
                        context,
                        viewModel.members[index],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddMemberDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddMemberDialog(),
    );
  }

  void _showEditMemberDialog(BuildContext context, TeamMember member) {
    showDialog(
      context: context,
      builder: (context) => EditMemberDialog(member: member),
    );
  }

  void _showDeleteConfirmDialog(BuildContext context, TeamMember member) {
    showDialog(
      context: context,
      builder: (context) => DeleteConfirmDialog(member: member),
    );
  }
}

// widgets/team_member_card.dart
class TeamMemberCard extends StatelessWidget {
  final TeamMember member;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TeamMemberCard({
    required this.member,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: member.profileImageUrl != null
                    ? Image.network(member.profileImageUrl!)
                    : Icon(Icons.person, size: 40),
              ),
              SizedBox(height: 12),
              Text(
                member.name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                member.specialty,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
          Positioned(
            top: 8,
            right: 8,
            child: PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Text('Modifier'),
                  value: 'edit',
                ),
                PopupMenuItem(
                  child: Text('Supprimer'),
                  value: 'delete',
                ),
              ],
              onSelected: (value) {
                if (value == 'edit') {
                  onEdit();
                } else if (value == 'delete') {
                  onDelete();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

// dialogs/add_member_dialog.dart
class AddMemberDialog extends StatefulWidget {
  @override
  _AddMemberDialogState createState() => _AddMemberDialogState();
}

class _AddMemberDialogState extends State<AddMemberDialog> {
  final _nameController = TextEditingController();
  final _specialtyController = TextEditingController();
  final _emailController = TextEditingController();
  String _selectedRole = 'Maquilleur';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Ajouter un membre de l\'équipe',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.person, size: 40),
              ),
              SizedBox(height: 20),
              _buildTextField('Nom et prénom', _nameController),
              SizedBox(height: 16),
              _buildTextField('Spécialité', _specialtyController),
              SizedBox(height: 16),
              _buildDropdown(),
              SizedBox(height: 16),
              _buildTextField('E-mail', _emailController),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Dos'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _addMember(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFB84EFF),
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Sauvegarder'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[700]),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: Colors.grey[50],
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rôle de la plateforme',
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[700]),
        ),
        SizedBox(height: 8),
        DropdownButton<String>(
          value: _selectedRole,
          isExpanded: true,
          items: ['Maquilleur', 'Styliste', 'Manager'].map((role) {
            return DropdownMenuItem(
              value: role,
              child: Text(role),
            );
          }).toList(),
          onChanged: (value) {
            setState(() => _selectedRole = value ?? 'Maquilleur');
          },
        ),
      ],
    );
  }

  void _addMember(BuildContext context) {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _specialtyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    final newMember = TeamMember(
      id: DateTime.now().toString(),
      name: _nameController.text,
      specialty: _specialtyController.text,
      email: _emailController.text,
    );

    context.read<TeamViewModel>().addMember(newMember);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _specialtyController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}

// dialogs/edit_member_dialog.dart
class EditMemberDialog extends StatefulWidget {
  final TeamMember member;

  const EditMemberDialog({required this.member});

  @override
  _EditMemberDialogState createState() => _EditMemberDialogState();
}

class _EditMemberDialogState extends State<EditMemberDialog> {
  late TextEditingController _nameController;
  late TextEditingController _specialtyController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.member.name);
    _specialtyController = TextEditingController(text: widget.member.specialty);
    _emailController = TextEditingController(text: widget.member.email);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Modifier le membre',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              _buildTextField('Nom et prénom', _nameController),
              SizedBox(height: 16),
              _buildTextField('Spécialité', _specialtyController),
              SizedBox(height: 16),
              _buildTextField('E-mail', _emailController),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Annuler'),
                  ),
                  ElevatedButton(
                    onPressed: () => _updateMember(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFB84EFF),
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Sauvegarder'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[700]),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: Colors.grey[50],
          ),
        ),
      ],
    );
  }

  void _updateMember(BuildContext context) {
    final updatedMember = widget.member.copyWith(
      name: _nameController.text,
      specialty: _specialtyController.text,
      email: _emailController.text,
    );

    context.read<TeamViewModel>().updateMember(updatedMember);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _specialtyController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}

// dialogs/delete_confirm_dialog.dart
class DeleteConfirmDialog extends StatelessWidget {
  final TeamMember member;

  const DeleteConfirmDialog({required this.member});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Supprimer le membre'),
      content: Text(
        'Êtes-vous sûr de vouloir supprimer ${member.name}?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: () {
            context.read<TeamViewModel>().deleteMember(member.id);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child: Text('Supprimer'),
        ),
      ],
    );
  }
}
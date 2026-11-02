import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task_model.dart';
import '../viewmodels/task_viewmodel.dart';
import '../viewmodels/theme_viewmodel.dart';
import 'color_picker_dialog.dart';
import 'edit_task_screen.dart';
import 'widgets/task_card.dart';

class TaskListScreen extends ConsumerStatefulWidget {
  const TaskListScreen({super.key});

  @override
  ConsumerState<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends ConsumerState<TaskListScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showColorPicker(BuildContext context, Color currentColor) {
    showDialog(
      context: context,
      builder: (ctx) => ColorPickerDialog(
        currentColor: currentColor,
        onColorSelected: (color) {
          ref.read(themeViewModelProvider.notifier).setAppBarColor(color);
        },
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context, Color themeColor) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    String selectedIcon = 'laptop';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Thêm công việc mới',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: 'Tiêu đề *',
                      hintText: 'Nhập tiêu đề công việc...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: descController,
                    decoration: InputDecoration(
                      labelText: 'Mô tả / Hạn hoàn thành',
                      hintText: 'Ví dụ: Hoàn thành trước thứ Sáu',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Chọn biểu tượng:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF4B5563),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildIconOption(
                        icon: Icons.laptop_chromebook_outlined,
                        type: 'laptop',
                        selectedType: selectedIcon,
                        onTap: () => setModalState(() => selectedIcon = 'laptop'),
                      ),
                      const SizedBox(width: 12),
                      _buildIconOption(
                        icon: Icons.menu_book_outlined,
                        type: 'book',
                        selectedType: selectedIcon,
                        onTap: () => setModalState(() => selectedIcon = 'book'),
                      ),
                      const SizedBox(width: 12),
                      _buildIconOption(
                        icon: Icons.co_present_outlined,
                        type: 'presentation',
                        selectedType: selectedIcon,
                        onTap: () => setModalState(() => selectedIcon = 'presentation'),
                      ),
                      const SizedBox(width: 12),
                      _buildIconOption(
                        icon: Icons.description_outlined,
                        type: 'document',
                        selectedType: selectedIcon,
                        onTap: () => setModalState(() => selectedIcon = 'document'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        final title = titleController.text.trim();
                        if (title.isEmpty) return;

                        final newTask = TaskModel(
                          title: title,
                          description: descController.text.trim(),
                          iconType: selectedIcon,
                        );

                        await ref
                            .read(taskViewModelProvider.notifier)
                            .addTask(newTask);

                        if (context.mounted) {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Đã thêm công việc thành công!'),
                              backgroundColor: Color(0xFF10B981),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        'Thêm công việc',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildIconOption({
    required IconData icon,
    required String type,
    required String selectedType,
    required VoidCallback onTap,
  }) {
    final isSelected = type == selectedType;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE5E7EB) : const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0xFF374151) : const Color(0xFFD1D5DB),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Icon(
          icon,
          size: 24,
          color: const Color(0xFF374151),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = ref.watch(themeViewModelProvider);
    final tasksAsync = ref.watch(taskViewModelProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: themeColor,
        elevation: 0,
        centerTitle: false,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                decoration: const InputDecoration(
                  hintText: 'Tìm kiếm công việc...',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val.trim().toLowerCase();
                  });
                },
              )
            : const Text(
                'Quản lý công việc',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: Colors.white,
            ),
            tooltip: _isSearching ? 'Đóng tìm kiếm' : 'Tìm kiếm',
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _isSearching = false;
                  _searchController.clear();
                  _searchQuery = '';
                } else {
                  _isSearching = true;
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.palette_outlined,
              color: Colors.white,
            ),
            tooltip: 'Chọn màu thanh ứng dụng',
            onPressed: () => _showColorPicker(context, themeColor),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: tasksAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 12),
                Text('Lỗi: $error', textAlign: TextAlign.center),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () =>
                      ref.read(taskViewModelProvider.notifier).refreshTasks(),
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          ),
        ),
        data: (taskList) {
          final filteredList = _searchQuery.isEmpty
              ? taskList
              : taskList.where((t) {
                  return t.title.toLowerCase().contains(_searchQuery) ||
                      t.description.toLowerCase().contains(_searchQuery);
                }).toList();

          if (filteredList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _searchQuery.isEmpty
                        ? Icons.checklist_outlined
                        : Icons.search_off,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _searchQuery.isEmpty
                        ? 'Chưa có công việc nào'
                        : 'Không tìm thấy công việc phù hợp',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await ref.read(taskViewModelProvider.notifier).refreshTasks();
            },
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 14, bottom: 80),
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final task = filteredList[index];
                return TaskCard(
                  task: task,
                  onEdit: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => EditTaskScreen(task: task),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF374151),
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        elevation: 4,
        onPressed: () => _showAddTaskDialog(context, themeColor),
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}

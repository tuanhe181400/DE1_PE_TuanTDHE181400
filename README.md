# Ứng Dụng Quản Lý Công Việc (Flutter - MVVM - Riverpod - SQLite)

Dự án được xây dựng theo đúng yêu cầu của **Đề 1**:

## 1. Yêu cầu đề bài & Giải pháp thực hiện

| STT | Yêu cầu đề bài | Cách thực hiện trong dự án |
| :--- | :--- | :--- |
| **1** | Hiển thị danh sách công việc từ SQLite như giao diện trên | Cài đặt `DatabaseHelper` với SQLite (hỗ trợ cả Mobile, Desktop và Web). Tạo bảng `tasks` và khởi tạo sẵn 4 công việc mẫu chính xác như ảnh: <br>• Làm bài tập Flutter (Hoàn thành trước thứ Sáu)<br>• Ôn tập Riverpod (Xem lại bài giảng MVVM)<br>• Chuẩn bị bài thuyết trình (Nhóm 4 - Chủ đề Firebase)<br>• Viết báo cáo môn học (Nộp trên LMS). Giao diện hiển thị dạng thẻ bo góc, có icon tương ứng, icon lịch và biểu tượng Edit. |
| **2** | Khi nhấn vào biểu tượng Edit chuyển đến giao diện chỉnh sửa công việc, người dùng có thể chỉnh sửa công việc và lưu lại thông tin | Màn hình `EditTaskScreen` với thanh AppBar có nút Back, các trường nhập liệu: "Tiêu đề *", "Mô tả", nút gạt "Đã hoàn thành", cùng 2 nút "Hủy" và "Lưu". Khi bấm "Lưu", dữ liệu cập nhật xuống SQLite và cập nhật danh sách qua Riverpod. |
| **3** | Cho phép lựa chọn màu thanh AppBar (xanh dương, xanh lá hoặc tím), lưu màu đã chọn để khi tắt ứng dụng đi mở lại thiết lập màu vẫn được ghi nhớ | Nút chọn màu (biểu tượng palette) trên AppBar mở hộp thoại `ColorPickerDialog` với lưới 8 ô màu tròn (bao gồm Xanh dương, Xanh lá, Tím, Xám đậm,...). Màu được lưu vào `SharedPreferences` và tự động khôi phục khi mở lại app. |
| **4** | Tổ chức mã nguồn theo MVVM; sử dụng `riverpod` và `riverpod_generator` để quản lý trạng thái | Cấu trúc chuẩn MVVM (`models/`, `data/`, `viewmodels/`, `views/`). Sử dụng `@riverpod` kết hợp `build_runner` sinh mã nguồn `*.g.dart`. |

---

## 2. Cấu trúc thư mục (Kiến trúc MVVM)

```text
lib/
├── data/
│   ├── database_helper.dart      # SQLite Database Helper (CRUD tasks, hỗ trợ đa nền tảng)
│   └── theme_storage.dart        # Lưu trữ và khôi phục màu AppBar qua SharedPreferences
├── models/
│   └── task_model.dart           # Model công việc (id, title, description, isCompleted, iconType)
├── viewmodels/
│   ├── task_viewmodel.dart       # ViewModel quản lý state danh sách công việc (@riverpod)
│   ├── task_viewmodel.g.dart     # Mã tự sinh bởi riverpod_generator
│   ├── theme_viewmodel.dart      # ViewModel quản lý màu sắc AppBar và theme (@riverpod)
│   └── theme_viewmodel.g.dart    # Mã tự sinh bởi riverpod_generator
├── views/
│   ├── widgets/
│   │   └── task_card.dart        # Widget thẻ công việc theo chuẩn giao diện
│   ├── color_picker_dialog.dart  # Hộp thoại chọn màu thanh ứng dụng (8 màu)
│   ├── edit_task_screen.dart     # Màn hình Chỉnh sửa công việc (Tiêu đề, Mô tả, Đã hoàn thành)
│   └── task_list_screen.dart     # Màn hình chính Quản lý công việc
└── main.dart                     # Khởi tạo ứng dụng & ProviderScope
```

---

## 3. Hướng dẫn chạy ứng dụng

### Chạy ứng dụng trên thiết bị (Android / Web / Windows):

```bash
cd task_manager_app
flutter run
```

### Sinh lại mã Riverpod Generator (nếu chỉnh sửa ViewModel):

```bash
dart run build_runner build --delete-conflicting-outputs
```

✅ Hướng dẫn chạy dự án từ GitHub
1. Clone mã nguồn từ GitHub
Mở terminal và chạy:

git clone https://github.com/hosobaomat/ITSS.git

2. Khởi động Backend (Java Spring Boot)
Bước 1: Mở file:

backend/be/src/main/java/nhom27/itss/be/BeApplication.java
Bước 2: Chạy file BeApplication.java bằng IDE như IntelliJ hoặc Eclipse để khởi động server backend.

3. Cài đặt các công nghệ cần thiết
Bạn cần cài đặt:

Python (>=3.9)

Django

Flutter

Java và Maven (nếu chưa có)

4. Chạy trang Admin Web (Django)
Bước 1: Di chuyển đến thư mục:

frontend/Admin_Web_Django/myproject
Bước 2: Tạo tài khoản superuser để đăng nhập admin:

python manage.py createsuperuser
👉 Làm theo hướng dẫn trên terminal để nhập username, email, password.

Bước 3: Chạy server Django:

python manage.py runserver
5. Chạy ứng dụng Flutter cho người dùng (Mobile App)
⚠️ Cấu hình địa chỉ IP nội bộ (IPv4)
Bước 1: Mở terminal/cmd và gõ:

ipconfig
Tìm địa chỉ IPv4 (ví dụ: 192.168.1.19).

Bước 2: Mở và chỉnh sửa 2 file sau:

File 1:
frontend/User_Mobile_flutter/lib/data/data_store.dart
👉 Tìm dòng:

late String url = 'http://192.168.1.19:8082/ITSS_BE';
👉 Sửa lại 192.168.1.19 thành IP bạn vừa tìm được.

File 2:
frontend/User_Mobile_flutter/lib/service/auth_service.dart
👉 Tìm dòng:

static const String apiUrl = "http://192.168.1.19:8082/ITSS_BE";
👉 Sửa lại IP tương tự.

6. Chạy ứng dụng Flutter
Bước 1: Di chuyển đến thư mục:

frontend/User_Mobile_flutter
Bước 2: Mở file lib/main.dart

Bước 3: Chạy ứng dụng Flutter:

Dùng USB (real device), hoặc

Emulator (trình giả lập), hoặc

Chạy trên Web (nếu có hỗ trợ)

flutter run

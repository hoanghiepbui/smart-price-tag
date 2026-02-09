# Smart E-Paper Price Tag System (Hệ thống Nhãn giá Điện tử Thông minh)

> Đồ án Thiết kế II - Đại học Bách Khoa Hà Nội

Hệ thống **Electronic Shelf Label (ESL)** hoàn chỉnh, cho phép cập nhật giá và thông tin sản phẩm từ xa thông qua Wi-Fi sử dụng công nghệ màn hình E-Ink tiết kiệm năng lượng. Dự án bao gồm cả thiết kế phần cứng (ESP32 + E-Paper) và phần mềm quản lý tập trung (FastAPI + MySQL).

## Nhóm tác giả
* **GV Hướng dẫn:** ThS. Nguyễn Minh Đức
* **Sinh viên thực hiện:**
    * Nguyễn Hữu Trung - 20223743
    * Bùi Hoàng Hiệp - 20223703

---

## Tính năng chính

* **Quản lý tập trung:** Thêm, sửa, xóa sản phẩm và quản lý danh sách thiết bị hiển thị (Display) qua giao diện Web Dashboard.
* **Cập nhật không dây:** Thiết bị Price Tag tự động cập nhật giá, tên sản phẩm qua Wi-Fi mà không cần kết nối dây.
* **Tiết kiệm năng lượng:** Sử dụng màn hình E-Ink (giấy điện tử) chỉ tốn điện khi thay đổi nội dung, giữ nguyên hình ảnh khi ngắt nguồn.
* **Giám sát thiết bị:** Theo dõi thời gian thực dung lượng Pin, cường độ tín hiệu (RSSI) và trạng thái Online/Offline của từng nhãn giá.
* **Hiển thị trực quan:** Hỗ trợ hiển thị tên, giá (màu đỏ nổi bật), trạng thái (Sold out), và mã vạch minh họa.

---

## Công nghệ sử dụng

### Phần cứng (Hardware)
* **Vi điều khiển:** ESP32 (NodeMCU/DevKit) tích hợp Wi-Fi.
* **Màn hình:** Waveshare 2.13inch E-Paper Display (3 màu: Đen, Trắng, Đỏ).
* **Giao tiếp:** SPI.

### Phần mềm (Software)
* **Firmware:** C++ (Arduino Framework / PlatformIO).
    * Thư viện: `GxEPD2`, `Adafruit_GFX`, `ArduinoJson`, `HTTPClient`.
* **Backend:** Python (FastAPI).
* **Database:** MySQL.
* **Frontend:** HTML/CSS (Jinja2 Templates tích hợp trong FastAPI).

---

## Sơ đồ kết nối phần cứng

Kết nối màn hình E-Ink với ESP32 theo chuẩn SPI như sau:

| Chân E-Ink | Chân ESP32 (GPIO) | Chức năng |
| :--- | :--- | :--- |
| **BUSY** | GPIO 4 | Báo trạng thái bận |
| **RST** | GPIO 16 | Reset màn hình |
| **DC** | GPIO 17 | Data/Command select |
| **CS** | GPIO 5 | Chip Select |
| **CLK (SCK)** | GPIO 18 | Clock SPI |
| **DIN (MOSI)**| GPIO 23 | Dữ liệu SPI |
| **GND** | GND | Nối đất |
| **VCC** | 3.3V | Nguồn 3.3V |

---

## Cài đặt và Hướng dẫn sử dụng

### 1. Backend (Server)
Yêu cầu: Python 3.8+, MySQL.

1.  Clone repository:
    ```bash
    git clone [https://github.com/your-username/your-repo.git](https://github.com/your-username/your-repo.git)
    ```
2.  Cài đặt thư viện:
    ```bash
    pip install fastapi uvicorn mysql-connector-python python-multipart jinja2
    ```
3.  Cấu hình Database:
    * Tạo database MySQL tên `epaper_price`.
    * Cập nhật thông tin kết nối trong file `.env` hoặc `config.py`.
    * Chạy script SQL để tạo bảng `products`, `displays`, `display_status_logs`.
4.  Khởi chạy Server:
    ```bash
    uvicorn main:app --host 0.0.0.0 --port 8000 --reload
    ```
5.  Truy cập Admin Dashboard tại: `http://localhost:8000/admin/displays`.

### 2. Firmware (ESP32)
1.  Mở project bằng **Arduino IDE** hoặc **VS Code (PlatformIO)**.
2.  Cấu hình thông tin mạng và Server trong code:
    ```cpp
    const char* ssid = "YOUR_WIFI_SSID";
    const char* password = "YOUR_WIFI_PASSWORD";
    const char* serverHost = "192.168.1.X"; // IP máy chạy Backend (LAN IP)
    const int serverPort = 8000;
    ```
3.  Nạp code vào ESP32.

---

## API Endpoints

Hệ thống sử dụng RESTful API để giao tiếp:

| Method | Endpoint | Mô tả |
| :--- | :--- | :--- |
| `GET` | `/display/active` | ESP32 lấy thông tin sản phẩm cần hiển thị. |
| `PUT` | `/display/active/status`| ESP32 gửi báo cáo pin, sóng, version về server. |
| `GET` | `/products` | Lấy danh sách sản phẩm (Admin). |
| `POST` | `/products` | Thêm sản phẩm mới (Admin). |

---

## 🔮 Hướng phát triển (Future Work)
* Chuyển từ cơ chế Polling (hỏi định kỳ) sang MQTT/WebSocket để tiết kiệm pin và cập nhật tức thời.
* Tối ưu hóa chế độ Deep Sleep cho ESP32.
* Thêm cơ chế bảo mật (Token, HTTPS) cho API.

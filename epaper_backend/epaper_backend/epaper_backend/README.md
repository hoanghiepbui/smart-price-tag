Dưới đây là nội dung **`README.md` cho backend** (bạn chỉ cần copy nguyên văn vào file `epaper_backend/README.md`):

---

````markdown
# E-Paper Price Display Backend

Backend cho hệ thống **hiển thị giá bằng màn hình e-paper + ESP32**.  
Dịch vụ này cung cấp:

- API quản lý **sản phẩm (Products)**  
- API quản lý & giám sát **màn hình (Displays)**  
- Giao diện admin web để quản trị  
- API cho **ESP32** để:
  - Lấy dữ liệu sản phẩm hiển thị
  - Gửi trạng thái thiết bị (pin, tín hiệu, firmware, …)

Công nghệ sử dụng:

- [FastAPI](https://fastapi.tiangolo.com/)
- [SQLAlchemy](https://www.sqlalchemy.org/)
- MySQL
- HTML template với Bootstrap (admin UI)

---

## 1. Cấu trúc thư mục

```text
epaper_backend/
├─ app/
│  ├─ main.py              # entrypoint FastAPI
│  ├─ database.py          # kết nối MySQL, SessionLocal, Base
│  ├─ models.py            # SQLAlchemy models: Product, Display, DisplayStatusLog
│  ├─ schemas.py           # Pydantic schemas
│  ├─ routers/
│  │   ├─ products.py      # API CRUD /products
│  │   └─ displays.py      # API /display, /display/{code}, /status
│  └─ templates/
│      ├─ base.html        # layout chung
│      ├─ products_list.html
│      ├─ product_form.html
│      ├─ displays_list.html
│      └─ display_form.html
├─ .env                    # cấu hình DB (không commit lên git)
└─ README.md
````

---

## 2. Yêu cầu hệ thống

* Python 3.9+
* MySQL 5.7+ hoặc 8.x
* pip / venv

---

## 3. Chuẩn bị môi trường Python

Tại thư mục gốc backend:

```bash
# tạo & kích hoạt venv (Windows)
python -m venv venv
venv\Scripts\activate

# Linux / macOS:
# python3 -m venv venv
# source venv/bin/activate
```

Cài dependency:

```bash
pip install -r requirements.txt
```

> Nếu chưa có `requirements.txt`, có thể cài thủ công:

```bash
pip install fastapi uvicorn[standard] sqlalchemy pymysql python-dotenv jinja2 python-multipart
```

---

## 4. Cấu hình database MySQL

### 4.1. Tạo database & bảng

Đăng nhập MySQL và chạy script:

```sql
CREATE DATABASE IF NOT EXISTS epaper_price
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE epaper_price;

CREATE TABLE IF NOT EXISTS products (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  sku VARCHAR(64) NOT NULL,
  name VARCHAR(255) NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  currency CHAR(3) NOT NULL DEFAULT 'VND',
  description TEXT NULL,
  image_url VARCHAR(500) NULL,
  status ENUM('active','inactive','deleted') NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
    ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uk_products_sku (sku)
);

CREATE TABLE IF NOT EXISTS displays (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  code VARCHAR(64) NOT NULL,
  name VARCHAR(255) NULL,
  location VARCHAR(255) NULL,
  product_id BIGINT UNSIGNED NULL,
  battery_level TINYINT UNSIGNED NULL,
  signal_strength TINYINT NULL,
  last_seen_at DATETIME NULL,
  status ENUM('online','offline','error') NOT NULL DEFAULT 'offline',
  firmware_version VARCHAR(32) NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
    ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uk_displays_code (code),
  CONSTRAINT fk_displays_product
    FOREIGN KEY (product_id) REFERENCES products(id)
    ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS display_status_logs (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  display_id BIGINT UNSIGNED NOT NULL,
  battery_level TINYINT UNSIGNED NULL,
  signal_strength TINYINT NULL,
  status ENUM('online','offline','error') NULL,
  firmware_version VARCHAR(32) NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_status_display
    FOREIGN KEY (display_id) REFERENCES displays(id)
    ON DELETE CASCADE
);
```

### 4.2. File `.env`

Tại thư mục `epaper_backend`, tạo file `.env` (không commit):

```env
MYSQL_USER=root
MYSQL_PASSWORD=your_password
MYSQL_HOST=127.0.0.1
MYSQL_DB=epaper_price
```

Thay `your_password` bằng password MySQL thực tế.

---

## 5. Chạy ứng dụng

Từ thư mục `epaper_backend` (đã kích hoạt venv):

```bash
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

Ứng dụng mặc định chạy tại:

* API root: [http://127.0.0.1:8000/](http://127.0.0.1:8000/)
* Swagger UI: [http://127.0.0.1:8000/docs](http://127.0.0.1:8000/docs)

---

## 6. API chính

### 6.1. Products API (`/products`)

Dùng để quản lý sản phẩm hiển thị trên e-paper.

* `POST /products` – tạo sản phẩm mới
* `GET  /products` – danh sách sản phẩm (hỗ trợ `skip`, `limit`)
* `GET  /products/{id}` – xem chi tiết
* `PUT  /products/{id}` – cập nhật
* `DELETE /products/{id}` – xoá

**Ví dụ JSON tạo sản phẩm:**

```json
{
  "sku": "MILK-001",
  "name": "Sữa tươi Vinamilk 1L",
  "price": 32000,
  "currency": "VND",
  "description": "Sữa tươi nguyên chất",
  "image_url": null,
  "status": "active"
}
```

---

### 6.2. Displays API (`/display`)

Dùng để quản lý thiết bị, gán sản phẩm, và phục vụ ESP32.

#### 6.2.1. CRUD cơ bản (admin/backend)

* `POST /display` – tạo display:

  ```json
  {
    "code": "D001",
    "name": "Kệ sữa 01",
    "location": "Tầng 1 - Kệ A",
    "product_id": 1
  }
  ```
* `GET /display` – danh sách display
* `GET /display/id/{display_id}` – lấy theo id
* `PUT /display/id/{display_id}` – cập nhật
* `DELETE /display/id/{display_id}` – xoá

#### 6.2.2. API cho ESP32

##### `GET /display/{code}` – lấy dữ liệu hiển thị

ESP32 gọi endpoint này để lấy nội dung cần vẽ lên e-paper.

**Response mẫu:**

```json
{
  "code": "D001",
  "product_sku": "MILK-001",
  "product_name": "Sữa tươi Vinamilk 1L",
  "price": 32000,
  "currency": "VND",
  "description": "Sữa tươi nguyên chất",
  "image_url": null,
  "updated_at": "2025-11-16T14:00:00"
}
```

##### `GET /display/{code}/status` – xem trạng thái hiện tại

Trả về toàn bộ thông tin display, gồm:

* pin (`battery_level`)
* tín hiệu (`signal_strength`)
* `last_seen_at`
* `status` (`online/offline/error`)
* `firmware_version`

##### `PUT /display/{code}/status` – ESP32 gửi trạng thái

ESP32 gửi JSON:

```json
{
  "battery_level": 88,
  "signal_strength": 70,
  "status": "online",
  "firmware_version": "1.0.0"
}
```

Backend sẽ:

* Cập nhật bảng `displays`
* Ghi một dòng vào `display_status_logs`

---

## 7. Giao diện admin

Dùng template Jinja2 + Bootstrap.

### 7.1. Products admin

* `GET /admin/products`

  * Danh sách sản phẩm
  * Nút “Thêm sản phẩm”
* `GET /admin/products/new`

  * Form thêm mới
* `POST /admin/products/new`

  * Lưu sản phẩm
* `GET /admin/products/{id}/edit`

  * Form chỉnh sửa
* `POST /admin/products/{id}/edit`

  * Lưu chỉnh sửa
* `POST /admin/products/{id}/delete`

  * Xoá sản phẩm

### 7.2. Displays admin

* `GET /admin/displays`

  * Danh sách display + trạng thái (pin, signal, last seen…)
* `GET /admin/displays/new`

  * Form tạo display, chọn product từ dropdown
* `POST /admin/displays/new`

  * Lưu display
* `GET /admin/displays/{id}/edit`

  * Form sửa, hiển thị trạng thái hiện tại
* `POST /admin/displays/{id}/edit`

  * Lưu chỉnh sửa
* `POST /admin/displays/{id}/delete`

  * Xoá display (log trạng thái sẽ bị xoá theo FK CASCADE)

---

## 8. Tích hợp với ESP32

ESP32 là một project **PlatformIO** riêng, không cần nằm cùng thư mục với backend.
ESP32 chỉ cần:

* Kết nối WiFi
* Gọi HTTP tới backend qua IP LAN của máy chạy FastAPI:

```cpp
const char* SERVER_HOST = "192.168.x.y";  // IP máy chạy backend
const int   SERVER_PORT = 8000;
const char* DISPLAY_CODE = "D001";
```

Luồng hoạt động:

1. ESP32 gọi `GET /display/{code}` → nhận JSON sản phẩm → vẽ lên e-paper.
2. Sau khi cập nhật, ESP32 gọi `PUT /display/{code}/status` → gửi pin, signal, firmware.
3. Backend hiển thị thông tin này trên `/admin/displays`.

---

## 9. Ghi chú

* API hiện tại **chưa có authentication** (JWT/API key).

  * Nếu triển khai production, nên bổ sung bảo mật (API key, Basic Auth hoặc JWT).
* Việc migrate DB hiện đang dùng script SQL thủ công + `Base.metadata.create_all`.
* Phần log trạng thái có thể lớn dần theo thời gian → xem xét thêm job xoá log cũ nếu cần.

---

## 10. Liên hệ / ghi chú phát triển

* Mọi thay đổi về API cần được cập nhật vào README này.
* Khi thêm bảng mới hoặc thay đổi schema MySQL, hãy:

  1. Cập nhật script SQL
  2. Cập nhật `models.py`, `schemas.py`
  3. Viết thêm route/logic tương ứng



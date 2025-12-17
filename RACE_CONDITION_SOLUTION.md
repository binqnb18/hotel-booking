# VBOOKING - Giải Pháp Race Condition (Overbooking)

## 1. VẤN ĐỀ

**Race Condition**: Khi 2 khách hàng (User A và User B) cùng đặt 1 loại phòng, nhưng chỉ còn **1 phòng trống**, cả 2 đều có thể đặt thành công → dẫn đến **overbooking** (tồn kho âm: -1).

### Ví dụ:
```
- Phòng "Deluxe Sea View" còn: 1 phòng
- User A: Check availability → 1 phòng → Click "Đặt phòng" → Đang thanh toán
- User B: Check availability → 1 phòng → Click "Đặt phòng" → Đang thanh toán
- Cả 2 thanh toán thành công → Tạo 2 booking → Overbooking!
```

---

## 2. GIẢI PHÁP TỔNG THỂ

Giải pháp được chia thành **5 lớp** (layers) để đảm bảo tính toàn vẹn dữ liệu:

### 2.1. Database Level (Lớp Cơ Sở Dữ Liệu)
### 2.2. Application Level (Lớp Ứng Dụng)
### 2.3. Business Logic Level (Lớp Nghiệp Vụ)
### 2.4. Frontend Level (Lớp Giao Diện)
### 2.5. Monitoring & Alerting (Giám Sát & Cảnh Báo)

---

## 3. CHI TIẾT GIẢI PHÁP

### 3.1. DATABASE LEVEL (Lớp Cơ Sở Dữ Liệu)

#### 3.1.1. Database Transaction với Isolation Level
- **Sử dụng**: `SERIALIZABLE` hoặc `REPEATABLE READ` isolation level
- **Mục đích**: Đảm bảo transaction không bị ảnh hưởng bởi transaction khác
- **Cách hoạt động**:
  - Khi check availability → lock row `room_types` hoặc `physical_rooms`
  - Khi tạo booking → vẫn giữ lock
  - Commit → release lock
  - Nếu conflict → rollback và retry

#### 3.1.2. Pessimistic Locking (Row-Level Lock)
- **Sử dụng**: `SELECT ... FOR UPDATE` trong PostgreSQL/MySQL
- **Mục đích**: Lock row ngay khi SELECT, không cho transaction khác đọc/ghi
- **Cách hoạt động**:
  ```sql
  BEGIN TRANSACTION;
  SELECT available_rooms FROM room_types WHERE id = ? FOR UPDATE;
  -- Check availability
  UPDATE room_types SET available_rooms = available_rooms - 1 WHERE id = ?;
  INSERT INTO bookings ...;
  COMMIT;
  ```
- **Ưu điểm**: Đảm bảo không có 2 transaction cùng update
- **Nhược điểm**: Có thể gây blocking nếu nhiều user cùng đặt

#### 3.1.3. Optimistic Locking (Version Control)
- **Sử dụng**: Thêm cột `version` hoặc `updated_at` vào bảng `room_types`
- **Mục đích**: Kiểm tra version trước khi update
- **Cách hoạt động**:
  ```sql
  -- Check availability với version
  SELECT available_rooms, version FROM room_types WHERE id = ?;
  -- Nếu available_rooms > 0, tạo booking
  UPDATE room_types 
  SET available_rooms = available_rooms - 1, version = version + 1
  WHERE id = ? AND version = ?; -- Chỉ update nếu version không đổi
  -- Nếu affected_rows = 0 → version đã thay đổi → rollback
  ```
- **Ưu điểm**: Không blocking, hiệu năng tốt hơn
- **Nhược điểm**: Cần retry logic nếu conflict

#### 3.1.4. Database Constraints
- **Sử dụng**: `CHECK` constraint để đảm bảo `available_rooms >= 0`
- **Mục đích**: Database tự động reject nếu update làm available_rooms < 0
- **Cách hoạt động**:
  ```sql
  ALTER TABLE room_types 
  ADD CONSTRAINT check_available_rooms 
  CHECK (available_rooms >= 0);
  ```
- **Kết quả**: Nếu update làm available_rooms = -1 → Database tự động reject → Transaction rollback

#### 3.1.5. Unique Constraint cho Booking
- **Sử dụng**: Unique constraint trên `(room_type_id, check_in, check_out, physical_room_id)`
- **Mục đích**: Đảm bảo 1 phòng vật lý không thể bị đặt trùng thời gian
- **Cách hoạt động**:
  ```sql
  ALTER TABLE bookings
  ADD CONSTRAINT unique_room_booking
  UNIQUE (physical_room_id, check_in, check_out);
  ```

---

### 3.2. APPLICATION LEVEL (Lớp Ứng Dụng)

#### 3.2.1. Distributed Lock (Redis/Distributed Cache)
- **Sử dụng**: Redis với `SETNX` (SET if Not eXists) hoặc `Redlock`
- **Mục đích**: Lock ở application level trước khi check availability
- **Cách hoạt động**:
  1. User A: `SETNX lock:room_type:123:2025-12-20:2025-12-23` → Success → Lock acquired
  2. User B: `SETNX lock:room_type:123:2025-12-20:2025-12-23` → Failed → Wait hoặc reject
  3. User A: Check availability → Create booking → Release lock
  4. User B: Retry hoặc thông báo "Phòng đã được đặt"
- **TTL**: Lock tự động expire sau 5-10 phút (tránh deadlock)
- **Ưu điểm**: Hoạt động tốt với multiple servers (distributed system)
- **Nhược điểm**: Cần Redis infrastructure

#### 3.2.2. Queue-Based Processing
- **Sử dụng**: Message Queue (RabbitMQ, Kafka, Redis Queue)
- **Mục đích**: Xử lý booking requests tuần tự (FIFO)
- **Cách hoạt động**:
  1. User A & B: Submit booking request → Push vào queue
  2. Worker: Lấy request từ queue (1 request tại 1 thời điểm)
  3. Worker: Check availability → Create booking → Response
  4. Nếu hết phòng → Reject request thứ 2
- **Ưu điểm**: Đảm bảo xử lý tuần tự, không conflict
- **Nhược điểm**: Có thể chậm nếu queue dài

#### 3.2.3. Atomic Operations
- **Sử dụng**: Database atomic operations (`DECREMENT`, `INCREMENT`)
- **Mục đích**: Giảm available_rooms trong 1 atomic operation
- **Cách hoạt động**:
  ```sql
  UPDATE room_types 
  SET available_rooms = available_rooms - 1
  WHERE id = ? AND available_rooms > 0;
  -- Nếu affected_rows = 0 → Hết phòng → Reject booking
  ```
- **Ưu điểm**: Đơn giản, hiệu quả
- **Nhược điểm**: Cần kết hợp với transaction

#### 3.2.4. Retry Logic với Exponential Backoff
- **Sử dụng**: Retry khi conflict xảy ra
- **Mục đích**: Tự động retry nếu transaction bị rollback do conflict
- **Cách hoạt động**:
  1. Try booking → Conflict → Rollback
  2. Wait (exponential backoff: 100ms, 200ms, 400ms, ...)
  3. Retry (tối đa 3 lần)
  4. Nếu vẫn fail → Thông báo "Phòng đã được đặt"
- **Ưu điểm**: Tự động xử lý conflict
- **Nhược điểm**: Có thể làm chậm response

---

### 3.3. BUSINESS LOGIC LEVEL (Lớp Nghiệp Vụ)

#### 3.3.1. Hold Mechanism (Giữ Phòng Tạm)
- **Sử dụng**: Bảng `room_holds` để giữ phòng trong thời gian thanh toán
- **Mục đích**: Tránh nhiều người cùng đặt 1 phòng trong lúc thanh toán
- **Cách hoạt động**:
  1. User A: Click "Đặt phòng" → Tạo `room_hold` (expire sau 5 phút)
  2. Giảm `available_rooms` tạm thời (hoặc không giảm, chỉ đánh dấu "đang giữ")
  3. User B: Check availability → Thấy `room_hold` → Hiển thị "1 phòng đang được giữ"
  4. User A: Thanh toán thành công → Convert `room_hold` → `booking` → Xóa `room_hold`
  5. User A: Thanh toán thất bại hoặc timeout → Xóa `room_hold` → Tăng lại `available_rooms`
- **TTL**: Tự động expire sau 5-10 phút (cron job hoặc database trigger)
- **Ưu điểm**: Tránh conflict trong lúc thanh toán
- **Nhược điểm**: Cần cleanup job cho expired holds

#### 3.3.2. Two-Phase Booking (Đặt Phòng 2 Giai Đoạn)
- **Giai đoạn 1**: Reserve (Giữ chỗ)
  - Check availability → Reserve → Giảm available_rooms
  - Status: `reserved` (có thể cancel trong 5 phút)
- **Giai đoạn 2**: Confirm (Xác nhận)
  - Thanh toán thành công → Convert `reserved` → `paid`
  - Thanh toán thất bại → Release reserve → Tăng lại available_rooms
- **Ưu điểm**: Tách biệt reserve và payment, dễ quản lý
- **Nhược điểm**: Phức tạp hơn single-phase

#### 3.3.3. Overbooking Policy (Chính Sách Overbooking)
- **Sử dụng**: Cho phép overbooking với giới hạn (ví dụ: +10%)
- **Mục đích**: Tối ưu doanh thu (một số khách có thể cancel/no-show)
- **Cách hoạt động**:
  - Nếu `available_rooms = 0` nhưng `booked_rooms < total_rooms * 1.1` → Vẫn cho đặt
  - Nếu `booked_rooms >= total_rooms * 1.1` → Reject
- **Rủi ro**: Cần có kế hoạch xử lý nếu tất cả khách đều đến (upgrade phòng, hoàn tiền, ...)
- **Ưu điểm**: Tăng doanh thu
- **Nhược điểm**: Rủi ro cao nếu không quản lý tốt

#### 3.3.4. Waitlist Mechanism (Danh Sách Chờ)
- **Sử dụng**: Bảng `waitlist` cho khách đặt khi hết phòng
- **Mục đích**: Cho phép khách đăng ký chờ khi có phòng hủy
- **Cách hoạt động**:
  1. User A: Đặt phòng → Hết phòng → Thêm vào `waitlist`
  2. User B: Cancel booking → Có phòng trống → Notify User A → User A có thể đặt
- **Ưu điểm**: Không mất khách hàng
- **Nhược điểm**: Cần notification system

---

### 3.4. FRONTEND LEVEL (Lớp Giao Diện)

#### 3.4.1. Real-time Availability Check
- **Sử dụng**: WebSocket hoặc Server-Sent Events (SSE)
- **Mục đích**: Cập nhật availability real-time cho user
- **Cách hoạt động**:
  1. User A: Xem phòng → Subscribe WebSocket
  2. User B: Đặt phòng → Server broadcast: "Phòng X còn Y phòng"
  3. User A: Nhận update → UI tự động refresh
- **Ưu điểm**: User luôn thấy availability mới nhất
- **Nhược điểm**: Cần WebSocket infrastructure

#### 3.4.2. Optimistic UI Update với Rollback
- **Sử dụng**: Update UI ngay khi user click "Đặt phòng"
- **Mục đích**: UX tốt hơn (không phải chờ response)
- **Cách hoạt động**:
  1. User click "Đặt phòng" → UI hiển thị "Đang xử lý..."
  2. Gửi request → Nếu success → Chuyển trang thanh toán
  3. Nếu fail (hết phòng) → Rollback UI → Hiển thị "Phòng đã được đặt"
- **Ưu điểm**: UX mượt mà
- **Nhược điểm**: Cần rollback logic

#### 3.4.3. Pre-validation trước khi Submit
- **Sử dụng**: Check availability trước khi cho phép submit form
- **Mục đích**: Tránh user submit khi đã hết phòng
- **Cách hoạt động**:
  1. User điền form → Trước khi submit, gọi API check availability
  2. Nếu còn phòng → Enable submit button
  3. Nếu hết phòng → Disable submit button → Hiển thị "Hết phòng"
- **Ưu điểm**: Tránh submit không cần thiết
- **Nhược điểm**: Vẫn có thể conflict nếu 2 user cùng check

#### 3.4.4. Loading State & Disable Button
- **Sử dụng**: Disable "Đặt phòng" button khi đang xử lý
- **Mục đích**: Tránh user click nhiều lần
- **Cách hoạt động**:
  1. User click "Đặt phòng" → Disable button → Show loading
  2. Request đang xử lý → Button vẫn disabled
  3. Response về → Enable button (nếu fail) hoặc redirect (nếu success)
- **Ưu điểm**: Đơn giản, hiệu quả
- **Nhược điểm**: Chỉ tránh double-click, không tránh race condition

---

### 3.5. MONITORING & ALERTING (Giám Sát & Cảnh Báo)

#### 3.5.1. Monitor Available Rooms
- **Sử dụng**: Alert khi `available_rooms < 0` (overbooking)
- **Mục đích**: Phát hiện sớm vấn đề
- **Cách hoạt động**:
  - Cron job check `available_rooms` mỗi 5 phút
  - Nếu `available_rooms < 0` → Alert admin → Manual fix
- **Ưu điểm**: Phát hiện sớm
- **Nhược điểm**: Chỉ phát hiện sau khi xảy ra

#### 3.5.2. Log Conflict Events
- **Sử dụng**: Log tất cả conflict events (retry, rollback, reject)
- **Mục đích**: Phân tích và tối ưu
- **Cách hoạt động**:
  - Log: `room_type_id`, `user_id`, `timestamp`, `action` (retry/reject)
  - Dashboard: Hiển thị conflict rate
- **Ưu điểm**: Hiểu rõ vấn đề
- **Nhược điểm**: Cần logging infrastructure

#### 3.5.3. Metrics & Dashboard
- **Sử dụng**: Metrics: conflict rate, retry rate, overbooking rate
- **Mục đích**: Theo dõi hiệu quả giải pháp
- **Cách hoạt động**:
  - Prometheus/Grafana: Track metrics
  - Alert khi conflict rate > threshold
- **Ưu điểm**: Proactive monitoring
- **Nhược điểm**: Cần monitoring infrastructure

---

## 4. KHUYẾN NGHỊ TRIỂN KHAI

### 4.1. Phase 1: Cơ Bản (Minimum Viable)
1. **Database Transaction** với `REPEATABLE READ` isolation
2. **Pessimistic Locking** (`SELECT ... FOR UPDATE`)
3. **Database Constraint** (`CHECK available_rooms >= 0`)
4. **Atomic Decrement** (`UPDATE ... WHERE available_rooms > 0`)
5. **Frontend**: Disable button khi đang xử lý

### 4.2. Phase 2: Nâng Cao (Recommended)
1. **Hold Mechanism** (giữ phòng tạm 5 phút)
2. **Optimistic Locking** (version control)
3. **Retry Logic** với exponential backoff
4. **Frontend**: Real-time availability check (WebSocket)
5. **Monitoring**: Log conflict events

### 4.3. Phase 3: Enterprise (Optional)
1. **Distributed Lock** (Redis)
2. **Queue-Based Processing** (RabbitMQ/Kafka)
3. **Overbooking Policy** (nếu cần)
4. **Waitlist Mechanism**
5. **Full Monitoring Dashboard**

---

## 5. LƯU Ý QUAN TRỌNG

### 5.1. Performance vs Consistency
- **Pessimistic Locking**: Đảm bảo consistency nhưng có thể blocking
- **Optimistic Locking**: Hiệu năng tốt hơn nhưng cần retry logic
- **Khuyến nghị**: Dùng **Optimistic Locking** + **Retry** cho high-traffic

### 5.2. Distributed System
- Nếu có nhiều server (load balancer) → **Bắt buộc** dùng **Distributed Lock** (Redis)
- Nếu chỉ 1 server → **Pessimistic Locking** đủ

### 5.3. User Experience
- **Thông báo rõ ràng**: "Phòng đã được đặt bởi khách khác, vui lòng chọn phòng khác"
- **Tự động retry**: Nếu conflict, tự động retry 1-2 lần trước khi thông báo
- **Real-time update**: Cập nhật availability real-time để user biết sớm

### 5.4. Testing
- **Load Testing**: Test với 100+ concurrent users đặt cùng 1 phòng
- **Stress Testing**: Test với 1000+ requests/second
- **Chaos Testing**: Test khi database slow, network timeout

---

## 6. KẾT LUẬN

Race Condition là vấn đề **phổ biến và nghiêm trọng** trong hệ thống booking. Giải pháp cần **kết hợp nhiều lớp** (Database, Application, Business Logic, Frontend) để đảm bảo:

1. **Consistency**: Không bao giờ overbooking
2. **Performance**: Không blocking quá lâu
3. **User Experience**: Thông báo rõ ràng, tự động retry
4. **Reliability**: Có monitoring và alerting

**Khuyến nghị cho VBOOKING**: Bắt đầu với **Phase 1** (cơ bản), sau đó nâng cấp lên **Phase 2** (nâng cao) khi có traffic cao.


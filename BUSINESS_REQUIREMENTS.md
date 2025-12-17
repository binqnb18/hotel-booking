# VBOOKING - Tài Liệu Business Requirements

## 1. TỔNG QUAN DỰ ÁN

**VBOOKING** là một hệ thống OTA (Online Travel Agency) cho phép khách hàng đặt phòng khách sạn trực tuyến, tương tự Agoda/Booking.com nhưng tập trung vào thị trường Việt Nam. Hệ thống bao gồm 3 phía chính:

- **Client (Guest)**: Khách hàng đặt phòng
- **Partner (Hotel Owner/Staff)**: Chủ khách sạn/quản lý khách sạn
- **Admin**: Quản trị viên hệ thống VBOOKING

---

## 2. CÁC VAI TRÒ (USER ROLES) VÀ QUYỀN HẠN

### 2.1. Guest (Khách hàng)
- **Quyền truy cập**: 
  - Xem danh sách khách sạn, tìm kiếm, lọc
  - Xem chi tiết khách sạn, phòng, đánh giá
  - So sánh phòng
  - Đặt phòng (bắt buộc đăng nhập)
  - Thanh toán (MoMo, VNPay, thẻ ngân hàng, QR Code)
  - Quản lý đặt phòng cá nhân (xem, hủy)
  - Đánh giá khách sạn sau check-out
  - Nhận voucher/khuyến mãi
  - Chat với partner/admin
  - Xem hóa đơn

### 2.2. Partner (Chủ khách sạn/Nhân viên khách sạn)
- **Quyền truy cập**:
  - Chỉ xem/quản lý dữ liệu của **khách sạn của mình** (scope: `hotelId`)
  - Dashboard với metrics (doanh thu, occupancy, check-in/out hôm nay)
  - Quản lý đặt phòng (xem, check-in, check-out, hủy)
  - Quản lý phòng vật lý (trạng thái: Available, Occupied, Dirty, Maintenance)
  - Quản lý loại phòng (thêm/sửa/xóa, giá, tiện ích)
  - Lịch phòng trống (calendar view)
  - Tài chính/Thanh toán (doanh thu, hoa hồng, payout)
  - Đánh giá (xem, trả lời)
  - Tin nhắn (chat với guest/admin)
  - Hồ sơ khách sạn (cập nhật thông tin)
  - Khuyến mãi (xem khuyến mãi áp dụng cho khách sạn mình)

### 2.3. Admin (Quản trị viên hệ thống)
- **Quyền truy cập**:
  - **Full access** toàn hệ thống
  - Dashboard tổng quan (KPIs, metrics, charts)
  - Quản lý khách sạn:
    - Duyệt/từ chối khách sạn mới (KYC: CMND/CCCD, GPKD, hợp đồng)
    - Xem/sửa/xóa khách sạn
    - Khóa/mở khóa khách sạn
    - Quản lý hợp đồng & KYC
  - Quản lý đặt phòng (xem tất cả, filter, export)
  - Quản lý phòng (xem tất cả khách sạn)
  - Quản lý người dùng (guest, partner, admin)
  - Tài chính:
    - Doanh thu toàn hệ thống
    - Hoa hồng OTA (commission)
    - Payout cho partner (duyệt, chuyển tiền)
    - Chi phí (advertising, salary, server, gateway_fee, marketing, office, other)
    - Hóa đơn
  - Khuyến mãi & Voucher (tạo, quản lý, theo dõi hiệu quả)
  - Đánh giá (duyệt, ẩn, xóa, trả lời)
  - Tin nhắn (xem tất cả conversations)
  - Cài đặt hệ thống

---

## 3. WORKFLOW CHÍNH

### 3.1. Workflow Đặt Phòng Của Guest (Client)

```
1. Khách truy cập trang chủ VBOOKING
2. Tìm kiếm: địa điểm + ngày check-in/check-out + số người
3. Hệ thống hiển thị danh sách khách sạn + filter (giá, sao, tiện ích, khoảng cách)
4. Khách click "Xem chi tiết" → xem ảnh, mô tả, đánh giá, bản đồ, loại phòng
5. Khách chọn loại phòng + số lượng + so sánh phòng (nếu cần)
6. Click "Đặt phòng" → bắt buộc đăng nhập (nếu chưa)
7. Nhập thông tin khách + áp dụng voucher/khuyến mãi (nếu có)
8. Chuyển đến trang thanh toán:
   - Tính tổng: giá phòng × số đêm + phụ phí (VAT, phí dịch vụ) - discount
   - Chọn phương thức: MoMo / VNPay / Thẻ ngân hàng / QR Code
9. Backend gọi gateway thanh toán → khách redirect sang gateway
10. Callback từ gateway:
    - Thành công → cập nhật bookings.status = 'paid'
    - Gửi email/SMS xác nhận + mã booking (BK25120015)
    - Giữ phòng tạm 5 phút nếu thanh toán thất bại
11. Partner nhận booking mới qua dashboard/tin nhắn
```

**Trạng thái Booking**:
- `pending_payment`: Chờ thanh toán
- `paid`: Đã thanh toán
- `confirmed`: Đã xác nhận (partner xác nhận)
- `checked_in`: Đã nhận phòng
- `checked_out`: Đã trả phòng
- `cancelled`: Đã hủy
- `no_show`: Không đến

### 3.2. Workflow Check-in/Check-out Của Partner

```
1. Partner đăng nhập dashboard
2. Vào "Đặt phòng" → tab "Hôm nay" (check-in/check-out hôm nay)
3. Tìm mã booking khách đưa (hoặc tên khách)
4. Click "Check-in + Gán phòng":
   - Chọn phòng trống (Available) từ danh sách
   - Cập nhật trạng thái booking: checked_in
   - Cập nhật trạng thái phòng: Occupied
   - Gửi SMS cho khách "Đã nhận phòng thành công"
5. Khách nhận phòng
6. Ngày check-out → Partner nhấn "Check-out":
   - Cập nhật trạng thái booking: checked_out
   - Cập nhật trạng thái phòng: Dirty (cần dọn)
   - Gửi link đánh giá + SMS cho khách
   - Sau khi dọn xong → phòng chuyển về Available
```

### 3.3. Workflow Duyệt Khách Sạn Mới Của Admin

```
1. Partner đăng ký tài khoản + upload KYC:
   - CMND/CCCD
   - Giấy phép kinh doanh (GPKD)
   - Hợp đồng ký tay + đóng dấu
2. Status: pending → Admin nhận thông báo
3. Admin vào "Quản lý khách sạn" → tab "Khách sạn mới (pending)"
4. Xem chi tiết:
   - Thông tin khách sạn (tên, địa chỉ, chủ sở hữu, email, SĐT, số sao)
   - Hợp đồng & KYC (tải file, xem từng file)
   - Ảnh & tiện ích
5. Admin quyết định:
   - Duyệt → status = approved
     - Gửi email/SMS chào mừng partner
     - Realtime notification
     - Lưu audit log
   - Từ chối → nhập lý do bắt buộc
     - Gửi email cho partner với lý do
     - Lưu audit log
   - Yêu cầu bổ sung → gửi thông báo realtime + email
     - Partner upload lại file
     - Lưu audit log
```

**Trạng thái KYC**:
- `pending`: Chờ duyệt
- `approved`: Đã duyệt
- `rejected`: Từ chối

**Trạng thái Khách sạn**:
- `pending`: Chờ duyệt
- `approved`: Đã duyệt
- `suspended`: Tạm khóa
- `rejected`: Từ chối

### 3.4. Workflow Tạo & Áp Dụng Khuyến Mãi (Admin)

```
1. Admin vào "Khuyến mãi & Voucher"
2. Tạo deal mới:
   - Tên khuyến mãi
   - Loại giảm: % hoặc số tiền cố định
   - Giá trị giảm
   - Quota (số lượng sử dụng tối đa)
   - Thời gian (startDate, endDate)
   - Banner ảnh
   - Áp dụng cho: tất cả / khách sạn cụ thể / loại phòng cụ thể
3. Status: active → hiển thị trên trang chủ Guest
4. Khách click deal → filter tự động khách sạn áp dụng
5. Khách đặt phòng → giá tự động giảm (áp dụng voucher)
6. Booking thành công → lưu promo_id + discount_amount vào booking
7. Admin báo cáo hiệu quả deal (số lần dùng, doanh thu tăng)
```

**Trạng thái Promotion**:
- `draft`: Nháp
- `active`: Đang hoạt động
- `paused`: Tạm dừng
- `expired`: Hết hạn

### 3.5. Workflow Payout Cho Partner (Admin)

```
1. Cuối tháng → hệ thống tự động tính payout:
   - Tổng doanh thu tháng của partner
   - Hoa hồng OTA (ví dụ: 15%)
   - Số tiền partner nhận = doanh thu - hoa hồng
2. Admin vào "Tài chính" → tab "Payout"
3. Xem danh sách payout theo kỳ (tháng/quý)
4. Duyệt payout:
   - Xem breakdown (doanh thu, hoa hồng, số tiền nhận)
   - Chuyển tiền vào tài khoản ngân hàng partner
   - Cập nhật status: paid
5. Gửi email/SMS cho partner "Đã nhận payout"
6. Lưu audit log
```

**Trạng thái Payout**:
- `calculated`: Đã tính toán
- `pending_approval`: Chờ duyệt
- `approved`: Đã duyệt
- `paid`: Đã chuyển tiền
- `failed`: Thất bại

### 3.6. Workflow Thanh Toán

```
1. Khách chọn phòng và số lượng
2. Áp dụng voucher/khuyến mãi nếu có
3. Tính tổng tiền:
   - Giá phòng × số đêm
   - + Phụ phí (thuế VAT, phí dịch vụ)
   - - Discount (voucher/khuyến mãi)
   - = Total payable
4. Chọn phương thức thanh toán:
   - MoMo
   - VNPay
   - Thẻ ngân hàng
   - QR Code
5. Backend gọi gateway thanh toán → khách redirect sang gateway
6. Kiểm tra kết quả thanh toán (callback từ gateway):
   - Thành công:
     - Cập nhật bookings.status = 'paid'
     - Gửi email/SMS xác nhận + mã booking
     - Partner nhận booking mới
   - Thất bại:
     - Trở về trang thanh toán → thông báo lỗi
     - Giữ phòng tạm 5 phút (rooms_holds)
     - Khách có thể thử lại
```

**Trạng thái Payment**:
- `paid`: Đã thanh toán
- `pending`: Chờ thanh toán
- `failed`: Thất bại
- `refunded`: Đã hoàn tiền
- `cancelled`: Đã hủy

### 3.7. Workflow Xử Lý Khiếu Nại

```
1. Khách/Partner gửi khiếu nại qua:
   - Form "Quản lý đặt phòng cá nhân" (guest)
   - Chat (guest/partner)
   - Email
2. Admin nhận thông báo (dashboard/tin nhắn)
3. Phân loại khiếu nại:
   - Hoàn tiền
   - Đánh giá giả mạo
   - Lỗi thanh toán
   - Vi phạm bảo mật
   - Hủy tập thể
4. Kiểm tra log + chứng cứ:
   - bookings (lịch sử đặt phòng)
   - reviews (đánh giá)
   - payments (thanh toán)
   - audit_logs (nhật ký hệ thống)
5. Xử lý:
   - Hoàn tiền: update payments.refund_amount
   - Ẩn review: reviews.is_hidden = true
   - Khóa user: users.is_active = false
   - Từ chối: gửi lý do cho bên khiếu nại
6. Gửi email/SMS xác nhận xử lý
7. Lưu log xử lý (audit_logs) để báo cáo sau
```

**SLA (Service Level Agreement)**:
- Duyệt KYC: 48 giờ
- Payout: 7 ngày sau cuối tháng
- Xử lý khiếu nại: 24-48 giờ

---

## 4. CẤU TRÚC DỮ LIỆU CHÍNH

### 4.1. User (Người dùng)
- `id`: ID người dùng
- `name`: Tên
- `email`: Email
- `phone`: Số điện thoại
- `role`: `guest` | `partner` | `admin`
- `status`: `active` | `locked` | `deleted`
- `hotel`: ID khách sạn (nếu là partner)
- `avatar`: Ảnh đại diện
- `permissions`: Danh sách quyền

### 4.2. Hotel (Khách sạn)
- `id`: ID khách sạn
- `name`: Tên khách sạn
- `owner`: Chủ sở hữu
- `city`: Thành phố
- `stars`: Số sao (1-5)
- `address`: Địa chỉ
- `description`: Mô tả
- `images`: Danh sách ảnh
- `amenities`: Tiện ích (WiFi, Pool, Gym, ...)
- `status`: `pending` | `approved` | `suspended` | `rejected`
- `submittedDate`: Ngày nộp
- `monthlyRevenue`: Doanh thu tháng
- `bankInfo`: Thông tin ngân hàng (số tài khoản, tên ngân hàng, chủ tài khoản)

### 4.3. Room Type (Loại phòng)
- `id`: ID loại phòng
- `name`: Tên loại phòng (ví dụ: "Deluxe Sea View")
- `hotelId`: ID khách sạn
- `description`: Mô tả
- `maxOccupancy`: Số người tối đa
- `bedType`: Loại giường ("King", "Queen", "Twin", "Family")
- `size`: Diện tích ("28 m²")
- `images`: Danh sách ảnh
- `amenities`: Tiện ích phòng
- `basePrice`: Giá cơ bản (VNĐ)
- `totalRooms`: Tổng số phòng
- `availableRooms`: Số phòng trống

### 4.4. Physical Room (Phòng vật lý)
- `id`: ID phòng
- `roomNumber`: Số phòng ("501", "502")
- `roomTypeId`: ID loại phòng
- `status`: `Available` | `Occupied` | `Dirty` | `Maintenance`
- `currentBookingId`: ID booking hiện tại
- `currentBookingCode`: Mã booking ("BK25120015")
- `currentGuestName`: Tên khách
- `housekeepingStatus`: Trạng thái dọn phòng ("Sạch", "Cần dọn", "Đang dùng")
- `lastCleaned`: Ngày dọn cuối

### 4.5. Booking (Đặt phòng)
- `id`: ID booking
- `code`: Mã booking ("BK25120015")
- `guestId`: ID khách
- `hotelId`: ID khách sạn
- `roomTypeId`: ID loại phòng
- `checkIn`: Ngày check-in
- `checkOut`: Ngày check-out
- `adults`: Số người lớn
- `children`: Số trẻ em
- `totalAmount`: Tổng tiền
- `discountAmount`: Số tiền giảm
- `finalAmount`: Số tiền cuối cùng
- `status`: `pending_payment` | `paid` | `confirmed` | `checked_in` | `checked_out` | `cancelled` | `no_show`
- `paymentStatus`: `paid` | `pending` | `failed` | `refunded`
- `paymentMethod`: Phương thức thanh toán
- `promoId`: ID khuyến mãi (nếu có)
- `voucherCode`: Mã voucher (nếu có)
- `createdAt`: Ngày tạo

### 4.6. Payment (Thanh toán)
- `id`: ID thanh toán
- `bookingId`: ID booking
- `amount`: Số tiền
- `status`: `paid` | `pending` | `failed` | `refunded`
- `method`: Phương thức (MoMo, VNPay, credit_card, ...)
- `gatewayResponse`: Response từ gateway
- `refundAmount`: Số tiền hoàn (nếu có)
- `paidAt`: Ngày thanh toán

### 4.7. Promotion (Khuyến mãi)
- `id`: ID khuyến mãi
- `name`: Tên khuyến mãi
- `description`: Mô tả
- `discountType`: `percent` | `fixed`
- `discountValue`: Giá trị giảm
- `startDate`: Ngày bắt đầu
- `endDate`: Ngày kết thúc
- `quota`: Số lượng tối đa
- `used`: Số lượng đã dùng
- `status`: `draft` | `active` | `paused` | `expired`
- `applyFor`: `all` | `hotel` | `roomType`
- `hotels`: Danh sách khách sạn áp dụng
- `roomTypes`: Danh sách loại phòng áp dụng
- `banner`: Ảnh banner

### 4.8. Review (Đánh giá)
- `id`: ID đánh giá
- `hotelId`: ID khách sạn
- `guestId`: ID khách
- `bookingId`: ID booking
- `rating`: Số sao (1-5)
- `content`: Nội dung đánh giá
- `images`: Ảnh đính kèm
- `status`: `approved` | `pending` | `flagged` | `replied`
- `reply`: Trả lời từ partner/admin
- `replyAt`: Ngày trả lời
- `isHidden`: Ẩn đánh giá (nếu vi phạm)
- `auditTrail`: Lịch sử xử lý

### 4.9. Payout (Chi trả cho partner)
- `id`: ID payout
- `period`: Kỳ ("11/2025")
- `hotelId`: ID khách sạn
- `totalRevenue`: Tổng doanh thu
- `commissionRate`: Tỷ lệ hoa hồng (0.15 = 15%)
- `commissionAmount`: Số tiền hoa hồng
- `transferAmount`: Số tiền chuyển cho partner
- `status`: `calculated` | `pending_approval` | `approved` | `paid` | `failed`
- `transferDate`: Ngày chuyển tiền
- `bankInfo`: Thông tin ngân hàng
- `breakdown`: Chi tiết từng booking

### 4.10. Message (Tin nhắn)
- `id`: ID tin nhắn
- `conversationId`: ID cuộc trò chuyện
- `sender`: `guest` | `partner` | `admin`
- `senderId`: ID người gửi
- `senderName`: Tên người gửi
- `content`: Nội dung
- `timestamp`: Thời gian
- `isRead`: Đã đọc chưa
- `isSystemMessage`: Tin nhắn hệ thống
- `systemType`: Loại tin nhắn hệ thống (`payout`, `refund`, `approval`, `booking_update`)
- `images`: Ảnh đính kèm
- `files`: File đính kèm

### 4.11. Audit Log (Nhật ký hệ thống)
- `id`: ID log
- `userId`: ID người thực hiện
- `action`: Hành động ("approve_hotel", "reject_hotel", "check_in", "check_out", ...)
- `actor`: Tên người thực hiện
- `resourceType`: Loại tài nguyên ("hotel", "booking", "payout", ...)
- `resourceId`: ID tài nguyên
- `timestamp`: Thời gian
- `details`: Chi tiết (JSON)
- `ipAddress`: Địa chỉ IP
- `userAgent`: User agent

---

## 5. BUSINESS RULES (QUY TẮC NGHIỆP VỤ)

### 5.1. Quyền và Scope
- **Partner**: Chỉ xem/quản lý dữ liệu của `hotelId` của mình
- **Client**: Chỉ xem/quản lý booking của chính họ
- **Admin**: Full access toàn hệ thống

### 5.2. Trạng thái chuẩn hóa
- **Booking**: `pending_payment` → `paid` → `confirmed` → `checked_in` → `checked_out` / `cancelled` / `no_show`
- **KYC**: `pending` → `approved` / `rejected`
- **Payout**: `calculated` → `pending_approval` → `approved` → `paid` / `failed`
- **Promotion**: `draft` → `active` / `paused` / `expired`
- **Hotel**: `pending` → `approved` / `rejected` / `suspended`

### 5.3. Xác nhận hành động nhạy cảm
Các hành động sau **bắt buộc** có dialog confirm + toast:
- Check-in/check-out
- Hủy booking
- Duyệt/từ chối KYC
- Duyệt payout
- Xóa/ẩn review
- Khóa/mở khóa khách sạn
- Xóa khách sạn

### 5.4. Thời gian và giữ chỗ
- **Giữ phòng tạm**: 5 phút khi thanh toán (nếu thất bại, tự động release)
- **SLA duyệt KYC**: 48 giờ
- **SLA payout**: 7 ngày sau cuối tháng
- **SLA xử lý khiếu nại**: 24-48 giờ

### 5.5. KYC Checklist
Partner phải upload đủ:
- CMND/CCCD (mặt trước + mặt sau)
- Giấy phép kinh doanh (GPKD)
- Hợp đồng ký tay + đóng dấu

Mỗi file có trạng thái riêng: `pending` | `approved` | `rejected` + lý do reject

### 5.6. Promo Rules
- Điều kiện áp dụng: tất cả / khách sạn cụ thể / loại phòng cụ thể
- Quota: số lần sử dụng tối đa
- Log số lần dùng
- Đảm bảo áp dụng giá VNĐ và hiển thị rõ phí/thuế

### 5.7. Payout Rules
- Breakdown: doanh thu / hoa hồng / thuế / số tiền nhận
- Trạng thái duyệt trả: `pending_approval` → `approved` → `paid`
- Thông báo cho partner khi `paid` / `failed`

### 5.8. Audit Log Rules
- Ghi log tất cả hành động quan trọng:
  - Ai làm gì (userId, action)
  - Tài nguyên nào (resourceType, resourceId)
  - Khi nào (timestamp)
  - Kết quả (details)
- **Không log** dữ liệu nhạy cảm (password, số thẻ, ...)

---

## 6. TÍNH NĂNG ĐẶC BIỆT

### 6.1. So sánh phòng
- Khách có thể chọn nhiều loại phòng để so sánh
- Hiển thị: giá, diện tích, tiện ích, chính sách hủy, ...

### 6.2. Tìm kiếm nâng cao
- Filter: giá, số sao, tiện ích, khoảng cách, đánh giá
- Sort: giá tăng/giảm, đánh giá, khoảng cách

### 6.3. Đánh giá và phản hồi
- Khách đánh giá sau check-out (1-5 sao, nội dung, ảnh)
- Partner/admin có thể trả lời đánh giá
- Admin có thể ẩn/xóa đánh giá vi phạm

### 6.4. Tin nhắn realtime
- Chat giữa guest ↔ partner
- Chat giữa guest ↔ admin
- Chat giữa partner ↔ admin
- Tin nhắn hệ thống (payout, refund, approval, booking_update)

### 6.5. Báo cáo và Analytics
- **Admin**: Doanh thu toàn hệ thống, hoa hồng, payout, chi phí
- **Partner**: Doanh thu khách sạn, occupancy, check-in/out, payout

### 6.6. Export dữ liệu
- Export Excel: bookings, hotels, reviews, financials, ...

---

## 7. TÍCH HỢP THANH TOÁN

### 7.1. Cổng thanh toán hỗ trợ
- **MoMo**: Ví điện tử
- **VNPay**: Cổng thanh toán Việt Nam
- **Thẻ ngân hàng**: Visa, Mastercard, JCB
- **QR Code**: Quét mã thanh toán

### 7.2. Quy trình thanh toán
1. Frontend gửi request đến backend với thông tin booking
2. Backend tính toán: subtotal - discount = total_payable
3. Backend tích hợp SDK MoMo/VNPay, tạo QR hoặc redirect URL
4. Khách redirect sang gateway
5. Callback từ gateway → cập nhật `payments.status`
6. Gửi email/SMS xác nhận

### 7.3. Xử lý lỗi
- Thanh toán thất bại → giữ phòng tạm 5 phút
- Retry: khách có thể thử lại
- Timeout: tự động release phòng

---

## 8. BẢO MẬT

### 8.1. Authentication
- JWT (AccessToken) + RefreshToken
- HttpOnly Secure Cookies
- Axios Interceptors cho token refresh

### 8.2. Authorization
- Role-Based Access Control (RBAC)
- Scope-based authorization (partner chỉ truy cập `hotelId` của mình)

### 8.3. Audit Log
- Ghi log tất cả hành động quan trọng
- Không log dữ liệu nhạy cảm

---

## 9. ĐỊNH DẠNG VÀ NGÔN NGỮ

### 9.1. Ngôn ngữ
- **UI**: Tiếng Việt (100%)
- **Currency**: VNĐ (₫)
- **Date format**: DD/MM/YYYY, HH:mm

### 9.2. Định dạng tiền tệ
- Hiển thị: `₫1.234.567`
- Input: số nguyên (không có dấu phẩy)
- Tính toán: số nguyên (VNĐ)

---

## 10. THÔNG BÁO

### 10.1. Email
- Xác nhận đặt phòng
- Xác nhận thanh toán
- Chào mừng partner (sau khi duyệt)
- Thông báo payout
- Thông báo hủy booking
- Link đánh giá (sau check-out)

### 10.2. SMS
- Xác nhận đặt phòng
- Xác nhận thanh toán
- Check-in thành công
- Check-out + link đánh giá
- Thông báo payout

### 10.3. Realtime Notification
- Booking mới (partner)
- KYC cần duyệt (admin)
- Payout đã chuyển (partner)
- Tin nhắn mới

---

## 11. KẾT LUẬN

VBOOKING là một hệ thống OTA hoàn chỉnh với 3 phía (Client, Partner, Admin), đảm bảo:
- **Tính nhất quán**: Trạng thái, quyền, scope được chuẩn hóa
- **Tính minh bạch**: Audit log, thông báo đầy đủ
- **Tính bảo mật**: JWT, RBAC, scope-based authorization
- **Tính tiện lợi**: Tích hợp thanh toán địa phương (MoMo, VNPay), UI tiếng Việt, currency VNĐ
- **Tính chuyên nghiệp**: SLA rõ ràng, workflow logic, xử lý khiếu nại

Hệ thống phù hợp cho team 3-4 người phát triển, thời gian ước tính 3-4 tháng (middle-level developers).



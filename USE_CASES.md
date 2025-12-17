# VBOOKING – 4.1.3 Mô tả trường hợp sử dụng (Use case descriptions)

Tài liệu này chuẩn hoá cách viết **Use Case Description** cho hệ thống VBOOKING (3 phía: Client/Partner/Admin). Bạn có thể dùng y hệt cấu trúc bảng 4.1.x như bạn đang làm.

---

## A. Hướng dẫn tạo file Word (khuyến nghị)

- **Bước 1**: Mở Word → tạo mục: `4.1.3 Mô tả trường hợp sử dụng`.
- **Bước 2**: Mỗi use case tương ứng **1 bảng** (Table).  
  - Dùng Table 2 cột: trái là “Thuộc tính”, phải là “Nội dung”.
- **Bước 3**: Đánh số bảng theo thứ tự: `Bảng 4.1.1`, `Bảng 4.1.2`… (Word caption).
- **Bước 4**: Phần “Kịch bản (Scenario)” nên tách:
  - **Main flow** (luồng chính)
  - **Alternative flow** (luồng thay thế – nếu có)
  - **Exceptions** (ngoại lệ)
- **Bước 5**: Cuối mỗi bảng nên có thêm 2 dòng (nên có):
  - **Hậu điều kiện (Postconditions)**
  - **Dữ liệu/Trạng thái liên quan (Data/Status)**

---

## B. Chuẩn hoá “Đúng chưa?” cho format bạn đưa

Bạn liệt kê như ví dụ (Log In, Search, Filter, View details, Book, Payment…) là **đúng hướng** cho mục 4.1.3.  
Điểm nên chỉnh để “đúng chất Use Case” hơn:

- **Diễn viên chính (Primary Actor)**: nên rõ vai trò theo màn hình (Guest/Partner/Admin).  
  - Với “Đăng nhập”, có thể ghi: *Guest/Partner/Admin (tất cả người dùng)*.
- **Điều kiện trước (Preconditions)**: ghi rõ “đã có tài khoản”, “tài khoản đã được duyệt (Partner)”, “booking ở trạng thái paid…”  
- **Ngoại lệ (Exceptions)**: nên là các lỗi/điều kiện thất bại thực tế (sai mật khẩu, tài khoản khóa, payment callback thất bại, hết phòng…).
- **Hậu điều kiện (Postconditions)**: mô tả “hệ thống đã tạo/cập nhật cái gì”.

---

## C. Danh sách Use Case đề xuất (đầy đủ theo dự án VBOOKING)

### C1) Client (Guest)
- UC-C01 Đăng ký tài khoản
- UC-C02 Đăng nhập
- UC-C03 Đăng xuất
- UC-C04 Quên mật khẩu / Khôi phục mật khẩu (OTP/email)
- UC-C05 Tìm kiếm khách sạn
- UC-C06 Lọc kết quả tìm kiếm
- UC-C07 Sắp xếp kết quả tìm kiếm
- UC-C08 Xem chi tiết khách sạn
- UC-C09 Xem danh sách loại phòng & giá
- UC-C10 So sánh phòng
- UC-C11 Tạo đặt phòng (Book Room)
- UC-C12 Áp dụng voucher/khuyến mãi
- UC-C13 Thanh toán (MoMo/VNPay/Thẻ/QR)
- UC-C14 Xác nhận đặt phòng (System)
- UC-C15 Xem đặt phòng của tôi
- UC-C16 Xem chi tiết đặt phòng
- UC-C17 Hủy đặt phòng
- UC-C18 Nhận thông báo (email/SMS/realtime)
- UC-C19 Gửi tin nhắn cho khách sạn / CSKH
- UC-C20 Đánh giá khách sạn sau check-out
- UC-C21 Quản lý hồ sơ cá nhân (profile)

### C2) Partner (Chủ khách sạn/Nhân viên)
- UC-P01 Đăng nhập đối tác
- UC-P02 Quản lý hồ sơ khách sạn (Hotel Profile)
- UC-P03 Upload hồ sơ KYC/Hợp đồng
- UC-P04 Quản lý loại phòng (Room Types) – thêm/sửa/xóa
- UC-P05 Quản lý phòng vật lý (Physical Rooms) – thêm/sửa/xóa
- UC-P06 Cập nhật trạng thái phòng (Available/Occupied/Dirty/Maintenance)
- UC-P07 Xem danh sách đặt phòng (theo tab)
- UC-P08 Xác nhận/Từ chối booking (SLA 24h – nếu có)
- UC-P09 Check-in & gán phòng
- UC-P10 Check-out & cập nhật housekeeping
- UC-P11 Xem tài chính / doanh thu / payout
- UC-P12 Xem & phản hồi đánh giá
- UC-P13 Chat/tin nhắn với guest/admin
- UC-P14 Export dữ liệu (booking/financial…)

### C3) Admin
- UC-A01 Đăng nhập admin
- UC-A02 Quản lý khách sạn (CRUD + khóa/mở khóa)
- UC-A03 Duyệt khách sạn mới (KYC) – duyệt/từ chối/yêu cầu bổ sung
- UC-A04 Quản lý đặt phòng toàn hệ thống (xem/lọc/export)
- UC-A05 Quản lý phòng toàn hệ thống (xem/lọc)
- UC-A06 Quản lý người dùng (guest/partner/admin) – khóa/mở khóa
- UC-A07 Quản lý khuyến mãi/voucher (CRUD + activate/pause)
- UC-A08 Duyệt payout & chuyển tiền (approve/paid/failed)
- UC-A09 Quản lý chi phí/hóa đơn (financial)
- UC-A10 Quản lý đánh giá (ẩn/xóa/flag)
- UC-A11 Quản lý khiếu nại (phân loại, xử lý, hoàn tiền/ẩn review/khóa user)
- UC-A12 Quản lý tin nhắn/conversations toàn hệ thống
- UC-A13 Cài đặt hệ thống (config cơ bản)
- UC-A14 Xem audit log (ai làm gì/khi nào/ở đâu)

---

## D. Use Case Description (mẫu bảng chuẩn để bạn copy)

> Bạn có thể copy bảng mẫu này và thay nội dung từng use case.

| Trường hợp sử dụng (Use Case) | [Tên use case] |
| --- | --- |
| Diễn viên chính (Primary Actor) |  |
| Mục tiêu trong ngữ cảnh (Goal In Context) |  |
| Điều kiện trước (Preconditions) |  |
| Kích hoạt (Trigger) |  |
| Kịch bản (Scenario) | **Main flow**: 1) … <br> 2) … <br><br> **Alternative flow** (nếu có): A1) … <br><br> **Exceptions**: E1) … |
| Hậu điều kiện (Postconditions) |  |
| Dữ liệu/Trạng thái liên quan (Data/Status) |  |

---

## E. Các bảng use case (đã bổ sung các trường hợp còn thiếu)

### Bảng 4.1.1 – Đăng Ký (Register)
| Trường hợp sử dụng (Use Case) | Đăng Ký (Register) |
| --- | --- |
| Diễn viên chính (Primary Actor) | Khách hàng / Chủ khách sạn |
| Mục tiêu trong ngữ cảnh (Goal In Context) | Tạo tài khoản để sử dụng hệ thống |
| Điều kiện trước (Preconditions) | Email/SĐT chưa tồn tại |
| Kích hoạt (Trigger) | Chọn “Đăng ký” |
| Kịch bản (Scenario) | **Main flow**: 1) Nhập họ tên + email/SĐT + mật khẩu <br> 2) Hệ thống gửi OTP/email xác thực <br> 3) Người dùng nhập OTP <br> 4) Tạo tài khoản + đăng nhập tự động (hoặc chuyển trang đăng nhập) <br><br> **Alternative flow**: A1) Đăng ký bằng Google/FB (nếu có) → tạo tài khoản nhanh <br><br> **Exceptions**: E1) OTP hết hạn → gửi lại OTP <br> E2) Email/SĐT đã tồn tại → báo lỗi |
| Hậu điều kiện (Postconditions) | User được tạo ở trạng thái active (Guest) / pending_approval (Partner tuỳ mô hình) |
| Dữ liệu/Trạng thái liên quan (Data/Status) | `users.role`, `users.status` |

### Bảng 4.1.2 – Đăng Nhập (Log In)
| Trường hợp sử dụng (Use Case) | Đăng Nhập (Log In) |
| --- | --- |
| Diễn viên chính (Primary Actor) | Khách hàng / Chủ khách sạn / Admin |
| Mục tiêu trong ngữ cảnh (Goal In Context) | Xác thực và truy cập đúng khu vực hệ thống |
| Điều kiện trước (Preconditions) | Tài khoản tồn tại, không bị khóa |
| Kích hoạt (Trigger) | Chọn “Đăng nhập” |
| Kịch bản (Scenario) | **Main flow**: 1) Nhập email/SĐT + mật khẩu <br> 2) Hệ thống xác thực <br> 3) Cấp JWT (access + refresh) <br> 4) Điều hướng đúng dashboard theo role (Client/Partner/Admin) <br><br> **Alternative flow**: A1) 2FA/OTP (Partner/Admin nếu bật) <br><br> **Exceptions**: E1) Sai thông tin → báo lỗi <br> E2) Tài khoản bị khóa → từ chối + hướng dẫn liên hệ <br> E3) Partner chưa được duyệt khách sạn/KYC → từ chối + thông báo trạng thái |
| Hậu điều kiện (Postconditions) | Phiên đăng nhập hợp lệ được tạo |
| Dữ liệu/Trạng thái liên quan (Data/Status) | JWT, `users.status`, (Partner) `hotel.status`/KYC |

### Bảng 4.1.3 – Đăng Xuất (Log Out)
| Trường hợp sử dụng (Use Case) | Đăng Xuất (Log Out) |
| --- | --- |
| Diễn viên chính (Primary Actor) | Khách hàng / Partner / Admin |
| Mục tiêu trong ngữ cảnh (Goal In Context) | Kết thúc phiên đăng nhập an toàn |
| Điều kiện trước (Preconditions) | Đang đăng nhập |
| Kích hoạt (Trigger) | Chọn “Đăng xuất” |
| Kịch bản (Scenario) | **Main flow**: 1) Người dùng chọn đăng xuất <br> 2) Hệ thống thu hồi refresh token (nếu có) <br> 3) Xoá cookie/token client <br> 4) Điều hướng về trang đăng nhập/trang chủ |
| Hậu điều kiện (Postconditions) | Không thể gọi API yêu cầu xác thực |
| Dữ liệu/Trạng thái liên quan (Data/Status) | Refresh token revoked (nếu dùng) |

### Bảng 4.1.4 – Quên/Khôi phục mật khẩu (Forgot/Reset Password)
| Trường hợp sử dụng (Use Case) | Quên mật khẩu (Forgot Password) |
| --- | --- |
| Diễn viên chính (Primary Actor) | Khách hàng / Partner / Admin |
| Mục tiêu trong ngữ cảnh (Goal In Context) | Khôi phục quyền truy cập khi quên mật khẩu |
| Điều kiện trước (Preconditions) | Tài khoản tồn tại |
| Kích hoạt (Trigger) | Chọn “Quên mật khẩu” |
| Kịch bản (Scenario) | **Main flow**: 1) Nhập email/SĐT <br> 2) Hệ thống gửi OTP/link reset <br> 3) Người dùng nhập OTP/mở link <br> 4) Nhập mật khẩu mới <br> 5) Đăng nhập lại <br><br> **Exceptions**: E1) OTP hết hạn → gửi lại <br> E2) Email/SĐT không tồn tại → báo lỗi |
| Hậu điều kiện (Postconditions) | Mật khẩu mới có hiệu lực, phiên cũ bị vô hiệu (khuyến nghị) |
| Dữ liệu/Trạng thái liên quan (Data/Status) | reset_token/OTP, audit log (nếu cần) |

### Bảng 4.1.5 – Tìm kiếm khách sạn (Search Hotel)
| Trường hợp sử dụng (Use Case) | Tìm Kiếm Khách Sạn (Search Hotel) |
| --- | --- |
| Diễn viên chính (Primary Actor) | Khách hàng |
| Mục tiêu trong ngữ cảnh (Goal In Context) | Tìm khách sạn phù hợp theo tiêu chí |
| Điều kiện trước (Preconditions) | Không yêu cầu đăng nhập |
| Kích hoạt (Trigger) | Nhập địa điểm/ngày/số người và bấm tìm |
| Kịch bản (Scenario) | **Main flow**: 1) Gợi ý địa điểm real-time <br> 2) Gọi tìm kiếm theo ngày + số người <br> 3) Hiển thị danh sách + bộ lọc + sắp xếp <br><br> **Exceptions**: E1) Không có kết quả → gợi ý ngày/địa điểm khác |
| Hậu điều kiện (Postconditions) | Danh sách kết quả được hiển thị |
| Dữ liệu/Trạng thái liên quan (Data/Status) | Query: location, checkIn, checkOut, guests |

### Bảng 4.1.6 – Lọc kết quả tìm kiếm (Filter Search Results)
| Trường hợp sử dụng (Use Case) | Lọc Kết Quả (Filter Search Results) |
| --- | --- |
| Diễn viên chính (Primary Actor) | Khách hàng |
| Mục tiêu trong ngữ cảnh (Goal In Context) | Thu hẹp kết quả theo tiêu chí (giá/sao/tiện nghi/đánh giá…) |
| Điều kiện trước (Preconditions) | Đang có danh sách kết quả |
| Kích hoạt (Trigger) | Chọn bộ lọc |
| Kịch bản (Scenario) | **Main flow**: 1) Người dùng chọn filter <br> 2) Hệ thống áp dụng filter (client hoặc server) <br> 3) Cập nhật danh sách <br><br> **Exceptions**: E1) Không còn kết quả → hiển thị “Không có kết quả phù hợp” |
| Hậu điều kiện (Postconditions) | Danh sách hiển thị đúng bộ lọc |
| Dữ liệu/Trạng thái liên quan (Data/Status) | filter state |

### Bảng 4.1.7 – Sắp xếp kết quả (Sort Search Results)
| Trường hợp sử dụng (Use Case) | Sắp Xếp Kết Quả (Sort Results) |
| --- | --- |
| Diễn viên chính (Primary Actor) | Khách hàng |
| Mục tiêu trong ngữ cảnh (Goal In Context) | Sắp xếp theo giá/đánh giá/khoảng cách |
| Điều kiện trước (Preconditions) | Có kết quả tìm kiếm |
| Kích hoạt (Trigger) | Chọn kiểu sort |
| Kịch bản (Scenario) | **Main flow**: 1) Chọn sort <br> 2) Hệ thống sắp xếp và render lại danh sách |
| Hậu điều kiện (Postconditions) | Danh sách theo thứ tự mới |
| Dữ liệu/Trạng thái liên quan (Data/Status) | sort state |

### Bảng 4.1.8 – Xem chi tiết khách sạn (View Hotel Details)
| Trường hợp sử dụng (Use Case) | Xem Chi Tiết Khách Sạn (View Hotel Details) |
| --- | --- |
| Diễn viên chính (Primary Actor) | Khách hàng |
| Mục tiêu trong ngữ cảnh (Goal In Context) | Xem mô tả/ảnh/tiện ích/đánh giá/vị trí/loại phòng |
| Điều kiện trước (Preconditions) | Chọn khách sạn từ danh sách |
| Kích hoạt (Trigger) | Click khách sạn / “Xem chi tiết” |
| Kịch bản (Scenario) | **Main flow**: 1) Hiển thị ảnh + mô tả + tiện ích <br> 2) Hiển thị bản đồ/điểm đánh giá <br> 3) Hiển thị danh sách loại phòng + giá theo ngày <br><br> **Exceptions**: E1) Lỗi tải ảnh → fallback |
| Hậu điều kiện (Postconditions) | Người dùng có thể tiếp tục đặt phòng |
| Dữ liệu/Trạng thái liên quan (Data/Status) | hotel, roomTypes, reviews |

### Bảng 4.1.9 – So sánh phòng (Compare Rooms)
| Trường hợp sử dụng (Use Case) | So Sánh Phòng (Compare Rooms) |
| --- | --- |
| Diễn viên chính (Primary Actor) | Khách hàng |
| Mục tiêu trong ngữ cảnh (Goal In Context) | So sánh nhiều loại phòng để ra quyết định |
| Điều kiện trước (Preconditions) | Có ít nhất 2 loại phòng |
| Kích hoạt (Trigger) | Chọn “So sánh” ở danh sách phòng |
| Kịch bản (Scenario) | **Main flow**: 1) Chọn các loại phòng <br> 2) Hệ thống hiển thị bảng so sánh (giá/diện tích/tiện nghi/chính sách) <br><br> **Exceptions**: E1) Chỉ chọn 1 phòng → nhắc chọn thêm |
| Hậu điều kiện (Postconditions) | Người dùng chọn 1 phòng để đặt |
| Dữ liệu/Trạng thái liên quan (Data/Status) | compare list |

### Bảng 4.1.10 – Đặt phòng (Book Room)
| Trường hợp sử dụng (Use Case) | Đặt Phòng (Book Room) |
| --- | --- |
| Diễn viên chính (Primary Actor) | Khách hàng |
| Mục tiêu trong ngữ cảnh (Goal In Context) | Tạo đơn đặt phòng hợp lệ trước khi thanh toán |
| Điều kiện trước (Preconditions) | Đăng nhập |
| Kích hoạt (Trigger) | Chọn “Đặt phòng” |
| Kịch bản (Scenario) | **Main flow**: 1) Chọn loại phòng + số lượng <br> 2) Nhập thông tin khách <br> 3) Hệ thống kiểm tra availability <br> 4) Tạo booking trạng thái `pending_payment` <br> 5) Chuyển sang thanh toán <br><br> **Exceptions**: E1) Hết phòng → gợi ý phòng/khách sạn khác <br> E2) Dữ liệu không hợp lệ → báo lỗi |
| Hậu điều kiện (Postconditions) | Booking được tạo (chờ thanh toán) |
| Dữ liệu/Trạng thái liên quan (Data/Status) | booking: `pending_payment`, room hold 5 phút |

### Bảng 4.1.11 – Áp dụng voucher/khuyến mãi (Apply Promotion/Voucher)
| Trường hợp sử dụng (Use Case) | Áp Dụng Voucher/Khuyến Mãi (Apply Voucher) |
| --- | --- |
| Diễn viên chính (Primary Actor) | Khách hàng |
| Mục tiêu trong ngữ cảnh (Goal In Context) | Giảm giá hợp lệ cho booking |
| Điều kiện trước (Preconditions) | Đã có booking nháp hoặc đang ở bước thanh toán |
| Kích hoạt (Trigger) | Nhập mã voucher |
| Kịch bản (Scenario) | **Main flow**: 1) Nhập mã <br> 2) Hệ thống kiểm tra điều kiện/quota/thời gian <br> 3) Áp dụng giảm giá, cập nhật tổng tiền <br><br> **Exceptions**: E1) Voucher hết hạn/không hợp lệ/hết quota → báo lỗi |
| Hậu điều kiện (Postconditions) | booking cập nhật `discountAmount`, `finalAmount` |
| Dữ liệu/Trạng thái liên quan (Data/Status) | promotion/voucher quota |

### Bảng 4.1.12 – Thanh toán (Payment)
| Trường hợp sử dụng (Use Case) | Thanh Toán (Payment) |
| --- | --- |
| Diễn viên chính (Primary Actor) | Khách hàng |
| Mục tiêu trong ngữ cảnh (Goal In Context) | Hoàn tất thanh toán cho booking |
| Điều kiện trước (Preconditions) | Booking ở `pending_payment`, còn hiệu lực giữ phòng |
| Kích hoạt (Trigger) | Chọn phương thức thanh toán và xác nhận |
| Kịch bản (Scenario) | **Main flow**: 1) Tính tổng (VNĐ) + phí/thuế - giảm giá <br> 2) Gọi gateway (MoMo/VNPay/Thẻ/QR) <br> 3) Nhận callback thành công <br> 4) Cập nhật payment `paid`, booking `paid` <br><br> **Exceptions**: E1) Thanh toán thất bại → payment `failed`, giữ phòng 5 phút để retry <br> E2) Timeout → release hold |
| Hậu điều kiện (Postconditions) | Booking đã thanh toán thành công hoặc thất bại có thông báo |
| Dữ liệu/Trạng thái liên quan (Data/Status) | payment: `paid/pending/failed`, booking: `paid` |

### Bảng 4.1.13 – Xác nhận đặt phòng (System Confirm Booking)
| Trường hợp sử dụng (Use Case) | Xác Nhận Đặt Phòng (Confirm Booking) |
| --- | --- |
| Diễn viên chính (Primary Actor) | Hệ thống |
| Mục tiêu trong ngữ cảnh (Goal In Context) | Phát sinh mã booking và gửi thông báo sau thanh toán |
| Điều kiện trước (Preconditions) | Thanh toán thành công |
| Kích hoạt (Trigger) | Gateway callback success |
| Kịch bản (Scenario) | **Main flow**: 1) Sinh mã booking <br> 2) Gửi email/SMS xác nhận <br> 3) Thông báo realtime cho partner <br> 4) Cập nhật availability/hold release <br><br> **Exceptions**: E1) Gửi email/SMS lỗi → retry 3 lần |
| Hậu điều kiện (Postconditions) | Guest nhận xác nhận, partner nhận booking mới |
| Dữ liệu/Trạng thái liên quan (Data/Status) | notifications, audit (nếu có) |

### Bảng 4.1.14 – Quản lý đặt phòng cá nhân (Manage My Bookings)
| Trường hợp sử dụng (Use Case) | Quản Lý Đặt Phòng Cá Nhân (My Bookings) |
| --- | --- |
| Diễn viên chính (Primary Actor) | Khách hàng |
| Mục tiêu trong ngữ cảnh (Goal In Context) | Xem danh sách & chi tiết booking của mình |
| Điều kiện trước (Preconditions) | Đăng nhập |
| Kích hoạt (Trigger) | Vào “Đặt phòng của tôi” |
| Kịch bản (Scenario) | **Main flow**: 1) Hiển thị danh sách booking <br> 2) Lọc theo trạng thái <br> 3) Xem chi tiết booking |
| Hậu điều kiện (Postconditions) | Người dùng nắm được tình trạng booking |
| Dữ liệu/Trạng thái liên quan (Data/Status) | scope guestId |

### Bảng 4.1.15 – Hủy đặt phòng (Cancel Booking)
| Trường hợp sử dụng (Use Case) | Hủy Đặt Phòng (Cancel Booking) |
| --- | --- |
| Diễn viên chính (Primary Actor) | Khách hàng |
| Mục tiêu trong ngữ cảnh (Goal In Context) | Hủy booking theo chính sách và xử lý hoàn tiền (nếu áp dụng) |
| Điều kiện trước (Preconditions) | Đăng nhập, booking cho phép hủy |
| Kích hoạt (Trigger) | Bấm “Hủy” |
| Kịch bản (Scenario) | **Main flow**: 1) Hiển thị chính sách + phí hủy (nếu có) <br> 2) Người dùng xác nhận <br> 3) Cập nhật booking `cancelled` <br> 4) Hoàn tiền tự động (nếu đủ điều kiện) <br><br> **Exceptions**: E1) Quá hạn hủy → từ chối hủy |
| Hậu điều kiện (Postconditions) | Booking bị hủy, phòng được release |
| Dữ liệu/Trạng thái liên quan (Data/Status) | booking: `cancelled`, payment: `refunded` (nếu có) |

### Bảng 4.1.16 – Đánh giá khách sạn (Review Hotel)
| Trường hợp sử dụng (Use Case) | Đánh Giá Khách Sạn (Review Hotel) |
| --- | --- |
| Diễn viên chính (Primary Actor) | Khách hàng |
| Mục tiêu trong ngữ cảnh (Goal In Context) | Gửi đánh giá sau lưu trú |
| Điều kiện trước (Preconditions) | Booking đã `checked_out` |
| Kích hoạt (Trigger) | Nhận link đánh giá / vào trang booking |
| Kịch bản (Scenario) | **Main flow**: 1) Nhập số sao + nội dung + ảnh <br> 2) Gửi đánh giá <br> 3) Hệ thống cập nhật điểm trung bình <br><br> **Exceptions**: E1) Nội dung vi phạm → flagged/ẩn theo quy định |
| Hậu điều kiện (Postconditions) | Review được tạo (`pending/approved/flagged`) |
| Dữ liệu/Trạng thái liên quan (Data/Status) | review status |

---

## F. Partner use cases (bảng mô tả ngắn – bạn có thể đánh số tiếp theo)

### Partner – Quản lý hồ sơ khách sạn (Manage Hotel Profile)
| Trường hợp sử dụng (Use Case) | Quản Lý Hồ Sơ Khách Sạn (Hotel Profile) |
| --- | --- |
| Diễn viên chính (Primary Actor) | Chủ khách sạn / Nhân viên |
| Mục tiêu trong ngữ cảnh (Goal In Context) | Cập nhật thông tin khách sạn, ảnh, tiện ích, ngân hàng |
| Điều kiện trước (Preconditions) | Đăng nhập, scope đúng `hotelId` |
| Kích hoạt (Trigger) | Chọn “Hồ sơ khách sạn” |
| Kịch bản (Scenario) | **Main flow**: 1) Sửa thông tin <br> 2) Upload ảnh <br> 3) Lưu <br><br> **Exceptions**: E1) Ảnh không đạt chuẩn → báo lỗi |
| Hậu điều kiện (Postconditions) | Thông tin khách sạn được cập nhật |
| Dữ liệu/Trạng thái liên quan (Data/Status) | hotel profile, audit log (nếu bật) |

### Partner – Upload KYC/Hợp đồng
| Trường hợp sử dụng (Use Case) | Upload KYC/Hợp Đồng |
| --- | --- |
| Diễn viên chính (Primary Actor) | Chủ khách sạn |
| Mục tiêu trong ngữ cảnh (Goal In Context) | Nộp đủ hồ sơ để admin duyệt |
| Điều kiện trước (Preconditions) | Đăng nhập, khách sạn `pending` |
| Kích hoạt (Trigger) | Chọn “Hợp đồng & KYC” / “Upload hồ sơ” |
| Kịch bản (Scenario) | **Main flow**: 1) Upload CCCD/GPKD/Hợp đồng <br> 2) Hệ thống lưu file + đặt trạng thái `pending` <br> 3) Thông báo admin <br><br> **Exceptions**: E1) File sai định dạng/dung lượng → báo lỗi |
| Hậu điều kiện (Postconditions) | Hồ sơ KYC chờ admin duyệt |
| Dữ liệu/Trạng thái liên quan (Data/Status) | KYC: `pending/approved/rejected` |

### Partner – Check-in & gán phòng
| Trường hợp sử dụng (Use Case) | Check-in & Gán Phòng |
| --- | --- |
| Diễn viên chính (Primary Actor) | Partner |
| Mục tiêu trong ngữ cảnh (Goal In Context) | Nhận phòng cho khách và cập nhật trạng thái phòng/booking |
| Điều kiện trước (Preconditions) | Booking `confirmed/paid`, phòng vật lý Available |
| Kích hoạt (Trigger) | Bấm “Check-in” |
| Kịch bản (Scenario) | **Main flow**: 1) Tìm booking <br> 2) Chọn phòng trống <br> 3) Cập nhật booking `checked_in` <br> 4) Phòng `Occupied` <br> 5) Gửi SMS khách <br><br> **Exceptions**: E1) Không còn phòng trống phù hợp → từ chối thao tác |
| Hậu điều kiện (Postconditions) | Khách đã check-in thành công |
| Dữ liệu/Trạng thái liên quan (Data/Status) | booking: `checked_in`, room: `Occupied` |

### Partner – Check-out & cập nhật housekeeping
| Trường hợp sử dụng (Use Case) | Check-out |
| --- | --- |
| Diễn viên chính (Primary Actor) | Partner |
| Mục tiêu trong ngữ cảnh (Goal In Context) | Trả phòng và cập nhật phòng về trạng thái dọn dẹp |
| Điều kiện trước (Preconditions) | Booking `checked_in` |
| Kích hoạt (Trigger) | Bấm “Check-out” |
| Kịch bản (Scenario) | **Main flow**: 1) Xác nhận check-out <br> 2) Booking `checked_out` <br> 3) Phòng `Dirty` <br> 4) Gửi link đánh giá <br><br> **Exceptions**: E1) Booking không đúng trạng thái → báo lỗi |
| Hậu điều kiện (Postconditions) | Booking hoàn tất, phòng chờ dọn |
| Dữ liệu/Trạng thái liên quan (Data/Status) | booking: `checked_out`, room: `Dirty` |

---

## G. Admin use cases (bảng mô tả ngắn)

### Admin – Duyệt khách sạn mới (Approve/Reject Hotel + KYC)
| Trường hợp sử dụng (Use Case) | Duyệt Khách Sạn Mới (Hotel Approval) |
| --- | --- |
| Diễn viên chính (Primary Actor) | Admin |
| Mục tiêu trong ngữ cảnh (Goal In Context) | Duyệt/từ chối/yêu cầu bổ sung hồ sơ KYC để kích hoạt đối tác |
| Điều kiện trước (Preconditions) | Hotel/KYC ở `pending` |
| Kích hoạt (Trigger) | Admin vào “Quản lý khách sạn” tab “Pending” |
| Kịch bản (Scenario) | **Main flow**: 1) Xem chi tiết + tải file <br> 2) Chọn “Duyệt” <br> 3) Cập nhật hotel `approved`, KYC `approved` <br> 4) Gửi email/SMS + realtime <br> 5) Lưu audit log <br><br> **Alternative flow**: A1) “Yêu cầu bổ sung” → gửi thông báo + ghi lý do <br><br> **Exceptions**: E1) “Từ chối” bắt buộc nhập lý do → hotel `rejected`, KYC `rejected` |
| Hậu điều kiện (Postconditions) | Hotel được kích hoạt hoặc bị từ chối/đòi bổ sung |
| Dữ liệu/Trạng thái liên quan (Data/Status) | hotel: `pending/approved/rejected/suspended`, KYC: `pending/approved/rejected`, audit log |

### Admin – Duyệt payout (Approve Payout)
| Trường hợp sử dụng (Use Case) | Duyệt Payout |
| --- | --- |
| Diễn viên chính (Primary Actor) | Admin |
| Mục tiêu trong ngữ cảnh (Goal In Context) | Duyệt và cập nhật trạng thái chi trả cho partner |
| Điều kiện trước (Preconditions) | Payout `pending_approval` |
| Kích hoạt (Trigger) | Admin vào “Tài chính” → “Payout” |
| Kịch bản (Scenario) | **Main flow**: 1) Xem breakdown <br> 2) Duyệt → `approved` <br> 3) Chuyển tiền <br> 4) Cập nhật `paid` hoặc `failed` <br> 5) Thông báo partner + audit log |
| Hậu điều kiện (Postconditions) | Partner nhận thông báo payout |
| Dữ liệu/Trạng thái liên quan (Data/Status) | payout: `calculated/pending_approval/approved/paid/failed` |

### Admin – Xử lý khiếu nại (Complaint Handling)
| Trường hợp sử dụng (Use Case) | Xử Lý Khiếu Nại |
| --- | --- |
| Diễn viên chính (Primary Actor) | Admin |
| Mục tiêu trong ngữ cảnh (Goal In Context) | Giải quyết tranh chấp/hoàn tiền/ẩn review/khóa user có căn cứ |
| Điều kiện trước (Preconditions) | Có complaint được tạo |
| Kích hoạt (Trigger) | Admin nhận thông báo khiếu nại |
| Kịch bản (Scenario) | **Main flow**: 1) Xem chứng cứ (booking/payment/review/audit) <br> 2) Chọn hướng xử lý (refund/hide review/lock user/deny) <br> 3) Gửi thông báo kết quả <br> 4) Lưu audit log <br><br> **Exceptions**: E1) Thiếu chứng cứ → yêu cầu bổ sung |
| Hậu điều kiện (Postconditions) | Complaint được cập nhật trạng thái xử lý |
| Dữ liệu/Trạng thái liên quan (Data/Status) | complaints, audit_logs, payments/refunds |

---

## H. Gợi ý thêm use case “nên có” (nếu thầy yêu cầu chi tiết hơn)

- **UC – Refresh token / Gia hạn phiên** (System): tự động refresh access token, revoke khi logout/rotate.
- **UC – Nhận thông báo realtime**: guest/partner/admin nhận notification theo sự kiện.
- **UC – Export Excel**: ở admin/partner cho bookings/hotels/financials/reviews.
- **UC – Quản trị người dùng** (Admin): khóa/mở khóa, reset mật khẩu, phân quyền.
- **UC – Audit log viewer** (Admin): lọc theo actor/action/resource/time.
- **UC – Quản lý tin nhắn**: tạo conversation, gửi/nhận, đánh dấu đã đọc, file/ảnh đính kèm.



@'
# NHẬT KÝ TƯƠNG TÁC CÙNG AI TRONG THIẾT KẾ HỆ THỐNG AUTORIDE

## Prompt 1: Lựa chọn kiểu dữ liệu tài chính (DECIMAL vs FLOAT)
- **Câu hỏi:** Trong MySQL, tại sao các cột tài chính như security_deposit, late_fee, damage_fee bắt buộc phải dùng DECIMAL(12,2) mà không dùng FLOAT hay DOUBLE?
- **Phản hồi từ AI:** Kiểu FLOAT/DOUBLE lưu trữ dưới dạng số nhị phân dấu phẩy động (chuẩn IEEE 754), gây sai số làm tròn khi thực hiện phép trừ tính tiền hoàn cọc. DECIMAL(12,2) là kiểu số thực cố định (Exact Numeric), đảm bảo tính chính xác tuyệt đối từng đơn vị tiền tệ cho bộ phận kế toán.

## Prompt 2: Lựa chọn quan hệ 1-1 hay 1-N cho bảng Inspections
- **Câu hỏi:** Bảng Inspections nên liên kết với Rentals theo quan hệ 1-1 hay 1-N?
- **Phản hồi từ AI:** Trong thực tế thuê xe, một hợp đồng thường có ít nhất 2 lần kiểm tra: khi giao xe (check-out) và khi nhận lại xe (check-in). Do đó, thiết kế quan hệ 1-N (1 hợp đồng có nhiều biên bản kiểm tra) giúp hệ thống mở rộng linh hoạt hơn so với 1-1.

## Prompt 3: Ngăn chặn chèn dữ liệu kiểm tra xe bằng Trigger
- **Câu hỏi:** Làm thế nào để ngăn chặn nhân viên tạo biên bản kiểm tra xe (Inspections) khi hợp đồng đang ở trạng thái BOOKED?
- **Phản hồi từ AI:** Sử dụng `BEFORE INSERT TRIGGER` trên bảng `Inspections` để truy vấn trạng thái hợp đồng trong `Rentals`. Nếu `status = 'BOOKED'`, phát tín hiệu lỗi `SIGNAL SQLSTATE '45000'` từ chối giao dịch.

## Prompt 4: Hậu quả của việc lệch pha giữa Activity Diagram và ERD lên UX
- **Câu hỏi:** Sự thiếu đồng bộ giữa Activity Diagram và ERD gây ảnh hưởng gì tới trải nghiệm người dùng cuối?
- **Phản hồi từ AI:** Giao diện ứng dụng (UI) có ô nhập thông tin hoặc hiển thị nút bấm nhưng khi bấm xác nhận thì API backend báo lỗi do CSDL không có cột lưu trữ. Điều này gây gián đoạn thanh toán, tranh chấp tiền cọc giữa khách và nhân viên, và làm mất uy tín dịch vụ.
'@ | Out-File -FilePath "ai_prompt_log.md" -Encoding utf8
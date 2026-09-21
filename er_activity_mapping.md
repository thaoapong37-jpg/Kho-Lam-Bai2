@'
# BÁO CÁO ÁNH XẠ ACTIVITY DIAGRAM & ERD TẠI AUTORIDE

Trong quy trình "Thuê và Trả xe", nhánh rẽ khi trả xe yêu cầu: Nếu xe trầy xước/hư hỏng, hệ thống phải ghi nhận lỗi và khấu trừ chi phí sửa chữa vào tiền cọc theo công thức:
`Tiền hoàn lại = Tiền cọc - Phí trễ - Phí sửa chữa`.

Cột `damage_fee` là **bắt buộc phải có** để đảm bảo tính toàn vẹn hệ thống vì 3 lý do:
1. **Toàn vẹn luồng tài chính:** Nếu thiếu `damage_fee`, hệ thống không thể tự động tính số tiền cọc cần hoàn trả. Nhân viên buộc phải trả đủ cọc hoặc tính nhẩm ngoài sổ sách, dẫn đến "bốc hơi" lợi nhuận và thất thoát chi phí sửa xe.
2. **Tính kiểm toán (Audit Trail):** `damage_fee` liên kết trực tiếp với biên bản giám định trong bảng `Inspections`, tạo bằng chứng pháp lý rõ ràng giữa số tiền bị trừ và vị trí xe bị vỡ.
3. **Đồng bộ với Activity Diagram:** Đảm bảo mọi nhánh rẽ nghiệp vụ trong UML đều có thuộc tính dữ liệu tương ứng để lưu trữ trạng thái kết thúc hợp đồng (`COMPLETED`).
'@ | Out-File -FilePath "er_activity_mapping.md" -Encoding utf8
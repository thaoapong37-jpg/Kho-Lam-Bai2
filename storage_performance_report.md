@'
# BÁO CÁO PHÂN TÍCH TÀI NGUYÊN VÀ ĐÁNH ĐỔI READ/WRITE - QUICKFEED

## 1. Sự đánh đổi giữa Truy xuất (Read) và Cập nhật (Write)
Index hỗ trợ tăng tốc độ đọc dữ liệu (Read) bằng thuật toán tìm kiếm nhị phân B-Tree. Tuy nhiên, nó tạo ra chi phí ẩn rất lớn cho thao tác ghi (Write): Mỗi lệnh `INSERT` bài viết mới buộc MySQL cập nhật đồng thời bảng dữ liệu chính (Clustered Index) và toàn bộ các cây Secondary Index. Khi có tới 5 Index, chi phí I/O tăng gấp nhiều lần kèm hiện tượng phân tách trang (Page Split), dẫn đến nghẽn tài nguyên và gây Timeout 5-10 giây cho người dùng.

## 2. Phân tích Cardinality và Tối ưu Storage
- **Loại bỏ `idx_is_visible` & `idx_post_type`:** Các cột này có độ phân biệt (Cardinality) cực thấp (2 đến 3 giá trị). Chi phí duyệt Index kết hợp Lookup bảng chính lớn hơn đọc tuần tự (Sequential I/O), khiến MySQL Optimizer luôn bỏ qua Index để thực hiện Full Table Scan.
- **Loại bỏ `idx_content`:** Cột `TEXT` có độ dài 255 bytes gây phình to Index Pages, nuốt trọn bộ nhớ đệm RAM Buffer Pool.
- **Kết quả:** Giữ lại `idx_user_id` (lọc trang cá nhân) và `idx_created_at` (sắp xếp bảng tin). Thao tác `INSERT` giảm bớt 3/5 khối lượng bảo trì B-Tree, giải phóng hơn 60% dung lượng `Index_length` trên ổ đĩa.
'@ | Out-File -FilePath "storage_performance_report.md" -Encoding utf8
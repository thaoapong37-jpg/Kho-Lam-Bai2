# BÁO CÁO PHÂN TÍCH ĐÁNH ĐỔI READ - WRITE VÀ CHI PHÍ LƯU TRỮ (SMARTFACTORY)

## 1. Sai lầm của Covering Index trên hệ thống IoT
Hệ thống IoT tiếp nhận hàng chục nghìn bản ghi mỗi giây. Việc đưa toàn bộ các cột biến thiên liên tục (`temperature`, `humidity`, `status`) vào `idx_fat_covering` đã biến Secondary Index thành một bản sao chép thứ hai gần như trọn vẹn của bảng chính. 
Hậu quả:
- **Write Penalty nghiêm trọng:** Mỗi thao tác `INSERT` buộc InnoDB phải định vị và tái cấu trúc cây B-Tree cồng kềnh, gây ra hàng loạt hiện tượng phân tách trang (Page Split), làm chậm tốc độ ghi và dẫn đến mất gói tin (Data Loss) từ pipeline.
- **Phình to ổ cứng & RAM:** Kích thước Index vượt quá dung lượng bảng dữ liệu gốc, chiếm dụng toàn bộ bộ nhớ đệm Buffer Pool và khiến hóa đơn AWS SSD tăng gấp 4 lần.

## 2. Giải pháp Lean Index và Đánh đổi
- **Chiến lược:** Thay thế bằng `idx_lean_search(sensor_id, recorded_at)`.
- **Đánh đổi chấp nhận:** Câu truy vấn Dashboard mất tính chất "Covering Index" (phải thực hiện Bookmark Lookup về Clustered Index để lấy dữ liệu hiển thị), làm thời gian đọc tăng thêm từ 1 - 2 mili-giây.
- **Lợi ích đạt được:** Giảm hơn 70% kích thước Index (`Index_length`), giải phóng RAM máy chủ, tăng tốc độ `INSERT` lên hơn 5 lần, giải quyết dứt điểm tình trạng Data Loss và đưa chi phí thuê Cloud về mức an toàn.

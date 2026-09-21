@'
# NHẬT KÝ TƯƠNG TÁC CÙNG AI VỀ CARDINALITY VÀ INNODB STORAGE

## Prompt 1: Tác hại của việc Index cột TEXT và BOOLEAN
- **Câu hỏi:** Trong MySQL, nếu tôi tạo Index trên cột TEXT(255) và cột BOOLEAN (0 và 1) thì gây hại như thế nào đến RAM, Disk và Query Optimizer?
- **Phản hồi từ AI:** Index trên cột TEXT chiếm dung lượng lớn trên mỗi nhánh B-Tree, làm giảm số lượng bản ghi trên một trang 16KB của InnoDB và đẩy nhanh quá trình phình to Disk/RAM. Với BOOLEAN, Cardinality chỉ bằng 2 khiến tính chọn lọc (Selectivity) cực thấp; Optimizer nhận định chi phí Index Scan + Random Read cao hơn Full Table Scan nên từ chối dùng Index, biến nó thành rác tiêu tốn tài nguyên bảo trì.

## Prompt 2: Lý do MySQL quét toàn bảng dù có Index trên cột BOOLEAN
- **Câu hỏi:** Tại sao `SELECT * FROM Posts WHERE is_visible = 1` trên bảng hàng triệu dòng (99% là 1) lại chạy Full Table Scan thay vì dùng Index?
- **Phản hồi từ AI:** MySQL sử dụng Cost-Based Optimizer (CBO). Khi 99% dòng dữ liệu mang giá trị 1, việc đọc Index rồi quay lại bảng chính để lấy dữ liệu (Bookmark Lookup) đòi hỏi hàng triệu lượt Random I/O rời rạc. Optimizer tính toán thấy đọc tuần tự toàn bộ bảng (Sequential I/O) nhanh hơn nhiều, do đó bỏ qua Index hoàn toàn.

## Prompt 3: Xem kích thước Data và Index tính bằng MB
- **Câu hỏi:** Cho tôi cú pháp SQL truy vấn bảng information_schema.TABLES để lấy kích thước Data_MB và Index_MB của bảng Posts?
- **Phản hồi từ AI:** Sử dụng công thức `ROUND(data_length / 1024 / 1024, 2)` và `ROUND(index_length / 1024 / 1024, 2)` từ bảng `information_schema.TABLES` có điều kiện lọc theo `table_schema` và `table_name`.

## Prompt 4: Giải pháp tìm kiếm văn bản trong cột content
- **Câu hỏi:** Để tìm kiếm từ khóa trong cột content mà không dùng B-Tree Index gây tốn dung lượng, giải pháp là gì?
- **Phản hồi từ AI:** Sử dụng **FULLTEXT Index** trong MySQL. Cơ chế này áp dụng cấu trúc Inverted Index (chỉ mục đảo), chỉ lưu từ khóa và vị trí xuất hiện, kết hợp cùng các hàm `MATCH(...) AGAINST(...)`, tiết kiệm dung lượng hơn và giải quyết được bài toán tìm kiếm từ tự nhiên.
'@ | Out-File -FilePath "ai_prompt_log.md" -Encoding utf8
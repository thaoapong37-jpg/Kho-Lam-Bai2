@'
# NHẬT KÝ TƯƠNG TÁC CÙNG AI VỀ COVERING INDEX VÀ TỐI ƯU HÓA HỆ THỐNG IOT

## Prompt 1: Bản chất của Covering Index và cái giá của Write Penalty
- **Câu hỏi:** "Covering Index" là gì? Tại sao nó giúp lệnh SELECT chạy cực nhanh nhưng lại là "kẻ hủy diệt" với hệ thống có tần suất ghi cao (High-write throughput)?
- **Phản hồi từ AI:** Covering Index là chỉ mục chứa toàn bộ các cột mà câu truy vấn SELECT cần lấy, giúp MySQL trả về kết quả ngay tại cây Secondary B-Tree mà không cần tra cứu ngược về Clustered Index (bảng chính). Tuy nhiên, với hệ thống High-write như IoT, mỗi khi chèn dữ liệu mới, Database phải cập nhật cả cây Index này; các cột có kích thước lớn làm mỗi trang Index 16KB chứa được ít bản ghi hơn, dẫn đến tần suất phân tách trang (Page Split) và Random I/O tăng vọt.

## Prompt 2: Cấu trúc lưu trữ Clustered Index vs Secondary Index trong InnoDB
- **Câu hỏi:** Trong InnoDB của MySQL, Secondary Index lưu trữ dữ liệu như thế nào so với Clustered Index?
- **Phản hồi từ AI:** Clustered Index lưu trữ toàn bộ dữ liệu của hàng (toàn bộ các cột) tại các nút lá theo thứ tự Khóa chính (Primary Key). Trong khi đó, các Secondary Index chỉ lưu các cột được định nghĩa trong Index kèm theo Khóa chính của dòng đó. Nếu nhét quá nhiều cột vào Secondary Index, kích thước của nó sẽ tiệm cận hoặc thậm chí vượt qua Clustered Index do có thêm chi phí quản lý con trỏ và nút phân nhánh B-Tree.

## Prompt 3: Tính toán dung lượng Byte tiêu tốn khi thêm cột vào Index
- **Câu hỏi:** Việc đưa thêm DECIMAL(5,2), DECIMAL(5,2) và VARCHAR(20) vào một Index tiêu tốn bao nhiêu byte trên mỗi bản ghi trong cây B-Tree?
- **Phản hồi từ AI:** `DECIMAL(5,2)` tiêu tốn 3 bytes (2 byte cho phần nguyên, 1 byte cho phần thập phân). Hai cột tiêu tốn 6 bytes. Cột `VARCHAR(20)` với bảng mã `utf8mb4` có thể tốn từ 1 byte tiền tố độ dài + tối đa 80 bytes dữ liệu. Thêm khoảng 87 bytes trên mỗi bản ghi trong Index, nhân với 100 triệu bản ghi IoT sẽ làm Index phình thêm gần 8.7 GB dữ liệu dư thừa.

## Prompt 4: Tiêu chuẩn thiết kế Lean Index cho hệ thống Time-series / IoT
- **Câu hỏi:** Quy chuẩn thiết kế Index tối ưu cho bảng dữ liệu cảm biến thời gian thực là gì?
- **Phản hồi từ AI:** Chỉ đưa các cột dùng để định danh thiết bị (`sensor_id`) và khoảng thời gian (`recorded_at`) vào Composite Index. Tuyệt đối không đưa các trường đo lường (metrics như nhiệt độ, áp suất, độ ẩm) vào Index. Ngoài ra, nên kết hợp phân vùng dữ liệu theo thời gian (Range Partitioning theo tháng/tuần) để dễ dàng dọn dẹp dữ liệu cũ.
'@ | Out-File -FilePath "ai_prompt_log.md" -Encoding utf8
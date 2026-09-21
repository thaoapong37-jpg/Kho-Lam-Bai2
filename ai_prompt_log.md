@'
# NHẬT KÝ TƯƠNG TÁC CÙNG AI TRONG TỐI ƯU HÓA HIỆU NĂNG TRUY VẤN

## Prompt 1: Ý nghĩa cột type trong lệnh EXPLAIN
* **Câu hỏi:** Trong MySQL, các giá trị trong cột type của lệnh EXPLAIN như ALL, index, range, ref, const có ý nghĩa gì và độ ưu tiên ra sao?
* **Phản hồi từ AI:** Thứ tự hiệu năng từ nhanh nhất đến chậm nhất là: `system` -> `const` (tìm theo PK/Unique) -> `eq_ref` -> `ref` (dùng Non-Unique Index) -> `range` (quét khoảng index với <, >, BETWEEN) -> `index` (quét toàn bộ cây Index) -> `ALL` (Full Table Scan - quét ổ đĩa toàn bảng, chậm nhất và cần tối ưu).

## Prompt 2: Khái niệm SARGable và lý do bọc hàm gây hỏng Index
* **Câu hỏi:** Thuật ngữ "SARGable" là gì? Tại sao `WHERE YEAR(created_at) = 2026` lại biến truy vấn thành Non-SARGable?
* **Phản hồi từ AI:** SARGable viết tắt của Search Argument Able (có thể tìm kiếm được bằng đối số). B-Tree Index sắp xếp theo giá trị thô ban đầu của cột. Khi bọc hàm `YEAR(col)`, giá trị so sánh không còn là giá trị lưu trong cây B-Tree nữa, khiến Optimizer không thể tìm nhị phân mà phải lôi toàn bộ dữ liệu ra tính toán từng dòng. Viết lại thành khoảng ngày `col >= '2026-01-01' AND col < '2027-01-01'` sẽ giữ được tính SARGable.

## Prompt 3: Thứ tự cột trong Composite Index
* **Câu hỏi:** Trong Composite Index `(transaction_type, created_at)`, quy tắc đặt thứ tự cột là gì?
* **Phản hồi từ AI:** Áp dụng nguyên tắc "Equality first, Range second" (Cột so sánh bằng đặt trước, cột so sánh khoảng đặt sau). Cột `transaction_type` dùng toán tử `=` nên đặt đầu tiên để thu hẹp tập dữ liệu nhanh nhất, sau đó mới đến `created_at` dùng toán tử so sánh khoảng `>=` và `<`.

## Prompt 4: Rủi ro khi lạm dụng Index trên hệ thống OLTP cao
* **Câu hỏi:** Nếu hệ thống có hàng nghìn thao tác INSERT/UPDATE/DELETE mỗi giây, việc đánh quá nhiều Index sẽ gây nguy cơ gì?
* **Phản hồi từ AI:** Mỗi thao tác ghi (Write), MySQL ngoài việc ghi dữ liệu vào bảng còn phải cập nhật lại toàn bộ các cây B-Tree Index tương ứng và thực hiện phân tách trang (Page Split), làm tăng đáng kể độ trễ ghi (Write Latency), gây lãng phí dung lượng RAM (Buffer Pool) và nguy cơ Deadlock cao.
'@ | Out-File -FilePath "ai_prompt_log.md" -Encoding utf8
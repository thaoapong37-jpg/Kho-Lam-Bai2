# AI Prompt Log - Refactoring MetricsHub

### Prompt 1: Nhận diện không gian 1D vs 2D
* **Prompt:** "Khi tôi cần một bố cục mà một phần tử con (Child) phải chiếm chính xác 2 hàng và 2 cột (span 2 rows, 2 columns) đan xen với các phần tử nhỏ khác, tôi nên chọn CSS Grid hay Flexbox? Tại sao Flexbox lại chật vật với yêu cầu này?"
* **Bài học rút ra:** Flexbox chỉ tính toán theo 1 chiều tại một thời điểm (hàng hoặc cột). Để làm layout chiếm nhiều hàng nhiều cột bằng Flexbox, lập trình viên buộc phải lồng nhiều tầng thẻ `<div>` (`Div Soup`), gây gãy đổ khi Responsive. CSS Grid giải quyết triệt để nhờ hệ tọa độ 2D độc lập với cấu trúc HTML.

### Prompt 2: Tối ưu khoảng cách với `gap` thay cho `margin`
* **Prompt:** "Lợi ích của thuộc tính `gap` trong Flexbox và Grid so với việc dùng margin/padding truyền thống trên các phần tử con là gì?"
* **Bài học rút ra:** `gap` phân bổ khoảng cách đồng đều giữa các phần tử mà không gây lỗi dư margin ở phần tử đầu/cuối (loại bỏ nhu cầu dùng `:first-child` hay `:last-child`), giúp mã nguồn ngắn gọn và tránh vỡ layout khi co giãn.

### Prompt 3: So sánh Bootstrap 12-column với CSS Grid
* **Prompt:** "Trong Bootstrap 5, sự khác biệt giữa lớp col-sm-4 và col-md-4 là gì? Tại sao tôi nên dùng Bootstrap thay vì tự viết CSS Grid cho một phần tử đơn giản như 3 cột Bảng giá?"
* **Bài học rút ra:** `col-md-4` giữ 3 cột từ màn hình >= 768px và tự rớt thành 1 cột trên màn hình nhỏ hơn. Dùng Bootstrap giúp rút ngắn thời gian triển khai (Rapid Prototyping), tận dụng các class chuẩn hóa (Card, Shadow, Spacing) mà không cần bảo trì các đoạn Media Query thuần phức tạp.
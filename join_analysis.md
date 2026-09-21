@'
# GIẢI TRÌNH: LÝ DO SỬ DỤNG COUNT(o.order_id) THAY VÌ COUNT(*)

Trong câu truy vấn báo cáo cho Marketing, việc sử dụng `COUNT(o.order_id)` thay vì `COUNT(*)` đóng vai trò quyết định để hiển thị chính xác số đơn hàng là `0` đối với khách hàng chưa phát sinh giao dịch (như Charlie):

1. **Hành vi của `COUNT(*)`:** Hàm này đếm tổng số dòng trong mỗi nhóm (group). Khi kết hợp với `LEFT JOIN`, những khách hàng không có đơn hàng sẽ trả về dòng chứa giá trị `NULL` ở các cột của bảng `Orders`. Tuy nhiên, `COUNT(*)` vẫn tính dòng chứa toàn giá trị `NULL` đó là `1` dòng, dẫn đến kết quả sai lệch hiển thị Charlie có `1` đơn hàng.
2. **Hành vi của `COUNT(o.order_id)`:** Các hàm tổng hợp như `COUNT(column_name)` sẽ tự động bỏ qua các giá trị `NULL`. Do đó, đối với khách hàng Charlie (không có đơn hàng, `o.order_id` mang giá trị `NULL`), hàm sẽ trả về đúng kết quả là `0`.
'@ | Out-File -FilePath "join_analysis.md" -Encoding utf8
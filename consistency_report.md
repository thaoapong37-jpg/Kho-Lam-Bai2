# BÁO CÁO PHÂN TÍCH ĐIỂM VÊNH HỆ THỐNG HEALTHSYNC (GAP ANALYSIS)

Qua quá trình đối chiếu giữa Lưu đồ hoạt động (UML Activity Diagram) từ BA và lược đồ cơ sở dữ liệu cũ (Legacy Schema), phát hiện 3 điểm vênh nghiêm trọng khiến hệ thống bị sập logic:

1. **Sai lệch mô hình trạng thái (Lifecycle State Gap):** Thiết kế cũ dùng cột cờ `is_active BOOLEAN`, chỉ biểu diễn được 2 giá trị True/False. Nghiệp vụ thực tế đòi hỏi chu trình 5 bước (`PENDING` -> `CONFIRMED` -> `CHECKED_IN` -> `COMPLETED` / `CANCELLED`). Dùng cờ nhị phân làm tê liệt toàn bộ luồng điều khiển nghiệp vụ.
2. **Đứt gãy luồng tài chính và phạt tiền cọc (Financial Audit Gap):** Bảng `Appointments` cũ thiếu hoàn toàn các cột `deposit_amount`, `penalty_fee` và `cancel_reason`. Khi bệnh nhân hủy lịch sau bước xác nhận, hệ thống không thể tính toán khấu trừ tiền cọc, dẫn đến mất cân đối sổ sách kế toán và thất thoát dòng tiền phạt.
3. **Vắng mặt hoàn toàn thực thể Đơn thuốc (Entity Omission Gap):** Nghiệp vụ yêu cầu bác sĩ kê đơn khi trạng thái là `COMPLETED`, nhưng database không có bảng `Prescriptions`. Điều này khiến tính năng cốt lõi của phòng khám không thể lưu trữ thông tin điều trị.

**Giải pháp:** Tái cấu trúc bảng `Appointments` bằng kiểu dữ liệu `ENUM` và `DECIMAL`, bổ sung bảng `Prescriptions` với quan hệ khóa ngoại bảo đảm toàn vẹn tham chiếu.
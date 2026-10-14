# Chiến lược Bố cục: Grid vs Flexbox

CSS Grid là hệ thống dàn trang 2 chiều (2D), kiểm soát đồng thời cả hàng và cột từ cấp độ container bao ngoài. Grid sinh ra để định hình khung xương layout tổng thể và cấu trúc bất đối xứng phức tạp (như Dashboard Bento Box), cho phép các khối con mở rộng (`span`) qua nhiều hàng/cột mà không làm biến dạng mã nguồn hay tạo "Div Soup".

Ngược lại, Flexbox là hệ thống dàn trang 1 chiều (1D), tính toán linh hoạt theo từng trục đơn lẻ (Content-driven). Flexbox tối ưu cho việc căn chỉnh các phần tử vi mô bên trong một thành phần (như thanh Navbar, Button group, nội dung thẻ Card), nơi kích thước hộp tự co giãn thuận tự nhiên theo dung lượng nội dung thực tế mà không bị bó buộc vào các tọa độ cố định.
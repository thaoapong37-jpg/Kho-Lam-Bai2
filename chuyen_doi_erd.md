# BÀI TẬP: CHUYỂN ĐỔI MÔ HÌNH ERD SANG MÔ HÌNH QUAN HỆ

## Bước 1: Xác định các thực thể
- PHIEUXUAT(SoPX, NgayXuat)
- VATTU(MaVTU, TenVTU)
- PHIEUNHAP(SoPN, NgayNhap)
- DONDH(SoDH, NgayDH)
- NHACC(MaNCC, TenNCC, DiaChi, SDT)

## Bước 2: Xác định các mối quan hệ
- Quan hệ 1 - N (Cung cấp): Đưa MaNCC từ NHACC sang DONDH làm khóa ngoại (FK).
- Quan hệ N - M (Chi tiết phiếu xuất): Tạo bảng ChiTietPhieuXuat(SoPX, MaVTU, DGXuat, SLXuat).
- Quan hệ N - M (Chi tiết phiếu nhập): Tạo bảng ChiTietPhieuNhap(SoPN, MaVTU, DGNhap, SLNhap).
- Quan hệ N - M (Chi tiết đơn đặt hàng): Tạo bảng ChiTietDonDatHang(SoDH, MaVTU).

## Bước 3: Thuộc tính đa trị
- Thuộc tính SDT của NHACC là thuộc tính đa trị (oval viền kép).
- Tách thành bảng riêng: SDT_NHACC(MaNCC, SDT).

## Bước 4: Danh sách các bảng sau khi chuyển đổi
1. PHIEUXUAT (SoPX [PK], NgayXuat)
2. VATTU (MaVTU [PK], TenVTU)
3. PHIEUNHAP (SoPN [PK], NgayNhap)
4. NHACC (MaNCC [PK], TenNCC, DiaChi)
5. DONDH (SoDH [PK], NgayDH, MaNCC [FK])
6. SDT_NHACC (MaNCC [PK, FK], SDT [PK])
7. ChiTietPhieuXuat (SoPX [PK, FK], MaVTU [PK, FK], DGXuat, SLXuat)
8. ChiTietPhieuNhap (SoPN [PK, FK], MaVTU [PK, FK], DGNhap, SLNhap)
9. ChiTietDonDatHang (SoDH [PK, FK], MaVTU [PK, FK])

Set-Content -Path "ERD_Quan_Ly_Don_Dat_Hang.md" -Value @'
# BÁO CÁO THỰC HÀNH: XÂY DỰNG MÔ HÌNH ERD QUẢN LÝ ĐƠN ĐẶT HÀNG

## 1. Xác định thực thể và thuộc tính
- **DON_VI_KHACH**: MaDV (PK), TenDV, DiaChi, DienThoai
- **NGUOI_DAT**: MaSoND (PK), HoTenND, MaDV (FK)
- **NGUOI_NHAN**: MaSoNN (PK), HoTenNN, MaDV (FK)
- **NGUOI_GIAO**: MaSoNG (PK), HoTenNG
- **NOI_GIAO**: MaSoDDG (PK), TenNoiGiao
- **DON_DAT_HANG**: SoDH (PK), NgayDat, MaSoND (FK)
- **HANG**: MaHang (PK), TenHang, DVTinh, MoTaHang
- **CHI_TIET_DAT_HANG**: SoDH (PK, FK), MaHang (PK, FK), SoLuongDat
- **PHIEU_GIAO_HANG**: SoPG (PK), NgayGiao, SoDH (FK), MaSoDDG (FK), MaSoNG (FK), MaSoNN (FK)
- **CHI_TIET_GIAO_HANG**: SoPG (PK, FK), MaHang (PK, FK), SoLuongGiao, DonGiaGiao, ThanhTien

## 2. Sơ đồ mô hình thực thể quan hệ (ERD)

```mermaid
erDiagram
    DON_VI_KHACH ||--o{ NGUOI_DAT : "co"
    DON_VI_KHACH ||--o{ NGUOI_NHAN : "co"
    NGUOI_DAT ||--o{ DON_DAT_HANG : "lap"
    DON_DAT_HANG ||--|{ CHI_TIET_DAT_HANG : "chua"
    HANG ||--o{ CHI_TIET_DAT_HANG : "nam_trong"
    DON_DAT_HANG ||--o{ PHIEU_GIAO_HANG : "giao_theo"
    PHIEU_GIAO_HANG ||--|{ CHI_TIET_GIAO_HANG : "gom"
    HANG ||--o{ CHI_TIET_GIAO_HANG : "duoc_giao"
    NOI_GIAO ||--o{ PHIEU_GIAO_HANG : "giao_tai"
    NGUOI_GIAO ||--o{ PHIEU_GIAO_HANG : "giao_boi"
    NGUOI_NHAN ||--o{ PHIEU_GIAO_HANG : "nhan_boi"

    DON_VI_KHACH {
        string MaDV PK
        string TenDV
        string DiaChi
        string DienThoai
    }
    NGUOI_DAT {
        string MaSoND PK
        string HoTenND
        string MaDV FK
    }
    NGUOI_NHAN {
        string MaSoNN PK
        string HoTenNN
        string MaDV FK
    }
    DON_DAT_HANG {
        string SoDH PK
        date NgayDat
        string MaSoND FK
    }
    HANG {
        string MaHang PK
        string TenHang
        string DVTinh
        string MoTaHang
    }
    CHI_TIET_DAT_HANG {
        string SoDH PK_FK
        string MaHang PK_FK
        int SoLuongDat
    }
    PHIEU_GIAO_HANG {
        string SoPG PK
        date NgayGiao
        string SoDH FK
        string MaSoDDG FK
        string MaSoNG FK
        string MaSoNN FK
    }
    CHI_TIET_GIAO_HANG {
        string SoPG PK_FK
        string MaHang PK_FK
        int SoLuongGiao
        decimal DonGiaGiao
        decimal ThanhTien
    }
    NOI_GIAO {
        string MaSoDDG PK
        string TenNoiGiao
    }
    NGUOI_GIAO {
        string MaSoNG PK
        string HoTenNG
    }
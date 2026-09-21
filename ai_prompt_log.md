# NHAT KY TUONG TAC CUNG AI TRONG THIET KE HE THONG HEALTHSYNC

## Prompt 1: Phan tich Anti-Pattern trang thai boolean
- Cau hoi: Trong thiet ke CSDL, tai sao dung is_active BOOLEAN theo doi vong doi lich hen lai la Anti-pattern va nen thay the the nao?
- Phan hoi tu AI: BOOLEAN chi phan anh 2 trang thai dong/mo, khong the luu vet duoc tien trinh da cap (PENDING -> CONFIRMED -> CHECKED_IN -> COMPLETED / CANCELLED). Nen dung ENUM hoac bang danh muc trang thai.

## Prompt 2: Kieu du lieu so cho tai chinh (FLOAT vs DECIMAL)
- Cau hoi: Khi luu deposit_amount va penalty_fee, tai sao phai dung DECIMAL ma khong dung FLOAT/DOUBLE?
- Phan hoi tu AI: FLOAT va DOUBLE gay ra sai so lam tron nhi phan (floating-point error). DECIMAL(12, 2) la so thuc co dinh chinh xac tuyet doi cho tinh toan ke toan.

## Prompt 3: Ngan chan don thuoc rac o tang CSDL bang Triggers
- Cau hoi: Lam the nao de chan chen don thuoc khi lich hen chua COMPLETED?
- Phan hoi tu AI: Dung BEFORE INSERT TRIGGER tren bang Prescriptions kiem tra status cua Appointments, neu khac COMPLETED thi dung SIGNAL SQLSTATE '45000' de huy giao dich.

## Prompt 4: Tinh nhat quan giua UML Activity Diagram va ERD
- Cau hoi: Su nhat quan giua Activity Diagram va ERD co vai tro gi khi chuyen giao BA va Dev?
- Phan hoi tu AI: Activity Diagram mo ta quy trinh dong theo thoi gian, ERD luu tru trang thai tinh. Neu ERD thieu cac truong du lieu tu quy trinh thi lap trinh vien backend khong co noi luu du lieu, he thong se bao loi.

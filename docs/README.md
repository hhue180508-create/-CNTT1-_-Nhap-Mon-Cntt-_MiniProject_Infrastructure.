# GreenTech Infrastructure Management System

Hệ thống quản trị hạ tầng, nhật ký kỹ thuật và tài sản phần cứng cho Startup GreenTech.

## 1. Phân tích IPO

| Thành phần | Nội dung |
|---|---|
| **Input** | Log máy chủ, danh mục linh kiện, trạng thái 100 trạm IoT, cấu hình môi trường |
| **Process** | Tổ chức thư mục, lọc log theo luồng, tra cứu mã linh kiện bằng VLOOKUP, làm sạch bằng TRIM |
| **Output** | Báo cáo sự cố, bảng thiết bị đã đối soát, tài liệu vận hành |

## 2. Tư duy DIKW

- **Data:** từng dòng log, mã linh kiện, RAM, ngày lắp đặt.
- **Information:** nhóm lỗi CRITICAL/ERROR và danh sách linh kiện theo trạm.
- **Knowledge:** phát hiện lỗi lặp lại, trạm có mã linh kiện không khớp.
- **Wisdom:** ưu tiên xử lý lỗi nghiêm trọng và lập kế hoạch bảo trì dựa trên dữ liệu.

## 3. Cấu trúc thư mục

```text
GreenTech_MiniProject_Infrastructure/
├── .env.example
├── .gitignore
├── docs/
│   ├── README.md
│   └── srs-he-thong.docx
├── scripts/
│   └── auto_report.bat
├── data/
│   ├── log-he-thong.log
│   └── quan-ly-thiet-bi.xlsx
└── backup/
    └── bao-cao-su-co.txt
```

## 4. Khởi tạo và chạy trên Windows

Mở CMD tại thư mục cha, chạy một dòng lệnh:

```bat
mkdir GreenTech_MiniProject_Infrastructure\docs GreenTech_MiniProject_Infrastructure\scripts GreenTech_MiniProject_Infrastructure\data GreenTech_MiniProject_Infrastructure\backup
```

Tạo cấu hình demo:

```bat
copy .env.example .env
```

Chạy script:

```bat
scripts\auto_report.bat
```

Script tự xác định thư mục gốc từ vị trí file BAT. Kết quả được ghi nối vào `backup/bao-cao-su-co.txt`.

## 5. Excel Asset Database

Workbook có hai sheet:
- `danh-muc-linh-kien`: `ma_linh_kien` (khóa chính), `ten_thiet_bi`, `don_gia`, `loai_storage`.
- `trang-thai-tram`: `ma_tram`, `ma_linh_kien` (khóa ngoại), `dung_luong_ram`, `ngay_lap_dat`, `ten_thiet_bi`.

Công thức tại cột tên thiết bị:

```excel
=IFERROR(VLOOKUP(TRIM(B2),'danh-muc-linh-kien'!$A$2:$D$6,2,FALSE),"KHONG_TIM_THAY_MA")
```

`TRIM` bỏ khoảng trắng thừa; `$` cố định vùng tra cứu; `2` lấy cột tên thiết bị; `FALSE` yêu cầu khớp chính xác; `IFERROR` hiển thị thông báo khi không tìm thấy mã. Không để hàng trống hoặc Merge Cell trong vùng dữ liệu.

## 6. Audit và bảo mật

- [ ] Đọc toàn bộ script trước khi chạy.
- [ ] Kiểm tra đường dẫn đầu vào/đầu ra.
- [ ] Không chạy lệnh xóa nguy hiểm nếu chưa hiểu rõ tác động.
- [ ] Script mẫu không dùng `del`, `rmdir` hoặc lệnh xóa.
- [ ] Không đưa mật khẩu thật, API key hoặc token lên GitHub.
- [ ] Chỉ commit `.env.example`; giữ `.env` trong `.gitignore`.

## 7. Tính thời gian tải log

Tốc độ MB/s = Mbps / 8. Với log 500 MB và mạng 100 Mbps: 100 / 8 = 12,5 MB/s; thời gian lý thuyết = 500 / 12,5 = **40 giây**. Thực tế lâu hơn do overhead mạng và tốc độ ổ đĩa.

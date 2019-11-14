
CREATE DATABASE QuanLyPhongKham
USE QuanLyPhongKham

CREATE TABLE Thuoc ( 
	Ma_Thuoc int identity(1,1) primary key,
	Ten	NVARCHAR(40),
	SoLuong DECIMAL (10,2),
	DonVi NVARCHAR (7),
	Gia int,
	HSD DATE
);
CREATE TABLE NhanVien (
	Ma_NV int IDENTITY(1,1) PRIMARY KEY,
	HoTen NVARCHAR(40),
	NgaySinh DATE,
	Chuc NVARCHAR(7),
	Luong int,
	TangCa int
);
CREATE TABLE BenhNhan (
	Ma_BN int IDENTITY(1,1) PRIMARY KEY,
	Ten NVARCHAR(40),
	Tuoi INT,
	GioiTinh int,
	SDT CHAR(12)
);
CREATE TABLE DichVu (
	Ma_DichVu int IDENTITY(1,1) PRIMARY KEY,
	TenDV NVARCHAR(40),
	Gia int
);
CREATE TABLE HoaDon (
	Ma_HoaDon INT IDENTITY(1,1) PRIMARY KEY,
	Ma_BN INT,
	NgayKham DATE,
	BacSi INT,
	TongTien INT,
	FOREIGN KEY (Ma_BN) REFERENCES BenhNhan (Ma_BN),
	FOREIGN KEY (BacSi) REFERENCES NhanVien(Ma_NV)
);
CREATE TABLE ChiTietDV (
	Ma_HoaDon INT,
	Ma_DichVu INT,
	PRIMARY KEY (Ma_HoaDon,Ma_DichVu),
	FOREIGN KEY (Ma_HoaDon) REFERENCES HoaDon(Ma_HoaDon),
	FOREIGN KEY (Ma_DichVu) REFERENCES DichVu(Ma_Dichvu)
);
CREATE TABLE ToaThuoc (
	Ma_HoaDon INT,
	Ma_Thuoc INT,
	SoLuong DECIMAL(10,2),
	DonVi NVARCHAR(7),
	HuongDanSD NVARCHAR(40),
	Gia INT,
	BacSi INT,
	PRIMARY KEY (Ma_HoaDon,Ma_Thuoc),
	FOREIGN KEY (BacSi) REFERENCES NhanVien (Ma_NV),
	FOREIGN KEY (Ma_Thuoc) REFERENCES Thuoc (Ma_Thuoc)
);
CREATE TABLE ACCounts (
	Ma_NV int PRIMARY KEY,
	TenTaiKhoan VARCHAR(20),
	PassWord VARCHAR(20),
	Quyen NVARCHAR(20),
	FOREIGN KEY (Ma_NV) REFERENCES NhanVien(Ma_NV)
);
CREATE TABLE LichSuKham (
	Ma_BN INT PRIMARY KEY,
	NgayKham DATE,
	ChuanDoan NVARCHAR(MAX),
	FOREIGN KEY (Ma_BN) REFERENCES BenhNhan(Ma_BN)
);
CREATE TABLE DoanhThu (
	Ma_DoanhThu INT IDENTITY(1,1) PRIMARY KEY,
	NgayThu DATE,
	TongThu INT
)
GO

CREATE FUNCTION DangNhap (@TenTaiKhoan VARCHAR(20),
						@PassWord VARCHAR(20))
RETURNS TABLE
	RETURN SELECT Ma_NV,Quyen
			FROM ACCounts
			WHERE ACCounts.TenTaiKhoan=@TenTaiKhoan AND ACCounts.PassWord=@PassWord
GO
CREATE PROC ThemNhanVien
	@HoTen NVARCHAR(40),
	@NgaySinh DATE,
	@Chuc NVARCHAR(7),
	@Luong INT,
	@TangCa INT
AS
BEGIN
INSERT INTO NhanVien VALUES (@HoTen,@NgaySinh,@Chuc,@Luong,@TangCa);
END
GO
CREATE PROC SuaNhanVien
	@Ma_NV INT,
	@HoTen NVARCHAR(40),
	@NgaySinh DATE,
	@Chuc NVARCHAR(7),
	@Luong INT,
	@TangCa INT
AS
BEGIN
UPDATE NhanVien SET HoTen=@HoTen, 
					NgaySinh=@NgaySinh, 
					Chuc=@Chuc, 
					Luong=@Luong, 
					TangCa=@TangCa 
				WHERE Ma_NV=@Ma_NV
END
GO
CREATE FUNCTION DanhSachNV()
 RETURNS TABLE
 AS
 RETURN	SELECT *
		FROM NhanVien

GO
CREATE FUNCTION TimNVTheoTen(@HoTen NVARCHAR(40))
 RETURNS TABLE
 AS
 RETURN	SELECT *
		FROM NhanVien
		WHERE NhanVien.HoTen like '%'+@HoTen+'%'
GO
CREATE FUNCTION TimNVTheoChuc(@Chuc NVARCHAR(7))
 RETURNS TABLE
 AS
 RETURN	SELECT *
		FROM NhanVien
		WHERE NhanVien.Chuc='%'+@Chuc+'%'
GO
CREATE FUNCTION TimNVTheoMa(@MaNhanVien INT)
 RETURNS TABLE
 AS
 RETURN	SELECT *
		FROM NhanVien
		WHERE NhanVien.Chuc=@MaNhanVien
GO

CREATE PROC ThemBenhNhan
	@HoTen NVARCHAR(40),
	@Tuoi INT,
	@GioiTinh INT,
	@SDT INT
AS
BEGIN
INSERT INTO BenhNhan VALUES (@HoTen,@Tuoi,@GioiTinh,@SDT);
END
GO
CREATE PROC SuaBenhNan
	@Ma_BN INT,
	@HoTen NVARCHAR(40),
	@Tuoi INT,
	@GioiTinh INT,
	@SDT INT
AS
BEGIN
UPDATE BenhNhan SET Ten=@HoTen, 
					Tuoi=@Tuoi,
					GioiTinh=@GioiTinh,
					SDT=@SDT
				WHERE Ma_BN=@Ma_BN
END
GO
CREATE FUNCTION DanhSachBN()
 RETURNS TABLE
 AS
 RETURN	SELECT *
		FROM BenhNhan

GO
CREATE FUNCTION TimBNTheoTen(@Ten NVARCHAR(40))
 RETURNS TABLE
 AS
 RETURN	SELECT *
		FROM BenhNhan
		WHERE BenhNhan.Ten='%'+@Ten+'%'
GO
CREATE FUNCTION TimBNTheoSDT(@SDT CHAR(12))
 RETURNS TABLE
 AS
 RETURN	SELECT *
		FROM BenhNhan
		WHERE BenhNhan.Ten=@SDT
GO

CREATE PROC ThemDichVu
	@TenDV NVARCHAR(40),
	@Gia int
AS
BEGIN
INSERT INTO DichVu VALUES (@TenDV,@Gia	);
END
GO
CREATE PROC SuaDichVu
	@Ma_DV INT,
	@TenDV NVARCHAR(40),
	@Gia int
AS
BEGIN
UPDATE DichVu SET	TenDV=@TenDV,
					Gia=@Gia
				WHERE Ma_DichVu=@Ma_DV
END
GO
CREATE FUNCTION DanhSachDV()
 RETURNS TABLE
 AS
 RETURN	SELECT *
		FROM DichVu

GO
CREATE PROC ChiDinhDV 
			@Ma_HoaDon INT,
			@TenDV NVARCHAR(40)
AS
BEGIN
	DECLARE @Ma_DV INT;
	SELECT @Ma_DV=DichVu.Ma_DichVu
	FROM DichVu
	WHERE DichVu.TenDV=@TenDV
	INSERT INTO ChiTietDV VALUES (@Ma_HoaDon,@Ma_DV)
END
GO

CREATE PROC ThemHoaDon
	@Ma_BN INT
AS
BEGIN
	DECLARE @NgayKham DATE;
	SET @NgayKham=GETDATE();
	INSERT INTO HoaDon VALUES(@Ma_BN,@NgayKham,null,0)
END
GO
CREATE PROC ThemToaThuoc
	@Ma_HoaDon INT,
	@TenThuoc NVARCHAR(40),
	@SoLuong DECIMAL(10,2),
	@DonVi NVARCHAR(10),
	@HuongDanSD NVARCHAR(40)
AS
BEGIN
	DECLARE @Ma_Thuoc INT;
	SELECT @Ma_Thuoc=Thuoc.Ma_Thuoc
	FROM Thuoc
	WHERE THUOC.Ten=@TenThuoc
	INSERT INTO ToaThuoc VALUES (@Ma_HoaDon,@Ma_Thuoc,@SoLuong,@DonVi,@HuongDanSD,0,NULL)
END
GO
CREATE FUNCTION DanhSachToaThuocBN(@Ma_BN INT)
RETURNS TABLE
AS
RETURN	SELECT Thuoc.Ten,ToaThuoc.HuongDanSD,ToaThuoc.SoLuong,ToaThuoc.DonVi,HoaDon.NgayKham
	FROM ToaThuoc,HoaDon,Thuoc
	WHERE HoaDon.Ma_BN=@Ma_BN AND HoaDon.Ma_HoaDon=ToaThuoc.Ma_HoaDon AND ToaThuoc.Ma_Thuoc=Thuoc.Ma_Thuoc
GO

CREATE TRIGGER TinhGiaThuoc ON ToaThuoc
AFTER insert,update
AS
BEGIN
	DECLARE @Tienthuoc INT
	SELECT @Tienthuoc=Thuoc.Gia
	FROM Thuoc,inserted
	WHERE Thuoc.Ma_Thuoc=inserted.Ma_Thuoc
	UPDATE ToaThuoc SET Gia=SoLuong*DonVi*@Tienthuoc
END
GO
CREATE PROC TinhTienHoaDon (@Ma_HoaDon INT)
AS
BEGIN TRAN TienHoaDon
	DECLARE @TongTienDV INT, @TongTienToaThuoc INT;
		BEGIN TRAN TienDV
		SELECT @TongTienDV=SUM(DichVu.Gia)
		FROM ChiTietDV,DichVu
		WHERE ChiTietDV.Ma_HoaDon=@Ma_HoaDon AND ChiTietDV.Ma_DichVu=DichVu.Ma_DichVu
		COMMIT TRAN TienDV

		BEGIN TRAN TienToaThuoc
		SELECT @TongTienToaThuoc=SUM(ToaThuoc.Gia)
		FROM ToaThuoc
		WHERE ToaThuoc.Ma_HoaDon=@Ma_HoaDon
		COMMIT TRAN TienToaThuoc
	UPDATE HoaDon SET TongTien=@TongTienDV+@TongTienToaThuoc
					WHERE Ma_HoaDon=@Ma_HoaDon
COMMIT TRAN TienHoaDon
GO
CREATE TRIGGER TinhDoanhThuNgay ON HoaDon
AFTER INSERT,UPDATE
AS
BEGIN
	DECLARE @TONGTHU INT, @NGAY DATE;
	SELECT @TONGTHU=HoaDon.TongTien,@NGAY=HoaDon.NgayKham
	FROM HoaDon
	IF ((SELECT DoanhThu.NgayThu
		FROM DoanhThu
		WHERE DoanhThu.NgayThu=@NGAY) IS NULL) 
		INSERT INTO DoanhThu VALUES (@NGAY,@TONGTHU);
	ELSE
	BEGIN
		DECLARE @TongThuCu INT;
		SELECT @TongThuCu=DoanhThu.TongThu
		FROM DoanhThu
		WHERE DoanhThu.NgayThu=@NGAY
		UPDATE DoanhThu SET TongThu=@TongThuCu+@TONGTHU
						WHERE NgayThu=@NGAY
	END
END
GO
CREATE FUNCTION HienDoanhThuNgay (@Ngay DATE)
RETURNS TABLE
AS
RETURN	SELECT NgayThu,TongThu
		FROM DoanhThu
		WHERE MONTH(DoanhThu.NgayThu)=MONTH(@Ngay) AND YEAR(DoanhThu.NgayThu)=YEAR(@Ngay)
GO
CREATE FUNCTION HienDoanhThuThang (@Ngay DATE)
RETURNS TABLE
AS
RETURN	SELECT MONTH(DoanhThu.NgayThu) AS ThangThu,SUM(TongThu) AS TONGTHU
		FROM DoanhThu
		WHERE YEAR(DoanhThu.NgayThu)=YEAR(@Ngay)
		GROUP BY MONTH(DoanhThu.NgayThu)
GO
CREATE FUNCTION HienDoanhThuNam ()
RETURNS TABLE
AS
RETURN	SELECT YEAR(DoanhThu.NgayThu) AS NamThu,SUM(TongThu) AS TONGTHU
		FROM DoanhThu
		GROUP BY YEAR(DoanhThu.NgayThu)
GO



EXEC SuaNhanVien 2,'LÊ VĂN HOÀNG','11/11/1999','PT',20000,15
EXEC ThemBenhNhan N'Lee Hang Soul',25,1,0905657894
EXEC ThemBenhNhan N'Park Hang Seo',45,1,0779825721
EXEC ThemHoaDon 1
EXEC ThemDichVu N'Khám Bệnh',20000
EXEC ThemDichVu N'Xét nghiệm máu',40000
SELECT *
FROM DanhSachNV()

SELECT *
FROM TimNVTheoTen('LÊ VĂN')

SELECT *
FROM TimNVTheoChuc('PT')
SELECT *
FROM HienDoanhThuNam()
SELECT *
FROM HienDoanhThuThang('10/11/2019')
SELECT *
FROM HienDoanhThuNgay('10/11/2019')
SELECT *
FROM DanhSachBN()
SELECT *
FROM DanhSachDV()
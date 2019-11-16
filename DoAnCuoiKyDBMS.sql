
CREATE DATABASE QuanLyPhongKham
USE QuanLyPhongKham
GO

CREATE TABLE Thuoc ( 
	Ma_Thuoc int identity(1,1) primary key,
	Ten	NVARCHAR(40) NOT NULL,
	SoLuong DECIMAL (10,2) NOT NULL,
	DonVi NVARCHAR (7) NOT NULL,
	Gia int NOT NULL,
	TrangThai bit
);
CREATE TABLE NhanVien (
	Ma_NV int IDENTITY(1,1) PRIMARY KEY,
	HoTen NVARCHAR(MAX) NOT NULL,
	NgaySinh DATE NOT NULL,
	SDT VARCHAR(MAX) NOT NULL,
	Chuc NVARCHAR(MAX) NOT NULL,
	Luong int NOT NULL,
	TangCa int NOT NULL,
	TrangThai bit
);
CREATE TABLE BenhNhan (
	Ma_BN int IDENTITY(1,1) PRIMARY KEY,
	Ten NVARCHAR(MAX) NOT NULL,
	Tuoi INT,
	GioiTinh int,
	SDT CHAR(12) NOT NULL
);
CREATE TABLE DichVu (
	Ma_DichVu int IDENTITY(1,1) PRIMARY KEY,
	TenDV NVARCHAR(40) NOT NULL,
	Gia int NOT NULL,
	TrangThai bit
);
CREATE TABLE HoaDon (
	Ma_HoaDon INT IDENTITY(1,1) PRIMARY KEY,
	Ma_BN INT NOT NULL,
	NgayKham DATE NOT NULL,
	BacSi INT,
	TongTien INT NOT NULL,
	TrangThai bit,
	FOREIGN KEY (Ma_BN) REFERENCES BenhNhan (Ma_BN),
	FOREIGN KEY (BacSi) REFERENCES NhanVien(Ma_NV)
);
CREATE TABLE ChiTietDV (
	Ma_HoaDon INT NOT NULL,
	Ma_DichVu INT NOT NULL,
	PRIMARY KEY (Ma_HoaDon,Ma_DichVu),
	FOREIGN KEY (Ma_HoaDon) REFERENCES HoaDon(Ma_HoaDon),
	FOREIGN KEY (Ma_DichVu) REFERENCES DichVu(Ma_Dichvu)
);
CREATE TABLE ToaThuoc (
	Ma_HoaDon INT,
	Ma_Thuoc INT,
	SoLuong DECIMAL(10,2) NOT NULL,
	DonVi NVARCHAR(7) NOT NULL,
	HuongDanSD NVARCHAR(40) NOT NULL,
	Gia INT NOT NULL,
	BacSi INT,
	PRIMARY KEY (Ma_HoaDon,Ma_Thuoc),
	FOREIGN KEY (BacSi) REFERENCES NhanVien (Ma_NV),
	FOREIGN KEY (Ma_Thuoc) REFERENCES Thuoc (Ma_Thuoc)
);
CREATE TABLE ACCounts (
	Ma_NV int PRIMARY KEY,
	TenTaiKhoan VARCHAR(20) NOT NULL UNIQUE,
	PassWord VARCHAR(20) NOT NULL,
	Quyen NVARCHAR(20) NOT NULL,
	FOREIGN KEY (Ma_NV) REFERENCES NhanVien(Ma_NV)
);
CREATE TABLE LichSuKham (
	Ma_BN INT,
	NgayKham DATE,
	ChuanDoan NVARCHAR(MAX),
	PRIMARY KEY (Ma_BN,NgayKham),
	FOREIGN KEY (Ma_BN) REFERENCES BenhNhan(Ma_BN)
);
CREATE TABLE DoanhThu (
	Ma_DoanhThu INT IDENTITY(1,1) PRIMARY KEY,
	NgayThu DATE,
	TongThu INT
);

GO

CREATE FUNCTION DangNhap (@TenTaiKhoan VARCHAR(20),
						@PassWord VARCHAR(20))
RETURNS TABLE
	RETURN SELECT Ma_NV,Quyen
			FROM ACCounts
			WHERE ACCounts.TenTaiKhoan=@TenTaiKhoan AND ACCounts.PassWord=@PassWord
GO
CREATE PROC DoiMatKhau
				@Ma_NV INT,
				@PassWord VARCHAR(20)
AS
BEGIN
	UPDATE ACCounts SET PassWord=@PassWord WHERE Ma_NV=@Ma_NV
END
GO

CREATE PROC ThemNhanVien
	@HoTen NVARCHAR(MAX),
	@NgaySinh DATE,
	@SDT VARCHAR(MAX),
	@Chuc NVARCHAR(MAX),
	@Luong INT
AS
BEGIN
INSERT INTO NhanVien VALUES (@HoTen,@NgaySinh,@SDT,@Chuc,@Luong,0,1);
END
GO
CREATE PROC SuaNhanVien
	@Ma_NV INT,
	@HoTen NVARCHAR(MAX),
	@NgaySinh DATE,
	@SDT VARCHAR(MAX),
	@Chuc NVARCHAR(7),
	@Luong INT,
	@TangCa INT
AS
BEGIN
UPDATE NhanVien SET HoTen=@HoTen,
					NgaySinh=@NgaySinh,
					SDT=@SDT,
					Chuc=@Chuc,
					Luong=@Luong, 
					TangCa=@TangCa 
				WHERE Ma_NV=@Ma_NV
END
GO
CREATE PROC XoaNhanVien
			@Ma_NV INT
AS
BEGIN TRAN
	UPDATE NhanVien SET TrangThai=0
					WHERE Ma_NV=@Ma_NV
COMMIT
GO
CREATE FUNCTION DanhSachNV()
 RETURNS TABLE
 AS
 RETURN	SELECT Ma_NV,HoTen,NgaySinh,Chuc,Luong,TangCa
		FROM NhanVien
		WHERE NhanVien.TrangThai=1

GO
CREATE FUNCTION TimNVTheoTen(@HoTen NVARCHAR(40))
 RETURNS TABLE
 AS
 RETURN	SELECT Ma_NV,HoTen,NgaySinh,Chuc,Luong,TangCa
		FROM NhanVien
		WHERE NhanVien.HoTen like '%'+@HoTen+'%' AND NhanVien.TrangThai=1
GO
CREATE FUNCTION TimNVTheoChuc(@Chuc NVARCHAR(7))
 RETURNS TABLE
 AS
 RETURN	SELECT Ma_NV,HoTen,NgaySinh,Chuc,Luong,TangCa
		FROM NhanVien
		WHERE NhanVien.Chuc='%'+@Chuc+'%' AND NhanVien.TrangThai=1
GO
CREATE FUNCTION TimNVTheoMa(@MaNhanVien INT)
 RETURNS TABLE
 AS
 RETURN	SELECT Ma_NV,HoTen,NgaySinh,Chuc,Luong,TangCa
		FROM NhanVien
		WHERE NhanVien.Ma_NV=@MaNhanVien AND NhanVien.TrangThai=1
GO

CREATE PROC ThemBenhNhan
	@HoTen NVARCHAR(MAX),
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
	@HoTen NVARCHAR(MAX),
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

CREATE PROC ThemThuocMoi
			@Ten NVARCHAR(40),
			@SoLuong DECIMAL (10,2),
			@DonVi NVARCHAR (7),
			@Gia int
AS
BEGIN
	INSERT INTO Thuoc VALUES (@Ten,@SoLuong,@DonVi,@Gia,1)
END
GO
CREATE PROC SuaThuocCu
			@Ma_Thuoc INT,
			@Ten NVARCHAR(40),
			@SoLuong DECIMAL (10,2),
			@DonVi NVARCHAR (7),
			@Gia int
AS
BEGIN
	UPDATE Thuoc SET Ten=@Ten,
						SoLuong=@SoLuong,
						DonVi=@DonVi,
						Gia=@Gia
				WHERE Ma_Thuoc=@Ma_Thuoc
END
GO
CREATE PROC XoaThuoc
			@Ma_Thuoc INT
AS
BEGIN TRAN
	UPDATE Thuoc SET TrangThai=0 WHERE Ma_Thuoc=@Ma_Thuoc
COMMIT
GO
CREATE FUNCTION DanhSachThuoc ()
RETURNS TABLE
AS
RETURN SELECT Ma_Thuoc,Ten,SoLuong,DonVi,Gia
		FROM Thuoc
		WHERE Thuoc.TrangThai=1
GO

CREATE PROC ThemDichVu
	@TenDV NVARCHAR(40),
	@Gia int
AS
BEGIN
INSERT INTO DichVu VALUES (@TenDV,@Gia,1);
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
CREATE PROC XoaDichVu
			@Ma_DV INT
AS
BEGIN TRAN
	UPDATE DichVu SET TrangThai=0 WHERE Ma_DichVu=@Ma_DV
COMMIT
GO
CREATE FUNCTION DanhSachDV()
 RETURNS TABLE
 AS
 RETURN	SELECT Ma_DichVu,TenDV,Gia
		FROM DichVu
		WHERE DichVu.TrangThai=1

GO
CREATE PROC ChiDinhDV
			@Ma_BN INT,
			@TenDV NVARCHAR(40)
AS
BEGIN TRAN
	DECLARE @Ma_DV INT, @Ma_HoaDon INT;
	IF ((SELECT HoaDon.Ma_HoaDon
		FROM HoaDon
		WHERE HoaDon.Ma_BN=@Ma_BN AND HoaDon.TrangThai=0) IS NULL)
				EXEC ThemHoaDon @Ma_BN;
	SELECT @Ma_HoaDon=HoaDon.Ma_HoaDon
	FROM HoaDon
	WHERE HoaDon.Ma_BN=@Ma_BN AND HoaDon.TrangThai=0

	SELECT @Ma_DV=DichVu.Ma_DichVu
	FROM DichVu
	WHERE DichVu.TenDV=@TenDV
	IF (@Ma_DV IS NULL)
		ROLLBACK
	INSERT INTO ChiTietDV VALUES (@Ma_HoaDon,@Ma_DV)
COMMIT
GO
CREATE FUNCTION TenDV()
RETURNS TABLE
AS
RETURN SELECT DichVu.TenDV
		FROM DichVu
GO
CREATE FUNCTION TimDVTheoMa (@Ma_DV INT)
RETURNS TABLE
AS
RETURN SELECT Ma_DichVu,TenDV,Gia
		FROM DichVu
		WHERE DichVu.Ma_DichVu=@Ma_DV
GO

CREATE PROC ThemHoaDon
	@Ma_BN INT
AS
BEGIN
	DECLARE @NgayKham DATE;
	SET @NgayKham=GETDATE();
	INSERT INTO HoaDon VALUES(@Ma_BN,@NgayKham,null,0,0)
END
GO
CREATE PROC ThemToaThuoc
	@Ma_BN INT,
	@TenThuoc NVARCHAR(40),
	@SoLuong DECIMAL(10,2),
	@DonVi NVARCHAR(10),
	@HuongDanSD NVARCHAR(40)
AS
BEGIN
	DECLARE @Ma_Thuoc INT, @Ma_HoaDon INT;

	SELECT @Ma_HoaDon=HoaDon.Ma_HoaDon
	FROM HoaDon
	WHERE HoaDon.Ma_BN=@Ma_BN AND HoaDon.TrangThai=0

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

CREATE FUNCTION HienDoanhThuNgay (@ngay DATE)
RETURNS TABLE
AS 
RETURN	SELECT NgayThu,TongThu
		FROM DoanhThu
		WHERE MONTH(DoanhThu.NgayThu)=MONTH(@ngay) AND YEAR(DoanhThu.NgayThu)=YEAR(@ngay)
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

CREATE PROC ThanhToanHoaDon @Ma_HoaDon INT
AS
BEGIN
	UPDATE HoaDon SET TrangThai=1 WHERE Ma_HoaDon=@Ma_HoaDon
END
GO

CREATE TRIGGER TinhGiaThuoc ON ToaThuoc
AFTER insert
AS
BEGIN TRAN
	DECLARE @Tienthuoc INT
	SELECT @Tienthuoc=Thuoc.Gia
	FROM Thuoc,inserted
	WHERE Thuoc.Ma_Thuoc=inserted.Ma_Thuoc

	UPDATE ToaThuoc SET Gia=SoLuong*@Tienthuoc
COMMIT
BEGIN TRAN
	DECLARE @TongTienCu INT, @GiaThuoc INT, @Ma_HoaDon INT

	SELECT @GiaThuoc=ToaThuoc.Gia, @Ma_HoaDon=inserted.Ma_HoaDon
	FROM ToaThuoc,inserted
	WHERE ToaThuoc.Ma_HoaDon=inserted.Ma_HoaDon

	SELECT @TongTienCu=HoaDon.TongTien
	FROM HoaDon
	WHERE HoaDon.Ma_HoaDon=@Ma_HoaDon

	UPDATE HoaDon SET TongTien=@TongTienCu+@GiaThuoc
					WHERE HoaDon.Ma_HoaDon=@Ma_HoaDon
COMMIT TRAN
GO
CREATE TRIGGER TinhTien ON ChiTietDV
AFTER INSERT
AS
BEGIN TRAN
	DECLARE @TongTienCu INT, @GiaDV INT, @Ma_HoaDon INT

	SELECT @GiaDV=DichVu.Gia, @Ma_HoaDon=inserted.Ma_HoaDon
	FROM ChiTietDV,DichVu,inserted
	WHERE ChiTietDV.Ma_HoaDon=inserted.Ma_HoaDon AND ChiTietDV.Ma_DichVu=DichVu.Ma_DichVu

	SELECT @TongTienCu=HoaDon.TongTien
	FROM HoaDon
	WHERE HoaDon.Ma_HoaDon=@Ma_HoaDon

	UPDATE HoaDon SET TongTien=@TongTienCu+@GiaDV
					WHERE HoaDon.Ma_HoaDon=@Ma_HoaDon
COMMIT TRAN
GO
CREATE TRIGGER TinhDoanhThuNgay ON HoaDon
AFTER INSERT,UPDATE
AS
BEGIN TRAN
	DECLARE @TONGTHU INT, @NGAY DATE;
	SELECT @TONGTHU=inserted.TongTien,@NGAY=inserted.NgayKham
	FROM inserted
	IF ((SELECT DoanhThu.NgayThu
		FROM DoanhThu
		WHERE DoanhThu.NgayThu=@NGAY) IS NULL) 
		INSERT INTO DoanhThu VALUES (@NGAY,@TONGTHU);
	ELSE IF EXISTS ((SELECT HoaDon.Ma_HoaDon
			FROM HoaDon,inserted
			WHERE HoaDon.TrangThai=1 AND HoaDon.Ma_HoaDon=inserted.Ma_HoaDon))
	BEGIN
		DECLARE @TongThuCu INT;
		SELECT @TongThuCu=DoanhThu.TongThu
		FROM DoanhThu
		WHERE DoanhThu.NgayThu=@NGAY
		UPDATE DoanhThu SET TongThu=@TongThuCu+@TONGTHU
						WHERE NgayThu=@NGAY
	END
COMMIT
GO

CREATE TRIGGER ThemTaiKhoan ON NhanVien
AFTER INSERT
AS
BEGIN TRAN
	DECLARE @Ma_NV INT, @TenTaiKhoan VARCHAR(MAX), @QUYEN NVARCHAR(MAX);
	SELECT @Ma_NV=inserted.Ma_NV, @TenTaiKhoan=inserted.SDT,@QUYEN=inserted.Chuc
	FROM inserted
	INSERT INTO ACCounts VALUES (@Ma_NV,@TenTaiKhoan,1,@QUYEN)
COMMIT
GO
CREATE TRIGGER KiemTraTen ON NhanVien
FOR INSERT,UPDATE
AS
BEGIN
	DECLARE @Incresment INT, @TEN NVARCHAR(MAX);
	SET @Incresment=1;
	SELECT @TEN=inserted.HoTen
	FROM inserted
	WHILE (@Incresment<LEN(@TEN))
		BEGIN
			IF ((SUBSTRING(@TEN,@Incresment, 1) BETWEEN '!' AND'~') or (SUBSTRING(@TEN,@Incresment, 1) BETWEEN '0' AND'9'))
			BEGIN
			RAISERROR (N'Tên không hợp lệ',10,1);
			ROLLBACK;
			END
			SET @Incresment=@Incresment+1
		END
END
GO

--CREATE PROC TinhTienHoaDon (@Ma_HoaDon INT)
--AS
--BEGIN TRAN TienHoaDon
--	DECLARE @TongTienDV INT, @TongTienToaThuoc INT;
--		BEGIN TRAN TienDV
--		SELECT @TongTienDV=SUM(DichVu.Gia)
--		FROM ChiTietDV,DichVu
--		WHERE ChiTietDV.Ma_HoaDon=@Ma_HoaDon AND ChiTietDV.Ma_DichVu=DichVu.Ma_DichVu
--		COMMIT TRAN TienDV

--		BEGIN TRAN TienToaThuoc
--		SELECT @TongTienToaThuoc=SUM(ToaThuoc.Gia)
--		FROM ToaThuoc
--		WHERE ToaThuoc.Ma_HoaDon=@Ma_HoaDon
--		COMMIT TRAN TienToaThuoc
--	UPDATE HoaDon SET TongTien=@TongTienDV+@TongTienToaThuoc
--					WHERE Ma_HoaDon=@Ma_HoaDon
--COMMIT TRAN TienHoaDon
--GO






           
 

EXEC ThemNhanVien N'Bat Xong Hia','10-10-1989','09012345678','BS',12000
EXEC ThemNhanVien N'Choi Xong !Chay','10-10-1989','09099090','YT',124567
EXEC ThemBenhNhan N'Lee Hang Soul',25,1,0905657894
EXEC ThemBenhNhan N'Park Hang Seo',45,1,0779825721
EXEC ThemDichVu N'Khám Bệnh',20000
EXEC ThemDichVu N'Xét nghiệm máu',40000
EXEC ThemThuocMoi N'Paradon Extra',100,N'Hộp',12000
EXEC ChiDinhDV 1,N'Khám Bệnh'
EXEC ThemToaThuoc 1,N'Paradon Extra',5,N'Viên',N'2 Viên/ngày'

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
FROM HienDoanhThuNgay('11/16/2019')
SELECT *
FROM DanhSachBN()
SELECT *
FROM DanhSachDV()
SELECT *
FROM TenDV()
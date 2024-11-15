<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fptshop.cơm.tương...</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.8.1/font/bootstrap-icons.min.css"
          rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        .card-img-top {
            /* width: 70%; */
            padding: 10px 60px 0 60px;
        }

        .card-price {
            display: flex;
            justify-content: space-between;
            /* Đặt khoảng cách giữa hai giá trị */
            align-items: center;
        }

        .original-price {
            color: gray;
            text-decoration: line-through;
            margin-left: 10px;
            /* Đặt khoảng cách giữa hai giá trị */
        }

        .discounted-price {
            color: red;
            font-size: 1.25rem;
            /* Tăng kích thước chữ cho giá sau khi giảm */
            font-weight: bold;
            margin-right: 10px;
            /* Đặt khoảng cách giữa hai giá trị */
        }

        .card-title a:hover {
            color: #0d6efd;
        }

        .card-title a {
            text-decoration: none;
            color: black;
        }

        body {
            background-color: #cdcecf;
        }
    </style>
</head>

<body>
<div class="container">
    <header class="row">
        <img src="https://cdn2.fptshop.com.vn/unsafe/640x0/filters:quality(100)/2022_4_25_637864974294984351_nf_1200x628_1650868492.png"
             alt="" style="height: 200px;">
    </header>
    <nav class="navbar navbar-expand-lg bg-body-tertiary">
        <div class="container-fluid">
            <a class="navbar-brand" href="/home"><img
                    src="https://cdn2.fptshop.com.vn/unsafe/150x0/filters:quality(100)/small/logo_main_2x_ad42cac235.png"
                    alt=""
                    style="height: 80px;"></a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
                    data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent"
                    aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarSupportedContent">
                <%--                <form class="d-flex" role="search">--%>
                <%--                    <input class="form-control me-2" type="search" placeholder="Search" aria-label="Search"--%>
                <%--                           style="width: 400px; margin-left: 50px;">--%>
                <%--                    <button class="btn btn-outline-success" type="submit">Search</button>--%>
                <%--                </form>--%>
                <ul class="navbar-nav me-auto mb-2 mb-lg-0" style="margin-left: 30px;">
                    <li class="nav-item">
                        <a class="nav-link" aria-current="page" href="/home">Trang chủ</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" aria-current="page" href="/chi_tiet_san_pham">Chi tiết sản phẩm</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" aria-current="page" href="/san_pham">Sản phẩm</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" aria-current="page" href="/hoa_don">Hóa đơn</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" aria-current="page" href="/khach_hang">Khách hàng</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" aria-current="page" href="/mau_sac">Màu sắc</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" aria-current="page" href="/size">Size</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" aria-current="page" href="/danh_muc">Danh mục</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <h1 class="text-center mb-4">BÁN HÀNG</h1>
    <div class="row">
        <!-- Sản phẩm và Giỏ hàng -->
        <div class="col-md-8">
            <div class="table-section">
                <!-- Bảng hóa đơn -->
                <div class="card">
                    <div class="card-header">
                        <h2 class="h4">Hóa đơn</h2>
                    </div>
                    <div class="card-body scrollable-table">
                        <div class="overflow-auto">
                            <table class="table table-bordered">
                                <thead class="table-info">
                                <tr>
                                    <th>STT</th>
                                    <th>Mã HD</th>
                                    <th>Tên khách</th>
                                    <th>Ngày tạo</th>
                                    <th>Trạng thái</th>
                                    <th>Action</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach items="${listHD}" var="lhd" varStatus="s">
                                    <tr>
                                        <td>${s.count}</td>
                                        <td>${lhd.id}</td>
                                        <td>${lhd.khachHang.hoTen}</td>
                                        <td>${lhd.ngayTao}</td>
                                        <td>${lhd.trangThai}</td>
                                        <td>
                                            <a href="/home/xem_hoa_don/${lhd.id}"
                                               class="btn btn-primary btn-sm">Xem HĐ</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <a href="/home/tao_hoa_don?soDT=${sessionScope.hoaDon.khachHang.sdt}"
                       class="btn btn-primary mt-3">Tạo hóa đơn mới</a>

                </div>
            </div>
            <div class="table-section">
                <!-- Bảng sản phẩm -->
                <div class="card">
                    <div class="card-header">
                        <h2 class="h4">Sản phẩm</h2>
                    </div>
                    <div class="card-body scrollable-table">
                        <div class="overflow-auto">
                            <table class="table table-bordered">
                                <thead class="table-info">
                                <tr>
                                    <th>STT</th>
                                    <th>Mã SP</th>
                                    <th>Tên SP</th>
                                    <th>Màu Sắc</th>
                                    <th>Size</th>
                                    <th>Giá SP</th>
                                    <th>Số lượng</th>
                                    <th>Action</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach items="${listCTSP}" var="lctsp" varStatus="s">
                                    <tr>
                                        <td>${s.count}</td>
                                        <td>${lctsp.sanPham.maSanPham}</td>
                                        <td>${lctsp.sanPham.tenSanPham}</td>
                                        <td>${lctsp.mauSac.tenMau}</td>
                                        <td>${lctsp.size.tenSize}</td>
                                        <td>${lctsp.giaBan}</td>
                                        <td>${lctsp.soLuongTon}</td>
                                        <td>
                                            <c:if test="${not empty sessionScope.hoaDon}">
                                                <!-- Form để nhập số lượng và thêm sản phẩm vào giỏ -->
                                                <form action="/home/them_vao_gio/${lctsp.id}?idhd=${sessionScope.hoaDon.id}"
                                                      method="POST" class="form-inline">
                                                    <div class="input-group">
                                                        <button type="button"
                                                                class="btn btn-warning d-flex justify-content-center"
                                                                style="width: 30px;"
                                                                onclick="decreaseQuantity(${s.index})">-
                                                        </button>
                                                        <input type="text" name="soLuongMua" id="quantity-${s.index}"
                                                               min="1"
                                                               max="${lctsp.soLuongTon}" value="1" readonly
                                                            <%--                                                               class="form-control form-control-sm d-inline-block"--%>
                                                               style="width: 30px; outline: none; text-align: center; border: beige; background-color: bisque"
                                                               required>
                                                        <button type="button"
                                                                class="btn btn-warning d-flex justify-content-center"
                                                                style="width: 30px;"
                                                                onclick="increaseQuantity(${s.index})">+
                                                        </button>
                                                        <button type="submit" class="btn btn-success btn-sm">Thêm
                                                        </button>
                                                    </div>
                                                </form>
                                            </c:if>
                                            <c:if test="${empty sessionScope.hoaDon}">
                                                <button class="btn btn-secondary btn-sm" disabled>Thêm</button>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <div class="table-section">
                <!-- Bảng giỏ hàng -->
                <div class="card">
                    <div class="card-header">
                        <h2 class="h4">Giỏ hàng</h2>
                    </div>
                    <div class="card-body scrollable-table">
                        <div class="overflow-auto">
                            <table class="table table-bordered">
                                <thead class="table-info">
                                <tr>
                                    <th>STT</th>
                                    <th>Mã SP</th>
                                    <th>Tên SP</th>
                                    <th>Giá SP</th>
                                    <th>Số lượng mua</th>
                                    <th>Tổng tiền</th>
                                    <th>Action</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach items="${listHDCT}" var="lhdct" varStatus="s">
                                    <tr>
                                        <td>${s.count}</td>
                                        <td>${lhdct.ctsp.sanPham.maSanPham}</td>
                                        <td>${lhdct.ctsp.sanPham.tenSanPham}</td>
                                        <td>${lhdct.giaBan}</td>
                                        <td>${lhdct.soLuongMua}</td>
                                        <td>${lhdct.tongTien}</td>
                                        <td>
                                            <a href="/home/xoa_san_pham/${lhdct.id}"
                                               class="btn btn-danger btn-sm">Xóa</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Hóa đơn và Thanh toán -->
        <div class="col-md-4">


            <!-- Thông tin thanh toán -->
            <div class="card">
                <div class="card-header">
                    <h2 class="h4">Thanh toán</h2>
                </div>
                <div class="card-body">
                    <c:if test="${not empty message}">
                        <div class="alert alert-danger">${message}</div>
                    </c:if>
                    <!-- Tìm kiếm khách hàng -->
                    <form action="/home/tim_khach_hang" method="GET" class="mb-3">
                        <div class="mb-3">
                            <label for="soDT" class="form-label">Số điện thoại</label>
                            <input type="text" class="form-control" id="soDT" name="soDT"
                                   value="${sessionScope.hoaDon.khachHang.sdt}">
                        </div>
                        <div class="d-flex">
                            <button type="submit" class="btn btn-primary">Tìm kiếm</button>
                            <button type="submit" class="btn btn-success" style="margin-left: 200px"
                                    formaction="/khach_hang">New KH
                            </button>
                        </div>
                    </form>

                    <!-- Form thanh toán -->
                    <form id="formThanhToan" action="/home/thanh_toan" method="POST">
                        <div class="mb-3">
                            <label for="tenKH" class="form-label">Tên khách hàng</label>
                            <input type="text" class="form-control" id="tenKH" name="tenKH"
                                   value="${sessionScope.hoaDon.khachHang.hoTen}" readonly>
                        </div>

                        <div class="mb-3">
                            <label for="maHD" class="form-label">Mã Hóa Đơn</label>
                            <input type="text" class="form-control" id="maHD" name="id"
                                   value="${sessionScope.hoaDon.id}" readonly>
                        </div>

                        <div class="mb-3">
                            <label for="ngayTao" class="form-label">Ngày Tạo</label>
                            <input type="text" class="form-control" id="ngayTao" name="ngay_tao"
                                   value="${sessionScope.hoaDon.ngayTao}" readonly>
                        </div>

                        <div class="mb-3">
                            <label for="tongTien" class="form-label">Tổng Tiền</label>
                            <input type="text" class="form-control" id="tongTien" name="tong_tien"
                                   value="${sessionScope.tongTien}" readonly>
                        </div>

                        <div class="mb-3">
                            <label for="tienKhachTra" class="form-label">Tiền Khách Trả</label>
                            <input type="number" class="form-control" id="tienKhachTra" name="tien_khach_tra" required>
                        </div>
                        <div id="thongBao" class="mb-3 text-danger" style="display:none;"></div>

                        <div class="d-flex justify-content-center">
                            <button type="submit" class="btn btn-success" id="btnThanhToan"
                            ${empty sessionScope.hoaDon.id or sessionScope.tongTien == 0 ? 'disabled' : ''}>
                                Thanh toán
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <hr>
    <footer class="footer">
        <div class="container">
            <div class="row">
                <div class="col-md-4">
                    <h5>About Us</h5>
                    <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam ac urna vel dui vulputate
                        luctus.
                    </p>
                </div>
                <div class="col-md-4">
                    <h5>Contact Us</h5>
                    <p>Email: contact@example.com</p>
                    <p>Phone: +123 456 789</p>
                </div>
                <div class="col-md-4">
                    <h5>Follow Us</h5>
                    <a href="#"><i class="bi bi-facebook"></i> Facebook</a><br>
                    <a href="#"><i class="bi bi-twitter"></i> Twitter</a><br>
                    <a href="#"><i class="bi bi-instagram"></i> Instagram</a>
                </div>
            </div>
        </div>
    </footer>
    <footer class="row" style="text-align: center; background-color: rgb(253, 249, 244);padding-top: 20px;">
        <p>© 2007 - 2023 Công Ty Cổ Phần Bán Lẻ Kỹ Thuật Số FPT / Địa chỉ: 261 - 263 Khánh Hội, P2, Q4, TP. Hồ Chí
            Minh / GPĐKKD số 0311609355 do Sở KHĐT TP.HCM cấp ngày 08/03/2012. GP số 47/GP-TTĐT do sở TTTT TP HCM
            cấp ngày 02/07/2018. Điện thoại: (028) 7302 3456. Email: fptshop@fpt.com. Chịu trách nhiệm nội dung:
            Nguyễn Trịnh Nhật Linh.</p>
    </footer>
</div>
<script>
    function increaseQuantity(index) {
        let quantityInput = document.getElementById('quantity-' + index);
        let currentValue = parseInt(quantityInput.value);
        let maxValue = parseInt(quantityInput.max);
        if (currentValue < maxValue) {
            quantityInput.value = currentValue + 1;
        }
    }

    function decreaseQuantity(index) {
        let quantityInput = document.getElementById('quantity-' + index);
        let currentValue = parseInt(quantityInput.value);
        if (currentValue > 1) {
            quantityInput.value = currentValue - 1;
        }
    }

    document.getElementById('formThanhToan').addEventListener('submit', function(event) {
        event.preventDefault();  // Ngăn form gửi ngay lập tức

        const tongTien = parseFloat(document.getElementById('tongTien').value);
        const tienKhachTra = parseFloat(document.getElementById('tienKhachTra').value);
        const thongBao = document.getElementById('thongBao');
        // const btnThanhToan = document.getElementById('btnThanhToan');

        if(tienKhachTra < 0){
            thongBao.style.display = 'block';
            thongBao.textContent = 'Tiền của người ÂM PHỦ à!';
            // btnThanhToan.disabled = true;
        } else if (tienKhachTra < tongTien) {
            thongBao.style.display = 'block';
            const tienThieu = tongTien - tienKhachTra;
            thongBao.textContent = 'Không đủ tiền! Nôn thêm ' + tienThieu + ' VND nữa!';
            // btnThanhToan.disabled = true;
        } else {
            thongBao.style.display = 'block';
            const tienThua = tienKhachTra - tongTien;
            thongBao.textContent = 'Thanh toán thành công! Xóp đớp ' + tienThua + ' VND luôn!';
            // btnThanhToan.disabled = false;
            this.submit();
        }
    });
    // Ẩn thông báo khi người dùng bắt đầu nhập lại
    document.getElementById('tienKhachTra').addEventListener('input', function() {
        document.getElementById('thongBao').style.display = 'none';
    });

</script>
<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
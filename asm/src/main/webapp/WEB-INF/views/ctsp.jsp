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

    <div class="container mt-5">
        <div class="card">
            <div class="card-header text-center">
                <h2>Quản Lý Sản Phẩm Chi Tiết</h2>
            </div>
            <div class="card-body">
                <form action="/chi_tiet_san_pham/add" method="post">
                    <div class="form-group">
                        <label for="tenSanPham">Tên sản phẩm: </label>
                        <select name="sanPham" id="sanPham" class="form-control">
                            <c:forEach items="${listSP}" var="listSP">
                                <option value="${listSP.id}" ${ctsp.sanPham.id == listSP.id ? "selected" : ""}>${listSP.tenSanPham}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="tenMau">Màu sắc: </label>
                        <select name="mauSac" id="mauSac" class="form-control">
                            <c:forEach items="${listMS}" var="listMS">
                                <option value="${listMS.id}" ${ctsp.mauSac.id == listMS.id ? "selected" : ""}>${listMS.tenMau}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="tenSize">Size: </label>
                        <select name="size" id="size" class="form-control">
                            <c:forEach items="${listSize}" var="listSize">
                                <option value="${listSize.id}" ${ctsp.size.id == listSize.id ? "selected" : ""}>${listSize.tenSize}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="giaBan">Giá bán: </label>
                        <input type="number" class="form-control" id="giaBan" name="giaBan" placeholder="Nhập giá bán"
                               required value="${ctsp.giaBan}">
                    </div>

                    <div class="form-group">
                        <label for="soLuongTon">Số lượng tồn: </label>
                        <input type="number" class="form-control" id="soLuongTon" name="soLuongTon"
                               placeholder="Nhập số lượng" required value="${ctsp.soLuongTon}">
                    </div>

                    <div class="form-group">
                        <label for="trangThai">Trạng Thái: </label>
                        <div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" id="active" name="trangThai"
                                       value="Active" ${ctsp.trangThai == 'Active' ? 'checked' : ''} checked>
                                <label class="form-check-label" for="active">Active</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" id="inactive" name="trangThai"
                                       value="Inactive" ${ctsp.trangThai == 'Inactive' ? 'checked' : ''}>
                                <label class="form-check-label" for="inactive">Inactive</label>
                            </div>
                        </div>
                    </div>

                    <div class="text-center">
                        <button formaction="/chi_tiet_san_pham/add" type="submit" class="btn btn-success">Thêm</button>
                        <button formaction="/chi_tiet_san_pham/update/${ctsp.id}" type="submit" class="btn btn-success">
                            Sửa
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <div class="mt-5">
            <h3>Danh Sách Sản Phẩm</h3>
            <table class="table table-striped table-bordered">
                <thead>
                <tr>
                    <th>STT</th>
                    <th>ID</th>
                    <th>Tên sản phẩm</th>
                    <th>Màu sắc</th>
                    <th>Size</th>
                    <th>Giá bán</th>
                    <th>Số lượng tồn</th>
                    <th>Trạng Thái</th>
                    <th>Ngày Tạo</th>
                    <th>Ngày Sửa</th>
                    <th>Hành Động</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${listCTSP}" var="spct" varStatus="s">
                    <tr>
                        <td>${s.count}</td>
                        <td>${spct.id}</td>
                        <td>${spct.sanPham.tenSanPham}</td>
                        <td>${spct.mauSac.tenMau}</td>
                        <td>${spct.size.tenSize}</td>
                        <td>${spct.giaBan}</td>
                        <td>${spct.soLuongTon}</td>
                        <td>${spct.trangThai}</td>
                        <td>${spct.ngayTao}</td>
                        <td>${spct.ngaySua}</td>
                        <td>
                            <a href="/chi_tiet_san_pham/delete/${spct.id}" class="btn btn-danger">Delete</a>
                            <a href="/chi_tiet_san_pham/detail/${spct.id}" class="btn btn-info">Detail</a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
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
<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.2/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
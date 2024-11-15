package com.example.asm_web_ban_hang.controller;

import com.example.asm_web_ban_hang.model.*;
import com.example.asm_web_ban_hang.repository.*;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.sql.Date;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Controller
public class AdminController {

    @Autowired
    KhachHangRepository khachHangRepository;
    @Autowired
    CTSPRepository ctspRepository;
    @Autowired
    DanhMucRepository danhMucRepository;
    @Autowired
    HDCTRepository hdctRepository;
    @Autowired
    MauSacRepository mauSacRepository;
    @Autowired
    SanPhamRepository sanPhamRepository;
    @Autowired
    SizeRepository sizeRepository;
    @Autowired
    HoaDonRepository hoaDonRepository;


    private double tinhTongTienGioHang(Integer hoaDonId) {
        double tongTien = 0;
        List<HDCT> listHDCT = hdctRepository.getL(hoaDonId);

        for (HDCT h : listHDCT) {
            tongTien += h.getTongTien();
        }

        return tongTien;
    }

    @GetMapping("/home")
    public String home(Model model) {
        model.addAttribute("listCTSP", ctspRepository.findAll());
        model.addAttribute("listHD", hoaDonRepository.getListChuaTT());
        return "trang_chu";
    }

    @GetMapping("/home/tao_hoa_don")
    public String taoHoaDon(String soDT, HttpSession session) {
        Optional<KhachHang> khachHang = khachHangRepository.findBySdt(soDT);

        if (khachHang.isPresent()) {
            HoaDon hoaDon = new HoaDon(null, khachHang.get(), "Cho thanh toan", Date.valueOf(LocalDate.now()), Date.valueOf(LocalDate.now()), null, soDT);
            hoaDonRepository.save(hoaDon);

            // Lưu hóa đơn vào session
            session.setAttribute("hoaDon", hoaDon);

            // Khởi tạo tổng tiền là 0 khi mới tạo hóa đơn
            session.setAttribute("tongTien", 0.0);
        } else {
            HoaDon hoaDon = new HoaDon(null, null, "Cho thanh toan", Date.valueOf(LocalDate.now()), Date.valueOf(LocalDate.now()), null, null);
            hoaDonRepository.save(hoaDon);

            // Lưu hóa đơn vào session
            session.setAttribute("hoaDon", hoaDon);

            // Khởi tạo tổng tiền là 0 khi mới tạo hóa đơn
            session.setAttribute("tongTien", 0.0);
        }
        return "redirect:/home";
    }

    @GetMapping("/home/xem_hoa_don/{id}")
    public String xemHoaDon(@PathVariable("id") Integer id, Model model, HttpSession session) {
        Optional<HoaDon> optionalHoaDon = hoaDonRepository.findById(id);

        if (optionalHoaDon.isPresent()) {
            HoaDon hoaDon = optionalHoaDon.get();
            model.addAttribute("hoaDon", hoaDon);

            // Lưu hóa đơn vào session
            session.setAttribute("hoaDon", hoaDon);

            // Tính tổng tiền và lưu vào session
            double tongTien = tinhTongTienGioHang(hoaDon.getId());
            session.setAttribute("tongTien", tongTien);
        } else {
            model.addAttribute("hoaDon", new HoaDon());
            session.setAttribute("tongTien", 0.0);
        }

        model.addAttribute("listCTSP", ctspRepository.findAll());
        model.addAttribute("listHDCT", hdctRepository.getL(id));
        model.addAttribute("listHD", hoaDonRepository.getListChuaTT());

        return "trang_chu";
    }

    @PostMapping("/home/them_vao_gio/{id}")
    public String ThemVaoGio(@PathVariable("id") Integer id,
                             @RequestParam("soLuongMua") Integer soLuongMua,
                             HttpSession session, Model model) {
        Optional<CTSP> optionalCTSP = ctspRepository.findById(id);
        if (optionalCTSP.isPresent()) {
            CTSP chiTietSanPham = optionalCTSP.get();

            // Lấy hóa đơn từ session
            HoaDon hoaDon = (HoaDon) session.getAttribute("hoaDon");

            // Kiểm tra nếu hóa đơn tồn tại và số lượng tồn đủ đáp ứng yêu cầu mua
            if (hoaDon != null && chiTietSanPham.getSoLuongTon() >= soLuongMua) {
                // Cập nhật số lượng tồn
                chiTietSanPham.setSoLuongTon(chiTietSanPham.getSoLuongTon() - soLuongMua);
                ctspRepository.save(chiTietSanPham);

                boolean existsInCart = false;

                // Tìm kiếm sản phẩm trong giỏ hàng
                for (HDCT h : hdctRepository.findAll()) {
                    if (h.getCtsp().getId().equals(chiTietSanPham.getId()) && h.getHoaDon().getId().equals(hoaDon.getId())) {
                        h.setSoLuongMua(h.getSoLuongMua() + soLuongMua);
                        h.setTongTien(h.getSoLuongMua() * h.getGiaBan());
                        hdctRepository.save(h);
                        existsInCart = true;
                        break;
                    }
                }

                // Nếu sản phẩm chưa có trong giỏ hàng, thêm mới vào giỏ
                if (!existsInCart) {
                    HDCT hoaDonChiTiet = new HDCT(null, hoaDon, chiTietSanPham, soLuongMua, chiTietSanPham.getGiaBan(), soLuongMua * chiTietSanPham.getGiaBan(), null, Date.valueOf(LocalDate.now()), Date.valueOf(LocalDate.now()));
                    hdctRepository.save(hoaDonChiTiet);
                }

                // Cập nhật tổng tiền giỏ hàng
                double tongTien = tinhTongTienGioHang(hoaDon.getId());
                session.setAttribute("tongTien", tongTien);
                session.setAttribute("listHDCT", hdctRepository.getL(hoaDon.getId()));
            }
        }

        return "redirect:/home";
    }

    @GetMapping("/home/xoa_san_pham/{id}")
    public String xoaSanPhamGioHang(@PathVariable("id") Integer id, HttpSession session) {
        Optional<HDCT> optionalHDCT = hdctRepository.findById(id);

        if (optionalHDCT.isPresent()) {
            HDCT hoaDonChiTiet = optionalHDCT.get();
            CTSP chiTietSanPham = hoaDonChiTiet.getCtsp();

            // Cộng lại số lượng mua vào số lượng tồn của sản phẩm
            chiTietSanPham.setSoLuongTon(chiTietSanPham.getSoLuongTon() + hoaDonChiTiet.getSoLuongMua());
            ctspRepository.save(chiTietSanPham);

            // Xóa sản phẩm khỏi giỏ hàng
            hdctRepository.delete(hoaDonChiTiet);

            // Lấy hóa đơn từ session
            HoaDon hoaDon = (HoaDon) session.getAttribute("hoaDon");

            // Cập nhật tổng tiền giỏ hàng
            double tongTien = tinhTongTienGioHang(hoaDon.getId());
            session.setAttribute("tongTien", tongTien);

            // Cập nhật lại danh sách sản phẩm trong giỏ hàng
            session.setAttribute("listHDCT", hdctRepository.getL(hoaDon.getId()));
        }

        return "redirect:/home";
    }


    @GetMapping("/home/tim_khach_hang")
    public String timKhachHang(@RequestParam("soDT") String soDT, Model model, HttpSession session) {
        Optional<KhachHang> khachHang = khachHangRepository.findBySdt(soDT);
        HoaDon hoaDon = (HoaDon) new HoaDon();

        if (khachHang.isPresent()) {
            // If customer is found, update the session with the customer's information

            hoaDon.setKhachHang(khachHang.get());
            session.setAttribute("hoaDon", hoaDon);
        } else {
            // If not found, set a message to indicate no customer found
            session.setAttribute("hoaDon", new HoaDon());
            model.addAttribute("message", "Không tìm thấy khách hàng với số điện thoại này.");
        }

        // Update the model with necessary attributes to display
        model.addAttribute("listCTSP", ctspRepository.findAll());
        model.addAttribute("listHDCT", hdctRepository.getL(hoaDon.getId()));
        model.addAttribute("listHD", hoaDonRepository.getListChuaTT());
//        model.addAttribute("listHD", hoaDonRepository.findAll());

        return "trang_chu";
    }

    @PostMapping("/home/thanh_toan")
    public String thanhToan(@RequestParam("id") Integer hoaDonId, HttpSession session, Model model) {

        Optional<HoaDon> optionalHoaDon = hoaDonRepository.findById(hoaDonId);
        HoaDon hd = (HoaDon) new HoaDon();

        if (optionalHoaDon.isPresent()) {
            HoaDon hoaDon = optionalHoaDon.get();

            // Kiểm tra nếu hóa đơn không có hoặc tổng tiền bằng 0 thì không cho thanh toán
            Double tongTien = (Double) session.getAttribute("tongTien");
            if (hoaDon.getId() == null || tongTien == null || tongTien == 0) {
                model.addAttribute("message", "Không thể thanh toán vì hóa đơn hoặc tổng tiền không hợp lệ.");
                return "redirect:/home";
            }

            // Cập nhật trạng thái hóa đơn thành "Đã thanh toán"
            hoaDon.setTrangThai("Da thanh toan");

            // Cập nhật ngày sửa thành ngày hiện tại
            hoaDon.setNgaySua(Date.valueOf(LocalDate.now()));

            // Lưu hóa đơn đã cập nhật
            hoaDonRepository.save(hoaDon);

            // Xóa hóa đơn và giỏ hàng khỏi session
            session.removeAttribute("hoaDon");
            session.removeAttribute("tongTien");
            session.removeAttribute("listHDCT");

            model.addAttribute("message", "Thanh toán thành công!");
        } else {
            model.addAttribute("message", "Không tìm thấy hóa đơn.");
        }

        model.addAttribute("listHDCT", hdctRepository.getL(hd.getId()));
        model.addAttribute("listHD", hoaDonRepository.findAll());
        return "redirect:/home"; // Chuyển hướng về trang bán hàng
    }

    //----------------------------------------------DANH MỤC------------------------------------------------------//
    @GetMapping("/danh_muc")
    public String danhMuc(Model model) {
        model.addAttribute("listDM", danhMucRepository.findAll());
        return "danh_muc";
    }

    @PostMapping("/danh_muc/add")
    public String adddDM(DanhMuc danhMuc, RedirectAttributes redirectAttributes) {
        danhMuc.setNgaySua(Date.valueOf(LocalDate.now()));
        danhMuc.setNgayTao(Date.valueOf(LocalDate.now()));
        danhMucRepository.save(danhMuc);
        redirectAttributes.addFlashAttribute("message", "Thêm danh mục thành công");
        return "redirect:/danh_muc";
    }

    @PostMapping("/danh_muc/upadate/{id}")
    public String updateDM(@PathVariable("id") Integer id, DanhMuc danhMuc) {
        danhMuc.setNgaySua(Date.valueOf(LocalDate.now()));
        danhMuc.setNgayTao(danhMucRepository.findById(id).get().getNgayTao());
        danhMucRepository.save(danhMuc);
        return "redirect:/danh_muc";
    }

    @GetMapping("/danh_muc/delete/{id}")
    public String deleteDM(@PathVariable("id") Integer id, RedirectAttributes redirectAttributes) {
        danhMucRepository.deleteById(id);
        redirectAttributes.addFlashAttribute("message", "Xóa danh mục thành công");
        return "redirect:/danh_muc";
    }

    @GetMapping("/danh_muc/detail/{id}")
    public String detailDM(@PathVariable Integer id, Model model) {
        DanhMuc danhMuc = danhMucRepository.findById(id).orElse(new DanhMuc());
        model.addAttribute("danhMuc", danhMuc);
        model.addAttribute("listDM", danhMucRepository.findAll());
        return "danh_muc";
    }

    //----------------------------------------------KHÁCH HÀNG------------------------------------------------------//
    @GetMapping("/khach_hang")
    public String khachHang(Model model) {
        model.addAttribute("listKH", khachHangRepository.findAll());
        return "khach_hang";
    }

    @GetMapping("/khach_hang/detail/{id}")
    public String detailKH(@PathVariable Integer id, Model model) {
        KhachHang kh = khachHangRepository.findById(id).orElse(new KhachHang());
        model.addAttribute("khachHang", kh);
        model.addAttribute("listKH", khachHangRepository.findAll());
        return "khach_hang";
    }

    @PostMapping("/khach_hang/add")
    public String addKH(KhachHang khachHang, RedirectAttributes redirectAttributes) {
        khachHang.setNgaySua(Date.valueOf(LocalDate.now()));
        khachHang.setNgayTao(Date.valueOf(LocalDate.now()));
        khachHangRepository.save(khachHang);
        redirectAttributes.addFlashAttribute("message", "Thêm khách hàng thành công");
        return "redirect:/khach_hang";
    }

    @PostMapping("/khach_hang/update/{id}")
    public String updateKH(@PathVariable("id") Integer id, KhachHang kh, RedirectAttributes redirectAttributes) {
        kh.setNgaySua(Date.valueOf(LocalDate.now()));
        kh.setNgayTao((khachHangRepository.findById(id).get().getNgayTao()));
        khachHangRepository.save(kh);
        redirectAttributes.addFlashAttribute("message", "Sửa khách hàng thành công");
        return "redirect:/khach_hang";
    }

    @GetMapping("/khach_hang/delete/{id}")
    public String deleteKH(@PathVariable("id") Integer id, RedirectAttributes redirectAttributes) {
        khachHangRepository.deleteById(id);
        redirectAttributes.addFlashAttribute("message", "Xóa khách hàng thành công");
        return "redirect:/khach_hang";
    }

    //----------------------------------------------HÓA ĐƠN------------------------------------------------------//
    @GetMapping("/hoa_don")
    public String hoaDon(Model model) {
        model.addAttribute("listHD", hoaDonRepository.findAll());
        return "hoa_don";
    }

    @GetMapping("/hoa_don/detail/{id}")
    public String detailHD(@PathVariable("id") Integer id, Model model, HttpSession session) {
        Optional<HoaDon> optionalHoaDon = hoaDonRepository.findById(id);

        if (optionalHoaDon.isPresent()) {
            HoaDon hoaDon = optionalHoaDon.get();
            model.addAttribute("hoaDon", hoaDon);

            // Lưu hóa đơn vào session
            session.setAttribute("hoaDon", hoaDon);

            // Tính tổng tiền và lưu vào session
            double tongTien = tinhTongTienGioHang(hoaDon.getId());
            session.setAttribute("tongTien", tongTien);
        } else {
            model.addAttribute("hoaDon", new HoaDon());
            session.setAttribute("tongTien", 0.0);
        }

//        model.addAttribute("listCTSP", ctspRepository.findAll());
        model.addAttribute("listHDCT", hdctRepository.getL(id));
        model.addAttribute("listHD", hoaDonRepository.findAll());

        return "hoa_don";
    }

//    @GetMapping("/hoa_don/all")
//    public String allHD(Model model) {
//        model.addAttribute("listHD", hoaDonRepository.findAll());
//        return "hoa_don";
//    }
    @GetMapping("/hoa_don/chua_tt")
    public String hdChuaTT(Model model) {
        model.addAttribute("listHD", hoaDonRepository.getListChuaTT());
        return "hoa_don";
    }
    @GetMapping("/hoa_don/da_tt")
    public String hdDaTT(Model model) {
        model.addAttribute("listHD", hoaDonRepository.getListDaTT());
        return "hoa_don";
    }

    //----------------------------------------------SẢN PHẨM------------------------------------------------------//
    @GetMapping("/san_pham")
    public String sanPham(Model model) {
        model.addAttribute("listSP", sanPhamRepository.findAll());
        model.addAttribute("listDM", danhMucRepository.findAll());
        return "san_pham";
    }

    @PostMapping("/san_pham/add")
    public String addSP(SanPham sanPham) {
        sanPham.setNgayTao(Date.valueOf(LocalDate.now()));
        sanPham.setNgaySua(Date.valueOf(LocalDate.now()));
        sanPhamRepository.save(sanPham);
        return "redirect:/san_pham";
    }

    @GetMapping("/san_pham/delete/{id}")
    public String deleteSP(@PathVariable("id") Integer id, RedirectAttributes redirectAttributes) {
        sanPhamRepository.deleteById(id);
        redirectAttributes.addFlashAttribute("message", "Xóa thành công");
        return "redirect:/san_pham";
    }

    @GetMapping("/san_pham/detail/{id}")
    public String detailSP(@PathVariable Integer id, Model model) {
        SanPham sp = sanPhamRepository.findById(id).orElse(new SanPham());
        model.addAttribute("sanPham", sp);
        model.addAttribute("listSP", sanPhamRepository.findAll());
        model.addAttribute("listDM", danhMucRepository.findAll());
        return "san_pham";
    }

    @PostMapping("/san_pham/update/{id}")
    public String updateSP(@PathVariable("id") Integer id, SanPham sp, RedirectAttributes redirectAttributes,
                           @RequestParam("danhMuc") Integer idDM) {
        DanhMuc dm = danhMucRepository.findById(idDM).get();
        sp.setNgaySua(Date.valueOf(LocalDate.now()));
        sp.setNgayTao((sanPhamRepository.findById(id).get().getNgayTao()));
        sp.setDanhMuc(dm);
        sanPhamRepository.save(sp);
        redirectAttributes.addFlashAttribute("message", "Sửa thành công");
        return "redirect:/san_pham";
    }

    //----------------------------------------------MÀU SẮC------------------------------------------------------//
    @GetMapping("/mau_sac")
    public String mauSac(Model model) {
        model.addAttribute("listMS", mauSacRepository.findAll());
        return "mau_sac";
    }

    @GetMapping("/mau_sac/detail/{id}")
    public String detailMS(@PathVariable Integer id, Model model) {
        MauSac ms = mauSacRepository.findById(id).orElse(new MauSac());
        model.addAttribute("mauSac", ms);
        model.addAttribute("listMS", mauSacRepository.findAll());
        return "mau_sac";
    }

    @PostMapping("/mau_sac/add")
    public String addMS(MauSac ms, RedirectAttributes redirectAttributes) {
        ms.setNgaySua(Date.valueOf(LocalDate.now()));
        ms.setNgayTao(Date.valueOf(LocalDate.now()));
        mauSacRepository.save(ms);
        redirectAttributes.addFlashAttribute("message", "Thêm thành công");
        return "redirect:/mau_sac";
    }

    @PostMapping("/mau_sac/update/{id}")
    public String updateMS(@PathVariable("id") Integer id, MauSac ms, RedirectAttributes redirectAttributes) {
        ms.setNgaySua(Date.valueOf(LocalDate.now()));
        ms.setNgayTao((mauSacRepository.findById(id).get().getNgayTao()));
        mauSacRepository.save(ms);
        redirectAttributes.addFlashAttribute("message", "Sửa thành công");
        return "redirect:/mau_sac";
    }

    @GetMapping("/mau_sac/delete/{id}")
    public String deleteMS(@PathVariable("id") Integer id, RedirectAttributes redirectAttributes) {
        mauSacRepository.deleteById(id);
        redirectAttributes.addFlashAttribute("message", "Xóa thành công");
        return "redirect:/mau_sac";
    }

    //----------------------------------------------SIZE------------------------------------------------------//
    @GetMapping("/size")
    public String size(Model model) {
        model.addAttribute("listSize", sizeRepository.findAll());
        return "size";
    }

    @GetMapping("/size/detail/{id}")
    public String detailS(@PathVariable Integer id, Model model) {
        Size s = sizeRepository.findById(id).orElse(new Size());
        model.addAttribute("size", s);
        model.addAttribute("listSize", sizeRepository.findAll());
        return "size";
    }

    @PostMapping("/size/add")
    public String addS(Size size, RedirectAttributes redirectAttributes) {
        size.setNgaySua(Date.valueOf(LocalDate.now()));
        size.setNgayTao(Date.valueOf(LocalDate.now()));
        sizeRepository.save(size);
        redirectAttributes.addFlashAttribute("message", "Thêm thành công");
        return "redirect:/size";
    }

    @PostMapping("/size/update/{id}")
    public String updateS(@PathVariable("id") Integer id, Size size, RedirectAttributes redirectAttributes) {
        size.setNgaySua(Date.valueOf(LocalDate.now()));
        size.setNgayTao((sizeRepository.findById(id).get().getNgayTao()));
        sizeRepository.save(size);
        redirectAttributes.addFlashAttribute("message", "Sửa thành công");
        return "redirect:/size";
    }

    @GetMapping("/size/delete/{id}")
    public String deleteS(@PathVariable("id") Integer id, RedirectAttributes redirectAttributes) {
        sizeRepository.deleteById(id);
        redirectAttributes.addFlashAttribute("message", "Xóa thành công");
        return "redirect:/size";
    }

    //----------------------------------------------HÓA ĐƠN CHI TIẾT------------------------------------------------------//
    @GetMapping("/hoa_don_chi_tiet")
    public String hdct() {
        return "hdct";
    }

    //----------------------------------------------CHI TIẾT SẢN PHẨM------------------------------------------------------//
    @GetMapping("/chi_tiet_san_pham")
    public String ctsp(Model model) {
        model.addAttribute("listCTSP", ctspRepository.findAll());
        model.addAttribute("listSP", sanPhamRepository.findAll());
        model.addAttribute("listMS", mauSacRepository.findAll());
        model.addAttribute("listSize", sizeRepository.findAll());
        return "ctsp";
    }

    @PostMapping("/chi_tiet_san_pham/add")
    public String addCTSP(CTSP ctsp) {
        ctsp.setNgayTao(Date.valueOf(LocalDate.now()));
        ctsp.setNgaySua(Date.valueOf(LocalDate.now()));
        ctspRepository.save(ctsp);
        return "redirect:/chi_tiet_san_pham";
    }

    @GetMapping("/chi_tiet_san_pham/delete/{id}")
    public String deleteCTSP(@PathVariable("id") Integer id, RedirectAttributes redirectAttributes) {
        ctspRepository.deleteById(id);
        redirectAttributes.addFlashAttribute("message", "Xóa thành công");
        return "redirect:/chi_tiet_san_pham";
    }

    @GetMapping("/chi_tiet_san_pham/detail/{id}")
    public String detailCTSP(@PathVariable Integer id, Model model) {
        CTSP ctsp = ctspRepository.findById(id).orElse(new CTSP());
        model.addAttribute("ctsp", ctsp);
        model.addAttribute("listCTSP", ctspRepository.findAll());
        model.addAttribute("listSP", sanPhamRepository.findAll());
        model.addAttribute("listMS", mauSacRepository.findAll());
        model.addAttribute("listSize", sizeRepository.findAll());
        return "ctsp";
    }

    @PostMapping("/chi_tiet_san_pham/update/{id}")
    public String updateCTSP(@PathVariable("id") Integer id, CTSP ctsp, RedirectAttributes redirectAttributes,
                             @RequestParam("sanPham") Integer idSP,
                             @RequestParam("mauSac") Integer idMS,
                             @RequestParam("size") Integer idSize) {
        SanPham sp = sanPhamRepository.findById(idSP).get();
        MauSac ms = mauSacRepository.findById(idMS).get();
        Size size = sizeRepository.findById(idSize).get();
        ctsp.setNgaySua(Date.valueOf(LocalDate.now()));
        ctsp.setNgayTao((ctspRepository.findById(id).get().getNgayTao()));
        ctsp.setSanPham(sp);
        ctsp.setMauSac(ms);
        ctsp.setSize(size);
        ctspRepository.save(ctsp);
        redirectAttributes.addFlashAttribute("message", "Sửa thành công");
        return "redirect:/chi_tiet_san_pham";
    }
}

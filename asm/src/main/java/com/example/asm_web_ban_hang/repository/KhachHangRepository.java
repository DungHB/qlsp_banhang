package com.example.asm_web_ban_hang.repository;

import com.example.asm_web_ban_hang.model.KhachHang;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface KhachHangRepository extends JpaRepository<KhachHang, Integer> {
    Optional<KhachHang> findBySdt(String sdt);
}

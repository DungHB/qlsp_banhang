package com.example.asm_web_ban_hang.repository;

import com.example.asm_web_ban_hang.model.HDCT;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface HDCTRepository extends JpaRepository<HDCT, Integer> {
    @Query("SELECT h FROM HDCT h WHERE h.hoaDon.id = :idhd")
    List<HDCT> getL(Integer idhd);
}

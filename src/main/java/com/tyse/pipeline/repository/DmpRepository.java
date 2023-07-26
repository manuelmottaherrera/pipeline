package com.tyse.pipeline.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.transaction.annotation.Transactional;

import com.tyse.pipeline.domain.entities.Dmp;

public interface DmpRepository extends JpaRepository<Dmp, Short> {

	@Modifying
    @Transactional
    @Query("UPDATE Dmp d SET d.status = :status WHERE d.id = :id")
    void updateStatus(Short id, String status);
	
	@Modifying
    @Transactional
    @Query("UPDATE Dmp d SET d.resultImport = :result WHERE d.id = :id")
    void updateResultImport(Short id, String result);
	
	@Modifying
    @Transactional
    @Query("UPDATE Dmp d SET d.exitCode = :exitCode WHERE d.id = :id")
    void updateExitCode(Short id, Byte exitCode);
}

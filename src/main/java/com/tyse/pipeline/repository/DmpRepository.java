package com.tyse.pipeline.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.tyse.pipeline.domain.entities.Dmp;

public interface DmpRepository extends JpaRepository<Dmp, Short> {

}

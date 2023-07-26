package com.tyse.pipeline.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.tyse.pipeline.domain.entities.Users;

public interface UsersRepository extends JpaRepository<Users, Short> {

}

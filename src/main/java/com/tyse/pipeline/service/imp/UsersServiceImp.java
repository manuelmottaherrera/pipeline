package com.tyse.pipeline.service.imp;

import org.springframework.stereotype.Service;

import com.tyse.pipeline.repository.UsersRepository;
import com.tyse.pipeline.service.UsersService;

@Service
public class UsersServiceImp implements UsersService {

	UsersRepository usersRepository;
	
	UsersServiceImp(UsersRepository usersRepository) {
		this.usersRepository = usersRepository;
	}
}

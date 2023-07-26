package com.tyse.pipeline.service.imp;

import com.tyse.pipeline.repository.UsersRepository;
import com.tyse.pipeline.service.UsersService;

public class UsersServiceImp implements UsersService {

	UsersRepository usersRepository;
	
	UsersServiceImp(UsersRepository usersRepository) {
		this.usersRepository = usersRepository;
	}
}

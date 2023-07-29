package com.tyse.pipeline.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.tyse.pipeline.service.UsersService;

@RestController
@RequestMapping("/users")
public class UsersController {

	UsersService usersService;
	
	UsersController(UsersService usersService) {
		this.usersService = usersService;
	}
}

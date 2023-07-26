package com.tyse.pipeline.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.tyse.pipeline.service.DmpService;

@RestController
@RequestMapping("/dmp")
public class DmpController {

	DmpService dmpService;
	
	DmpController(DmpService dmpService) {
		this.dmpService = dmpService;
	}
}

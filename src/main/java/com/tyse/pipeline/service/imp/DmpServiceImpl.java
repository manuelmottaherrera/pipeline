package com.tyse.pipeline.service.imp;

import org.springframework.stereotype.Service;

import com.tyse.pipeline.repository.DmpRepository;
import com.tyse.pipeline.service.DmpService;

@Service
public class DmpServiceImpl implements DmpService {

	DmpRepository dmpRepository;
	
	DmpServiceImpl(DmpRepository dmpRepository) {
		this.dmpRepository = dmpRepository;
	}
}

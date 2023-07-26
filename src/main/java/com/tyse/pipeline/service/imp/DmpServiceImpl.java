package com.tyse.pipeline.service.imp;

import com.tyse.pipeline.repository.DmpRepository;
import com.tyse.pipeline.service.DmpService;

public class DmpServiceImpl implements DmpService {

	DmpRepository dmpRepository;
	
	DmpServiceImpl(DmpRepository dmpRepository) {
		this.dmpRepository = dmpRepository;
	}
}

package com.tyse.pipeline.service.imp;

import java.io.IOException;
import java.time.Instant;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.tyse.pipeline.domain.entities.Dmp;
import com.tyse.pipeline.repository.DmpRepository;
import com.tyse.pipeline.service.DmpService;

@Service
public class DmpServiceImpl implements DmpService {

	DmpRepository dmpRepository;
	
	DmpServiceImpl(DmpRepository dmpRepository) {
		this.dmpRepository = dmpRepository;
	}
	
	@Override
	public Dmp saveDmpFile(MultipartFile dmpFile) throws IOException {
        Dmp dmpEntity = new Dmp();
        dmpEntity.setDmpFile(dmpFile.getBytes());
        dmpEntity.setDate(Instant.now());
        dmpEntity.setStatus("CREATED");
        dmpEntity.setId((short) 1);
        return dmpRepository.save(dmpEntity);
	}
}

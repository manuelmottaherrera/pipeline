package com.tyse.pipeline.service.imp;

import java.io.IOException;
import java.time.Instant;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.tyse.pipeline.constants.ConstantsCommands;
import com.tyse.pipeline.domain.entities.Dmp;
import com.tyse.pipeline.repository.DmpRepository;
import com.tyse.pipeline.service.DmpService;
import com.tyse.pipeline.util.CommandLineExecutionUtil;
import com.tyse.pipeline.util.FileUtil;

@Service
public class DmpServiceImpl implements DmpService {

	DmpRepository dmpRepository;

	@Value("${dmp.directory}")
	String dmpDirectory;

	@Value("${dmp.datasource}")
	String datasource;

	DmpServiceImpl(DmpRepository dmpRepository) {
		this.dmpRepository = dmpRepository;
	}

	@Override
	public Dmp saveDmpFile(MultipartFile dmpFile) throws IOException {
		Dmp dmpEntity = new Dmp();
		dmpEntity.setDateUpload(Instant.now());
		dmpEntity.setStatus("GUARDANDO DMP EN DB");
		dmpEntity.setIdUsers((short) 1);
		dmpEntity.setDmpFileName(dmpFile.getOriginalFilename());
		return dmpRepository.save(dmpEntity);
	}

	@Override
	public void putInDmpDirectory(MultipartFile dmp) {
		FileUtil.putInDirectory(dmp, dmpDirectory);
	}

	@Override
	public void deleteDmpFile(Dmp dmp) {
		FileUtil.deleteDmp(dmp, dmpDirectory);
	}

	@Override
	public void importDmp(Dmp dmp) {
		StringBuilder cmd = new StringBuilder();
		cmd.append(ConstantsCommands.IMP).append(datasource).append(ConstantsCommands.FILE).append(dmpDirectory)
				.append(dmp.getDmpFileName());
		dmp.setExitCode(CommandLineExecutionUtil.executeCommand(cmd.toString(), dmp));
		dmpRepository.updateResultImport(dmp.getId(), dmp.getResultImport());
		dmpRepository.updateExitCode(dmp.getId(), dmp.getExitCode());
		
	}

	@Override
	public void changeStatus(Dmp dmp, String status) {
		dmp.setStatus(status);
		dmpRepository.updateStatus(dmp.getId(), dmp.getStatus());
	}
}

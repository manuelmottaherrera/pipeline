package com.tyse.pipeline.service;

import java.io.IOException;

import org.springframework.web.multipart.MultipartFile;

import com.tyse.pipeline.domain.entities.Dmp;

public interface DmpService {
	public Dmp saveDmpFile(MultipartFile dmpFile) throws IOException;

	public void downloadToDmpFolder(Dmp dmp);

	public void deleteDmpFile(Dmp dmp);

	public void importDmp(Dmp dmp);

	public void changeStatus(Dmp dmp, String status);
}

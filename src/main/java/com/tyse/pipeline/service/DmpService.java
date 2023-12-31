package com.tyse.pipeline.service;

import java.io.File;
import java.io.IOException;
import java.util.concurrent.CompletableFuture;

import com.tyse.pipeline.domain.entities.Dmp;

public interface DmpService {
	public Dmp saveDmpFile(File dmpFile) throws IOException;

	public void archiveDmpFile(Dmp dmp);

	public void importDmp(Dmp dmp);

	public void changeStatus(Dmp dmp, String status);

	public void exportToSqlite();

	public void changeNameSqliteFile(Dmp dmp);

	public void createDbSqlite(Dmp dmp);

	public void deleteNumberOfLastLinesSqliteFile(Dmp dmp, int numberOfLines);

	public CompletableFuture<Void> importSqlite(String nameFile);

	public Dmp findById(Short id);

	public File[] getAllDmpFiles();

	public void moveDbSqlite(Dmp dmpSaved);

	public void deleteSqlFile(String fileName);

	public File[] getAllPlainTextFiles();

	public void moveFileToSqlDirectory(File plainText);

	public void importCenso(File plainText);

	public void cleanSqlloaderProcess(File plainText);

	public void importDivipol(File plainText);

	public void importJurados(File plainText);

	public void processCompressFile(File plainText);

	public void moveAllDbFolderToOutputFolder();

	public File[] getAllSqlFiles();

	public int getFinishImport();

	public int getStartImport();

	public void moveFilesToFolders();

	public File[] getAllCompressFiles();
}

package com.tyse.pipeline.service.imp;

import java.io.File;
import java.io.IOException;
import java.time.Instant;
import java.util.Iterator;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import com.tyse.pipeline.constants.ConstantsCommands;
import com.tyse.pipeline.domain.entities.Dmp;
import com.tyse.pipeline.repository.DmpRepository;
import com.tyse.pipeline.service.DmpService;
import com.tyse.pipeline.util.CommandLineExecutionUtil;
import com.tyse.pipeline.util.FileUtil;

@Service
public class DmpServiceImpl implements DmpService {
	
	int startImport;
	
	int finishImport;

	DmpRepository dmpRepository;

	@Value("${pipeline.home}")
	String home;

	@Value("${pipeline.sqlite.generate}")
	String generatePlSql;
	
	@Value("${pipeline.sqlite.generate-sqlite-files}")
	String generateSqliteFiles;
	
	@Value("${pipeline.sql.name-sqlite-file}")
	String nameDefaultSqliteFile;

	@Value("${pipeline.sql.script-sqlite}")
	String initScriptSqlite;

	@Value("${pipeline.sql.directory}")
	String sqlDirectory;
	
	@Value("${pipeline.sqlite.directory}")
	String sqliteDirectory;
	
	@Value("${pipeline.sqlite.directory-db}")
	String sqliteDirectoryDb;

	@Value("${pipeline.datasource}")
	String datasource;

	@Value("${pipeline.inputFolder}")
	String inputFolder;

	@Value("${pipeline.archiveFolder}")
	String archiveFolder;

	@Value("${pipeline.outputFolder}")
	String outputFolder;

	@Value("${pipeline.sql.sqlldr.censo}")
	String censoCtl;

	@Value("${pipeline.sql.sqlldr.divipol}")
	String divipolCtl;

	@Value("${pipeline.sql.sqlldr.jurados}")
	String juradosCtl;

	@Value("${pipeline.sql.sqlldr.clave-puesto}")
	String clavePuestoCtl;
	
	@Value("${pipeline.user-db}")
	String userDb;
	
	@Override
	public int getFinishImport() {
		return finishImport;
	}

	@Override
	public int getStartImport() {
		return startImport;
	}

	DmpServiceImpl(DmpRepository dmpRepository) {
		this.dmpRepository = dmpRepository;
	}

	@Override
	public File[] getAllPlainTextFiles() {
		return FileUtil.getFilesFromFolder(inputFolder, ".txt");
	}

	@Override
	public File[] getAllDmpFiles() {
		return FileUtil.getFilesFromFolder(inputFolder, ".dmp");
	}

	@Override
	public Dmp saveDmpFile(File dmpFile) throws IOException {
		Dmp dmpEntity = new Dmp();
		dmpEntity.setDateUpload(Instant.now());
		dmpEntity.setStatus("SIN PROCESAR");
		dmpEntity.setIdUsers((short) 1);
		dmpEntity.setDmpFileName(dmpFile.getName());
		return dmpRepository.save(dmpEntity);
	}

	@Override
	public void archiveDmpFile(Dmp dmp) {
		CommandLineExecutionUtil.executeCommand(
				ConstantsCommands.moveFile(inputFolder + dmp.getDmpFileName(), archiveFolder), home, true);
	}

	@Override
	public void importDmp(Dmp dmp) {
		dmp.setExitCodeDmp(CommandLineExecutionUtil
				.executeCommandImp(ConstantsCommands.impCommand(datasource, inputFolder + dmp.getDmpFileName(), userDb), dmp));
		dmpRepository.saveAndFlush(dmp);
	}

	@Override
	public void changeStatus(Dmp dmp, String status) {
		dmp.setStatus(status);
		dmpRepository.saveAndFlush(dmp);
	}

	@Override
	public void exportToSqlite() {
		CommandLineExecutionUtil.executeCommand(
				ConstantsCommands.sqlPlusCommand(datasource, sqliteDirectory + generatePlSql), sqliteDirectory, true);
		CommandLineExecutionUtil.executeCommand(
				ConstantsCommands.sqlPlusCommand(datasource, sqliteDirectory + generateSqliteFiles), sqliteDirectory, true);
	}

	@Override
	public void changeNameSqliteFile(Dmp dmp) {
		StringBuilder cmd = new StringBuilder();
		cmd.append(ConstantsCommands.renameSqliteFile(nameDefaultSqliteFile, nameSqlLite(dmp)));
		CommandLineExecutionUtil.executeCommand(cmd.toString(), sqlDirectory, true);
	}

	@Override
	public void createDbSqlite(Dmp dmp) {
		CommandLineExecutionUtil.executeCommand(ConstantsCommands.runInitScript(nameSqlLite(dmp), initScriptSqlite),
				sqlDirectory, true);
	}

	@Override
	public void deleteNumberOfLastLinesSqliteFile(Dmp dmp, int numberOfLines) {
		CommandLineExecutionUtil.executeCommand(ConstantsCommands.deleteNumberOfLines(nameSqlLite(dmp), numberOfLines),
				sqlDirectory, true);
	}

	@Override
	public void cleanSqlloaderProcess(File plainText) {
		String[] fileName = plainText.getName().split("\\.");
		CommandLineExecutionUtil.executeCommand(ConstantsCommands.moveFile(plainText.getName(), archiveFolder),
				sqlDirectory, true);
		CommandLineExecutionUtil.executeCommand(ConstantsCommands.deleteFile(fileName[0] + ".*"), sqlDirectory, false);
	}

	@Override
	@Async
	public void importSqlite(String nameFile) {
		startImport = getStartImport() + 1;
		String nameWithoutExtension = nameFile.split("\\.")[0];
		CommandLineExecutionUtil.executeCommand(ConstantsCommands.importSqlite(nameWithoutExtension),
				sqliteDirectoryDb, true);
		deleteSqlFile(nameFile);
		compressSqliteFile(nameWithoutExtension + ".db");
		deleteSqlFile(nameWithoutExtension + ".db");
		finishImport = getFinishImport() + 1;
	}
	
	private void compressSqliteFile(String nameFile) {
		CommandLineExecutionUtil.executeCommand(ConstantsCommands.compressFile(nameFile), sqliteDirectoryDb, true);
	}

	@Override
	public void importCenso(File plainText) {
		CommandLineExecutionUtil.executeCommand(
				ConstantsCommands.sqlldrCommand(datasource, censoCtl, plainText.getName()), sqlDirectory, false);
	}

	@Override
	public void importDivipol(File plainText) {
		CommandLineExecutionUtil.executeCommand(
				ConstantsCommands.sqlldrCommand(datasource, divipolCtl, plainText.getName()), sqlDirectory, false);
	}

	@Override
	public void importJurados(File plainText) {
		CommandLineExecutionUtil.executeCommand(
				ConstantsCommands.sqlldrCommand(datasource, juradosCtl, plainText.getName()), sqlDirectory, false);
	}
	
	@Override
	public void importClavePuesto(File plainText) {
		CommandLineExecutionUtil.executeCommand(
				ConstantsCommands.sqlldrCommand(datasource, clavePuestoCtl, plainText.getName()), sqlDirectory, false);
	}

	@Override
	public Dmp findById(Short id) {
		return dmpRepository.findById(id).get();
	}

	@Override
	public void moveDbSqlite(Dmp dmp) {
		CommandLineExecutionUtil.executeCommand(
				ConstantsCommands.moveFile(sqlDirectory + nameSqlLite(dmp) + ".db", outputFolder), home, true);
	}

	@Override
	public void moveFileToSqlDirectory(File file) {
		CommandLineExecutionUtil.executeCommand(ConstantsCommands.moveFile(inputFolder + file.getName(), sqlDirectory),
				home, true);
	}

	@Override
	public void deleteSqlFile(String fileName) {
		CommandLineExecutionUtil.executeCommand(
				ConstantsCommands.deleteFile(fileName), sqliteDirectoryDb, true);
	}

	private String nameSqlLite(Dmp dmp) {
		return new StringBuilder().append(dmp.getDmpFileName().split("\\.")[0]).append("_")
				.append(dmp.getDateUpload().getEpochSecond()).toString();
	}
	
	@Override
	public File[] getAllSqlFiles() {
		return FileUtil.getFilesFromFolder(sqliteDirectoryDb, ".sql");
	}

	@Override
	public void moveAllDbFolderToOutputFolder() {
		FileUtil.moveAll(sqliteDirectoryDb, outputFolder);
	}

	@Override
	public void moveFilesToFolders() {
		for (File file : FileUtil.getFilesFromFolder(sqliteDirectoryDb, ".zip")) {
			String dptoCode = file.getName().substring(0, 2);
			if (!FileUtil.exist(sqliteDirectoryDb + dptoCode)) {
				FileUtil.createDirectory(sqliteDirectoryDb + dptoCode);
			}
			CommandLineExecutionUtil.executeCommand(ConstantsCommands.moveFile(sqliteDirectoryDb + file.getName(), sqliteDirectoryDb + dptoCode + "/"), home, true);
		}
	}	

}

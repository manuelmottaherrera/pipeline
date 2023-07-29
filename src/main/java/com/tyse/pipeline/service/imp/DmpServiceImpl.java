package com.tyse.pipeline.service.imp;

import java.io.File;
import java.io.IOException;
import java.time.Instant;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.tyse.pipeline.constants.ConstantsCommands;
import com.tyse.pipeline.domain.entities.Dmp;
import com.tyse.pipeline.repository.DmpRepository;
import com.tyse.pipeline.service.DmpService;
import com.tyse.pipeline.util.CommandLineExecutionUtil;
import com.tyse.pipeline.util.FileUtil;

@Service
public class DmpServiceImpl implements DmpService {

	DmpRepository dmpRepository;

	@Value("${pipeline.home}")
	String home;

	@Value("${pipeline.sql.generate-export}")
	String generateExportFile;

	@Value("${pipeline.sql.name-sqlite-file}")
	String nameDefaultSqliteFile;

	@Value("${pipeline.sql.script-sqlite}")
	String initScriptSqlite;

	@Value("${pipeline.sql.directory}")
	String sqlDirectory;

	@Value("${pipeline.datasource}")
	String datasource;

	@Value("${pipeline.inputFolder}")
	String inputFolder;

	@Value("${pipeline.archiveFolder}")
	String archiveFolder;

	@Value("${pipeline.outputFolder}")
	String outputFolder;

	DmpServiceImpl(DmpRepository dmpRepository) {
		this.dmpRepository = dmpRepository;
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
		CommandLineExecutionUtil
				.executeCommand(ConstantsCommands.moveFile(inputFolder + dmp.getDmpFileName(), archiveFolder), home, true);
	}

	@Override
	public void importDmp(Dmp dmp) {
		dmp.setExitCodeDmp(CommandLineExecutionUtil
				.executeCommandImp(ConstantsCommands.impCommand(datasource, inputFolder + dmp.getDmpFileName()), dmp));
		dmpRepository.saveAndFlush(dmp);
	}

	@Override
	public void changeStatus(Dmp dmp, String status) {
		dmp.setStatus(status);
		dmpRepository.saveAndFlush(dmp);
	}

	@Override
	public void exportToSqlite(Dmp dmp) {
		dmp.setExitCodeSql(CommandLineExecutionUtil.executeCommand(
				ConstantsCommands.sqlPlusCommand(datasource, sqlDirectory + generateExportFile), sqlDirectory, false));
		dmpRepository.saveAndFlush(dmp);
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
	public void importSqlite(Dmp dmp) {
		dmp.setExitCodeSqlite(CommandLineExecutionUtil.executeCommand(ConstantsCommands.importSqlite(nameSqlLite(dmp)),
				sqlDirectory, false));
		dmpRepository.save(dmp);
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
	public void deleteSqliteFile(Dmp dmpSaved) {
		CommandLineExecutionUtil.executeCommand(ConstantsCommands.deleteFile(sqlDirectory + nameSqlLite(dmpSaved) + ".sql"),
				home, true);
	}

	private String nameSqlLite(Dmp dmp) {
		return new StringBuilder().append(dmp.getDmpFileName().split("\\.")[0]).append("_")
				.append(dmp.getDateUpload().getEpochSecond()).toString();
	}
}

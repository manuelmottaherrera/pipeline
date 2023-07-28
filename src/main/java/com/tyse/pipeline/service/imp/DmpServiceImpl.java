package com.tyse.pipeline.service.imp;

import java.io.File;
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

	@Value("${pipeline.dmp.directory}")
	String dmpDirectory;

	@Value("${pipeline.datasource}")
	String datasource;

	DmpServiceImpl(DmpRepository dmpRepository) {
		this.dmpRepository = dmpRepository;
	}

	@Override
	public Dmp saveDmpFile(File dmpFile) throws IOException {
		Dmp dmpEntity = new Dmp();
		dmpEntity.setDateUpload(Instant.now());
		dmpEntity.setStatus("GUARDANDO DMP EN DB");
		dmpEntity.setIdUsers((short) 1);
		dmpEntity.setDmpFileName(dmpFile.getName());
		return dmpRepository.save(dmpEntity);
	}

	@Override
	public void putInDmpDirectory(File dmp) {
		FileUtil.putInDirectory(dmp, dmpDirectory);
	}

	@Override
	public void deleteDmpFile(Dmp dmp) {
		FileUtil.deleteDmp(dmp, dmpDirectory);
	}

	@Override
	public void importDmp(Dmp dmp) {
		StringBuilder cmd = new StringBuilder();
		cmd.append(ConstantsCommands.IMP).append(datasource).append(ConstantsCommands.IMP_FILE).append(dmpDirectory)
				.append(dmp.getDmpFileName()).append(ConstantsCommands.IMP_ARGS);
		dmp.setExitCodeDmp(CommandLineExecutionUtil.executeCommandImp(cmd.toString(), dmp));
		dmpRepository.saveAndFlush(dmp);

	}

	@Override
	public void changeStatus(Dmp dmp, String status) {
		dmp.setStatus(status);
		dmpRepository.saveAndFlush(dmp);
	}

	@Override
	public void exportToSqlite(Dmp dmp) {
		StringBuilder cmd = new StringBuilder();
		cmd.append(ConstantsCommands.SQLPLUS).append(datasource).append(ConstantsCommands.SQLPLUS_ARGS)
				.append(sqlDirectory).append(generateExportFile);
		dmp.setExitCodeSql(CommandLineExecutionUtil.executeCommand(cmd.toString(), sqlDirectory));
		dmpRepository.saveAndFlush(dmp);
	}

	@Override
	public void changeNameSqliteFile(Dmp dmp) {
		StringBuilder cmd = new StringBuilder();
		cmd.append(ConstantsCommands.renameSqliteFile(nameDefaultSqliteFile, nameSqlLite(dmp)));
		CommandLineExecutionUtil.executeCommand(cmd.toString(), sqlDirectory);
	}

	@Override
	public void createDbSqlite(Dmp dmp) {
		//CommandLineExecutionUtil.executeCommand(ConstantsCommands.createSqliteDB(nameSqlLite(dmp)), sqlDirectory);
		CommandLineExecutionUtil.executeCommand(ConstantsCommands.runInitScript(nameSqlLite(dmp), initScriptSqlite), sqlDirectory);
	}

	@Override
	public void deleteNumberOfLastLinesSqliteFile(Dmp dmp, int numberOfLines) {
		CommandLineExecutionUtil.executeCommand(ConstantsCommands.deleteNumberOfLines(nameSqlLite(dmp), numberOfLines),
				sqlDirectory);
	}

	@Override
	public void importSqlite(Dmp dmp) {
		dmp.setExitCodeSqlite(CommandLineExecutionUtil.executeCommand(ConstantsCommands.importSqlite(nameSqlLite(dmp)), sqlDirectory));
		dmpRepository.save(dmp);
	}
	
	private String nameSqlLite(Dmp dmp) {
		return new StringBuilder().append(dmp.getDmpFileName().split("\\.")[0]).append("_")
				.append(dmp.getDateUpload().getEpochSecond()).toString();
	}

	@Override
	public Dmp findById(Short id) {
		return dmpRepository.findById(id).get();
	}
}

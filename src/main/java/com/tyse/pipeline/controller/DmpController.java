package com.tyse .pipeline.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.concurrent.CompletableFuture;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.tyse.pipeline.domain.entities.Dmp;
import com.tyse.pipeline.service.DmpService;

@RestController
@RequestMapping("/migration")
public class DmpController {

	DmpService dmpService;

	DmpController(DmpService dmpService) {
		this.dmpService = dmpService;
	}

	@PostMapping("/run-pipeline")
	public ResponseEntity<Object> runPipeline() {
		try {
			importProcess();
			exportProcess();
			return ResponseEntity.ok("ok");
		} catch (IOException e) {
			e.printStackTrace();
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error al guardar el archivo");
		}
	}

	private void exportProcess() {
		dmpService.exportToSqlite();
		
		List<CompletableFuture<Void>> generateFutureList = new ArrayList<>();
		for (File outputFile : dmpService.getOutputsFiles()) {
			generateFutureList.add(dmpService.executeOutputFile(outputFile));
		}
		
		CompletableFuture<Void> combinedGenerateFuture = CompletableFuture.allOf(
				generateFutureList.toArray(new CompletableFuture[0])
				);
		combinedGenerateFuture.join();
				
		
		List<CompletableFuture<Void>> futuresList = new ArrayList<>();
		for (File fileSql : dmpService.getAllSqlFiles()) {
			futuresList.add(dmpService.importSqlite(fileSql.getName()));
		}
		CompletableFuture<Void> combinedFuture = CompletableFuture.allOf(
	            futuresList.toArray(new CompletableFuture[0])
		        );
		combinedFuture.join();
		
		dmpService.moveFilesToFolders();
		dmpService.moveAllDbFolderToOutputFolder();
		
		
		
		//dmpService.generateDbSqlite();
		//dmpService.deleteSqlFiles();
		//dmpService.deleteAllOfOutputDirectory();
//		dmpService.changeNameSqliteFile(dmpSaved);
//		dmpService.deleteNumberOfLastLinesSqliteFile(dmpSaved, 2);
//		dmpService.createDbSqlite(dmpSaved);
//		dmpService.changeStatus(dmpSaved, "IMPORTANDO A SQLITE");
//		dmpService.importSqlite(dmpSaved);
//		if (dmpSaved.getExitCodeSqlite() != 0) {
//			dmpService.changeStatus(dmpSaved, "ERROR IMPORTANDO SQLITE");
//			return;
//		}
//		dmpService.deleteSqliteFile(dmpSaved);
//		dmpService.moveDbSqlite(dmpSaved);
		
	}

	private void importProcess() throws IOException {
		for (File compressFile : dmpService.getAllCompressFiles()) {
			processCompressFile(compressFile);
		}
		for (File plainText : dmpService.getAllPlainTextFiles()) {
			processFile(plainText);
		}
		for (File fileDmp : getAllDmpFiles()) {
			processDmpFile(fileDmp);
		}
	}

	private void processCompressFile(File compressFile) {
		dmpService.processCompressFile(compressFile);
	}

	private void processFile(File plainText) {
		final String CENSO = "Censo";
		final String DIVIPOL = "Divipol";
		final String JURADOS = "Jurados";
		String fileName = plainText.getName();
		if (fileName.contains(CENSO)) {
			processCenso(plainText);
		} else if (fileName.contains(DIVIPOL)) {
			processDivipol(plainText);
		} else if (fileName.contains(JURADOS)) {
			processJurados(plainText);
		}
	}

	private void processJurados(File plainText) {
		dmpService.moveFileToSqlDirectory(plainText);
		dmpService.importJurados(plainText);
		dmpService.cleanSqlloaderProcess(plainText);
	}

	private void processDivipol(File plainText) {
		dmpService.moveFileToSqlDirectory(plainText);
		dmpService.importDivipol(plainText);
		dmpService.cleanSqlloaderProcess(plainText);
	}

	private void processCenso(File plainText) {
		dmpService.moveFileToSqlDirectory(plainText);
		dmpService.importCenso(plainText);
		dmpService.cleanSqlloaderProcess(plainText);
	}

	private void processDmpFile(File dmpFile) throws IOException {
		Dmp dmpSaved = dmpService.saveDmpFile(dmpFile);
		dmpService.changeStatus(dmpSaved, "IMPORTANDO DMP");
		dmpService.importDmp(dmpSaved);
		if (dmpSaved.getExitCodeDmp() != 0) {
			dmpService.changeStatus(dmpSaved, "ERROR IMPORTANDO DMP");
			return;
		}
		dmpService.changeStatus(dmpSaved, "RESTAURANDO ESTADO");
		dmpService.archiveDmpFile(dmpSaved);
		dmpService.changeStatus(dmpSaved, "IMPORTACION FINALIZADA");
	}

	private File[] getAllDmpFiles() {
		return dmpService.getAllDmpFiles();
	}
}

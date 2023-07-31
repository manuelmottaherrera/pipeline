package com.tyse .pipeline.controller;

import java.io.File;
import java.io.IOException;

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
		// TODO Auto-generated method stub
		
	}

	private void importProcess() throws IOException {
		for (File plainText : dmpService.getAllPlainTextFiles()) {
			processFile(plainText);
		}
		for (File fileDmp : getAllDmpFiles()) {
			processDmpFile(fileDmp);
		}
	}

	private void processFile(File plainText) {
		final String CENSO = "Censo";
		final String DIVIPOL = "Divipol";
		final String JURADOS = "Jurados";
		final String CLAVE_PUESTO = "ClavePuesto";
		String fileName = plainText.getName();
		if (fileName.contains(CENSO)) {
			processCenso(plainText);
		} else if (fileName.contains(DIVIPOL)) {
			processDivipol(plainText);
		} else if (fileName.contains(JURADOS)) {
			processJurados(plainText);
		} else if (fileName.contains(CLAVE_PUESTO)) {
			processClavePuesto(plainText);
		}
	}

	private void processClavePuesto(File plainText) {
		dmpService.moveFileToSqlDirectory(plainText);
		dmpService.importClavePuesto(plainText);
		dmpService.cleanSqlloaderProcess(plainText);
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
//		dmpService.changeStatus(dmpSaved, "EXPORTANDO A FORMATO SQLITE");
//		dmpService.exportToSqlite(dmpSaved);
//		if (dmpSaved.getExitCodeSql() != 0) {
//			dmpService.changeStatus(dmpSaved, "ERROR GENERANDO SQLITE FILE");
//			return;
//		}
//		dmpService.changeStatus(dmpSaved, "PREPARANDO ARCHIVO SQLITE");
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

	private File[] getAllDmpFiles() {
		return dmpService.getAllDmpFiles();
	}
}

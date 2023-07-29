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
			for (File fileDmp : getAllDmpFiles()) {
				convertDmpFile(fileDmp);
			}
			return ResponseEntity.ok("ok");
		} catch (IOException e) {
			e.printStackTrace();
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error al guardar el archivo");
		}
	}

	private void convertDmpFile(File dmpFile) throws IOException {
		Dmp dmpSaved = dmpService.saveDmpFile(dmpFile);
		dmpService.changeStatus(dmpSaved, "IMPORTANDO DMP");
		dmpService.importDmp(dmpSaved);
		if (dmpSaved.getExitCodeDmp() != 0) {
			dmpService.changeStatus(dmpSaved, "ERROR IMPORTANDO DMP");
			return;
		}
		dmpService.archiveDmpFile(dmpSaved);
		dmpService.changeStatus(dmpSaved, "RESTAURANDO ESTADO");
		dmpService.changeStatus(dmpSaved, "EXPORTANDO A FORMATO SQLITE");
		dmpService.exportToSqlite(dmpSaved);
		if (dmpSaved.getExitCodeSql() != 0) {
			dmpService.changeStatus(dmpSaved, "ERROR GENERANDO SQLITE FILE");
			return;
		}
		dmpService.changeStatus(dmpSaved, "PREPARANDO ARCHIVO SQLITE");
		dmpService.changeNameSqliteFile(dmpSaved);
		dmpService.deleteNumberOfLastLinesSqliteFile(dmpSaved, 2);
		dmpService.createDbSqlite(dmpSaved);
		dmpService.changeStatus(dmpSaved, "IMPORTANDO A SQLITE");
		dmpService.importSqlite(dmpSaved);
		if (dmpSaved.getExitCodeSqlite() != 0) {
			dmpService.changeStatus(dmpSaved, "ERROR IMPORTANDO SQLITE");
			return;
		}
		dmpService.deleteSqliteFile(dmpSaved);
		dmpService.moveDbSqlite(dmpSaved);
	}

	private File[] getAllDmpFiles() {
		return dmpService.getAllDmpFiles();
	}
}

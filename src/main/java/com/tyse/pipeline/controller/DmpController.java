package com.tyse .pipeline.controller;

import java.io.File;
import java.io.IOException;
import java.time.Instant;
import java.util.Iterator;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.tyse.pipeline.domain.entities.Dmp;
import com.tyse.pipeline.service.DmpService;

@RestController
@RequestMapping("/dmp")
public class DmpController {

	DmpService dmpService;

	DmpController(DmpService dmpService) {
		this.dmpService = dmpService;
	}

	@PostMapping("/upload")
	public ResponseEntity<Object> uploadFile() {
		try {
			for (File fileDmp : getAllDmpFiles()) {
				convertDmpFile(fileDmp);
			}
			Dmp dmpSaved = dmpService.saveDmpFile(dmpFile);
			dmpService.changeStatus(dmpSaved, "CREANDO REGISTRO");
			dmpService.putInDmpDirectory(dmpFile);
			dmpService.changeStatus(dmpSaved, "IMPORTANDO DMP");
			dmpService.importDmp(dmpSaved);
			dmpService.changeStatus(dmpSaved, "RESTAURANDO ESTADO");
			dmpService.deleteDmpFile(dmpSaved);
			if (dmpSaved.getExitCodeDmp() != 0) {
				dmpService.changeStatus(dmpSaved, "ERROR IMPORTANDO DMP");
				return ResponseEntity.internalServerError().body(dmpSaved.getStatus());
			}
			dmpService.changeStatus(dmpSaved, "EXPORTANDO A FORMATO SQLITE");
			dmpService.exportToSqlite(dmpSaved);
			if (dmpSaved.getExitCodeSql() != 0) {
				dmpService.changeStatus(dmpSaved, "ERROR GENERANDO SQLITE FILE");
				return ResponseEntity.internalServerError().body(dmpSaved.getStatus());
			}
			dmpService.changeStatus(dmpSaved, "PREPARANDO ARCHIVO SQLITE");
			dmpService.changeNameSqliteFile(dmpSaved);
			dmpService.deleteNumberOfLastLinesSqliteFile(dmpSaved, 2);
			dmpService.createDbSqlite(dmpSaved);
			dmpService.changeStatus(dmpSaved, "IMPORTANDO A SQLITE");
			dmpService.importSqlite(dmpSaved);
			if (dmpSaved.getExitCodeSqlite() != 0) {
				dmpService.changeStatus(dmpSaved, "ERROR IMPORTANDO SQLITE");
				return ResponseEntity.internalServerError().body(dmpSaved.getStatus());
			}
			return ResponseEntity.ok(dmpSaved.getStatus());
		} catch (IOException e) {
			e.printStackTrace();
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error al guardar el archivo");
		}
	}

	private void convertDmpFile(File dmpFile) {
		
	}

	private File[] getAllDmpFiles() {
		// TODO Auto-generated method stub
		return null;
	}
}

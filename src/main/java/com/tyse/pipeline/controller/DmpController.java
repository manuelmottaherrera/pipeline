package com.tyse.pipeline.controller;

import java.io.IOException;

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
    public ResponseEntity<Object> uploadFile(@RequestParam("dmp-file") MultipartFile dmpFile) {
		try {
            // Verificar si el archivo no es vacío
            if (dmpFile.isEmpty()) {
                return ResponseEntity.badRequest().body("El archivo está vacío");
            }
            Dmp dmpSaved = dmpService.saveDmpFile(dmpFile);
            dmpService.changeStatus(dmpSaved, "DESCARGANDO");
            dmpService.downloadToDmpFolder(dmpSaved);
            dmpService.changeStatus(dmpSaved, "IMPORTANDO DMP");
            dmpService.importDmp(dmpSaved);
            dmpService.changeStatus(dmpSaved, "RESTAURANDO ESTADO");
            dmpService.deleteDmpFile(dmpSaved);
            if (dmpSaved.getExitCode() == 0) {
            	dmpService.changeStatus(dmpSaved, "PROCESAMIENTO FINALIZADO");
			} else {
				dmpService.changeStatus(dmpSaved, "ERROR IMPORTANDO");
			}
            return ResponseEntity.ok(dmpSaved.getStatus());
        } catch (IOException e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error al guardar el archivo");
        }
	}
}

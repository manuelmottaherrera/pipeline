package com.tyse.pipeline.controller;

import java.io.IOException;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

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
            
            return ResponseEntity.ok(dmpService.saveDmpFile(dmpFile));
        } catch (IOException e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error al guardar el archivo");
        }
	}
}

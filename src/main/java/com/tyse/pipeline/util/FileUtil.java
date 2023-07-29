package com.tyse.pipeline.util;

import java.io.File;
import java.io.FileOutputStream;
import java.io.FilenameFilter;

import org.springframework.web.multipart.MultipartFile;

import com.tyse.pipeline.domain.entities.Dmp;
import com.tyse.pipeline.error.DownloadDmpException;

public class FileUtil {

	private FileUtil() {
	}

	/*
	 * public static void putInDirectory(File dmp, String dmpDirectory) { try { File
	 * outputFile = new File(dmpDirectory + dmp.getName()); if (outputFile.exists())
	 * { outputFile.delete(); } FileOutputStream fileOutputStream = new
	 * FileOutputStream(outputFile);
	 * 
	 * fileOutputStream.write(dmp.); fileOutputStream.close(); } catch (Exception e)
	 * { throw new DownloadDmpException("Error al descargar dmp"); } }
	 */

	public static void deleteDmp(Dmp dmp, String dmpDirectory) {
		// Ruta del archivo que deseas eliminar
		String filePath = dmpDirectory + dmp.getDmpFileName();

		// Crear un objeto File con la ruta del archivo
		File file = new File(filePath);

		// Verificar si el archivo existe
		if (file.exists()) {
			// Intentar eliminar el archivo
			if (file.delete()) {
				System.out.println("El archivo fue eliminado con éxito.");
			} else {
				System.out.println("No se pudo eliminar el archivo.");
			}
		} else {
			System.out.println("El archivo no existe en la ruta especificada.");
		}
	}

	public static File[] getFilesFromFolder(String folderPath, String extension) {
		File folder = new File(folderPath);

		return folder.listFiles(new FilenameFilter() {
			@Override
			public boolean accept(File dir, String name) {
				return name.toLowerCase().endsWith(extension);
			}
		});
	}
}

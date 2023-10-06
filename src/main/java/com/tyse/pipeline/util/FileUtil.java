package com.tyse.pipeline.util;

import java.io.File;
import java.io.FileOutputStream;
import java.io.FilenameFilter;
import java.io.IOException;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.tyse.pipeline.domain.entities.Dmp;
import com.tyse.pipeline.error.DownloadDmpException;

public class FileUtil {

	private FileUtil() {
	}

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

	public static boolean exist(String path) {
		return Files.exists(Paths.get(path));
	}

	public static void createDirectory(String path) {
		try {
			Files.createDirectories(Paths.get(path));
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}		
	}
	
	public static void moveAll(String origenDirectorio, String destinoDirectorio) {
        Path origenPath = Paths.get(origenDirectorio);
        Path destinoPath = Paths.get(destinoDirectorio);

        try (DirectoryStream<Path> stream = Files.newDirectoryStream(origenPath)) {
            for (Path path : stream) {
                Path destino = destinoPath.resolve(origenPath.relativize(path));
                Files.move(path, destino, StandardCopyOption.REPLACE_EXISTING);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
	
	public static List<File> getOutputFileSQLs(String directoryPath, String startsWith, String endsWith) {
	    File directory = new File(directoryPath);
	    List<File> matchingFiles = new ArrayList<>();

	    if (directory.exists() && directory.isDirectory()) {
	        File[] files = directory.listFiles((dir, name) -> name.startsWith(startsWith) && name.endsWith(endsWith));

	        if (files != null) {
	            for (File file : files) {
	                matchingFiles.add(file);
	            }
	        }
	    }

	    return matchingFiles;
	}
}

package com.tyse.pipeline.util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

import com.tyse.pipeline.domain.entities.Dmp;
import com.tyse.pipeline.error.ExecuteCommandException;

public class CommandLineExecutionUtil {

	private CommandLineExecutionUtil() {

	}

	public static Byte executeCommand(String command, Dmp dmp) {
		try {
			// Ejecutar el comando
			ProcessBuilder processBuilder = new ProcessBuilder(command.split(" "));
			processBuilder.redirectErrorStream(true);
			Process process = processBuilder.start();

			// Leer la salida del comando
			BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
			String line;
			StringBuilder response = new StringBuilder();
			while ((line = reader.readLine()) != null) {
				response.append(line).append("\n");
			}

			// Esperar a que termine la ejecución del comando
			int exitCode = process.waitFor();
			response.append("Comando ejecutado con código de salida: " + exitCode);
			dmp.setResultImport(response.toString());
			return (byte) exitCode;
		} catch (IOException | InterruptedException e) {
			e.printStackTrace();
			throw new ExecuteCommandException(e.getMessage(), e.getCause(), true, true);
		}
	}
	
	public static String executeCommand(String command) {
		try {
			// Ejecutar el comando
			String[] cmdArray = { command };
			Process process = Runtime.getRuntime().exec(cmdArray);

			// Leer la salida del comando
			BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
			String line;
			StringBuilder response = new StringBuilder();
			while ((line = reader.readLine()) != null) {
				response.append(line).append("\n");
			}

			// Esperar a que termine la ejecución del comando
			int exitCode = process.waitFor();
			response.append("Comando ejecutado con código de salida: " + exitCode);
			return response.toString();
		} catch (IOException | InterruptedException e) {
			e.printStackTrace();
			return e.getMessage();
		}
	}
}

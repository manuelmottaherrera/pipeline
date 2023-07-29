package com.tyse.pipeline.util;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;

import com.tyse.pipeline.domain.entities.Dmp;
import com.tyse.pipeline.error.ExecuteCommandException;

public class CommandLineExecutionUtil {

	private CommandLineExecutionUtil() {

	}

	public static Byte executeCommandImp(String command, Dmp dmp) {
		try {
			ProcessBuilder processBuilder = new ProcessBuilder(command.split(" "));
			processBuilder.redirectErrorStream(true);
			Process process = processBuilder.start();

			BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
			String line;
			StringBuilder response = new StringBuilder();
			while ((line = reader.readLine()) != null) {
				response.append(line).append("\n");
				System.out.println(line);
			}

			int exitCode = process.waitFor();
			response.append("Comando ejecutado con código de salida: " + exitCode);
			dmp.setResultImport(response.toString());
			return (byte) exitCode;
		} catch (IOException | InterruptedException e) {
			e.printStackTrace();
			throw new ExecuteCommandException(e.getMessage(), e.getCause(), true, true);
		}
	}
	
	public static Byte executeCommand(String command, String homeDirectory) {
		try {
			System.out.println(command);
			ProcessBuilder processBuilder = new ProcessBuilder(command.split(" "));
			processBuilder.redirectErrorStream(true);
			processBuilder.directory(new File(homeDirectory));
			Process process = processBuilder.start();
			BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
			String line;
			while ((line = reader.readLine()) != null) {
				System.out.println(line);
			}

			int exitCode = process.waitFor();
			return (byte) exitCode;
		} catch (IOException | InterruptedException e) {
			e.printStackTrace();
			throw new ExecuteCommandException(e.getMessage(), e.getCause(), true, true);
		}
	}
	
	public static Byte executeCommand(String[] command, String homeDirectory) {
		try {
			for (String string : command) {
				System.out.println(string + " ");
			}
			ProcessBuilder processBuilder = new ProcessBuilder(command);
			processBuilder.redirectErrorStream(true);
			processBuilder.directory(new File(homeDirectory));
			Process process = processBuilder.start();
			BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
			String line;
			while ((line = reader.readLine()) != null) {
				System.out.println(line);
			}

			int exitCode = process.waitFor();
			return (byte) exitCode;
		} catch (IOException | InterruptedException e) {
			e.printStackTrace();
			throw new ExecuteCommandException(e.getMessage(), e.getCause(), true, true);
		}
	}
}

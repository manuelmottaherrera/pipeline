package com.tyse.pipeline.util;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.tyse.pipeline.PipelineApplication;
import com.tyse.pipeline.domain.entities.Dmp;
import com.tyse.pipeline.error.ExecuteCommandException;

public class CommandLineExecutionUtil {
	
	private static final Logger logger = LoggerFactory.getLogger(PipelineApplication.class);
	
	private CommandLineExecutionUtil() {

	}

	public static Byte executeCommandImp(String[] command, Dmp dmp) {
		try {
			for (String string : command) {
				logger.info(string + " ");
			}
			ProcessBuilder processBuilder = new ProcessBuilder(command);
			processBuilder.redirectErrorStream(true);
			Process process = processBuilder.start();

			BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
			String line;
			StringBuilder response = new StringBuilder();
			while ((line = reader.readLine()) != null) {
				response.append(line).append("\n");
				logger.info(line);
			}

			int exitCode = process.waitFor();
			response.append("Comando ejecutado con código de salida: " + exitCode);
			dmp.setResultImport(response.toString());
			return (byte) exitCode;
		} catch (IOException | InterruptedException e) {
			e.printStackTrace();
			logger.error(e.getMessage());
			throw new ExecuteCommandException(e.getMessage(), e.getCause(), true, true);
		}
	}
	
	public static Byte executeCommand(String command, String homeDirectory, boolean verbose) {
		try {
			logger.info(command);
			ProcessBuilder processBuilder = new ProcessBuilder(command.split(" "));
			processBuilder.redirectErrorStream(true);
			processBuilder.directory(new File(homeDirectory));
			Process process = processBuilder.start();
			if (verbose) {
				BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
				String line;
				while ((line = reader.readLine()) != null) {
					logger.info(line);
				}
			}
			int exitCode = process.waitFor();
			return (byte) exitCode;
		} catch (IOException | InterruptedException e) {
			e.printStackTrace();
			logger.error(e.getMessage());
			throw new ExecuteCommandException(e.getMessage(), e.getCause(), true, true);
		}
	}
	
	public static Byte executeCommand(String[] command, String homeDirectory, boolean verbose) {
		try {
			for (String string : command) {
				logger.info(string + " ");
			}
			ProcessBuilder processBuilder = new ProcessBuilder(command);
			processBuilder.redirectErrorStream(true);
			processBuilder.directory(new File(homeDirectory));
			Process process = processBuilder.start();
			if (verbose) {
				BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
				String line;
				while ((line = reader.readLine()) != null) {
					logger.info(line);
				} 
			}
			int exitCode = process.waitFor();
			return (byte) exitCode;
		} catch (IOException | InterruptedException e) {
			e.printStackTrace();
			logger.error(e.getMessage());
			throw new ExecuteCommandException(e.getMessage(), e.getCause(), true, true);
		}
	}
}

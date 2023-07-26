package com.tyse.pipeline.error;

public class DownloadDmpException extends RuntimeException {

	private static final long serialVersionUID = -6825735449415829281L;

	public DownloadDmpException() {
		super();
	}

	public DownloadDmpException(String message) {
		super(message);
	}

	public DownloadDmpException(Throwable cause) {
		super(cause);
	}

	public DownloadDmpException(String message, Throwable cause) {
		super(message, cause);
	}

	public DownloadDmpException(String message, Throwable cause, boolean enableSuppression,
			boolean writableStackTrace) {
		super(message, cause, enableSuppression, writableStackTrace);
	}

}

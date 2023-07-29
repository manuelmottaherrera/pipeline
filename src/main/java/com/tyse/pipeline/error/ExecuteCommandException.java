package com.tyse.pipeline.error;

public class ExecuteCommandException extends RuntimeException {

	private static final long serialVersionUID = 3043250386842411842L;

	public ExecuteCommandException() {
		super();
	}

	public ExecuteCommandException(String message) {
		super(message);
	}

	public ExecuteCommandException(Throwable cause) {
		super(cause);
	}

	public ExecuteCommandException(String message, Throwable cause) {
		super(message, cause);
	}

	public ExecuteCommandException(String message, Throwable cause, boolean enableSuppression,
			boolean writableStackTrace) {
		super(message, cause, enableSuppression, writableStackTrace);
	}

}

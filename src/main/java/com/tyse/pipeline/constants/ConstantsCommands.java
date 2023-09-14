package com.tyse.pipeline.constants;

public class ConstantsCommands {
	private static final String SQLITE3 = "sqlite3";

	private ConstantsCommands() {

	}
	
	public static final String impCommand(String datasource, String file, String userDb) {
		return "imp " + datasource + " file=" + file + "  fromuser=APLADMIN touser=" + userDb;
	}
	
	public static final String sqlldrCommand(String datasource, String ctlFile, String fileName) {
		return "sqlldr " + datasource + " control=" + ctlFile + " data=" + fileName;
	}
	
	public static final String sqlPlusCommand(String datasource, String file) {
		return "sqlplus " + datasource + " @" + file;
	}

	public static final String renameSqliteFile(String defaultName, String newName) {
		return "mv " + defaultName + " " + newName + ".sql";
	}

	public static final String[] runInitScript(String nameDb, String initScriptFile) {
		return new String[] { SQLITE3, nameDb + ".db", ".read " + initScriptFile, ".exit" };
	}

	public static final String[] deleteNumberOfLines(String nameSqliteFile, int linesToDelete) {
		return new String[] { "bash", "-c", "truncate -s $(($(stat -c %s " + nameSqliteFile + ".sql) - $(tail -n "
				+ linesToDelete + " " + nameSqliteFile + ".sql | wc -c))) " + nameSqliteFile + ".sql" };
	}

	public static final String[] importSqlite(String nameFileSql) {
		return new String[] { SQLITE3, nameFileSql + ".db", ".read " + nameFileSql + ".sql", ".exit" };
	}
	
	public static final String[] importSqliteWithCsv(String nameFileSql) {
		return new String[] { SQLITE3, nameFileSql + ".db", ".read " + nameFileSql + ".sql",".mode csv", ".import " + nameFileSql + "_divipol.csv", ".import " + nameFileSql + "_censo.csv", ".exit" };
	}
	
	public static final String[] moveFile(String absolutePathFileOrigen, String absolutePathFileFinal) {
		return new String [] {"bash", "-c", "mv " + absolutePathFileOrigen + " " + absolutePathFileFinal };
	}
	
	public static final String[] deleteFile(String absoluteFileName) {
		return new String[] {"rm", absoluteFileName};
	}
	
	public static final String[] compressFile(String fileName) {
		return new String[] {"zip", fileName.split("\\.")[0] + ".zip", fileName };
	}
}

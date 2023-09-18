package com.tyse.pipeline.constants;

public class ConstantsCommands {
	private static final String SQLITE3 = "sqlite3";

	private ConstantsCommands() {

	}
	
	public static final String[] impCommand(String datasource, String file, String dmpDirectory, String tablespaceClient, String tablespaceIndex, String userClient, String userDb) {
		return new String[] {
				"bash", "-c", //"podman exec oracle-19-3-p " + 
				"impdp " + datasource +
				" DUMPFILE=" + file + 
				" directory=" + dmpDirectory + 
				" logfile=import00.log" + 
				" REMAP_TABLESPACE=" + tablespaceClient + ":users," + tablespaceIndex + ":users" + 
				" REMAP_SCHEMA=" + userClient + ":" + userDb
			};
		//impdp adm_biometria DUMPFILE=main_dump.dmp directory=DMP_INPUT logfile=import00.log  REMAP_TABLESPACE=TBS_COL_DATA_NEW:users,TBS_APL_IDX:users REMAP_SCHEMA=APLADMIN:adm_biometria
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
		return new String[] { SQLITE3, nameFileSql + ".db", ".read " + nameFileSql + ".sql",".mode csv", ".import " + nameFileSql + "_divipol.csv" + " divipol", ".import " + nameFileSql + "_censo.csv" + " censo", ".exit" };
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

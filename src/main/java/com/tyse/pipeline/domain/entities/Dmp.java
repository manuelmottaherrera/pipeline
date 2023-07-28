package com.tyse.pipeline.domain.entities;

import java.io.Serializable;
import java.time.Instant;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.SequenceGenerator;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "DMP")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class Dmp implements Serializable{

	private static final long serialVersionUID = -7823186460173679406L;

	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "dmp_sequence")
    @SequenceGenerator(name = "dmp_sequence", sequenceName = "DMP_SEQ", allocationSize = 1)
	@Column(name = "ID")
	private Short id;
	
	@Column(name = "DMP_FILE_NAME")
    private String dmpFileName;

	@Column(name = "DATE_UPLOAD")
    private Instant dateUpload;

	@Column(name = "ID_USERS")
    private Short idUsers;

	@Column(name = "STATUS")
    private String status;
	
	@Column(name = "RESULT_IMPORT")
    private String resultImport;
	
	@Column(name = "EXIT_CODE_DMP")
    private Byte exitCodeDmp;
	
	@Column(name = "EXIT_CODE_SQL")
    private Byte exitCodeSql;
	
	@Column(name = "EXIT_CODE_SQLITE")
    private Byte exitCodeSqlite;
}

package com.tyse.pipeline.domain.entities;

import java.io.Serializable;
import java.time.Instant;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
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
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Short id;
	
	@Column
	private byte[] dmpFile;

	@Column
    private Instant date;

	@Column
    private Long idUsers;

	@Column
    private String status;
}

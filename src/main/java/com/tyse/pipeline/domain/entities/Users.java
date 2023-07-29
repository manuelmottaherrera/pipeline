package com.tyse.pipeline.domain.entities;

import java.io.Serializable;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class Users implements Serializable {

	private static final long serialVersionUID = -6690533777415142181L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Short id;
	
	@Column(length = 20, nullable = false, unique = true)
	private String username;
	
	@Column(length = 100, nullable = false)
	private String password;
}

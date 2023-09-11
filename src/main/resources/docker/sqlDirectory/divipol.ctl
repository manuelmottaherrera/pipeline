LOAD DATA
INFILE '&1' -- Reemplaza 'divipol.txt' con la ruta de tu archivo de divipol
APPEND
INTO TABLE DIVIPOL
FIELDS TERMINATED BY '\t'
TRAILING NULLCOLS
(
  DEPARTAMENTO,
  MUNICIPIO,
  ZONA,
  PUESTO,
  DESCRIPCION,
  DIPOCONS,
  DIRECCION
)
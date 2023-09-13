rm -R ~/pipelineDirectory/archiveFolder/logs
rm -R ~/pipelineDirectory/archiveFolder/sqlite/db/*
mv ~/pipelineDirectory/archiveFolder/archive/* ~/pipelineDirectory/inputFolder/
rm -R ~/pipelineDirectory/outputFolder/*
mvn liquibase:dropAll
mvn clean install
java -jar target/pipeline-0.0.1-SNAPSHOT.jar

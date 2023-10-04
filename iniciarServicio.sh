rm -R ~/pipelineDirectory/logs
rm -R ~/pipelineDirectory/sqlite/db/*
rm ~/pipelineDirectory/sqlDirectory/*.log
rm ~/pipelineDirectory/sqlDirectory/*.bad
mv ~/pipelineDirectory/archiveFolder/* ~/pipelineDirectory/inputFolder/
rm -R ~/pipelineDirectory/outputFolder/*
mvn liquibase:dropAll
mvn clean install
java -jar target/pipeline-0.0.1-SNAPSHOT.jar

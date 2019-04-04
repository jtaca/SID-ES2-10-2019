@echo %time%

mysql --user=root --database=bdauditorgr18 --execute="LOAD DATA LOCAL INFILE 'C:/xampp/mysql/data/logs_cultura.csv' INTO TABLE log_cultura FIELDS TERMINATED BY ';' OPTIONALLY ENCLOSED BY '""' LINES TERMINATED BY '\n'; LOAD DATA LOCAL INFILE 'C:/xampp/mysql/data/logs_investigador.csv' INTO TABLE log_investigador FIELDS TERMINATED BY ';' OPTIONALLY ENCLOSED BY '""' LINES TERMINATED BY '\n'; LOAD DATA LOCAL INFILE 'C:/xampp/mysql/data/logs_medicoes.csv' INTO TABLE log_medicoes FIELDS TERMINATED BY ';' OPTIONALLY ENCLOSED BY '""' LINES TERMINATED BY '\n'; LOAD DATA LOCAL INFILE 'C:/xampp/mysql/data/logs_medicoesluminosidade.csv' INTO TABLE log_medicoesluminosidade FIELDS TERMINATED BY ';' OPTIONALLY ENCLOSED BY '""' LINES TERMINATED BY '\n'; LOAD DATA LOCAL INFILE 'C:/xampp/mysql/data/logs_medicoestemperatura.csv' INTO TABLE log_medicoestemperatura FIELDS TERMINATED BY ';' OPTIONALLY ENCLOSED BY '""' LINES TERMINATED BY '\n'; LOAD DATA LOCAL INFILE 'C:/xampp/mysql/data/logs_sistema.csv' INTO TABLE log_sistema FIELDS TERMINATED BY ';' OPTIONALLY ENCLOSED BY '""' LINES TERMINATED BY '\n'; LOAD DATA LOCAL INFILE 'C:/xampp/mysql/data/logs_variaveis.csv' INTO TABLE log_variaveis FIELDS TERMINATED BY ';' OPTIONALLY ENCLOSED BY '""' LINES TERMINATED BY '\n'; LOAD DATA LOCAL INFILE 'C:/xampp/mysql/data/logs_variaveismedidas.csv' INTO TABLE log_variaveismedidas FIELDS TERMINATED BY ';' OPTIONALLY ENCLOSED BY '""' LINES TERMINATED BY '\n'"

del "C:\xampp\mysql\data\logs_cultura.csv"
del "C:\xampp\mysql\data\logs_investigador.csv"
del "C:\xampp\mysql\data\logs_medicoes.csv"
del "C:\xampp\mysql\data\logs_medicoesluminosidade.csv"
del "C:\xampp\mysql\data\logs_medicoestemperatura.csv"
del "C:\xampp\mysql\data\logs_sistema.csv"
del "C:\xampp\mysql\data\logs_variaveis.csv"
del "C:\xampp\mysql\data\logs_variaveismedidas.csv"

@echo %time%
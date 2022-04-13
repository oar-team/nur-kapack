CREATE TABLE IF NOT EXISTS Applications (job_id INT unsigned NOT NULL, step_id INT unsigned NOT NULL, node_id VARCHAR(64), signature_id INT unsigned, power_signature_id INT unsigned, PRIMARY KEY(job_id, step_id, node_id));
CREATE TABLE IF NOT EXISTS Loops ( event INT unsigned NOT NULL, size INT unsigned NOT NULL, level INT unsigned NOT NULL, job_id INT unsigned NOT NULL, step_id INT unsigned NOT NULL, node_id VARCHAR(64), total_iterations INT unsigned, signature_id INT unsigned);
CREATE TABLE IF NOT EXISTS Jobs (id INT unsigned NOT NULL,step_id INT unsigned NOT NULL, user_id VARCHAR(128),app_id VARCHAR(128),start_time INT NOT NULL,end_time INT NOT NULL,start_mpi_time INT NOT NULL,end_mpi_time INT NOT NULL,policy VARCHAR(256) NOT NULL,threshold FLOAT NOT NULL,procs INT unsigned NOT NULL,job_type SMALLINT unsigned NOT NULL,def_f INT unsigned, user_acc VARCHAR(256), user_group VARCHAR(256), e_tag VARCHAR(256), PRIMARY KEY(id, step_id));
CREATE TABLE IF NOT EXISTS Signatures (id INT unsigned NOT NULL AUTO_INCREMENT,DC_power FLOAT,DRAM_power FLOAT,PCK_power FLOAT,EDP FLOAT,GBS FLOAT,IO_MBS FLOAT,TPI FLOAT,CPI FLOAT,Gflops FLOAT,time FLOAT,perc_MPI FLOAT,FLOPS1 BIGINT unsigned,FLOPS2 BIGINT unsigned,FLOPS3 BIGINT unsigned,FLOPS4 BIGINT unsigned,FLOPS5 BIGINT unsigned,FLOPS6 BIGINT unsigned,FLOPS7 BIGINT unsigned,FLOPS8 BIGINT unsigned,instructions BIGINT unsigned, cycles BIGINT unsigned,avg_f INT unsigned,avg_imc_f INT unsigned,def_f INT unsigned, PRIMARY KEY (id));
CREATE TABLE IF NOT EXISTS Periodic_metrics ( id INT unsigned NOT NULL AUTO_INCREMENT, start_time INT NOT NULL, end_time INT NOT NULL, DC_energy INT unsigned NOT NULL, node_id VARCHAR(64) NOT NULL, job_id INT unsigned NOT NULL, step_id INT unsigned NOT NULL, avg_f INT, temp INT, DRAM_energy INT, PCK_energy INT, PRIMARY KEY (id));
CREATE TABLE IF NOT EXISTS Power_signatures (  id INT unsigned NOT NULL AUTO_INCREMENT, DC_power FLOAT NOT NULL, DRAM_power FLOAT NOT NULL, PCK_power FLOAT NOT NULL, EDP FLOAT NOT NULL, max_DC_power FLOAT NOT NULL, min_DC_power FLOAT NOT NULL, time FLOAT NOT NULL, avg_f INT unsigned NOT NULL, def_f INT unsigned NOT NULL, PRIMARY KEY (id));
CREATE TABLE IF NOT EXISTS Events ( id INT unsigned NOT NULL AUTO_INCREMENT, timestamp INT NOT NULL, event_type INT NOT NULL, job_id INT unsigned NOT NULL, step_id INT unsigned NOT NULL, freq INT unsigned NOT NULL, node_id VARCHAR(64), PRIMARY KEY (id));
CREATE TABLE IF NOT EXISTS Global_energy ( energy_percent FLOAT, warning_level INT UNSIGNED NOT NULL, time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, inc_th FLOAT, p_state INT, GlobEnergyConsumedT1 INT UNSIGNED, GlobEnergyConsumedT2 INT UNSIGNED, GlobEnergyLimit INT UNSIGNED, GlobEnergyPeriodT1 INT UNSIGNED, GlobEnergyPeriodT2 INT UNSIGNED, GlobEnergyPolicy VARCHAR(64), PRIMARY KEY (time));
CREATE TABLE IF NOT EXISTS Learning_applications (job_id INT unsigned NOT NULL, step_id INT unsigned NOT NULL, node_id VARCHAR(64), signature_id INT unsigned,power_signature_id INT unsigned, PRIMARY KEY(job_id, step_id, node_id));
CREATE TABLE IF NOT EXISTS Learning_jobs (id INT unsigned NOT NULL,step_id INT unsigned NOT NULL, user_id VARCHAR(256),app_id VARCHAR(256),start_time INT NOT NULL,end_time INT NOT NULL,start_mpi_time INT NOT NULL,end_mpi_time INT NOT NULL,policy VARCHAR(256) NOT NULL,threshold FLOAT NOT NULL,procs INT unsigned NOT NULL,job_type SMALLINT unsigned NOT NULL,def_f INT unsigned, user_acc VARCHAR(256) NOT NULL, user_group VARCHAR(256), e_tag VARCHAR(256), PRIMARY KEY(id, step_id));
CREATE TABLE IF NOT EXISTS Periodic_aggregations (id INT unsigned NOT NULL AUTO_INCREMENT,start_time INT,end_time INT,DC_energy INT unsigned, eardbd_host VARCHAR(64), PRIMARY KEY(id));
CREATE TABLE IF NOT EXISTS Learning_signatures (id INT unsigned NOT NULL AUTO_INCREMENT,DC_power FLOAT,DRAM_power FLOAT,PCK_power FLOAT,EDP FLOAT,GBS FLOAT,IO_MBS FLOAT,TPI FLOAT,CPI FLOAT,Gflops FLOAT,time FLOAT,perc_MPI FLOAT,FLOPS1 BIGINT unsigned,FLOPS2 BIGINT unsigned,FLOPS3 BIGINT unsigned,FLOPS4 BIGINT unsigned,FLOPS5 BIGINT unsigned,FLOPS6 BIGINT unsigned,FLOPS7 BIGINT unsigned,FLOPS8 BIGINT unsigned,instructions BIGINT unsigned, cycles BIGINT unsigned,avg_f INT unsigned,avg_imc_f INT unsigned,def_f INT unsigned, PRIMARY KEY (id));
CREATE TABLE IF NOT EXISTS Applications (job_id INT  NOT NULL, step_id INT  NOT NULL, node_id VARCHAR(64), signature_id INT , power_signature_id INT , PRIMARY KEY(job_id, step_id, node_id));
CREATE TABLE IF NOT EXISTS Loops ( event INT  NOT NULL, size INT  NOT NULL, level INT  NOT NULL, job_id INT  NOT NULL, step_id INT  NOT NULL, node_id VARCHAR(64), total_iterations INT , signature_id INT );
CREATE TABLE IF NOT EXISTS Jobs (id INT  NOT NULL,step_id INT  NOT NULL, user_id VARCHAR(128),app_id VARCHAR(128),start_time INT NOT NULL,end_time INT NOT NULL,start_mpi_time INT NOT NULL,end_mpi_time INT NOT NULL,policy VARCHAR(256) NOT NULL,threshold FLOAT NOT NULL,procs INT  NOT NULL,job_type SMALLINT  NOT NULL,def_f INT , user_acc VARCHAR(256), user_group VARCHAR(256), e_tag VARCHAR(256), PRIMARY KEY(id, step_id));
CREATE TABLE IF NOT EXISTS Signatures (id SERIAL NOT NULL,DC_power FLOAT,DRAM_power FLOAT,PCK_power FLOAT,EDP FLOAT,GBS FLOAT,IO_MBS FLOAT,TPI FLOAT,CPI FLOAT,Gflops FLOAT,time FLOAT,perc_MPI FLOAT,FLOPS1 BIGINT ,FLOPS2 BIGINT ,FLOPS3 BIGINT ,FLOPS4 BIGINT ,FLOPS5 BIGINT ,FLOPS6 BIGINT ,FLOPS7 BIGINT ,FLOPS8 BIGINT ,instructions BIGINT , cycles BIGINT ,avg_f INT ,avg_imc_f INT ,def_f INT , PRIMARY KEY (id));
CREATE TABLE IF NOT EXISTS Periodic_metrics ( id SERIAL NOT NULL, start_time INT NOT NULL, end_time INT NOT NULL, DC_energy INT  NOT NULL, node_id VARCHAR(64) NOT NULL, job_id INT  NOT NULL, step_id INT  NOT NULL, avg_f INT, temp INT, DRAM_energy INT, PCK_energy INT, PRIMARY KEY (id));
CREATE TABLE IF NOT EXISTS Power_signatures (  id SERIAL NOT NULL, DC_power FLOAT NOT NULL, DRAM_power FLOAT NOT NULL, PCK_power FLOAT NOT NULL, EDP FLOAT NOT NULL, max_DC_power FLOAT NOT NULL, min_DC_power FLOAT NOT NULL, time FLOAT NOT NULL, avg_f INT  NOT NULL, def_f INT  NOT NULL, PRIMARY KEY (id));
CREATE TABLE IF NOT EXISTS Events ( id SERIAL NOT NULL, timestamp INT NOT NULL, event_type INT NOT NULL, job_id INT  NOT NULL, step_id INT  NOT NULL, freq INT  NOT NULL, node_id VARCHAR(64), PRIMARY KEY (id));
CREATE TABLE IF NOT EXISTS Global_energy ( energy_percent FLOAT, warning_level INT NOT NULL, time INT, inc_th FLOAT, p_state INT, GlobEnergyConsumedT1 INT, GlobEnergyConsumedT2 INT, GlobEnergyLimit INT, GlobEnergyPeriodT1 INT, GlobEnergyPeriodT2 INT, GlobEnergyPolicy VARCHAR(64), PRIMARY KEY (time));
CREATE TABLE IF NOT EXISTS Learning_applications (job_id INT  NOT NULL, step_id INT  NOT NULL, node_id VARCHAR(64), signature_id INT ,power_signature_id INT , PRIMARY KEY(job_id, step_id, node_id));
CREATE TABLE IF NOT EXISTS Learning_jobs (id INT  NOT NULL,step_id INT  NOT NULL, user_id VARCHAR(256),app_id VARCHAR(256),start_time INT NOT NULL,end_time INT NOT NULL,start_mpi_time INT NOT NULL,end_mpi_time INT NOT NULL,policy VARCHAR(256) NOT NULL,threshold FLOAT NOT NULL,procs INT  NOT NULL,job_type SMALLINT  NOT NULL,def_f INT , user_acc VARCHAR(256) NOT NULL, user_group VARCHAR(256), e_tag VARCHAR(256), PRIMARY KEY(id, step_id));
CREATE TABLE IF NOT EXISTS Periodic_aggregations (id SERIAL NOT NULL,start_time INT,end_time INT,DC_energy INT , eardbd_host VARCHAR(64), PRIMARY KEY(id));
CREATE TABLE IF NOT EXISTS Learning_signatures (id SERIAL NOT NULL,DC_power FLOAT,DRAM_power FLOAT,PCK_power FLOAT,EDP FLOAT,GBS FLOAT,TPI FLOAT,CPI FLOAT,Gflops FLOAT,time FLOAT,FLOPS1 BIGINT ,FLOPS2 BIGINT ,FLOPS3 BIGINT ,FLOPS4 BIGINT ,FLOPS5 BIGINT ,FLOPS6 BIGINT ,FLOPS7 BIGINT ,FLOPS8 BIGINT ,instructions BIGINT , cycles BIGINT ,avg_f INT ,def_f INT , PRIMARY KEY (id));
CREATE OR REPLACE FUNCTION update_time_column() 
RETURNS TRIGGER AS $$
BEGIN
NEW.time = now(); 
RETURN NEW;
END;
$$ language 'plpgsql';
CREATE TRIGGER update_table_timestamp BEFORE UPDATE ON global_energy FOR EACH ROW EXECUTE PROCEDURE update_time_column();

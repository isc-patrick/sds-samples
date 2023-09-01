package sample.busybox;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.DatabaseMetaData;
import java.sql.Statement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.sql.DataSource;

import com.intersystems.jdbc.IRISDataSource;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.ApplicationPidFileWriter;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@EnableScheduling
@SpringBootApplication
@Configuration
public class App implements ApplicationRunner
{	
	@Value("${BUSYBOX_IRIS_JDBC_URL}")
    private String jdbcConnectionString;

	@Value("${BUSYBOX_INSERT_RATE}")
	private String insertRateInMillis;

	@Value("${BUSYBOX_TABLE_NAME}")
	private String fullTableName;

	@Value("${IRIS_USERNAME}")
	private String irisUsername;

	@Value("${IRIS_PASSWORD}")
	private String irisPassword;
	
	private Connection connection = null;
    
	@Bean
    public Connection irisConnection() throws SQLException
	{
		if (this.connection!=null) return connection;

		logger.info("Connecting to InterSystems IRIS using " + this.jdbcConnectionString);

		IRISDataSource ds = new IRISDataSource();
		ds.setURL(this.jdbcConnectionString);
		ds.setUser(irisUsername);
		ds.setPassword(irisPassword);
		this.connection = ds.getConnection();

		logger.info("Connected!");

		return connection;
    }

	Logger logger = LoggerFactory.getLogger(App.class);
    
	public static void main(String[] args) throws IOException
	{
		SpringApplication app = new SpringApplication(App.class);

		app.addListeners(new ApplicationPidFileWriter("./bin/shutdown.pid"));
		        
		ConfigurableApplicationContext ctx = app.run(args);
		
        /// This will terminate the app after run() is done.
		//ctx.close();
    }
    
    // @Scheduled(fixedRate=1000)
    // public void work() throws SQLException
    // {
    //     logger.info("Hi there: " + this.jdbcConnectionString);
    // }

	public void run(ApplicationArguments args) throws InterruptedException
	{	
		try {

			Statement stmt = this.connection.createStatement();
			String sql = "";

			// Delete table if it already exists with given name
			try
			{
				stmt.executeUpdate("DROP TABLE " + this.fullTableName);
			}
			catch (SQLException ignoredException) 
			{ 
				//Ignoring 
			}
			
			// Create table with given name
			sql = "CREATE TABLE " + this.fullTableName + " " +
					"(val int);";
			stmt.executeUpdate(sql);

			logger.info("Created table "+this.fullTableName+" in given database...");

			// Insert a record in the table at the given rate
			sql = "INSERT INTO " + this.fullTableName + " VALUES (?)";
			PreparedStatement pstmt = this.connection.prepareStatement(sql);

			for (int val=0; val<15; val++)
			{
				pstmt.setInt(1, val);
				pstmt.executeUpdate();
				Thread.sleep(Long.valueOf(this.insertRateInMillis));
			}

			// Query table to ensure values added properly (for testing purposes)
			//
			// sql = "SELECT * FROM " + this.fullTableName;
			// rs = stmt.executeQuery(sql);
			// String tablevals = "";
			// while (rs.next()) {
			// 	tablevals += rs.getString("val") + ",";
			// }
			// logger.info("Values added: " + tablevals);

		}

		catch (SQLException e) {
			logger.info("error: ", e);
		}
        
	}
}

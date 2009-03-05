package lu.mind.projects.cms;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.Connection;
import java.util.Properties;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;
import javax.servlet.ServletContext;
import org.apache.log4j.Logger;


public class Application {

	static Properties applicationConfigFile = null;
	static String configFileName = null;
	static ServletContext context = null;
	static private Connection conn = null;
	static private DataSource dataSource;

	// claimsform.conf claimsform.conf sso.conf
	final static private String configFileLinux = "/home/tomcat/cms.conf";
	final static private String configFileWindows = "c:\\cms.conf";

    public static Logger log = org.apache.log4j.Logger.getLogger("CMS");

	public Application() {
		super();
	}



	public static void readConfigFile() {
		Properties configFile = new Properties();
		if (System.getProperty("os.name").startsWith("Windows")) {
			configFileName = configFileWindows;
		} else if (System.getProperty("os.name").startsWith("Linux")) {
			configFileName = configFileLinux;
		}
		Application.log.info("Reading configfile " + configFileName);

		try {
			configFile.load(new FileInputStream(new File(configFileName)));
		} catch (FileNotFoundException e) {
			Application.log.error("Application.closeDbConnection(), FileNotFoundException: "+e.getMessage());
			e.printStackTrace();
		} catch (IOException e) {
			Application.log.error("Application.closeDbConnection(), IOException: "+e.getMessage());
			e.printStackTrace();
		}
		Application.applicationConfigFile = configFile;
	}

	public static String getConfigFileParameter(String key) {
		String value = Application.applicationConfigFile.getProperty(key);
		if (value == null) {
			context.log(key+" not found in "+configFileName);
		}
		return value;
	}


	public static Connection getDbConnection() {
		Connection dbConnection = null;
			try {
				Application.log.info("Got a connection from the pool.");
				dbConnection = dataSource.getConnection(); // TODO: here we crash when Firebird is unavailable
			} catch (Exception e) {
				e.printStackTrace();
				Application.log.error("Getting connection from pool failed. Trying to reconnect pool to database. Exception: "+e.getMessage());
				//connectToPool();
				//dbConnection = getDbConnection();
			}
		return dbConnection;
	}

	public static void closeDbConnection(Connection conn) {
		try {
			conn.close();
		} catch (Exception e2) {
			Application.log.error("Application.closeDbConnection(), Exception: "+e2.getMessage());
		}
	}

	/*
	public static void closeDbConnection(Connection conn) {
		if ((Application.applicationConfigFile.getProperty("dbConnectionType").equals("0")) || (Application.applicationConfigFile.getProperty("dbConnectionType").equals("1"))) {
			Application.log.info("Application.closeDbConnection(conn): Closing conn.");
			try {
				conn.close();
				conn = null;
			} catch (Exception e2) {
				Application.log.error("Application.closeDbConnection(), Exception: "+e2.getMessage());
			} finally {
				if (conn != null) {
					try { conn.close(); } catch (SQLException e) { ; }
					conn = null;
				}
			}
		}
	}

	public static void closeDbConnection(Connection conn, PreparedStatement pstmt, ResultSet rst) {
		if ((Application.applicationConfigFile.getProperty("dbConnectionType").equals("0")) || (Application.applicationConfigFile.getProperty("dbConnectionType").equals("1"))) {
			Application.log.info("Application.closeDbConnection(conn, pstmt, rst): Closing conn, pstmt, rst.");
			try {
				rst.close();
				rst = null;
				pstmt.close();
				pstmt = null;
				conn.close(); // Return to connection pool
				conn = null;  // Make sure we don't close it twice
			} catch (SQLException e) {
				Application.log.error("Application.closeDbConnection(): Exception: "+e.getMessage());
			} finally {
				// Always make sure result sets and statements are closed,
				// and the connection is returned to the pool
				if (rst != null) {
					try { rst.close(); } catch (SQLException e) { ; }
					rst = null;
				}
				if (pstmt != null) {
					try { pstmt.close(); } catch (SQLException e) { ; }
					pstmt = null;
				}
				if (conn != null) {
					try { conn.close(); } catch (SQLException e) { ; }
					conn = null;
				}
			}
		}
	}
	 */

	public static void connectToPool() {
		Application.log.info("Application.connectToPool(): Connecting to pool. ("+Application.getConfigFileParameter("dataSource")+")");
		Context initCtx = null;
		Context envCtx = null;

		try {
			initCtx = new InitialContext();
			envCtx = (Context) initCtx.lookup("java:comp/env");
		} catch (NamingException e) {
			Application.log.error("Application.connectToPool(): NamingException: "+e.getMessage());
		}

		try {
			//envCtx.
			dataSource = (DataSource) envCtx.lookup(Application.getConfigFileParameter("dataSource"));
		} catch (NamingException e2) {
			Application.log.error("Application.connectToPool(): NamingException2: "+e2.getMessage());
		}

/*		if (dataSource != null) {
			Application.log.info("Application.connectToDb(): Got non-null datasource from pool.");
		} else {
			Application.log.error("Application.connectToDb(): Datasource we got from pool is null.");
		}*/
	}
}

package lu.mind.projects.cms.factories;

import java.sql.Connection;
import lu.mind.projects.cms.Application;
import lu.mind.projects.cms.dao.Sqlreportdatasource;
import lu.mind.projects.cms.dao.SqlreportdatasourceDAOFirebird;

public class SqlreportdatasourceFactory {

	public static Sqlreportdatasource getDataSourceById(String id) {
		Connection conn = Application.getDbConnection();
		SqlreportdatasourceDAOFirebird dao = new SqlreportdatasourceDAOFirebird(conn);
		Sqlreportdatasource sqlreportdatasource = dao.get(id);
		Application.closeDbConnection(conn);
		return sqlreportdatasource;
	}
}

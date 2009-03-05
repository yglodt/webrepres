package lu.mind.projects.cms.factories;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import lu.mind.projects.cms.Application;
import lu.mind.projects.cms.dao.Content;
import lu.mind.projects.cms.dao.ContentDAOFirebird;

public class SQLReportFactory {
	
	public static Content[] getAllReports() {
		Connection conn = Application.getDbConnection();
		ContentDAOFirebird dao = new ContentDAOFirebird(conn);
		Content[] content = dao.getAll("where ID = ?");
		Application.closeDbConnection(conn);
		return content;		
	}

	public static ArrayList<ResultSet> getReportById(String id) {
		ArrayList<ResultSet> result = new ArrayList<ResultSet>();
		PreparedStatement pstmt = null;
		ResultSet rst = null;
		Connection conn = Application.getDbConnection();
		
		String sql = "select mi.id,mi.pos,mi.item_id,mi.menu_id, c.title,c.published " +
		"from MENUITEM mi " +
		"left join CONTENT c on mi.item_id = c.id " +
		"where mi.MENU_ID = ? order by pos";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			rst = pstmt.executeQuery();
			while (rst.next()) {
				result.add(rst);
			}
		} catch (Exception e) {
			System.out.println("Exception in SQLReportFactory.getReportById(): "+e.getMessage());
		}
		Application.closeDbConnection(conn);
		return result;
	}
}

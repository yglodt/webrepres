package lu.mind.projects.cms.factories;

import java.sql.Connection;
import lu.mind.projects.cms.Application;
import lu.mind.projects.cms.dao.ContentType;
import lu.mind.projects.cms.dao.ContentTypeDAOFirebird;

public class ContentItemFactory {
	
	public static ContentType[] getContentTypes() {
		Connection conn = Application.getDbConnection();
		ContentType[] contentTypes = null;
		ContentTypeDAOFirebird dao = new ContentTypeDAOFirebird(conn);
		contentTypes = dao.getAll("order by title");
		return contentTypes;
	}

}

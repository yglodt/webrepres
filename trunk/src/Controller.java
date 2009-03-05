import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.UUID;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.tomcat.util.http.fileupload.FileUpload;
import lu.mind.projects.cms.Application;
import lu.mind.projects.cms.FileTools;
import lu.mind.projects.cms.dao.*;

public class Controller extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public Controller() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		RequestDispatcher disp;
		ServletContext app = getServletContext();

		/*Cookie cookie = new Cookie("SID", "ad630cd8-d21c-440e-992e-ed36add2547d");
		//cookie.setDomain(Application.getConfigFileParameter("cookieDomain"));
		cookie.setPath("/");
		cookie.setMaxAge(1000000);
		response.addCookie(cookie);
*/
		/*
		 * do not delete this

	    PrintWriter out = response.getWriter();
	    ByteArrayOutputStream temp = new ByteArrayOutputStream();
	    Properties properties = new Properties();
	    properties.setProperty("fontUnit", "px");
	    properties.setProperty("fontSize", "10");
	    properties.setProperty("backgroundColor", "#fef");
	    properties.storeToXML(temp, "comment", "UTF-8");
	    out.println(temp.toString("UTF-8"));
	    */
		
		Connection conn = Application.getDbConnection();
		//request.setAttribute("conn", conn);
		String view = "index.jsp";
		String viewPrefix = "/";

		if ((request.getParameter("action") != null) && 
				(request.getParameter("action").equals("view")) && 
				(request.getParameter("id") != null) ) {

			ContentDAOFirebird dao = new ContentDAOFirebird(conn);
			Content c = dao.get(request.getParameter("id"), 1);
			
			ContentTypeDAOFirebird tDao = new ContentTypeDAOFirebird(conn);
			ContentType ct = tDao.get(c.getContentType());
			System.out.println("R: "+ct.getRenderer());
			
			request.setAttribute("c", c);
			request.setAttribute("ct", ct);

			//disp = app.getRequestDispatcher(ct.getRenderer());
			view = "index.jsp";
		}

		// viewFile, e.g. for outputting an Image from the CONTENT table
		if ((request.getParameter("action") != null) && 
				(request.getParameter("action").equals("viewFile")) && 
				(request.getParameter("id") != null) ) {
			// http://balusc.blogspot.com/2007/04/imageservlet.html
			// better: http://www.java2s.com/Code/Java/Servlets/DisplayBlobServlet.htm

		    ServletOutputStream out = response.getOutputStream();

			ContentDAOFirebird dao = new ContentDAOFirebird(conn);
			Content c = dao.get(request.getParameter("id"), 1);
            Application.closeDbConnection(conn);

            byte[] data = FileTools.getFile(c.getId(), 1);
            if (data != null) {
    			System.out.println("viewFile: "+c.getContentLength()+","+c.getMimeType());
    			response.reset();
                response.setContentType(c.getMimeType());
    		    out.write(data);
    		    out.flush();
            }

            return;
          /*
            response.reset();
            response.setHeader("Content-disposition", "inline; filename=\"" + c.getFilename() + "\"");
            response.setContentType(c.getMimeType());
            response.setContentLength(c.getContentLength());
            response.getOutputStream().write(data, 0, data.length);
            response.getOutputStream().flush();
            */        
		}
		
		if ((request.getParameter("action") != null) && 
				(request.getParameter("action").equals("edit")) && 
				(request.getParameter("id") != null)) {
			ContentDAOFirebird dao = new ContentDAOFirebird(conn);
			Content c = dao.get(request.getParameter("id"), 1);
			ContentTypeDAOFirebird tDao = new ContentTypeDAOFirebird(conn);
			ContentType ct = tDao.get(c.getContentType());
			request.setAttribute("c", c);
			request.setAttribute("ct", ct);
			
			// sql content
			if (c.getContentType().equals("950d5d28-34a7-4e01-ba39-a47b8e28acba")) {
				SqlreportdatasourceDAOFirebird ddao = new SqlreportdatasourceDAOFirebird(conn);
				Sqlreportdatasource[] d = ddao.getAll();
				request.setAttribute("d", d);			
			}
			System.out.println("E: "+ct.getEditor());
			view = ct.getEditor();
		}

		if ((request.getParameter("action") != null) && 
				(request.getParameter("action").equals("add")) ) {
			
			if (request.getParameter("ctid") != null) {
				ContentTypeDAOFirebird ctDao = new ContentTypeDAOFirebird(conn);
				ContentType contentType = ctDao.get(request.getParameter("ctid"));
				view = contentType.getEditor();
			} else {
				view = "addContent.jsp";				
			}
		}

		Application.closeDbConnection(conn);
		disp = app.getRequestDispatcher(viewPrefix+view);
		disp.forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Connection conn = Application.getDbConnection();
		ContentDAOFirebird dao = new ContentDAOFirebird(conn);

		boolean isMultipart = FileUpload.isMultipartContent(request);
		System.out.println("length: "+request.getContentLength());
		String newFileId = null;
		if (isMultipart) {
			System.out.println("File Upload!");
			System.out.println("TODO: process form fields in FileTools.processFormField() since we are in multipart !!!!!!!!");
			newFileId = FileTools.saveFile(request);
			response.sendRedirect(request.getContextPath()+"/Controller?action=view&id="+newFileId);
			return;
		}

		if (request.getParameter("action").equals("edit")) {
			if (request.getParameter("preview") != null) {
				Content c = dao.get(request.getParameter("id"), 1);	
				c.setData(request.getParameter("data"));
				c.setTitle(request.getParameter("title"));

				// ?? gets lost in post : request.setAttribute("previewContent", c);
	/*
				ContentTypeDAOFirebird tDao = new ContentTypeDAOFirebird(conn);
				ContentType ct = tDao.get(c.getContentType());

				RequestDispatcher disp;
				ServletContext app = getServletContext();

				String view = ct.getRenderer();
				String viewPrefix = "/";

				disp = app.getRequestDispatcher(viewPrefix+view);
				disp.forward(request, response);
	*/
				Application.closeDbConnection(conn);
				response.sendRedirect(request.getContextPath()+"/Controller?action=	&id="+c.getId());
				return;
			} else if (request.getParameter("update") != null) {
				System.out.println("update");

				Content r = dao.get(request.getParameter("id"), 1);
				r.setTitle(request.getParameter("title"));

				if (request.getParameter("data") != null) {
					r.setData(request.getParameter("data"));
					r.setContentLength(r.getData().length());
				}
				
				if (request.getParameter("url") != null) {
					r.setUrl(request.getParameter("url"));				
				}

				if (request.getParameter("width") != null) {
					r.setWidth(request.getParameter("width"));			
				}

				if (request.getParameter("height") != null) {
					r.setHeight(request.getParameter("height"));		
				}

				if (request.getParameter("css") != null) {
					r.setCss(request.getParameter("css"));
				}

				//System.out.println(request.getContentType());
				//r.setMimeType(request.getContentType());
				r.setDateModified(new java.sql.Timestamp(System.currentTimeMillis()));
				dao.update(r);
				
				int result = 0;
				PreparedStatement pstmt = null;
				String stmt = "update MENUITEM set MENU_ID = ?, DATE_MODIFED = 'NOW' where ITEM_ID = ?";
				try {
					pstmt = conn.prepareStatement(stmt);
					pstmt.setString(1, request.getParameter("menuId"));
					pstmt.setString(2, r.getId());
					result = pstmt.executeUpdate();
				} catch (SQLException e) {
					e.printStackTrace();
				}
				System.out.println("res:"+result);
				if (result == 0) {
					MenuitemDAOFirebird mDao = new MenuitemDAOFirebird(conn);
					Menuitem mi = new Menuitem();
					mi.setId(UUID.randomUUID().toString());
					mi.setMenuId(request.getParameter("menuId"));
					mi.setItemId(r.getId());
					mi.setDateCreated(new java.sql.Timestamp(System.currentTimeMillis()));
					mDao.insert(mi);
				}

				
				/*
				Menuitem mi = new Menuitem();
				mi.setId(UUID.randomUUID().toString());
				mi.setMenuId(request.getParameter("menuId"));
				mi.setItemId(r.getId());
				mi.setDateCreated(new java.sql.Timestamp(System.currentTimeMillis()));
				mDao.insert(mi);
				*/
				
				Application.closeDbConnection(conn);
				response.sendRedirect(request.getContextPath()+"/Controller?action=view&id="+r.getId());
				return;
			} else if (request.getParameter("insert") !=  null) {
				System.out.println("insert");
				Content r = new Content();
				r.setId(UUID.randomUUID().toString());
				if (request.getParameter("title").equals("")) {
					r.setTitle("Untitled");	
				} else {
					r.setTitle(request.getParameter("title"));			
				}
				
				r.setContentType(request.getParameter("ctid"));
								
				if (request.getParameter("data") != null) {
					r.setData(request.getParameter("data"));
					r.setContentLength(r.getData().length());
				}
				
				if (request.getParameter("url") != null) {
					r.setUrl(request.getParameter("url"));				
				}

				if (request.getParameter("width") != null) {
					r.setWidth(request.getParameter("width"));			
				}

				if (request.getParameter("height") != null) {
					r.setHeight(request.getParameter("height"));		
				}

				if (request.getParameter("css") != null) {
					r.setCss(request.getParameter("css"));
				}
				
				
				r.setDateCreated(new java.sql.Timestamp(System.currentTimeMillis()));
				r.setVersion(1);
				dao.insert(r);

				MenuitemDAOFirebird mDao = new MenuitemDAOFirebird(conn);
				Menuitem mi = new Menuitem();
				mi.setId(UUID.randomUUID().toString());
				mi.setMenuId(request.getParameter("menuId"));
				mi.setItemId(r.getId());
				mi.setDateCreated(new java.sql.Timestamp(System.currentTimeMillis()));
				mDao.insert(mi);
				
				Application.closeDbConnection(conn);
				response.sendRedirect(request.getContextPath()+"/Controller?action=view&id="+r.getId());
				return;
			} else if (request.getParameter("delete") != null) {
				System.out.println("delete");
				Content r = dao.get(request.getParameter("id"), 1);
				dao.delete(r);

				/*
				MenuitemDAOFirebird miDao = new MenuitemDAOFirebird(conn);
				Menuitem[] mi = miDao.getAll("where ITEM_ID = ?");
				for (Menuitem menuitem : mi) {
					miDao.delete(menuitem);
				}
				*/
				
				PreparedStatement pstmt = null;
				String stmt = "delete from MENUITEM where ITEM_ID = ?";
				try {
					pstmt = conn.prepareStatement(stmt);
					pstmt.setString(1, request.getParameter("id"));
					pstmt.executeUpdate();
				} catch (SQLException e) {
					e.printStackTrace();
				}

				Application.closeDbConnection(conn);
				response.sendRedirect(request.getContextPath()+"/Controller");
			}
		}
				
		if ((request.getParameter("action") != null) && 
				(request.getParameter("action").equals("add")) ) {
			Application.closeDbConnection(conn);
			response.sendRedirect(request.getContextPath()+"/Controller?action=add");
			return;
		}

	}
}

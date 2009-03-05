package lu.mind.projects.cms;

import java.sql.Blob;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Iterator;
import java.util.List;
import java.util.UUID;
import javax.servlet.http.HttpServletRequest;
import javax.swing.ImageIcon;
import lu.mind.projects.cms.dao.Content;
import lu.mind.projects.cms.dao.Language;

import org.apache.commons.fileupload.*;
import org.apache.commons.fileupload.disk.*;
import org.apache.commons.fileupload.servlet.*;
import org.apache.commons.io.FilenameUtils;

public class FileTools {
	
	public static byte[] getFile(String id, Integer version) {
		Blob photo = null;
		byte[] bytes = null;
		Connection conn = Application.getDbConnection();
		ResultSet rst = null;
		PreparedStatement pstmt = null;
		String sql = "select DATA from CONTENT where ID = ? and VERSION = ?";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			pstmt.setInt(2, version);
			rst = pstmt.executeQuery();
			if(rst.next()) {
				photo = rst.getBlob(1);
				bytes = photo.getBytes(1, (int) photo.length());
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		Application.closeDbConnection(conn);
		return bytes;
	}

	public static String saveFile(HttpServletRequest request) {
		List<FileItem> items = null;
		String newFileId = null;
		// Create a factory for disk-based file items
		FileItemFactory factory = new DiskFileItemFactory();
		//factory.setSizeThreshold(yourMaxMemorySize);
		//factory.setRepository(yourTempDirectory);

		ServletFileUpload upload = new ServletFileUpload(factory);
		upload.setFileSizeMax(1024*1024*10); // 10M

		try {
			items = upload.parseRequest(request);
		} catch (FileUploadException e) {
			e.printStackTrace();
		}
		
		// Process the uploaded items
		Iterator<FileItem> iter = items.iterator();
		while (iter.hasNext()) {
		    FileItem item = (FileItem) iter.next();
		    if (item.isFormField()) {
		        processFormField(item);
		    } else {
		    	newFileId = processUploadedFile(item);
		    }
		}
		return newFileId;
	}

	private static String processUploadedFile(FileItem item) {
		// http://www.digitalsanctuary.com/tech-blog/java/how-to-resize-uploaded-images-using-java.html
		// http://greatwebguy.com/programming/java/java-image-resizer-servlet/
		// http://weblogs.java.net/blog/robogeek/archive/2007/05/the_image_resiz.html
		Connection conn = Application.getDbConnection();
		PreparedStatement pstmt = null;

		String fileName = item.getName();
	    if (fileName != null) {
	    	fileName = FilenameUtils.getName(fileName);
	    }

	    byte[] data = item.get();

		ImageIcon ic = new ImageIcon(data);
		String width = Integer.toString(ic.getIconWidth());
		String height = Integer.toString(ic.getIconHeight());

		Content c = new Content();
		c.setId(UUID.randomUUID().toString());
		c.setVersion(1);
		c.setContentType("0bf17083-3ffb-4f3e-9c07-dbc0d3559525");
		c.setMimeType(item.getContentType());
		c.setDateCreated(new java.sql.Timestamp(System.currentTimeMillis()));
		c.setFilename(fileName);
		c.setContentLength(data.length);
		c.setWidth((width.equals("-1")) ? null : width);
		c.setHeight((height.equals("-1")) ? null : height);

		String stmt = "insert into CONTENT "+
		"(ID, VERSION, CONTENT_TYPE, MIME_TYPE, CONTENT_LENGTH, DATA, DATE_CREATED, DATE_MODIFIED, PUBLISHED, TITLE, URL, USER_CREATED, USER_MODIFIED, SQLDATASOURCE, STRING_ID, HEIGHT, WIDTH, CSS, FILENAME) "+ 
		"values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
		try {
			pstmt = conn.prepareStatement(stmt);
			pstmt.setString(1, c.getId());
			pstmt.setObject(2, c.getVersion());
			pstmt.setString(3, c.getContentType());
			pstmt.setString(4, c.getMimeType());
			pstmt.setObject(5, c.getContentLength());
			pstmt.setBytes(6, data);
			pstmt.setTimestamp(7, (java.sql.Timestamp) c.getDateCreated());
			pstmt.setTimestamp(8, (java.sql.Timestamp) c.getDateModified());
			pstmt.setObject(9, c.getPublished());
			pstmt.setString(10, c.getTitle());
			pstmt.setString(11, c.getUrl());
			pstmt.setString(12, c.getUserCreated());
			pstmt.setString(13, c.getUserModified());
			pstmt.setString(14, c.getSqldatasource());
			pstmt.setString(15, c.getStringId());
			pstmt.setString(16, c.getHeight());
			pstmt.setString(17, c.getWidth());
			pstmt.setString(18, c.getCss());
			pstmt.setString(19, c.getFilename());
			int result = pstmt.executeUpdate();
			System.out.println("Result from File-upload insert: "+result);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	    Application.closeDbConnection(conn);
	    return c.getId();
	}

	private static void processFormField(FileItem item) {
		String name = item.getFieldName();
	    String value = item.getString();
	    System.out.println("From Multipart: "+name+": "+value);
	}
}

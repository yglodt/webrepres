<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@page import="java.util.*"%>
<%@page import="java.sql.*"%>
<%@page import="javax.sql.*"%>
<%@page import="javax.naming.*"%>
<%@page import="lu.webreports.*"%>
<%@page import="java.sql.Timestamp"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sql" uri="http://java.sun.com/jstl/sql" %>
<%!

Cookie getCookieByName(HttpServletRequest request, String name) {
    //System.out.println("Checking for cookie named "+name);
    Cookie[] cookies = request.getCookies();
    Cookie returnValue = null;
    if (cookies != null) {
            for (int i =0; i< cookies.length; i++) {
                    Cookie c = cookies[i];
                    if (c.getName().equals(name)) {
                            returnValue = c;
                    }
            }
    }
    if (returnValue == null) {
            System.out.println("Cookie "+name+" not found in client.");
    }
    return returnValue;
}

%>
<%

Cookie cookie = null;
cookie = getCookieByName(request, "SID");

if (cookie == null) {
	cookie = new Cookie("SID", UUID.randomUUID().toString());
	//cookie.setDomain(Application.getConfigFileParameter("cookieDomain"));
	cookie.setPath("/");
	cookie.setMaxAge(0);
	response.addCookie(cookie);	
}

String titleEn = "";
String sql = "";
String uuid = "";

DataSource dataSource = null;
Connection conn = null;

Context ctx = null;
try {
	ctx = new InitialContext();
} catch (NamingException e) {
	e.printStackTrace();
	System.out.println("Application.connectToPool(): NamingException1: "+e.getMessage());
}
try {
	dataSource = (DataSource) ctx.lookup("java:comp/env/jdbc/ticketsDev");
} catch (NamingException e) {
	e.printStackTrace();
	System.out.println("Application.connectToPool(): NamingException2: "+e.getMessage());
}
if (dataSource != null) {
	//System.out.println("Application.connectToDb(): Got datasource from to pool.");
} else {
	System.out.println("Application.connectToDb(): Datasource we got from pool is null.");			
}

try {
	conn = dataSource.getConnection(); // TODO: here we crash when Firebird is unavailable
	//System.out.println("Application.getDbConnection(): Got a connection from the pool.");
} catch (Exception e) {
	e.printStackTrace();
	System.out.println("Application.getDbConnection(): Getting connection from pool failed. Trying to reconnect pool to database. Exception: "+e.getMessage());
}

ReportsFromSqlDAO dao = new ReportsFromSqlDAO(conn);

if (request.getMethod().equals("POST")) {
	if (request.getParameter("test") != null) {
		ReportsFromSql r = dao.get(request.getParameter("id"));	
		titleEn = request.getParameter("title_en");
		sql = request.getParameter("sql");
		uuid = r.getId();
	} else if (request.getParameter("update") != null) {
		ReportsFromSql r = dao.get(request.getParameter("id"));
		r.setTitleEn(request.getParameter("title_en"));
		r.setSql(request.getParameter("sql"));
		//r.setDateModified(new Timestamp(System.currentTimeMillis()));
		r.setDateModified(new java.sql.Date(System.currentTimeMillis()));
		dao.update(r);
		response.sendRedirect(request.getContextPath()+"/reports.jsp?id="+r.getId());
	} else if (request.getParameter("insert") !=  null) {
		uuid = UUID.randomUUID().toString();
		ReportsFromSql r = new ReportsFromSql();
		r.setDateCreated(new java.sql.Date(System.currentTimeMillis()));
		r.setId(uuid);
		if (request.getParameter("title_en").equals("")) {
			r.setTitleEn("Untitled");	
		} else {
			r.setTitleEn(request.getParameter("title_en"));			
		}
		r.setSql(request.getParameter("sql"));
		dao.insert(r);
		response.sendRedirect(request.getContextPath()+"/reports.jsp?id="+uuid);
	} else if (request.getParameter("delete") != null) {
		ReportsFromSql r = dao.get(request.getParameter("id"));
		dao.delete(r);
		response.sendRedirect(request.getContextPath()+"/reports.jsp");
	}
} else if (request.getMethod().equals("GET")) {
	if ((request.getParameter("id") != null) && !(request.getParameter("id").equals(""))) {
		
		


	    Properties prop = new Properties();
	    prop.setProperty("fontSize", "10");
	    prop.setProperty("fontUnit", "px");
	    
	    
		ReportsFromSql r = dao.get(request.getParameter("id"));	
		titleEn = r.getTitleEn();
		sql = r.getSql().trim();
		uuid = r.getId();
	}
}

conn.close();

pageContext.setAttribute("title_en", titleEn);
pageContext.setAttribute("sql", sql);
pageContext.setAttribute("uuid", uuid);

%>
<sql:setDataSource dataSource="jdbc/ticketsDev" />
<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'>
<html xmlns='http://www.w3.org/1999/xhtml'>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title>Report Editor</title>
	<link href='<c:url value="/style.css" />' rel='stylesheet' type='text/css' />
	<link rel='shortcut icon' href='<c:url value="/images/favicon.ico" />' />
	<script type='text/javascript'>
	function Confirm(what) { var Check = confirm(what); return Check; }
	</script>
</head>
<body>

<div style='float:right;'>
<a href='<c:url value="/reports.jsp" />'>Back to reports</a>
</div>

<form name='editReport' action='<c:url value="/reportEditor.jsp" />' method='post'>
<input type='hidden' name='id' value='${uuid}' />
<table>
<tr><th>Title (en)</th><td><input type='text' name='title_en' size='120' value='${title_en}' /></td></tr>
<tr><th>SQL</th><td><textarea name='sql' rows='15' cols='140'>${sql}</textarea></td></tr>
<tr><th></th><td>
<input type='submit' name='test' value='Test' />&nbsp;&nbsp;&nbsp;
<c:if test="${! empty uuid}">
<input type='submit' name='update' value='Update' />
<input type='submit' name='delete' value='Delete' onclick="return Confirm('Really delete?');" />&nbsp;&nbsp;&nbsp;
</c:if>
<input type='submit' name='insert' value='Insert as new' />
</td></tr>
</table>
</form>

<br />

<c:if test="${! empty param.test && ! empty param.sql}">
<c:catch var="catchException">
<sql:query var="rst">
${param.sql}
</sql:query>
</c:catch>

<c:if test = "${catchException == null}">
<table>
<thead><tr>
<c:forEach var="columnName" items="${rst.columnNames}">
<th><c:out value="${columnName}"/></th>
</c:forEach>
</tr>
</thead>

<tbody>

<c:forEach var="row" items="${rst.rowsByIndex}" varStatus="status">
<tr class="${status.index % 2 == 0 ? 'e' : 'o'}">
<c:forEach var="column" items="${row}">
<td><c:out escapeXml="true" value="${column}"/></td>
</c:forEach>
</tr>
</c:forEach>
</tbody>
</table>
</c:if>

<c:if test = "${catchException != null}">
<div id='exception'>
<p>An exception occurred:</p>
<pre>${catchException}</pre>
</div>
</c:if>

</c:if>
<%


%>
</body>
</html>

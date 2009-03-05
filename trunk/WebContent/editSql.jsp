<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@page import="java.util.*"%>
<%@page import="java.sql.*"%>
<%@page import="javax.sql.*"%>
<%@page import="javax.naming.*"%>
<%@page import="java.util.*"%>
<%@page import="java.sql.*"%>
<%@page import="lu.mind.projects.cms.Application"%>
<%@page import="lu.mind.projects.cms.dao.*"%>
<%@page import="java.sql.Timestamp"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sql" uri="http://java.sun.com/jstl/sql" %>
<%@page import="lu.mind.projects.cms.dao.ContentDAOFirebird"%>

<jsp:include page="htmlHeader.jsp">
<jsp:param name="title" value="Edit ${c.title}" />
</jsp:include>

<h1>Edit ${c.title}</h1>

<form name='editReport' action='<c:url value="/Controller" />' method='post'>
<input type='hidden' name='action' value='edit' />
<input type='hidden' name='id' value='${c.id}' />
<table>
<tr><th>Title</th><td><input type='text' name='title' size='120' value='${c.title}' /></td></tr>
<tr><th>Datasource</th><td>
<select name='sqldatasource'>
<option value=''>[...]</option>
<c:forEach var="d" items="${d}" varStatus="status">
<option value='${d.id}'${d.id == c.sqldatasource ? ' selected="selected"' : ''}>${d.title}</option>
</c:forEach>
</select>
</td></tr>
<tr><th>SQL</th><td><textarea name='data' rows='15' cols='140'>${c.data}</textarea></td></tr>
<tr>
<th>Menu</th>
<td>
<%

Connection conn = Application.getDbConnection();

MenuDAOFirebird mDao = new MenuDAOFirebird(conn);
Menu[] menus = mDao.getAll("order by title");
pageContext.setAttribute("menus", menus);

if (request.getParameter("id") != null) {
	MenuitemDAOFirebird miDao = new MenuitemDAOFirebird(conn);
	Menuitem[] menuitem = miDao.getAll("where ITEM_ID = '"+request.getParameter("id")+"'");
	pageContext.setAttribute("menuitem", menuitem[0]);
}

Application.closeDbConnection(conn);

%>
<select name='menuId'>
<option value=''>[...]</option>
<c:forEach var="v" items="${menus}" varStatus="status">
<option value='${v.id}'${v.id == menuitem.menuId ? ' selected="selected"' : ''}>${v.title}</option>
</c:forEach>
</select>
</td>
</tr>
<tr><th></th><td>
<input type="submit" name='preview' value='Preview' />
<c:if test="${not empty c.id}">
<input type="submit" name='update' value='Update' />
<input type="submit" name='delete' value='Delete' onclick="return Confirm('Really delete?');" />
</c:if>
<input type="submit" name='insert' value='Insert as new' />
<input type="submit" name='cancel' value='Cancel' onclick="Goto('${c.id}'); return false;"/>
</td></tr>
</table>
</form>

<c:if test="${! empty param.test && ! empty c.sql}">

<sql:setDataSource dataSource="jdbc/tickets" />

<jsp:include page="renderSql.jsp" />

<c:catch var="catchException">
<sql:query var="rst">
${c.data}
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

<jsp:include page="footer.jsp" />

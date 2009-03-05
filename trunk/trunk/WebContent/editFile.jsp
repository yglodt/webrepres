<%@ page session="true" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="java.sql.*"%>
<%@page import="lu.mind.projects.cms.Application"%>
<%@page import="lu.mind.projects.cms.dao.*"%>
<%@page import="lu.mind.projects.cms.helperclasses.*"%>
<%@page import="lu.mind.projects.cms.factories.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sql" uri="http://java.sun.com/jstl/sql" %>

<jsp:include page="htmlHeader.jsp">
<jsp:param name="title" value="${c.title}" />
</jsp:include>

<div id='content'>
<h1>Upload a file</h1>

<form name='editReport' action='<c:url value="/Controller" />' method='post' enctype="multipart/form-data">
<input type='hidden' name='action' value='${param.action}' />
<input type='hidden' name='id' value='${c.id}' />
<input type='hidden' name='ctid' value='${param.ctid}' />
<table>

<tr>
<th>File to Upload</th>
<td><input type='file' name='file' /></td>
</tr>

<tr>
<th>Title</th>
<td><input type="text" name='title' size='120' value='${not empty previewContent.title ? previewContent.title : c.title}' /></td>
</tr>

<tr>
<th>Add to Menu</th>
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


<tr><th></th>
<td>
<input type="submit" name='preview' value='Preview' />
<c:if test="${not empty c.id}">
<input type="submit" name='update' value='Update' />
<input type="submit" name='delete' value='Delete' onclick="return Confirm('Really delete?');" />
</c:if>
<input type="submit" name='insert' value='Insert as new' />
<input type="submit" name='cancel' value='Cancel' onclick="Goto('${c.id}'); return false;"/>
</td>
</tr>

</table>

</form>
</div>

<jsp:include page="footer.jsp" />

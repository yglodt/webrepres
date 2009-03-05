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

<h1>Edit ${c.title}</h1>

<form name='editReport' action='<c:url value="/Controller" />' method='post'>
<input type='hidden' name='action' value='edit' />
<input type='hidden' name='id' value='${c.id}' />
<table>

<tr>
<th>Title</th>
<td><input type="text" name='title' size='120' value='${c.title}' /></td>
</tr>

<tr>
<th>Content</th>
<td><textarea name='data' rows="15" cols="140">${c.data}</textarea></td>
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

<jsp:include page="footer.jsp" />

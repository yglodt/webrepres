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
<jsp:param name="title" value="Add new Content" />
</jsp:include>

<jsp:include page="menu.jsp">
	<jsp:param name="divId" value="topMenu"  />
	<jsp:param name="menuId" value="27cbe650-4f6c-4210-840d-ade70a5c4ec8"  />
</jsp:include>

<jsp:include page="systemMenu.jsp">
	<jsp:param value="${c}" name="content" />
	<jsp:param value="${ct}" name="contentType" />
</jsp:include>
<%

ContentType[] contentTypes = ContentItemFactory.getContentTypes();
pageContext.setAttribute("contentTypes", contentTypes);

%>
<div id='content'>
<h1>Add new Content</h1>
<form name='selectContent' method='get' action='<c:url value="/Controller" />'>
<input type='hidden' name='action' value='add' />
<select name='ctid'>
<option value=''>[...]</option>
<c:forEach var="c" items="${contentTypes}" varStatus="status">
<option value='${c.id}'${c.id == param.ctid ? ' selected="selected"' : ''}>${c.title}</option>
</c:forEach>
</select>
<input type='submit' name='submit' value='Continue...' />
</form>
</div>

<jsp:include page="menu.jsp">
	<jsp:param name="divId" value="bottomMenu"  />
	<jsp:param name="menuId" value="4a2d1f49-ebe9-4841-8482-0b7291aa95c7"  />
	<jsp:param name="itemSeparator" value=" | " />
</jsp:include>

<jsp:include page="footer.jsp" />

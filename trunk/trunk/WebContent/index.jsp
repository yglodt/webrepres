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
	<jsp:param name="title" value="${empty c.title ? c.filename : c.title}" />
</jsp:include>

<jsp:include page="menu.jsp">
	<jsp:param name="divId" value="topMenu"  />
	<jsp:param name="menuId" value="27cbe650-4f6c-4210-840d-ade70a5c4ec8"  />
</jsp:include>

<jsp:include page="menu.jsp">
	<jsp:param name="divId" value="leftMenu"  />
	<jsp:param name="menuId" value="99b6ffbb-2797-45fa-9e0b-1102bceab02f"  />
</jsp:include>

<jsp:include page="menu.jsp">
	<jsp:param name="divId" value="rightMenu"  />
	<jsp:param name="menuId" value="65cefa17-ac7f-458e-a88d-5adf94078371"  />
</jsp:include>

<jsp:include page="systemMenu.jsp" />

<c:if test="${not empty c.id}">
<div id='content'>

<jsp:include page="${ct.renderer}">
	<jsp:param name="" value="${c}" />
</jsp:include>

<!-- Rendered by ${ct.renderer} -->
</div>
</c:if>

<jsp:include page="menu.jsp">
	<jsp:param name="divId" value="bottomMenu"  />
	<jsp:param name="menuId" value="4a2d1f49-ebe9-4841-8482-0b7291aa95c7"  />
	<jsp:param name="itemSeparator" value=" | " />
</jsp:include>
<jsp:include page="footer.jsp" />

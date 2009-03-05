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

<jsp:include page="menuTop.jsp" />
<%

ArrayList<MenuItemDetail> menus = MenuFactory.getMenus();
pageContext.setAttribute("menus", menus);

%>
<div id='editMenus'>
<c:if test="${not empty menus}">
<form name='editMenus' action='<c:url value="/Controller" />' method='post'>
<select name='menuItems' multiple="multiple" size="20">
<c:forEach var="bm" items="${menus}" varStatus="status">
<option value=${bm.itemId}">${bm.menuTitle}: ${bm.title}</option>
<c:if test="${!status.last}"> selected='selected'</c:if>
</c:forEach>
</select>
</c:if>
</div>

<jsp:include page="menuBottom.jsp" />
<jsp:include page="footer.jsp" />

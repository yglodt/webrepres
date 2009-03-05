<%@ page session="true" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="java.sql.*"%>
<%@page import="lu.mind.projects.cms.helperclasses.*"%>
<%@page import="lu.mind.projects.cms.factories.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%

ArrayList<MenuItemDetail> menuItemsDetail = MenuItemFactory.getMenuItems(request.getParameter("menuId"));
pageContext.setAttribute("menuItemsDetail", menuItemsDetail);

%>
<div id='${param.divId}'>
<c:if test="${not empty menuItemsDetail}">
<ul class="navlist">
<c:forEach var="m" items="${menuItemsDetail}" varStatus="status">
<li${status.last ? ' class="last"' : ''}${status.first ? ' class="first"' : ''}><a href='<c:url value="/Controller?action=view&id=${m.itemId}" />'<c:if test="${(param.id == m.itemId) || (empty m.itemId && status.index == 0)}"> class='current'<c:set var='selectedReport' scope='page' value='${m}' /></c:if>>${m.title}</a><c:if test="${!status.last and ! empty param.itemSeparator}">${param.itemSeparator}</c:if></li>
</c:forEach>
</ul>
</c:if>
</div>

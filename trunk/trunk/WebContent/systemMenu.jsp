<%@ page session="true" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div id='systemmenu'>
<ul>
<li id='title'>System Menu</li>
<c:if test="${!empty param.id}">
<li><a href='<c:url value="/Controller?action=edit&id=${param.id}" />'>Edit this ${ct.title}</a></li>
</c:if>
<li><a href='<c:url value="/Controller?action=add" />'>Edit Navigation</a></li>
<li><a href='<c:url value="/Controller?action=add" />'>Add new Content</a></li>
<li><a href='<c:url value="/Controller?action=settings" />'>Settings</a></li>
<li><a href='<c:url value="/Controller?action=settings" />'>Help</a></li>
</ul>
</div>

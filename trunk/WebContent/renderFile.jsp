<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div id='fileContent'>
<c:choose>

<c:when test="${fn:startsWith(c.mimeType, 'image')}">
<h1>${empty c.title ? c.filename : c.title}</h1>
<a href='<c:url value="/Controller?action=viewFile&id=" />${c.id}'>
<img title='${c.title}' src='<c:url value="/Controller?action=viewFile&id=" />${c.id}' title='${c.filename}' width='${c.width}' height='${c.height}' />
</a>
<br /><a href='<c:url value="/Controller?action=viewFile&id=" />${c.id}' title='${c.title}'>${c.filename}</a>
</c:when>

<c:when test="${c.mimeType == 'application/x-shockwave-flash'}">
<h1>${empty c.title ? c.filename : c.title}</h1>
<object codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,29,0" 
width="350" 
height="60">
<param name="movie" value="http://hotelzurich.lu./bed.swf">
<param name="quality" value="high">
<embed src="<c:url value="/Controller?action=viewFile&id=" />${c.id}"
quality="high" 
pluginspage="http://www.macromedia.com/go/getflashplayer" 
type="application/x-shockwave-flash"
width="350"
height="60"></embed>
</object>
</c:when>

<c:otherwise>

<h1>${empty c.title ? c.filename : c.title}</h1>

<a href='<c:url value="/Controller?action=viewFile&id=" />${c.id}' title='${c.title}'>${c.filename}</a>
</c:otherwise>

</c:choose>
</div>

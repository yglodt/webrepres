<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:if test="${not empty c.data}">
<pre>
<c:out value="${c.data}" escapeXml="false"/>
</pre>
</c:if>

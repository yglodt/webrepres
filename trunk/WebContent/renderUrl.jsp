<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:if test="${ not empty c.url}">
<div id='urlContent'>
<iframe
src='${c.url}'
height='${c.height}'
width='${c.width}'
class='embedded'
<c:if test="${not empty c.css}">style="${c.css}"</c:if>>
</iframe>
</div>
</c:if>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@page import="java.util.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sql" uri="http://java.sun.com/jstl/sql" %>
<%--

create table REPORTS_FROM_SQL (
	ID varchar(40) not null primary key,
	PRETTY_NAME VARCHAR(50),
	TITLE_EN VARCHAR(100),
	SQL blob sub_type text,
	date_created timestamp,
	date_modified timestamp
)

--%>
<sql:setDataSource dataSource="jdbc/ticketsDev" />
<c:catch var="catchException"><sql:query var="reportList">
select id,title_en,sql from reports_from_sql order by title_en
</sql:query></c:catch>
<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'>
<html xmlns='http://www.w3.org/1999/xhtml'>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title>Reports from SQL</title>
	<link href='<c:url value="/style.css" />' rel='stylesheet' type='text/css' />
	<link rel='shortcut icon' href='<c:url value="/images/favicon.ico" />' />
	<meta http-equiv='refresh' content='600' />
</head>
<body>

<div id='menu'>
<c:if test="${!empty param.id}">
<a href='<c:url value="/reportEditor.jsp?id=${param.id}" />'>Edit this report</a><br />
</c:if>
<a href='<c:url value="/reportEditor.jsp?action=add" />'>Add new report</a><br />
<a href='<c:url value="/settings.jsp" />'>Settings</a>
</div>

<c:if test="${param.hidemenu == '0'}">
<c:forEach var="c" items="${reportList.rows}" varStatus="status">
<a href='<c:url value="/reports.jsp?id=${c.ID}" />'<c:if test="${(param.id == c.ID) || (empty c.ID && status.index == 0)}"> style='font-weight:bold;'<c:set var='selectedReport' scope='page' value='${c}' /></c:if>>${c.TITLE_EN}</a>
<c:if test="${!status.last}"> | </c:if>
</c:forEach>
<br /><br />
</c:if>

<c:if test="${! empty selectedReport.SQL}">

<c:catch var="catchException">
<sql:query var="rst">
${selectedReport.SQL}
</sql:query>
</c:catch>

<table>
<thead><tr>
<c:forEach var="columnName" items="${rst.columnNames}"><th><c:out value="${columnName}"/></th></c:forEach>
</tr>
</thead>
<tbody>
<c:forEach var="row" items="${rst.rowsByIndex}" varStatus="status">
<tr class="${status.index % 2 == 0 ? 'e' : 'o'}"><c:forEach var="column" items="${row}"><td><c:out escapeXml="true" value="${column}"/></td></c:forEach></tr>
</c:forEach>
</tbody>
</table>

<c:if test = "${catchException != null}">
<div id='exception'>
<p>An exception occurred:</p>
<pre>${catchException}</pre>
</div>
</c:if>

</c:if>

</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@ page import="java.util.*"%>
<%@ page import="lu.mind.projects.cms.dao.*"%>
<%@ page import="lu.mind.projects.cms.factories.MenuFactory"%>
<%@ page import="lu.mind.projects.cms.factories.SQLReportFactory"%>
<%@ page import="lu.mind.projects.cms.factories.SqlreportdatasourceFactory"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sql" uri="http://java.sun.com/jstl/sql" %>

<c:if test="${! empty c.data}">
<%--
<sql:setDataSource
  driver="org.firebirdsql.jdbc.FBDriver"
  url="jdbc:firebirdsql:localhost:intervention_tickets?encoding=ISO8859_1&amp;sql_role_name=ROLE_WEBREPORTS"
  user="webreports"
  password="webrepor"
/>
--%>

<sql:setDataSource dataSource="jdbc/tickets" />

<div id='report'>
<h1>${c.title}</h1>
<c:catch var="catchException">
<sql:query var="rst">${c.data}</sql:query>
</c:catch>

<table>
<thead><tr>
<c:forEach var="columnName" items="${rst.columnNames}"><th><c:out value="${columnName}"/></th></c:forEach>
</tr>
</thead>
<tbody>
<c:forEach var="row" items="${rst.rowsByIndex}" varStatus="status">
<tr class="${status.index % 2 == 0 ? 'e' : 'o'}">
<c:forEach var="column" items="${row}"><td><c:out escapeXml="true" value="${column}"/></td></c:forEach>
</tr>
</c:forEach>
</tbody>
</table>

<c:if test = "${catchException != null}">
<div id='exception'>
<p>An exception occurred:</p>
<pre>${catchException}</pre>
</div>
</c:if>

</div>

</c:if>

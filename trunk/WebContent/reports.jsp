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
<%

Sqlreport[] reports = SQLReportFactory.getAllReports();
pageContext.setAttribute("reports", reports);

Sqlreport selectedSqlreport = SQLReportFactory.getReportById(request.getParameter("id"));
System.out.println(selectedSqlreport.getTitle());
pageContext.setAttribute("selectedSqlreport", selectedSqlreport);

%>
<jsp:include page="htmlHeader.jsp">
	<jsp:param name="title" value="${selectedSqlreport.title}" />
	<jsp:param name="refresh" value="600" />
</jsp:include>

<div id='menu'>
<c:if test="${not empty param.id}">
<a href='<c:url value="/reportEditor.jsp?id=${param.id}" />'>Edit this report</a><br />
</c:if>
<a href='<c:url value="/reportEditor.jsp?action=add" />'>Add new report</a><br />
<a href='<c:url value="/settings.jsp" />'>Settings</a>
</div>

<div id='reportList'>
<c:forEach var="v" items="${reports}" varStatus="status">
<a href='<c:url value="/reports.jsp?id=${v.id}" />'<c:if test="${(param.id == v.id) || (empty v.id && status.index == 0)}">
style='font-weight:bold;'<c:set var='selectedReport' scope='page' value='${v}' /></c:if>
>${v.title}</a>
<c:if test="${!status.last}"> | </c:if>
</c:forEach> 
</div>


<c:if test="${! empty selectedReport.sql}">
<%

Sqlreport selectedReport = (Sqlreport) pageContext.getAttribute("selectedReport");
Sqlreportdatasource reportdatasource = SqlreportdatasourceFactory.getDataSourceById(selectedReport.getId());
pageContext.setAttribute("reportdatasource", reportdatasource);

//<sql:setDataSource dataSource="${reportdatasource.name}" />

%>
<sql:setDataSource
  driver="org.firebirdsql.jdbc.FBDriver"
  url="jdbc:firebirdsql:localhost:intervention_tickets?encoding=ISO8859_1&amp;sql_role_name=ROLE_WEBREPORTS"
  user="webreports"
  password="webrepor"
/>

<div id='report'>
<c:catch var="catchException">
<sql:query var="rst">${selectedReport.sql}</sql:query>
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

</div>

</c:if>

<jsp:include page="footer.jsp" />

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@page import="java.util.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sql" uri="http://java.sun.com/jstl/sql" %>
<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'>
<html xmlns='http://www.w3.org/1999/xhtml'>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<c:if test="${not empty param.title}"><title>${param.title}</title></c:if>
<link href='<c:url value="/css/style.css" />' rel='stylesheet' type='text/css' />
<link href='<c:url value="/css/content.css" />' rel='stylesheet' type='text/css' />
<script type="text/javascript" src='<c:url value="/javascript.js" />'></script>
<link rel='shortcut icon' href='<c:url value="/images/favicon.ico" />' />
<c:if test="${not empty param.refresh}"><meta http-equiv='refresh' content='${param.refresh}' />
</c:if>
</head>
<body id='body'>
<c:if test="${not empty param.heading}"><h1 class='heading'>${param.heading}</h1></c:if>

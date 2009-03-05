<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib uri="http://java.fckeditor.net" prefix="FCK" %>

    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>


<FCK:editor instanceName="EditorDefault" height="400" width="600">
<jsp:attribute name="value">
This is some <strong>sample text</strong>.
You are using <a href="http://www.fckeditor.net">FCKeditor</a>.
</jsp:attribute>
</FCK:editor>
  
  
<form method="post">
<FCK:editor instanceName="test2" basePath="/FCKeditor/" height="300">
</FCK:editor>

<input type="button" value="Set Value" onclick="setEditorValue('content', 'Hello World!')" />
<input type="button" value="Get Value" onclick="alert(getEditorValue('content'))" />
<input type="submit" value="Submit" name="submit" />
</form>


</body>
</html>

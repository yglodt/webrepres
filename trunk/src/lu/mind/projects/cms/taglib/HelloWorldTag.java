package lu.mind.projects.cms.taglib;
import java.io.IOException;

import javax.servlet.jsp.tagext.TagSupport;

public class HelloWorldTag extends TagSupport {
	private static final long serialVersionUID = 7397077170799606987L;

	private String name = "";
	private int test;

	public HelloWorldTag() {
		super();
	}

	public void setName(String name) {
		this.name=name;
	}


	public int doEndTag() throws javax.servlet.jsp.JspTagException {
		try {
			pageContext.getOut().write("Hello "+name+"!");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return EVAL_PAGE;
	}
}

package lu.mind.projects.cms.taglib;

import java.io.IOException;

import javax.servlet.jsp.tagext.TagSupport;

public class RenderMenu extends TagSupport {

	private static final long serialVersionUID = 1L;
	private String oldvalue = "";
	private String newvalue = "";
	private String label = "";

	public RenderMenu() {
		super();
	}

	public String getOldvalue() {
		return oldvalue;
	}

	public void setOldvalue(String oldvalue) {
		this.oldvalue = oldvalue;
	}

	public String getNewvalue() {
		return newvalue;
	}

	public void setNewvalue(String newvalue) {
		this.newvalue = newvalue;
	}

	public String getLabel() {
		return label;
	}

	public void setLabel(String label) {
		this.label = label;
	}

	public int doEndTag() throws javax.servlet.jsp.JspTagException {
		try {
			if (oldvalue.equals("") && !newvalue.equals("")) {
				pageContext.getOut().write("<li><span class='label'>"+label+"</span> set to <span class='value'>"+newvalue+"</span></li>\n");
			}

			if (!newvalue.equals(oldvalue) && !oldvalue.equals("") && !newvalue.equals("")) {
				pageContext.getOut().write("<li><span class='label'>"+label+"</span> changed from <span class='value'>"+oldvalue+"</span> to <span class='value'>"+newvalue+"</span></li>\n");
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
		return EVAL_PAGE;
	}
}

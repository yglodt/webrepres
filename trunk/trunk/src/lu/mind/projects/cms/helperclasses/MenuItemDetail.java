package lu.mind.projects.cms.helperclasses;

import lu.mind.projects.cms.dao.Menuitem;

public class MenuItemDetail extends Menuitem {
	private String title;
	private int published;
	private String menuTitle;

	public int getPublished() {
		return published;
	}

	public void setPublished(int published) {
		this.published = published;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getMenuTitle() {
		return menuTitle;
	}

	public void setMenuTitle(String menuTitle) {
		this.menuTitle = menuTitle;
	}
}

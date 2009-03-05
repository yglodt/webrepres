package lu.mind.projects.cms.factories;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import lu.mind.projects.cms.Application;
import lu.mind.projects.cms.dao.Menu;
import lu.mind.projects.cms.dao.MenuDAOFirebird;
import lu.mind.projects.cms.helperclasses.MenuItemDetail;

public class MenuFactory {

	public static ArrayList<MenuItemDetail> getMenus() {
		PreparedStatement pstmt = null;
		ResultSet rst = null;
		Connection conn = Application.getDbConnection();
		ArrayList<MenuItemDetail> menuItemsDetail = new ArrayList<MenuItemDetail>();
		String sql = "select mi.id," +
		"mi.pos," +
		"mi.item_id," +
		"mi.menu_id," +
		"c.title as CONTENT_TITLE," +
		"c.published," +
		"m.title as MENU_TITLE," +
		"m.id as MENU_ID " +
		"from menuitem mi " +
		"left join content c on mi.item_id = c.id " +
		"left join menu m on m.id = mi.menu_id " +
		"order by m.title, mi.pos";
		try {
			pstmt = conn.prepareStatement(sql);
			//pstmt.setString(1, id);
			rst = pstmt.executeQuery();
			while (rst.next()) {
				MenuItemDetail temp = new MenuItemDetail();
				temp.setTitle(rst.getString("CONTENT_TITLE"));
				temp.setId(rst.getString("ID"));
				temp.setItemId(rst.getString("ITEM_ID"));
				temp.setPublished(rst.getInt("PUBLISHED"));
				temp.setMenuTitle(rst.getString("MENU_TITLE"));
				temp.setMenuId(rst.getString("MENU_ID"));
				//temp.setItemType(itemType)
				menuItemsDetail.add(temp);
			}
		} catch (Exception e) {
			System.out.println("Exception in PolicyDetail.getPolicies(): "+e.getMessage());
		}
		Application.closeDbConnection(conn);
		return menuItemsDetail;
	}
	
	public static Menu getMenu(String id) {
		Connection conn = Application.getDbConnection();
		MenuDAOFirebird mDao = new MenuDAOFirebird(conn);
		Menu menu = mDao.get(id);
		Application.closeDbConnection(conn);
		return menu;
	}

	public static ArrayList<Menu> getMenus(String id) {
		ArrayList<Menu> menus = new ArrayList<Menu>();
		Connection conn = Application.getDbConnection();
		MenuDAOFirebird mDao = new MenuDAOFirebird(conn);
		//menus = mDao.getAll();
		Application.closeDbConnection(conn);
		return menus;
	}
}

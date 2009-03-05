package lu.mind.projects.cms.factories;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import lu.mind.projects.cms.Application;
import lu.mind.projects.cms.helperclasses.MenuItemDetail;

public class MenuItemFactory {

	public static ArrayList<MenuItemDetail> getMenuItems(String id) {
		PreparedStatement pstmt = null;
		ResultSet rst = null;
		Connection conn = Application.getDbConnection();
		ArrayList<MenuItemDetail> menuItemsDetail = new ArrayList<MenuItemDetail>();
		String sql = "select mi.id,mi.pos,mi.item_id,mi.menu_id, c.title,c.published " +
		"from MENUITEM mi " +
		"left join CONTENT c on mi.item_id = c.id " +
		//"left join MENU m on m.id = mi.menu_id "+
		"where mi.MENU_ID = ? order by mi.pos";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			rst = pstmt.executeQuery();
			while (rst.next()) {
				MenuItemDetail temp = new MenuItemDetail();
				temp.setTitle(rst.getString("TITLE"));
				temp.setId(rst.getString("ID"));
				temp.setItemId(rst.getString("ITEM_ID"));
				temp.setPublished(rst.getInt("PUBLISHED"));
				temp.setMenuId(rst.getString("MENU_ID"));
				//temp.setItemType(itemType)
				menuItemsDetail.add(temp);
			}
		} catch (Exception e) {
			System.out.println("Exception in MenuItemFactory.getMenuItems(): "+e.getMessage());
		}
		Application.closeDbConnection(conn);
		return menuItemsDetail;
	}

	public static ArrayList<MenuItemDetail> getAllMenus() {
		PreparedStatement pstmt = null;
		ResultSet rst = null;
		Connection conn = Application.getDbConnection();
		ArrayList<MenuItemDetail> menuItemsDetail = new ArrayList<MenuItemDetail>();
		String sql = "select mi.id,mi.pos,mi.item_id,mi.menu_id, c.title,c.published " +
		"from MENUITEM mi " +
		"left join CONTENT c on mi.item_id = c.id " +
		//"left join MENU m on m.id = mi.menu_id "+
		"order by mi.pos";
		try {
			pstmt = conn.prepareStatement(sql);
			//pstmt.setString(1, id);
			rst = pstmt.executeQuery();
			while (rst.next()) {
				MenuItemDetail temp = new MenuItemDetail();
				temp.setTitle(rst.getString("TITLE"));
				temp.setId(rst.getString("ID"));
				temp.setItemId(rst.getString("ITEM_ID"));
				temp.setPublished(rst.getInt("PUBLISHED"));
				temp.setMenuId(rst.getString("MENU_ID"));
				//temp.setItemType(itemType)
				menuItemsDetail.add(temp);
			}
		} catch (Exception e) {
			System.out.println("Exception in MenuItemFactory.getMenuItems(): "+e.getMessage());
		}
		Application.closeDbConnection(conn);
		return menuItemsDetail;
	}
}

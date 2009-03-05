package lu.mind.projects.cms.helperclasses;

import lu.mind.projects.cms.dao.Content;

public class FileContent extends Content {
	private byte[] fileData;

	public byte[] getFileData() {
		return fileData;
	}

	public void setFileData(byte[] fileData) {
		this.fileData = fileData;
	}
}

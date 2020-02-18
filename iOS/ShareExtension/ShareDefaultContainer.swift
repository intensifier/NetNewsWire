//
//  ShareDefaultContainer.swift
//  NetNewsWire-iOS
//
//  Created by Maurice Parker on 2/11/20.
//  Copyright © 2020 Ranchero Software. All rights reserved.
//

import Foundation

struct ShareDefaultContainer {
	
	static func defaultContainer(containers: ExtensionContainers) -> ExtensionContainer? {
		
		if let accountID = AppDefaults.addWebFeedAccountID, let account = containers.accounts.first(where: { $0.accountID == accountID }) {
			if let folderName = AppDefaults.addWebFeedFolderName, let folder = account.folders.first(where: { $0.name == folderName }) {
				return folder
			} else {
				return substituteContainerIfNeeded(account: account)
			}
		} else if let account = containers.accounts.first {
			return substituteContainerIfNeeded(account: account)
		} else {
			return nil
		}
		
	}
	
	static func saveDefaultContainer(_ container: ExtensionContainer) {
		AppDefaults.addWebFeedAccountID = container.accountID
		if let folder = container as? ExtensionFolder {
			AppDefaults.addWebFeedFolderName = folder.name
		} else {
			AppDefaults.addWebFeedFolderName = nil
		}
	}
	
	private static func substituteContainerIfNeeded(account: ExtensionAccount) -> ExtensionContainer? {
		if !account.disallowFeedInRootFolder {
			return account
		} else {
			if let folder = account.folders.first {
				return folder
			} else {
				return nil
			}
		}
	}
}
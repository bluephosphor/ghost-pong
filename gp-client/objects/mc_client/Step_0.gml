if (gamestate == ACTIONABLE and keyboard_check_pressed(191)){
	shell.open();
	shell.consoleString += "/";
	shell.cursorPos++;
}
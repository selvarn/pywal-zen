// copy into user.js in your zen profile (about:profiles -> root directory)

// load userChrome.css
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

// zen ignores firefox themes by default, this turns them back on
user_pref("zen.theme.disable-lightweight", false);

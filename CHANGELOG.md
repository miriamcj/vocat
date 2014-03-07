## Vocat v3.0.0-beta1.7 (March 7, 2014)

* [FEATURE] Fixes #16: Improve handling of 403, 404, and 500 errors
* [FEATURE] Fixes #59: Add project ordering to course manage projects view
* [FEATURE] Fixes #51: Creators should have access to the rubric before assessment occurs
* [FEATURE] Fixes #38: Adjust sample env configuration and login form wording to accommodate ldap login via email or username
* [CHORE] Built production assets
* [CHORE] Changed language on admin course list to make view as role more clear
* [BUGFIX] Corrects typo in generated rubric description
* [BUGFIX] Fixes #62: Non LDAP users should be able to change their password
* [BUGFIX] Fixes #66: Inaccurate Percentage Data Display
* [BUGFIX] Fixes #65: :tracking: section is absent from config/environment.yml.sample
* [BUGFIX] Fixes #58: Fixed height of matrix--row-header--item in compact matrix
* [BUGFIX] Videos without processors were breaking the course map JSON request

## Vocat v3.0.0-beta1.6 (February 20, 2014)

* [FEATURE] Delivers #44: add ability to configure Google Analytics tracking code for VOCAT
* [BUGFIX] Fixes #50 No paragraph breaks in project description
* [BUGFIX] Fixes #57: Need to crop long course titles in header nav
* [CHORE] Removes unneeded factory and spec files
* [BUGFIX] Fixes #47: Vimeo thumbnails not generated correctly
* [CHORE] Updates production assets
* [FEATURE] Significant rewrite and refactoring of upload and transcoding mechanisms
* [BUGFIX] Fixes #54: Corrects icon color in annotations header
* [BUGFIX] Fixes #53: When the overlay is opened in the course map, the viewport should scroll to the header
* [BUGFIX] Fixes #41: Unable to check course settings checkboxes in Firefox

## Vocat v3.0.0-beta1.5 (February 18, 2014)

* [BUGFIX] Increases DB pool size in production **(zdavis)**
* [BUGFIX] Fixes #42: Temporarily disable shortcut nav until help content has been written. **(zdavis)**
* [BUGFIX] Fixes #36: Dropdown menu items in admin/users/edit view should be capitalized **(zdavis)**
* [DELIVERS BUGFIX #27] Fixes dimensions of SVG images in IE9-10 **(smills)**
* [CHORE] Moving changelog to correct location **(zdavis)**
* [CHORE] Changelog formatting adjustment **(zdavis)**

## Vocat v3.0.0-beta1.4 (February 12, 2014)

* [CHORE] Adds changelog to VOCAT **(zdavis)**
* [CHORE] Updates production assets **(zdavis)**
* [BUGFIX] Fixes #35: Cannot create single integer top range in rubric generator **(zdavis)**
* [BUGFIX] Fixes height of rubric editor headers **(zdavis)**
* [BUGFIX] Fixes #21: Chosen not properly intitialized in rubric edit view **(zdavis)**
* [BUGFIX] Fixes #36: Dropdown menu items in admin/users/edit view should be capitalized **(zdavis)**
* [CHORE] UI text edits: small text edits in course and projects views **(mgershovich)**
* [CHORE] Edited user deletion dialog text **(mgershovich)**
* [CHORE] Small UX changes: Edited rubric deletion prompt for style, etc **(mgershovich)**
* [CHORE] Small UX changes: edited prompt **(mgershovich)**
* [BUGFIX] Fixes #28: vertical alignment of coursemap creator names in IE9-10 **(zdavis)**
* [BUGFIX] Fixes #31: Removes scrollbars from rubric generator in IE9 **(zdavis)**
* [BUGFIX] Fixes #33 It should be possible to disable LDAP authentication **(zdavis)**

## Vocat v3.0.0-beta1.3 (February 10, 2014)

* [BUGFIX] Fixes #20: IE problem at log-in screen; also updates handlbars require.js library for IE9 compatibility and begins adjusting vocat.js so that it works better with browsers that do not support HTML5 push state **(zdavis)**
* [BUGFIX] Fixes #21: by moving chosen initialization to onShow event callback instead of onRender event callback **(zdavis)**
* [BUGFIX] Fixes #22: Evaluator changes to Manage Course -> Settings generates error **(zdavis)**
* [BUGFIX] Fixes #17: Non-admin users shouldn't be allowed to access the admin interface. **(zdavis)**

## Vocat v3.0.0-beta1.2 (February 7, 2014)

* [BUGFIX] Fixes #19 LDAP_authenticator should ignore case when seeing if user already exists locally. **(zdavis)**

## Vocat v3.0.0-beta1.1.1 (February 7, 2014)

[CHORE] Builds production javascript **(zdavis)**
[BUGFIX] Updates marionette version in build.js and adds chosen vendored files **(zdavis)**

## Vocat v3.0.0-beta1 (February 7, 2014)

Refer to the commit history on Github to view changes prior to v3.0.0-beta1

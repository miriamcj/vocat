## Vocat v3.0.0-beta1.9.0 (April 8, 2014)

* [BUGFIX]  Fixes #86: Some flash messages no longer display correctly **(zdavis)**
* [FEATURE] Closes #90: Instructors should be able to define a project as available to groups, students, or groups and students **(zdavis)**
* [CHORE]   Fixes #91: Remove old, scaffolded unit tests **(zdavis)**
* [FEATURE] Fixes #88: Major refactoring of submission factory to allow users to see individual and group submissions **(zdavis)**
* [CHORE]   Remove placeholder specs **(zdavis)**
* [FEATURE] When there are no projects in a course, show a "new project" button in the course map **(zdavis)**
* [FEATURE] Adds a due date field to projects; currently this field is only visible to instructors. **(zdavis)**

## Vocat v3.0.0-beta1.8.3 (March 28, 2014)

* [CHORE] Updates production assets **(zdavis)**

## Vocat v3.0.0-beta1.8.2 (March 28, 2014)

* [BUGFIX] Fixes #85: Pagination not working in admin courses index view **(zdavis)**
* [BUGFIX] Fixes #84: Password expiratoin is too short **(zdavis)**
* [BUGFIX] Fixes #83: Capitalized e-mails do not work with bulk import **(zdavis)**

## Vocat v3.0.0-beta1.8.1 (March 28, 2014)

* [BUGFIX] Removed bulk user button and corresponding route from admin UI **(zdavis)**

## Vocat v3.0.0-beta1.8 (March 28, 2014)

* [FEATURE] Adds bulk enrollment and non-ldap user invite functionality to VOCAT **(zdavis)**
* [CHORE] Correcting wkhtmltopdf-binary license to lgpl **(zdavis)**
* [CHORE] Against my wishes, including license info in the readme for all dependency gems **(zdavis)**
* [CHORE] Adjusts production mailer config **(zdavis)**
* [FEATURE] Fixes #75, Fixes #15: Handle enrollments and invitations  in non-ldap environments and allow admins to bulk-add users **(zdavis)**
* [FEATURE] Added dev_server script **(zdavis)**
* [BUGFIX] Fixes #80: Inaccurate messaging in enrollment view when list is empty **(zdavis)**
* [BUGFIX] Fixes #71: Sorting buttons wrap in project index due to missing col width **(zdavis)**
* [FEATURE] Fixes #76: Add evaluator name to admin course index and add evaluator filter to filters **(zdavis)**
* [BUGFIX] Fixes #77: Improve password wording on edit profile page **(zdavis)**
* [BUGFIX] Fixes ongoing problems with course year selector on admin dashboard **(zdavis)**
* [BUGFIX] Fixes #74: If a course has a missing year, the admin dashboard breaks. **(zdavis)**
* [DELIVERS BUGFIX #70] Fixes authentication checkbox behavior in Firefox **(zdavis)**

## Vocat v3.0.0-beta1.7 (March 7, 2014)

* [FEATURE] Fixes #16: Improve handling of 403, 404, and 500 errors **(zdavis)**
* [FEATURE] Fixes #59: Add project ordering to course manage projects view **(zdavis)**
* [FEATURE] Fixes #51: Creators should have access to the rubric before assessment occurs **(zdavis)**
* [FEATURE] Fixes #38: Adjust sample env configuration and login form wording to accommodate ldap login via email or username **(zdavis)**
* [CHORE]   Built production assets **(zdavis)**
* [CHORE]   Changed language on admin course list to make view as role more clear **(zdavis)**
* [BUGFIX]  Corrects typo in generated rubric description **(zdavis)**
* [BUGFIX]  Fixes #62: Non LDAP users should be able to change their password **(zdavis)**
* [BUGFIX]  Fixes #66: Inaccurate Percentage Data Display **(zdavis)**
* [BUGFIX]  Fixes #65: :tracking: section is absent from config/environment.yml.sample **(zdavis)**
* [BUGFIX]  Fixes #58: Fixed height of matrix--row-header--item in compact matrix **(smills)**
* [BUGFIX]  Videos without processors were breaking the course map JSON request **(zdavis)**

## Vocat v3.0.0-beta1.6 (February 20, 2014)

* [FEATURE] Delivers #44: add ability to configure Google Analytics tracking code for VOCAT **(zdavis)**
* [BUGFIX]  Fixes #50 No paragraph breaks in project description **(zdavis)**
* [BUGFIX]  Fixes #57: Need to crop long course titles in header nav **(zdavis)**
* [CHORE]   Removes unneeded factory and spec files **(zdavis)**
* [BUGFIX]  Fixes #47: Vimeo thumbnails not generated correctly **(zdavis)**
* [CHORE]   Updates production assets **(zdavis)**
* [FEATURE] Significant rewrite and refactoring of upload and transcoding mechanisms **(zdavis)**
* [BUGFIX]  Fixes #54: Corrects icon color in annotations header **(zdavis)**
* [BUGFIX]  Fixes #53: When the overlay is opened in the course map, the viewport should scroll to the header **(zdavis)**
* [BUGFIX]  Fixes #41: Unable to check course settings checkboxes in Firefox **(smills)**

## Vocat v3.0.0-beta1.5 (February 18, 2014)

* [BUGFIX]  Increases DB pool size in production **(zdavis)**
* [BUGFIX]  Fixes #42: Temporarily disable shortcut nav until help content has been written. **(zdavis)**
* [BUGFIX]  Fixes #36: Dropdown menu items in admin/users/edit view should be capitalized **(zdavis)**
* [BUGFIX]  Fixes #27: Fixes dimensions of SVG images in IE9-10 **(smills)**
* [CHORE]   Moving changelog to correct location **(zdavis)**
* [CHORE]   Changelog formatting adjustment **(zdavis)**

## Vocat v3.0.0-beta1.4 (February 12, 2014)

* [CHORE]   Adds changelog to VOCAT **(zdavis)**
* [CHORE]   Updates production assets **(zdavis)**
* [BUGFIX]  Fixes #35: Cannot create single integer top range in rubric generator **(zdavis)**
* [BUGFIX]  Fixes height of rubric editor headers **(zdavis)**
* [BUGFIX]  Fixes #21: Chosen not properly intitialized in rubric edit view **(zdavis)**
* [BUGFIX]  Fixes #36: Dropdown menu items in admin/users/edit view should be capitalized **(zdavis)**
* [CHORE]   UI text edits: small text edits in course and projects views **(mgershovich)**
* [CHORE]   Edited user deletion dialog text **(mgershovich)**
* [CHORE]   Small UX changes: Edited rubric deletion prompt for style, etc **(mgershovich)**
* [CHORE]   Small UX changes: edited prompt **(mgershovich)**
* [BUGFIX]  Fixes #28: vertical alignment of coursemap creator names in IE9-10 **(zdavis)**
* [BUGFIX]  Fixes #31: Removes scrollbars from rubric generator in IE9 **(zdavis)**
* [BUGFIX]  Fixes #33 It should be possible to disable LDAP authentication **(zdavis)**

## Vocat v3.0.0-beta1.3 (February 10, 2014)

* [BUGFIX]  Fixes #20: IE problem at log-in screen; also updates handlbars require.js library for IE9 compatibility and begins adjusting vocat.js so that it works better with browsers that do not support HTML5 push state **(zdavis)**
* [BUGFIX]  Fixes #21: by moving chosen initialization to onShow event callback instead of onRender event callback **(zdavis)**
* [BUGFIX]  Fixes #22: Evaluator changes to Manage Course -> Settings generates error **(zdavis)**
* [BUGFIX]  Fixes #17: Non-admin users shouldn't be allowed to access the admin interface. **(zdavis)**

## Vocat v3.0.0-beta1.2 (February 7, 2014)

* [BUGFIX]  Fixes #19 LDAP_authenticator should ignore case when seeing if user already exists locally. **(zdavis)**

## Vocat v3.0.0-beta1.1.1 (February 7, 2014)

* [CHORE]   Builds production javascript **(zdavis)**
* [BUGFIX]  Updates marionette version in build.js and adds chosen vendored files **(zdavis)**

## Vocat v3.0.0-beta1 (February 7, 2014)

Refer to the commit history on Github to view changes prior to v3.0.0-beta1

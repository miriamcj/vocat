## Vocat v3.0.0-beta1.4 (February 12, 2014)

[*zdavis*][CHORE] Updates production assets
[*zdavis*][BUGFIX] Fixes #35: Cannot create single integer top range in rubric generator
[*zdavis*][BUGFIX] Fixes height of rubric editor headers
[*zdavis*][BUGFIX] Fixes #21: Chosen not properly intitialized in rubric edit view
[*zdavis*][BUGFIX] Fixes #36: Dropdown menu items in admin/users/edit view should be capitalized
[*mgershovich*][CHORE] UI text edits: small text edits in course and projects views
[*mgershovich*][CHORE] Edited user deletion dialog text
[*mgershovich*][CHORE] Small UX changes: Edited rubric deletion prompt for style, etc
[*mgershovich*][CHORE] Small UX changes: edited prompt
[*zdavis*][BUGFIX] Fixes #28: vertical alignment of coursemap creator names in IE9-10
[*zdavis*][BUGFIX] Fixes #31: Removes scrollbars from rubric generator in IE9
[*zdavis*][BUGFIX] Fixes #33 It should be possible to disable LDAP authentication

## Vocat v3.0.0-beta1.3 (February 10, 2014)

[*zdavis*][BUGFIX] Fixes #20: IE problem at log-in screen; also updates handlbars require.js library for IE9 compatibility and begins adjusting vocat.js so that it works better with browsers that do not support HTML5 push state
[*zdavis*][BUGFIX] Fixes #21: by moving chosen initialization to onShow event callback instead of onRender event callback
[*zdavis*][BUGFIX] Fixes #22: Evaluator changes to Manage Course -> Settings generates error
[*zdavis*][BUGFIX] Fixes #17: Non-admin users shouldn't be allowed to access the admin interface.

## Vocat v3.0.0-beta1.2 (February 7, 2014)

[*zdavis*][BUGFIX] Fixes #19 LDAP_authenticator should ignore case when seeing if user already exists locally. 

## Vocat v3.0.0-beta1.1.1 (February 7, 2014)

[*zdavis*][CHORE] Builds production javascript
[*zdavis*][BUGFIX] Updates marionette version in build.js and adds chosen vendored files

## Vocat v3.0.0-beta1 (February 7, 2014)

Refer to the commit history on Github to view changes prior to v3.0.0-beta1
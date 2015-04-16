## Vocat v3.2-rc1 (April 9, 2015)

* [BUGFIX] Removes typo from vjs.rewind plugin
* [BUGFIX] Show non-annotated tags in build number output
* [CHORE] Upgrades rails and other gems
* [BUGFIX] Fixes buffered track color on player
* [BUGFIX] Makes the messaging on emptia media and evaluations boxes more visually consistent
* [BUGFIX] Bug in for_creator_and_project submission API was preventing user from seeing his or her own submissions
* [FEATURE] Finishes implementing annotation and player UI on lighter background
* [BUGFIX FIXES #91223866] Not enough bottom padding between upload progress indicator and below no assets check back soon message.
* [CHORE] Removes assets from merged master
* [FEATURE] Breaks out seed data into sample data generator and creates proper seed script
* [FEATURE] Adds permanent URL for each asset on a submission and allows users to navigate to them directly
* [BUGFIX] Add empty annotations messages
* [BUGFIX FIXES #90731408] Don’t include a show rubric button on submission detail view if there is no rubric.
* [FEATURE] Adds basic markdown instructions
* [CHORE DELIVERS #90729308] Lightens annotation background on inline asset detail
* [FEATURE DELIVERS #90721372] Improve look and feel of move UI on asset management
* [FEATURE STARTS #88355986] Add link to modal markdown overview to discussion post input
* [FEATURE DELIVERS #88265114] Durring asset playback, users can jump back 10 seconds
* [FEATURE DELIVERS #90705718] Show avatar and annotation info in full screen mode
* [BUGFIX] Improves VideoJS icons
* [FEATURE DELIVERS #90697998] Replace stock videojs icons with Laelicons
* [FEATURE DELIVERS #90310348] Allow markdown in annotations, comments, course message, and project descriptions
* [BUGFIX FIXES #90633218 AND #90633196] Fixes problems with toggling edit mode for durationless asset annotations
* [FEATURE DELIVERS #90198978] Moves asset playback inline onto submission detail view
* [BUGFIX FIXES #90154118] Activating or deactivating annotation on image asset when in annotation edit mode should trigger edit mode exit
* [FEATURE DELIVERS #88271608] Make asset playback UI responsive
* [BUGFIX FIXES #90066086] Hide drawing tools on audio annotation
* [FEATURE DELIVERS #88358152] Reduce height of player for audio annotations
* [FEATURE DELIVERS #88271784] Show annotations on video when video is full screen
* [BUGFIX] Returns progress bar to full screen video view
* [FEATURE] Annotators should be able to submit an annotation with an enter keypress
* [FEATURE DELIVERS #88359032 AND #89834796] Adds role colors and shadows to annotation drawings
* [BUGFIX] Don't show the annotation post button until an annotation can actually be posted
* [FEATURE] Makes shift circle behavior more intuitive on canvas drawings
* [BUGFIX] Prevent UI flapping when switching between annotations to edit
* [BUGFIX] Fixes race conditions around annotation editing state
* [FEATURE] Numerous improvements and bugfixes for new annotation canvas functionality
* [FEATURE DELIVERS #88271890, #88357586, #87317848] Adds annotation selection and moving, and improves UX for annotation editing; general refactoring
* [FEATURE] Allow upload and transcoding of mkv files
* [FEATURE DELIVERS #88271164] Aligns audio waveform with scrubber
* [FEATURE DELIVERS #88271466] Adds polling for annotation processing
* [FEATURE DELIVERS #88270328] Prevent user from closing asset management interface while uploading a file
* [FEATURE DELIVERS #88357976] Adjusts upload placeholder text to be clear about what asset types are accepted.
* [FEATURE DELIVERS #88359704] Remove PDFs from allowed image types
* [FEATURE DELIVERS #88358070] Improves add first asset language on empty asset list
* [FEATURE DELIVERS #89055718] Prompt users to name YouTube and Vimeo assets
* [FEATURE FIXES #87317912] Removes drag and drop sorting on assets and makes sorting more reliable
* [FEATURE DELIVERS #88265172] Users can see the whole rubric on the submission detail page
* [BUGFIX FIXES #88947672] Lose the glow on the videojs player UI
* [BUGFIX FIXES #88271052] Removes full screen link from audio playback
* [BUGFIX FIXES #87326774] Submission summary should show first sorted asset
* [BUGFIX FIXES #88911926] Makes no media message on submission summary partial more consistent
* [BUGFIX] Restores asset_collection_empty access to asset layout vent object
* [BUGFIX DELIVERS #88354988] Change course map header from "evaluations" to "course overview"
* [FEATURE DELIVERS #88828444 AND #88264784] Allow refusal of media after project due date; show project details to creator on submission detail view
* [BUGFIX FIXES #88357706] Change project back button to be more specific
* [BUGFIX DELIVERS #88354320] Call assets "media" instead of "assets" on the frontend
* [BUGFIX FIXES #88549082] Removes console message from project edit view
* [BUGFIX DELIVERS #88795030] In 3.2 it is no longer possible to publish or unpublish all evaluations for a project
* [BUGFIX] Removes deprecated partial include from course edit form
* [FEATURE] Refactoring code to further accomodate moving settings from course to project model
* [FEATURE] Always show the average in course map cell to evaluators. Never show it to creators
* [BUGFIX] When course creators see the coursemap unavailable warning, include a buton that jumps to the groups or individual coursemap view
* [BUGFIX] Hide create new project link in coursemap header from creators
* [BUGFIX] Improves instructional language for 'enable public discussion' project setting
* [FEATURE DELIVERS #88796000] Instructors should see some project settings in the project list table
* [BUGFIX FIXES #88794472] Restores course map warnings and removes view toggle if group or user coursemap is unavailable
* [FEATURE] Initial work is done on moving settings from course to project; tests are all passing. UI stil requires some refactoring
* [FEATURE] Migrates course settings to project model
* [FEATURE DELIVERS #88337582] Creating a new user in the admin interface sends welcome email with password reset link; improvements to welcome email language
* [BUGFIX FIXES #88476714] Moves footer build number code out of configuration and into initializer
* [BUGFIX] Fixes parse error
* [BUGFIX FIXES #88476648] Standalone views are not properly included in optimized r.js javascript
* [BUGFIX FIXES #88474368] Secret token needs to be regenerated and sourced from secrets.yml
* [BUGFIX FIXES #88474346] Staging config still references environment.yml config file
* [BUGFIX FIXES #88355682] Improves allow media UI on project edit/new form
* [FEATURE DELIVERS #88270906] Use a date picker instead of multiple fields for project due date
* [BUGFIX FIXES #88450380] Set application timezone to eastern US
* [FEATURE DELIVERS #88276818] Adds edit project option to project list actions dropdown
* [BUGFIX Fixes #135] Improve formatting of examples in bulk enrollment instructions
* [BUGFIX] Allows configuratoin of email domain
* [BUGFIX] Adds support for (animated) gifs
* [BUGFIX] Soften button styles in asset UIs
* [BUGFIX] Minor adjustment to annotation spacer height
* [BUGFIX] Fix SSL::Digest::Digest deprecation warning
* [BUGFIX] If a project does not allow video, do not show the external video input field on new asset form
* [BUGFIX] Corrects layout of course stats
* [BUGFIX] Add ogv to video file types
* [BUGFIX] Adds log_level setting to production environment
* [FEATURE] Refactors asset creation migration and adds a submission counter cache update migration
* [BUGFIX] Fixes deprecated setting in production environment
* [BUGFIX] For now, disabling visual annotations on vimeo videosg
* [BUGFIX] Minor change allows vimeo videos to play
* [BUGFIX] Fixes devstaging deployment script to properly restart vocat_workers
* [BUGFIX] Annotator canvas was automatically disabling the canvas whenever it announced its contents. This behavior has been removed
* [BUGFIX] Updates minimagick to 4.0.2
* [BUGFIX] Make MiniMagick stop whining
* [FEATURE] Adding visual active state to annotations; fine tuning various UI interactions
* [BUGFIX] Fixes bugs with asset collection sorting
* [FEATURE] Improvements to annotation drawing display and corrections to creator routes
* [BUGFIX] Course settings were not displaying properly in edit course form
* [BUGFIX] Asset manage interface should not be available if creators are unable to upload assets
* [BUGFIX] Adds annotation drawing indication and fixes annotation drawing display for assets without duration
* [FEATURE] Adds asset counter cache to submissions
* [BUGFIX] Makes asset audio thumbnail more responsive
* [BUGFIX] Fixes issue with matrix col widths being inaccurate
* [BUGFIX] Fixes case on video thumbnail state
* [BUGFIX] Additional tweaks to js build
* [FEATURE] Wrapping up audio annotation functionality
* [FEATURE] Developing annotation drawing playback
* [BUGFIX] Solving problems with annotation scroll
* [FEATURE] Refinements to asset management and annotation UIs
* [FEATURE] Ongoing development of asset management and annotation views
* [FEATURE] Adds middleware that allows asset requests to bypass Rails
* [BUGFIX] Fixes to Guardfile for recent guard:coffeescript compatibility
* [BUGFIX] Fixes missing method in seeds.rb
* [BUGFIX] Fixes old migration
* [FEATURE] Adjustment to annotation sorting and fixes to staging deploy
* [FEATURE] Continued work on asset annotations and multiple asset type
* [BUGFIX] Adding a smidgen more margin-top to .page-content to make room for single line notifications
* [FEATURE] Improves layout and behavior of notifications
* [FEATURE] Continued work on new annotation UI
* [FEATURE] Adds functional scrubber to video progress bar
* [BUGFIX] Switches controller _filter methods to corresponding _action methods in advance of future deprecations
* [BUGFIX] Removes simple form deprecation
* [BUGFIX] Ensuring that all tests pass following Rails 4.2 upgrade
* [FEATURE] Updating gems
* [BUGFIX] Fixing specs after 4.1 upgrade
* [BUGFIX] Fixing test runner for upgraded rspec and rails
* [BUGFIX] Pointing State Machine gem at Rails 4.2 compatible fork until the dust clears
* [FEATURE] Upgrades Rails to 4.1 and refactors configuration approach to safely store secrets
* [FEATURE] Changes deployment approach so that asset compilation is moved back to the server side
* [BUGFIX] Removing incorrect inclusrion in submission controller js
* [BUGFIX] Fixing seeds.rb and updating schema from fresh DB create
* [CHORE] Attempting to unwind the tracking of compiled assets
* [FEATURE] Continued development of the annotations UI
* [BUGFIX] Submission models should update their asset collection when they are changed
* [BUGFIX] Style loading message in course map cells
* [FEATURE] Restores and relocated course map loading message; improves routing to submission detail so it can be clicked before submissions are loaded
* [FEATURE] Large commit refactors routing in coursemap and adds ongoing work on asset management
* [FEATURE] Adds sidekiq for handling thumbnail generation; adds thumbnail worker and generator for handling image submissions
* [BUGFIX] Removing gems that are not currently in use; moving from cancan to cancancan
* [FEATURE] Fixes sorting for mixed asset types; implements vimeo and youtube assets
* [FEATURE] Initial work on removing video model and replacing it with more flexible asset model
* [FEATURE] Ongoing work on new submission upload UI
* [FEATURE] Initial work on supporting multiple assets per submission

## Vocat v3.1.3 (February 4, 2015)

* [BUGFIX Fixes #135] Improve formatting of examples in bulk enrollment instructions
* [BUGFIX] Allows configuratoin of email domain
* [BUGFIX] Fixes domain in default_url_options in production env
* [BUGFIX] Fixes incorrect colcount on admin courses index view
* [CHORE] Adds york deployment target
* [CHORE] Updated deployment targets

## Vocat v3.1.2 (January 6, 2015)

* [BUGFIX] Fixes missing creator name on project reporter score export
* [BUGFIX] Fixes problem with thor configure script not capturing IAM role name correctly
* [BUGFIX] Fixes enrollment in seeds.rb
* [BUGFIX FIXES #117] Adjusts coursemap view and drawer nav so that access to coursemap is based on view_submissions course ability rather than evaluate course ability
* [BUGFIX FIXES #131] Previous fix was inadequate because fix was accidentally commented. Derpy.
* [BUGFIX FIXES #131] In some situations, the course map bleeds into the submission overlay.
* [BUGFIX #117] Bug in ability class gave evaluate ability on course to creators not enrolled in the course; fix revealed video permission test shortcoming
* [BUGFIX FIXES #130] Creators see individual projects header in drawer nav even when a course has no individual projects
* [BUGFIX FIXES #128] Creators logging into a course with no projects should be given a explanatory message
* [BUGFIX FIXES #129] Adjusts bulk enroller enroll call from user to course object
* [BUGFIX FIXES #122] Removes caching from stats on admin course index view
* [FEATURE #120] Vocat now remembers whether a user last looked at the group or user coursemap and defaults to that view when a user access the course
* [BUGFIX #120] Improves warning message language when the group or individual evaluation grid is not available
* [BUGFIX CLOSES #126] Instructors without courses should see a message to that effect on their dashboard.
* [BUGFIX FIXES #127] Email in admin/user show view tends to overflow quarter width column
* [BUGFIX] Fixes ambiguous course scope on user model
* [CHORE] Showing love to model specs and adding new specs for Reporter::Project class
* [CHORE] Very minor text changes to course request mailers
* [BUGFIX] Improves course request email language
* [CHORE] Adjusts ruby version for 3.1.2 release and adjusts staging deploy target
* [BUGFIX] Improves course request email language
* [BUGFIX #125] Adds course request submitted date to admin course request index view
* [FEATURE FIXES #123] Allow instructors to export detailed project scores
* [BUGFIX] Cleaning up routes and seeds from prior user/course relationship refactoring
* [BUGFIX FIXES #121] Improve drawer nav and course sorting for users with many courses
* [BUGFIX FIXES #124] Video and evaluations not loading for one group video
* [FEATURE] Adds flash message to dashboards notifying users of upcoming downtime
* [BUGFIX] Fixes invalid search params on rubric model
* [FEATURE] Allows evaluators to see other evaluators unpublished scores

## Vocat v3.1.1 (December 10, 2014)

* [BUGFIX] Attempts to address #124, error on evaluation frontend rendering
* [BUGFIX] Fixes problems with publish checkbox not appearing in coursemap
* [BUGFIX FIXES #118] Missing URL on portfolio submission summary upload link
* [BUGFIX] Fixes incorrect partial include on edit password view
* [BUGFIX] Fixes webkit layout issue with new admin figures
* [BUGFIX] Fixes to warning message on coursemap when there are no projects in a course
* [FEATURE] Adds Vocat at a Glance stats to Admin Dashboard
* [BUGFIX] Fixes incorrect variable name for S3 global vars
* [CHORE] Builds production assets
* [BUGFIX] Score slider should respect the lower possible score value on the rubric
* [BUGFIX] Removes top pagination from system rubrics table
* [BUGFIX] Show instructors the average instructor score in coursemap cells
* [BUGFIX] Crop long course names in the header bar
* [FEATURE] Allows evaluators to see other evaluators unpublished scores
* [BUGFIX FIXES #82751464] Error in evaluation.score_detail when there is no rubric for the evaluation
* [FEATURE] Adds project count to admin course list
* [CHORE] Updates deployment scripts for new host configuration
* [BUGFIX FIXES #81555662] Restore proper error pages
* [BUGFIX FIXES #82232422] Video does not restart after annotation is entered
* [BUGFIX FIXES #82290068] Show actual scores, not percentages on criteria.
* [BUGFIX FIXES #82412108] Restores cropped description text in rubric cells
* [BUGFIX FIXES #82052834] Switches button icon sizing to pixels for sharp rendering in IE10, 11
* [BUGFIX] Picks some low hanging responsive fruit
* [BUGFIX FIXES #82426256] Ambiguous icon used on portfolio thumbnail placeholders
* [BUGFIX FIXES #82413824] Admins should be able to easily change course settings
* [FEATURE DELIVERS #81450290] Show rubric cell descriptions on various score sliders
* [BUGFIX #82257614] Fixes border-bottom on single-line annotation input
* [BUGFIX] CSS Regression was causing improper rendering on switches
* [FEATURE DELIVERS #81408458] Add group / individual switcher to course map
* [BUGFIX #82258500] Ensures animated transition for group switches in Safari, IE11, IE10
* [FEATURE DELIVERS #82257658] Evaluation range bar shows cursor pointer and grabber shows grab in modern browsers
* [BUGFIX FIXES #82241732] Dropdown arrows are no longer cut off in IE9

## Vocat v3.1 (November 13, 2014)

* [CHORE] Builds production assets
* [FEATURE DELIEVERS #80351296] Reimplments creator portfolios in the course map and as stand alone views
* [BUGFIX FIXES #82179424] Adds placeholders to authentication tile in IE9
* [BUGFIX] Removes tiny play button artifact on video.js player
* [BUGFIX] Creators who can see the coursemap should not have access to project and creator detail views
* [CHORE] Changes overflow scroll to auto on annotations list
* [CHORE] Compiles production assets
* [BUGFIX FIXES #82177420] After deleting an annotation, option to edit shows up again
* [BUGFIX FIXES #81784410] Browser back button not working reliably in coursemap detail views
* [BUGFIX FIXES #82175892] Matrix header look the same in Chrome, FF, and IE11
* [BUGFIX] Restores 50/50 col layout to submission assets
* [BUGFIX FIXES #82173542] Video count on project detail includes submissions with videos for users who have been removed from the course.
* [BUGFIX] Cleans up bulk enrollment; needs second pass
* [BUGFIX] Improves handling of server-side array style errors in notification class
* [BUGFIX FIXES #82090340] Awkward notification message when inviting one user to a course fails
* [BUGFIX FIXES #82006472] Admin delete course redirects to incorrect route
* [BUGFIX FIXES #82160748] Missing link indicator on edit rubric cells
* [BUGFIX FIXES #82168374] Textareas should not be resizable.
* [CHORE] Removes console logging msg
* [BUGFIX FIXES #82161678] Adds simple javascript exception handler and makes sure project rubric_id is nullified when rubric is deleted
* [CHORE] Fixes case on stock rubric in seeds.rb
* [BUGFIX FIXES #82156050] Regression preventing new editable score from displaying sliders
* [BUGFIX FIXES #8209141] Admin Course Search Section criteria is exact, not contains
* [BUGFIX FIXES #82155086] No courses found on admin course list should result in message to that effect
* [FEATURE DELIVERS #81637922] Styles video player play button and adjusts aspect ratio
* [FEATURE] Adds group modal to submission view and refactors back navigation across various submission views
* [CHORE] Removes view that is no longer used
* [BUGFIX FIXES #82084390] Creators should not be invited to create a group on course map warning when no groups exist
* [FEATURE] Wraps up portfolio and student dashboard
* [FEATURE] First pass at new creator course landing page
* [BUGFIX] Lightens informational alert background color
* [CHORE] Adds instructional language to project due date field and fixes sorting on project type select
* [CHORE] Removes console msgs
* [BUGFIX FIXES #82073260] Regression in evaluation score reverting
* [CHORE] Removes console notifictions
* [BUGFIX] Removes overflow hidden on container; adds it to matrix wrapper
* [CHORE] Removes earlier animation queue approach
* [CHORE] Builds assets
* [FEATURE] More improvements to notification subsystem
* [BUGFIX] Fixes minor display issue with form submit rows
* [CHORE] Builds production js
* [BUGFIX] Adds overflow-x hidden to container to prevent coursemap horiz. scroll
* [CHORE] Builds production js
* [BUGFIX] Reverting to fixed notifications
* [CHORE] Builds production js
* [BUGFIX] Minor issues with group course map warning
* [BUGFIX] Minor language change on course settings
* [BUGFIX] Minor language change on course settings
* [BUGFIX] Minor language change on course settings
* [BUGFIX] Improves language on project type field
* [BUGFIX FIXES #82007666] Missing language on admin course edit form
* [BUGFIX FIXES #82007600] 1 px line showing on coursemap when warning is visible
* [BUGFIX FIXES #81989516] Error on forgot password view
* [BUGFIX FIXES #82006950] Link video to submission and course to course in admin video list
* [BUGFIX FIXES #82006912] Fuzzy language on user's course list
* [BUGFIX FIXES #82006720] Section in course search should be case insensitive
* [BUGFIX] Better organizes edit profile pw fields
* [BUGFIX] Removes test flash messages
* [FEATURE] Refactoring notifications subsystem
* [BUGFIX FIXES #81879802] Adds call to action to groups UI when there are no groups
* [BUGFIX] Corrects javascript error in FF
* [CHORE] Builds assets
* [FEATURE] Adjusts creator landing page; refactors creator course portfolio view
* [CHORE] Compiles assets
* [BUGFIX] Improves but does not finish coursemap layout at mobile size
* [BUGFIX] Fixes matrix column resizing when header is stuck
* [CHORE] Builds production assets for release
* [BUGFIX] Further work to address invisible dropdowns in fixed matrix headers; improvements to matrices with no rows
* [BUGFIX] Restores deselect icon to chosen selects
* [BUGFIX FIXES #81784100] Missing course filter reset button
* [CHORE] Removes console msg
* [BUGFIX] Fixes regression with scroll on coursemap close; still not quite smooth enough
* [CHORE] Builds production assets
* [BUGFIX FIXES #81673354] Matrixes should be able to have fixed headers. Coursemap matrix should have a fixed header.
* [BUGFIX] Regression was preventing evaluators from creating new rubrics
* [BUGFIX FIXES #81673368] Coursemap should return to matrix scroll pos on detail close
* [BUGFIX FIXES #81079312] Updates to submission media not reflected on course map
* [BUGFIX FIXES #81724060] Submission factory not creating submissions for open projects
* [BUGFIX] Fixes regression that was causing new evaluations to not show score fields
* [CHORE] Removes console message from score slider view
* [BUGFIX FIXES #81639016] Your Evaluation fill width not animating when range sliders change
* [BUGFIX FIXES #81511610] Annoying flash when evaluation is saved
* [BUGFIX FIXES #81513156] Width is wrong on project rows when sorting/dragging
* [BUGFIX FIXES #81629970] Primary navigation options are wrong for creators
* [BUGFIX FIXES #81633162] Project table should show project type
* [BUGFIX] Corrects display for courses with no projects on evaluator dashboard
* [CHORE] Builds production assets
* [FEATURE] Provisional student landing page is functional
* [BUGFIX] Lightens yellow alert bg color
* [BUGFIX] Improves course request flash messaging language and adds back buttons to course request new view
* [BUGFIX FIXES #81509424] Fixes video.js styles and builds production assets
* [FEATURE] Improves communication between submission detail and coursemap
* [FEATURE] Improves title of courses in admin course section
* [BUGFIX] Further improevments to fight fout
* [BUGFIX] Uses opacity instead of display on body to fight fout
* [BUGFIX] Reduces fout and improve typekit initialization time
* [CHORE] Builds production assets
* [BUGFIX FIXES #81454332] Improve flash msg location and display on auth splash page
* [BUGFIX] If scrollpos is 0, do not maintain scroll on showing a notification
* [CHORE] Removes console msg
* [BUGFIX FIXES #81449224] Regression: When there are only one or two projects in eval matrix, row heights don't match.
* [BUGFIX FIXES #81426524] Regression: notification layout was not listening for notification destroy event
* [BUGFIX FIXES #81449570] Regression: slide down effect on evals is janky.
* [CHORE] Deletes old scss partials
* [CHORE] Removes console.log messages
* [BUGFIX FIXES #81449236] Publish all evaluations success message happens before the action is truly successful
* [BUGFIX FIXES #81449158 AND #81449168] Minor fixed to enrollment list
* [CHORE] Compiles production assets
* [BUGFIX] Fixes JS build manifest and builds production javascript
* [FEATURE] Improves evaluation present/absent messaging
* [BUGFIX] Fixes drawer trigger icon spacing
* [BUGFIX] Many small design changes based on LT feedback
* [BUGFIX] Add better language for edit profile link
* [BUGFIX FIXES #81158694] Fixes table dragger being blown out on sort
* [BUGFIX] Updates video.js and video.js youtube tech
* [BUGFIX FIXES #81307054] Hide Evaluation view if a project does not have a rubric
* [BUGFIX FIXES #81312348] Unable to enroll users in courses because click event not propagating correctly
* [FEATURE] Fine tuning statistic figures
* [FEATURE DELIVERS #80351330] Redesigns evaluator landing page
* [FEATURE DELIVERS #81079424] Restores group coursemap
* [FEATURE DELIVERS #80351288] Reimplements and cleans up project detail view
* [FEATURE DELIVERS #80351322] Update modal design
* [BUGFIX FIXES #81079334] Buttons in notification have wrong hover color
* [FEATURE] Refactors edit profile view
* [FEATURE] Ensures course requests display correctly in admin view
* [FEATURE] Wraps up evaluator rubric view refactoring
* [FEATURE] Improves dashboard controller structure and begins refactoring instructor rubric views
* [FEATURE] Initial refactoring of login page
* [FEATURE] Improves sortable table grabber
* [BUGFIX FIXES #81127528] Invalid vimeo and youtube URLs should trigger an error
* [BUGFIX] Fixes course manage new proejct view
* [BUGFIX FIXES #81079374] Javascript error on project sorting
* [BUGFIX] Removes deprecated js views and tightens up annotation performance
* [BUGFIX FIXES #81079304] Content container top margin not always correct in relation to notification display
* [FEATURE] Tightens up scoring UI
* [FEATURE] Additional revisions to scoring UI
* [FEATURE] Redesigned scoring is functional
* [FEATURE] Score range inputs are complete, but not yet persisting
* [FEATURE] Begins work on updated scoring UI
* [FEATURE] Begins work on the score sliders
* [BUGFIX] Fixes score display regression
* [FEATURE] Adjusts look and feel of pre-chosenized selects
* [FEATURE] Moving html view initialization further up in bootstrap
* [FEATURE] Refactored global notifications for improved UI and removed numerous console logs
* [FEATURE] Restores media checkbox to coursemap; adjusts project child view insertion
* [BUGFIX] Introduces work around in abstract matrix for chrome rendering bug
* [CHORE] Removes deprecated coursemap template
* [FEATURE] Working on individual evaluation publishing
* [FEATURE] Refactors and simplifies course map publishers
* [FEATURE] Wraps up refactoring of rubric
* [BUGFIX FIXES #80351298] Small fix to admin video list template
* [FEATURE] Refactored rubrics are now functional, if not a bit buggy still
* [DELIVERS FEATURE #80351298] Style admin videos view
* [CHORE] Cleans up js bootstrap and removes jquery plugin layouts, moving code into backbone views instead
* [FEATURE] Incremental work on rubric refactoring
* [FEATURE] Begining work on rubric generator refactoring
* [BUGFIX] Fixes invalid search params on rubric model
* [FEATURE] Refactoring of admin user views
* [FEATURE] Wraps up redesigned pagination
* [FEATURE] Begins work on pagination layout
* [FEATURE] Beginning work on pagination styles
* [FEATURE] Finishes up first major pass at enrollment refactoring
* [FEATURE] Refactoring enrollment views
* [FEATURE] Admin CSS refactoring conntinues
* [CHORE] Fixing staging deployment config
* [CHORE] Changing unicorn socket path
* [BUGFIX] Fixes botched merge error in view
* [CHORE] Adjusts capistrano configuration for staging vm deployment
* [CHORE] Tweaking database config
* [CHORE] Simplifies database configuration
* [BUGFIX] Corrects lambda argument whitespace for Ruby 1.9 compatibility
* [BUGFIX] Corrects lambda argument whitespace for Ruby 1.9 compatibility
* [BUGFIX] Removes lambda argument whitespace for Ruby 1.9 compatibility
* [FEATURE] Refactoring to page-section and ongoing CSS improvements
* [CHORE] Reorganizing course partials
* [FEATURE] Cleans up course management and evaluator dashboard
* [BUGFIX Resolves #114] Issue where editing course in admin dashboard would push modified course to bottom.
* [BUGFIX Fixes #116] Fixes issues with Course Request form not repopulating fields during an error redirect.
* [FEATURE] Wraps up major development of groups UI
* [FEATURE] Incremental improvements to the modal ui
* [FEATURE] Close to wrapping up groups refactoring
* [FEATURE] Incremental work on the groups refactoring
* [FEATURE] Ongoing work on groups grid
* [FEATURE] Fine tuning look and feel of groups page; various fixes
* [FEATURE] Group management UI is now functional
* [FEATURE] Continues work on manage projects UI and begins refactoring groups
* [FEATURE] Added no records message for CRs; updated config sample file
* [FEATURE] Adds draggable handles to projects table
* [FEATURE] Working on project sorting
* [FEATURE] to_course implemented; course created on approval
* [FEATURE] Approve / deny mostly working; emails going out
* [FEATURE] Working on new navigation
* [FEATURE] Major refactoring of serializers to improve performance
* [FEATURE] Approve / deny actions; tests
* [FEATURE] CR saving with state and evaluator
* [CHORE] Updating DB schema after merging master
* [FEATURE] Course Request form working and saving records
* [BUGFIX] Sets width of matrix columns correctly when there is an especially long word in a column
* [FEATURE] Finishing up annotation views
* [FEATURE] Generated course request model and controller
* [FEATURE] Refactoring of video and annotations nearly complete
* [FEATURE] Adds wmvs to list of acceptable video formats
* [FEATURE] Finished up UI for read-only scores
* [FEATURE] Working on submission views UI refresh
* [FEATURE] Working on evaluation range css
* [FEATURE] Refactoring of submission views
* [FEATURE] Updates marionette and backbone; fixes discussions
* [BUGFIX] Upgraded JS for Marionette 2
* [FEATURE] Responsive course map
* [BUGFIX] Adds a default false value to submission.published and handles nil values better
* [BUGFIX] Evaluators could not see their own unpublished evaluations
* [BUGFIX] Admins were unable to evaluate submissions even if they were evaluators in the course
* [FEATURE] Ongoing css development
* [FEATURE] Continued refactoring of csss. , esp. on course matrix
* [FEATURE] Ongoing css refactoring
* [FEATURE] Continued development
* [FEATURE] Ongoing css work
* [FEATURE] Go to hell, SCSS refactoring
* [FEATURE] Continued work on sass refactoring
* [FEATURE] Continued work on CSS refactoring
* [FEATURE] Continuing work on css refactoring
* [FEATURE] Progress on css refactoring
* [FEATURE] Incremental work on CSS refactoring for redesign
* [FEATURE] Incremental progress on css refactoring
* [FEATURE] Adds creator enrollment management to evaluator course view
* [FEATURE Closes #110] Users cannot clone their own rubrics
* [FEATURE] Removes left shim from coursemap overlay
* [BUGFIX] Fixes evaluation permissions for admins and adjusts ability spec and model to fix discussion post ability tests
* [FEATURE] Adds transcoding support for m4v videos
* [FEATURE] Adds transcoding support for m4v videos
* [BUGFIX] Corrects regression that was preventing table headers from showing
* [CHORE] Adds capistrano to the Gemfile
* [BUGFIX FIXES #71694852] Rubric criteria range descriptions are truncated only with CSS, removing superfluous ellipsis

Vocat v3.0.0-beta1.11 (July 11, 2014)

* [CHORE] Builds js for release
* [FEATURE] Adds capistrano config for one-command deploys; precompiled assets for release
* [CHORE] Adds guard to other bundler contexts
* [FEATURE] Adds markup for table sorting
* [BUGFIX FIXES #108] "Your evaluation" label should be "self evaluation"
* [BUGFIX CLOSES #109] Instructors are unable to see self-evaluations
* [BUGFIX] Enables students to see instructor evaluations
* [CHORE] Removes whitespace from evaluation view
* [BUGFIX] Rounds percentages in course synopsis partial
* [FEATURE] Adds CSS for sortable table headers
* [CHORE] Bumps ruby version to 2.1.1
* [BUGFIX FIXES #103] Poor messaging for failed logins
* [BUGFIX FIXES #104] Missing link on "no video has been uploaded" button
* [CHORE] Remove js template that is no longer in use
* [BUGFIX] Adjust seed data to address project STI refactoring
* [FEATURE] Adds count possible submissions method to course
* [CHORE] Cleans up rubric list interface for instructors; adds a proper modal box to the instructor rubric delete link
* [CHORE] Reviewing code and adding to-dos for future refactoring
* [CHORE] Clean up and adding todos
* [CHORE] Refactored method for determining how many submissions can exist for a project
* [FEATURE] Adds single table inheritance to projects and refactors Group, User, and Open projects to fully fledged objects
* [CHORE] More DRYing up of admin views
* [CHORE] Drying up rubric views and fixing a few small model issues
* [CHORE] Further small adjustments to admin course and user UIs
* [CHORE] Minor fixes to admin course navigation
* [FEATURE] Improves admin users interface with easier navigation
* [BUGFIX] Restores bare-link mix-in to drop-down toggles
* [FEATURE] Refactors course admin views to utilize more effective sub-navigation
* [BUGFIX] Fixes incorrect method call in course model
* [FEATURE] Allows users to see project detail for various types of evaluations; includes some refactoring to underlying classes
* [CHORE] Renamed project_detail view to project_dialog to make room for refactored course map project detail view
* [FEATURE] Show admins all evaluations for a project, not just those that she created
* [BUGFIX] Two Thors is one Thor too many.
* [BUGFIX FIXES #71697810] When adding a video, create can now accept plain YouTube urls and short (share) URLs
* [BUGFIX] Admin users are given a role of evaluator for all evaluations, unless they have a specific role in the associated course

## Vocat v3.0.0-beta1.10.1 (April 30, 2014)

* [BUGFIX] Variants should send the correct mime type for S3 files

## Vocat v3.0.0-beta1.10 (April 29, 2014)

* [FEATURE] Fixes #94: Adjust transcoder so that it will not re-transcode a video if the target S3 object already exists
* [FEATURE] Fixes #94: Refactors Thor CLI script and improves VOCAT's ability to create AWS objects.
* [FEATURE] Fixes #94: Significant refactoring of the attachment processing subsystem.
* [FEATURE] Fixes #98: Hide rubric description by default on submission detail pages
* [BUGFIX]  Fixes #100: Fixes project statistics for projects without a rubric
* [BUGFIX]  Fixes #99: Evaluation serializer should show relative role for evaluator rather than her global role
* [BUGFIX]  Fixes #99: Admins should be able to see evaluator scores in submission and course map views
* [BUGFIX]  Fixes #96: Single chosen selects should allow de-select
* [BUGFIX]  Fixes #95: Improve CSS compile time in development context
* [BUGFIX]  Projects in seed data were not being assigned a rubric

## Vocat v3.0.0-beta1.9.1 (April 17, 2014)

* [BUGFIX]  Fixes #93: Regression in collectinon proxy breaks rubric UI **(zdavis)**
* [FEATURE] Fixes #92: Show video count and course link on course overview **(zdavis)**

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

# VOCAT 3.0
###### Like a beautiful phoneix, VOCAT rises from its ashes and takes flight.

## About VOCAT

Developed by the Bernard L. Schwartz Communication Institute at Baruch College, CUNY to help our students grow as confident, effective speakers, Vocat is a web application that facilitates feedback on live performances or recorded video or any other type of digital media. Over 10,000 Baruch College undergraduates in 30+ courses have used Vocat since launch of Vocat 2 in 2007.

The newest version features qualitative and quantitative feedback options, video annotation, improved discussions, support for cloud processing and storage of video, improved groups, and APIs for integration with other tools and services. LTI support for integration with most LMSs is coming soon.

## Infrastructure
- Vocat relies on postgres, which can generally be installed via yum or apt-get
- You will need Postgres' hstore module. On RHEL, you start by installing the pg contrib package: yum install postgresql92-contrib.x86_64

## Seeds

### Users
- Passwords are the same for everyone: 'testtest123'
- There are 2 evaluators: i.e. `evaluator1@test.com`
- There are 2 assistants: i.e. `assistant1@test.com`
- There are 50 students: i.e. `student37@test.com`
- The idea was to create an even distribution of users to courses. 

### Organizations
- There are two. Baruch and something else. 
- Only Baruch has any associated data. Always use Baruch.

### Courses
- There are a handful of courses with somewhat realistic names.

### Projects
- Each course has 2 to 10 projects.
- Each project has 3 to 5 submissions.

### Project Types
- There is only one type: `presentation`

## Open Source Libraries Distributed with VOCAT

Vocat incorporates code from a number of open source projects:

- [Backbone.js](http://backbonejs.org/) - MIT License
- [Backbone Babysitter](https://github.com/marionettejs/backbone.babysitter) - MIT License
- [Backbone Wreqr](https://github.com/marionettejs/backbone.wreqr) - MIT License
- [Marionette](https://github.com/marionettejs/backbone.marionette) - MIT License
- [Crossfilter](https://github.com/square/crossfilter) - Apache 2.0 License
- [d3](http://d3js.org/) - BSD License
- [dc](https://github.com/dc-js/dc.js) - Apache 2.0 License
- [handlebars](https://github.com/wycats/handlebars.js/) - MIT License
- [hbs](https://github.com/SlexAxton/require-handlebars-plugin) - WTFPL License
- [JQuery](http://jquery.com/) - MIT License
- [JQuery UI](http://jquery.com/) - MIT License
- [jQuery File Upload](https://github.com/blueimp/jQuery-File-Upload) - MIT License
- [jQuery iFrame Transport](http://cmlenz.github.io/jquery-iframe-transport/) - MIT License
- [jQuery Simple Slider](http://loopj.com/jquery-simple-slider/) - MIT License
- [jQuery Smooth Scroll](https://github.com/kswedberg/jquery-smooth-scroll) - MIT License
- [jQuery Waypoints](https://github.com/imakewebthings/jquery-waypoints) - MIT License
- [jQuery Chosen](http://harvesthq.github.io/chosen/) - MIT License
- [jQuery Autosize](http://www.jacklmoore.com/autosize/) - MIT License
- [Modernizr](http://modernizr.com/) - MIT License
- [Require.js](http://requirejs.org/) - MIT License
- [Underscore.js](https://github.com/jashkenas/underscore/) - MIT License
- [Video.js](https://github.com/videojs/video.js/blob/master/LICENSE) - Apache 2.0 License


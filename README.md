# VOCAT 3.0
###### Like a beautiful phoneix, VOCAT rises from its ashes and takes flight.

## About VOCAT

Developed by the Bernard L. Schwartz Communication Institute at Baruch College, CUNY to help our students grow as confident, effective speakers, Vocat is a web application that facilitates feedback on live performances or recorded video or any other type of digital media. Over 10,000 Baruch College undergraduates in 30+ courses have used Vocat since launch of Vocat 2 in 2007.

The newest version features qualitative and quantitative feedback options, video annotation, improved discussions, support for cloud processing and storage of video, improved groups, and APIs for integration with other tools and services. LTI support for integration with most LMSs is coming soon.

## Setting up a Development Environment

TODO: Discuss setting up how to install dependencies, start the server, etc.

### Load Sample Data

As you work on VOCAT, it's helpful to have a good set of sample data. VOCAT includes a rake task that will truncate existing tables and load fake users and course data.

To load sample data, execute `rake development:load`. This Will create the following models:

#### Organizations
- http://greendale.vocat.dev/
- http://starfleet.vocat.dev/
- http://gotham.vocat.dev/

#### Users (replace "greendale" with the appropriate subdomain)
- superadmin@vocat.io / cuny4life
- admin@greendale.edu / vocat1223
- evaluator1@greendale.edu / vocat123 (there are more evaluators; just change the number)
- creator1@greendale.edu / vocat123 (there are more creators; just change the number)
- assistant1@greendale.edu / vocat123 (there are more assistants; just change the number)

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

As of 3/25/14, it also relies on the following Gems:

- actionmailer, 4.0.2, MIT
- actionpack, 4.0.2, MIT
- active_model_serializers, 0.7.0, MIT
- activemodel, 4.0.2, MIT
- activerecord, 4.0.2, MIT
- activerecord-deprecated_finders, 1.0.3, MIT
- activesupport, 4.0.2, MIT
- arel, 4.0.1, MIT
- atomic, 1.1.14, Apache-2.0
- aws-sdk, 1.32.0, Apache 2.0
- bcrypt-ruby, 3.1.2, MIT
- builder, 3.1.4, MIT
- bundler, 1.3.5, MIT
- cancan, 1.6.9, MIT
- celluloid, 0.15.2, MIT
- chunky_png, 1.2.9, MIT
- climate_control, 0.0.3, MIT
- cocaine, 0.5.3, MIT
- coderay, 1.1.0, MIT
- coffee-rails, 4.0.1, MIT
- coffee-script, 2.2.0, MIT
- coffee-script-source, 1.6.3, MIT
- compass, 0.12.2, MIT
- compass-rails, 1.1.3, MIT
- daemons, 1.1.9, MIT
- delayed_job, 4.0.0, MIT
- delayed_job_active_record, 4.0.0, MIT
- devise, 3.2.2, MIT
- diff-lcs, 1.2.5, MIT
- ejs, 1.1.1, MIT
- erubis, 2.7.0, MIT
- execjs, 2.0.2, MIT
- factory_girl, 4.3.0, MIT
- factory_girl_rails, 4.3.0, MIT
- faker, 1.2.0, MIT
- ffi, 1.9.3, BSD
- formatador, 0.2.4, MIT
- fssm, 0.2.10, MIT
- guard, 2.3.0, MIT
- guard-coffeescript, 1.3.4, MIT
- guard-copy, 0.5.0, MIT
- hashie, 2.0.5, MIT
- hike, 1.2.3, MIT
- i18n, 0.6.9, MIT
- jquery-fileupload-rails, 0.4.1, MIT
- jquery-rails, 2.1.4, MIT
- json, 1.8.1, Ruby
- kaminari, 0.15.1, MIT
- kgio, 2.8.1, LGPL
- listen, 2.4.0, MIT
- lumberjack, 1.0.4, MIT
- mail, 2.5.4, MIT
- method_source, 0.8.2, MIT
- mime-types, 1.25.1, MIT
- mini_portile, 0.5.2, MIT
- minitest, 4.7.5, MIT
- multi_json, 1.8.4, MIT
- net-ldap, 0.3.1, MIT
- nokogiri, 1.6.1, MIT
- orm_adapter, 0.5.0, MIT
- paper_trail, 3.0.0, MIT
- paperclip, 3.4.2, MIT
- pg, 0.17.1, BSD
- polyglot, 0.3.3, MIT
- pry, 0.9.12.4, MIT
- quiet_assets, 1.0.2, other
- rack, 1.5.2, MIT
- rack-test, 0.6.2, MIT
- rails, 4.0.2, MIT
- rails-backbone, 0.9.10, MIT
- railties, 4.0.2, MIT
- raindrops, 0.12.0, LGPL
- rake, 10.1.1, MIT
- ranked-model, 0.4.0, MIT
- rb-fsevent, 0.9.4, MIT
- rb-inotify, 0.9.3, MIT
- rspec, 2.14.1, MIT
- rspec-core, 2.14.7, MIT
- rspec-expectations, 2.14.4, MIT
- rspec-mocks, 2.14.4, MIT
- rspec-rails, 2.14.1, MIT
- sass, 3.2.13, MIT
- sass-rails, 4.0.1, MIT
- simple_form, 3.0.1, MIT
- slop, 3.4.7, MIT
- sprockets, 2.10.1, MIT
- sprockets-rails, 2.0.1, MIT
- state_machine, 1.2.0, MIT
- thor, 0.18.1, MIT
- thread_safe, 0.1.3, Apache-2.0
- tilt, 1.4.1, MIT
- timers, 1.1.0, MIT
- treetop, 1.4.15, MIT
- tzinfo, 0.3.38, MIT
- uglifier, 2.4.0, MIT
- unicorn, 4.8.0, GPLv2+
- uuidtools, 2.1.4, Apache 2.0
- warden, 1.2.3, MIT
- wicked_pdf, 0.9.7, MIT
- wkhtmltopdf-binary, 0.9.9.1, Lesser GPL

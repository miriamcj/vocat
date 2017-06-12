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
- admin@greendale.edu / vocat123
- evaluator1@greendale.edu / vocat123 (there are more evaluators; just change the number)
- creator1@greendale.edu / vocat123 (there are more creators; just change the number)
- assistant1@greendale.edu / vocat123 (there are more assistants; just change the number)


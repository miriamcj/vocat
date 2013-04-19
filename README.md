# VOCAT 3.0
###### Like a beautiful phoneix, VOCAT rises from its ashes and takes flight.

## Infrastructure
- Vocat relies on postgres, which can generally be installed via yum or apt-get
- You will need Postgres' hstore module. On RHEL, you start by installing the pg contrib package: yum install postgresql92-contrib.x86_64

## Seeds

### Users
- Passwords are the same for everyone: 'testtest123'
- Administrators are your email addresses: i.e. `alex@castironcoding.com`
- There are 6 evaluators: i.e. `evaluator3@test.com`
- There are 15 assistants: i.e. `assistant7@test.com`
- There are 150 students: i.e. `student37@test.com`
- The idea was to create an even distribution of users to courses. 

> Note that since the data is random, **some users may have no courses related to them**. In that case, log out and use a different user. Also, the randomness is consistent for every re-seeding. So, unless `seeds.rb` changes significantly, there is a good chance that `student19@test.com` will always have the same data associated with it.

### Special users
- There is one user who has a global role of `evaluator` but is an `assistant` for one course: `assistant_evaluator@test.com`

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

### Submissions
- Each submission has one attachment, one of two videos. 
- All of the videos are pointing to only two videos on AWS S3. So never delete the S3 folder `2013/2/20`.

## Migration Procedures

Since we're still early in the development process, it doesn't make sense to manage a ton of various migrations. Here are the steps that have been working for me to maintain one migration.

After making regular changes to the migration.rb file, like adding columns or indices:

    rake db:rollback # This undoes the current migration.
	rake db:migrate  # This redoes the migration with your new changes.
	rake db:seed     # This fills the database with the seed data.
			    
After renaming or dropping tables, you need to actually remove the old tables from the schema.rb file and then:

    rake db:reset

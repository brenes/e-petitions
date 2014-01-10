e-petitions
===========

This is the code base for the UK Government's e-petitions service (http://epetitions.direct.gov.uk).  
We have open sourced the code for you to use under the terms of licence contained in this repository.

We hope you enjoy it!

A few things to know:

You will need `ruby 1.8.7`

You will need to set up the `database.yml`
You will need to run `seeds.rb` to seed the 'department' data required for moderation of petitions
You will need to set the ENV vars from env_vars initializer (`config/initializers/env_vars.rb.example`) by copying it to `config/initializers/env_vars.rb` and setting your own values.
Remember that if you use Heroku you must set those ENV variables in Heroku.


For setting up a sysadmin user, run `rake epets:add_sysadmin_user` - the password must contain a mix of upper and lower case letters, numbers and special characters.

To start a solr instance, run `rake sunspot:solr:start`
To index the models, run `rake sunspot:reindex`

To get the selenium tests running, make sure you're running firefox 7 as your firefox browser or alternatively, have firefox 7 in one of the following locations:

`/Applications/Firefox7.app/Contents/MacOS/firefox-bin`
 or
`/Applications/Firefox 7.app/Contents/MacOS/firefox-bin`

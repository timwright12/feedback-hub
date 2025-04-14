# Feedback Hub

View the live app at [https://feedback-hub-e659c24714b9.herokuapp.com/](https://feedback-hub-e659c24714b9.herokuapp.com/)

Feedback Hub is a one stop shop for viewing feedback from various sources. It is a Rails app that uses the Reddit API to search for posts/comments in the subreddits r/VeteransBenefits and r/Veterans, along with reviews in both the App Store and Play Store. You can search based on keyword, date range, and rating (if applicable). The results can be downloaded as a CSV file.

Currently, the CSV contains columns specified by a team member. They are predetermined and not customizable.

## Installation
This assumes you already have ruby installed and you have your own ruby version manager. If you do not have one installed, I would recommend [rbenv](https://github.com/rbenv/rbenv).

You will need to perform the standard procedures for installing a rails app. This involves, installing gems, installing and migrating a database, obtaining the `master.key`, and running the app.

### Installing Bun
Bun is used for the javascript build pipeline. Ensure you have it [installed](https://bun.sh) before proceeding. 

### Installing the Gems
From the repo root, run `bundle install`

### Installing the database
You can choose to install postgres through either `brew` or the [postgres app](https://postgresapp.com/). After installing the database,
run `bundle exec rails db:migrate`

This assume you will be running the database locally with default settings. If you need to configure the app to connect to another database,
you can configure it to do so in `config/database.yml` under development. Just don't commit the changes if you end up doing this.

### Obtaining the master.key
Obtain the `master.key` from a team member, and place it inside the `config` directory

### Running the app
Run `bin/dev`. This starts up and runs the services inside the `Procfile.dev` file. That file is also where the port is set
for the app. Feel free to change the services here however you would like, just don't commit them to the repo.

## Contributing
We're not yet sure how this app will expand, but it is set up with rudimentary tests and a basic CI/CD pipeline. The tests are written in Minitest and the pipeline is set up with GitHub Actions. The pipeline runs the tests and deploys to Heroku if the tests pass.

Everything in the app is built with the bleeding edge Rails 7.1 defaults. This means the front end is built with Hotwire and Tailwind CSS. The only non-default added to the front end is [View Components](https://viewcomponent.org). The back end is built with the latest Rails conventions.

If you'd like to contribute, please open an issue or a pull request. We're open to any and all suggestions. Please refrain from forking and developing in a silo, we'd like to develop this collaboratively 

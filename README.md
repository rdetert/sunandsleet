# README

## Installation

> bundle install

> rake db:migrate

> rake locations:seed

> rake dev:cache

> rails s

Goto http://localhost:3000

Weather API provided by http://forecast.io

Zipcodes + GPS loaded from database. Source file is several years old so some zipcodes may have changed slightly over the years.

## Issues

Everything works properly on my machine but Heroku looks to have some issues sometimes with timezones and the proper day of the week showing up in the extended forecasts.

It could be because I'm using SQLite in dev and Postgres in production. Not sure exactly...

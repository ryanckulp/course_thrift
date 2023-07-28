# Course Thrift
a Rails 7 live stream build by [@ryanckulp](https://twitter.com/ryanckulp). watch the full build [here](https://www.youtube.com/watch?v=u9xajgugRLM). learn how to build this yourself at [24 Hour MVP](https://founderhacker.com/24-hour-mvp).

url: https://course-thrift-6e04a47f6ec1.herokuapp.com

## Installation
1. clone the repo
2. bin/setup
3. get repo secrets (`config/application.yml`) from admin

## Development
```sh
bin/dev # uses foreman to boot server, frontend, and bg job queue
```

## Testing
```
bundle exec rspec # run all tests inside spec/
bundle exec rspec spec/dir_name # run all tests inside given directory
```

## Deploying
```sh
figaro heroku:set -e production # you only need to do this once
heroku git:remote -a heroku_app_name_here # you only need to do this once
```

```sh
git push heroku master # deploys master branch
git push heroku some_branch_name:master # deploys non-master branch
```

**note**: Heroku must have 2 'dynos' enabled, `web` + `worker`, to process background jobs. if you don't need a queue, simply remove the `worker` task from `Procfile` and don't invoke `.delayed` functions.

## Miscellaneous
to use Postmark for emails, set `postmark_api_token` inside `application.yml`, then [verify your sending domain](https://account.postmarkapp.com/signature_domains/initialize_verification).

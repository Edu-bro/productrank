#!/usr/bin/env bash
# exit on error
set -o errexit

# SECRET_KEY_BASE가 없으면 임시로 생성 (Render가 자동 생성하기 전 빌드용)
if [ -z "$SECRET_KEY_BASE" ]; then
  export SECRET_KEY_BASE=$(openssl rand -hex 64)
fi

# Clear bootsnap cache to prevent stale code issues
rm -rf tmp/cache/bootsnap*

bundle install
bundle exec rake assets:precompile
bundle exec rake assets:clean
bundle exec rake db:migrate

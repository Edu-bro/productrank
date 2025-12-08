#!/usr/bin/env bash
# exit on error
set -o errexit

echo "=== Render Build Script Starting ==="
echo "Current directory: $(pwd)"
echo "Git branch: $(git branch --show-current)"
echo "Git commit: $(git rev-parse HEAD)"

# SECRET_KEY_BASE가 없으면 임시로 생성 (Render가 자동 생성하기 전 빌드용)
if [ -z "$SECRET_KEY_BASE" ]; then
  export SECRET_KEY_BASE=$(openssl rand -hex 64)
fi

# Clear all caches to prevent stale code issues
echo "=== Clearing caches ==="
rm -rf tmp/cache/*

# Clear Spring if it exists (development tool that shouldn't be in production)
if [ -d tmp/pids ]; then
  rm -rf tmp/pids/*
fi

bundle install
bundle exec rake assets:precompile
bundle exec rake assets:clean
bundle exec rake db:migrate

# Seed database only if it's empty (no products exist)
echo "=== Checking if database needs seeding ==="
PRODUCT_COUNT=$(bundle exec rails runner "puts Product.count")
if [ "$PRODUCT_COUNT" -eq "0" ]; then
  echo "Database is empty. Running seeds..."
  bundle exec rake db:seed
else
  echo "Database already has $PRODUCT_COUNT products. Skipping seed."
fi

echo "=== Build completed successfully ==="

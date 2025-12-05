namespace :products do
  desc "Update launch dates to random dates within last 2 months"
  task update_launch_dates: :environment do
    puts "Updating launch dates for all products..."

    # 2개월 전부터 어제까지
    end_date = Date.yesterday
    start_date = 2.months.ago.to_date

    Launch.find_each do |launch|
      # 랜덤 날짜 생성
      random_days = rand(0..(end_date - start_date).to_i)
      random_date = start_date + random_days.days

      # 시간도 랜덤하게 (9시~18시 사이)
      random_hour = rand(9..18)
      random_minute = rand(0..59)
      random_datetime = random_date.to_time + random_hour.hours + random_minute.minutes

      launch.update!(launch_date: random_datetime)

      print "."
    end

    puts "\n✅ Updated #{Launch.count} launches"
    puts "Date range: #{start_date} ~ #{end_date}"

    # 통계 출력
    puts "\n📊 Distribution by date:"
    Launch.group("DATE(launch_date)").count.sort.last(10).each do |date, count|
      puts "  #{date}: #{count} products"
    end
  end
end

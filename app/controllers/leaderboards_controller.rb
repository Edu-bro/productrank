class LeaderboardsController < ApplicationController
  before_action :set_date_params, only: [:daily_date]
  
  def index
    redirect_to "/leaderboard/daily"
  end

  def daily
    @date = Date.current
    @products = get_products_by_period(:daily, @date)
    @period_title = "오늘 (#{@date.strftime('%Y년 %m월 %d일')})"
  end

  def daily_date
    @date = Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)
    @products = get_products_by_period(:daily, @date)
    @period_title = "#{@date.strftime('%Y년 %m월 %d일')}"
    render :daily
  end

  def weekly
    @date = params[:date] ? Date.parse(params[:date]) : Date.current
    @date = @date.beginning_of_week
    @products = get_products_by_period(:weekly, @date)
    @period_title = "이번 주 (#{@date.strftime('%m월 %d일')} - #{@date.end_of_week.strftime('%m월 %d일')})"
  end

  def monthly
    @date = params[:date] ? Date.parse(params[:date]) : Date.current
    @date = @date.beginning_of_month
    @products = get_products_by_period(:monthly, @date)
    @period_title = "이번 달 (#{@date.strftime('%Y년 %m월')})"
  end

  def yearly
    @date = params[:date] ? Date.parse(params[:date]) : Date.current
    @date = @date.beginning_of_year
    @products = get_products_by_period(:yearly, @date)
    @period_title = "올해 (#{@date.strftime('%Y년')})"
  end

  def all_time
    @products = get_products_by_period(:all_time)
    @period_title = "전체"
  end

  private

  def set_date_params
    @year = params[:year].to_i
    @month = params[:month].to_i  
    @day = params[:day].to_i
  end

  def get_products_by_period(period, date = nil)
    page = (params[:page] || 1).to_i
    per_page = 20
    offset = (page - 1) * per_page

    case period
    when :daily
      products = Product.where(created_at: date.beginning_of_day..date.end_of_day)
    when :weekly
      products = Product.where(created_at: date.beginning_of_week..date.end_of_week)
    when :monthly
      products = Product.where(created_at: date.beginning_of_month..date.end_of_month)
    when :yearly
      products = Product.where(created_at: date.beginning_of_year..date.end_of_year)
    when :all_time
      products = Product.all
    end

    # 투표 수로 정렬하고 페이지네이션 적용
    products = products.published
                      .order('products.votes_count DESC, products.likes_count DESC, products.created_at DESC')
                      .limit(per_page)
                      .offset(offset)

    # 현재 페이지 정보 추가
    @current_page = page
    @total_pages = (get_total_count(period, date) / per_page.to_f).ceil
    @has_next_page = page < @total_pages
    @has_prev_page = page > 1

    products
  end

  def get_total_count(period, date = nil)
    case period
    when :daily
      Product.published.where(created_at: date.beginning_of_day..date.end_of_day).count
    when :weekly
      Product.published.where(created_at: date.beginning_of_week..date.end_of_week).count
    when :monthly
      Product.published.where(created_at: date.beginning_of_month..date.end_of_month).count
    when :yearly
      Product.published.where(created_at: date.beginning_of_year..date.end_of_year).count
    when :all_time
      Product.published.count
    end
  end
end

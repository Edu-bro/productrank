class LaunchesController < ApplicationController
  def index
    # 기본은 오늘로 리다이렉트
    redirect_to launches_today_path
  end

  def today
    @period = 'today'
    @page_title = '오늘 출시된 신규 제품'

    @products = Product.published
                      .includes([:makers, :topics, :user,
                                logo_image_attachment: :blob,
                                cover_image_attachment: :blob])
                      .joins(:launches)
                      .where('DATE(launches.launch_date) = ?', Date.current)
                      .order('launches.launch_date DESC, products.created_at DESC')
                      .page(params[:page]).per(20)

    render :index
  end

  def week
    @period = 'week'
    @page_title = '이번주 출시된 신규 제품'

    @products = Product.published
                      .includes([:makers, :topics, :user,
                                logo_image_attachment: :blob,
                                cover_image_attachment: :blob])
                      .joins(:launches)
                      .where('DATE(launches.launch_date) >= ? AND DATE(launches.launch_date) <= ?',
                             Date.current.beginning_of_week, Date.current.end_of_week)
                      .order('launches.launch_date DESC, products.created_at DESC')
                      .page(params[:page]).per(20)

    render :index
  end

  def month
    @period = 'month'
    @page_title = '이번달 출시된 신규 제품'

    @products = Product.published
                      .includes([:makers, :topics, :user,
                                logo_image_attachment: :blob,
                                cover_image_attachment: :blob])
                      .joins(:launches)
                      .where('DATE(launches.launch_date) >= ? AND DATE(launches.launch_date) <= ?',
                             Date.current.beginning_of_month, Date.current.end_of_month)
                      .order('launches.launch_date DESC, products.created_at DESC')
                      .page(params[:page]).per(20)

    render :index
  end

  def upcoming
    @period = 'upcoming'
    @page_title = '출시 예정 제품'
    @is_upcoming = true

    @products = Product.where(status: [:scheduled, :pending])
                      .includes([:makers, :topics, :user,
                                logo_image_attachment: :blob,
                                cover_image_attachment: :blob])
                      .joins(:launches)
                      .where('DATE(launches.launch_date) > ?', Date.current)
                      .order('launches.launch_date ASC, products.created_at DESC')
                      .page(params[:page]).per(20)

    render :upcoming
  end
end

class Challenge < ApplicationRecord
  # 상태: active(진행중), upcoming(예정), ended(종료)
  enum :status, { upcoming: 0, active: 1, ended: 2 }

  # period_type: 'weekly' or 'monthly'
  validates :title, presence: true
  validates :period_type, inclusion: { in: %w[weekly monthly] }
  validates :start_date, :end_date, presence: true
  validate :end_date_after_start_date

  # Scopes
  scope :current, -> { where(status: :active).where('end_date >= ?', Time.current) }
  scope :by_period, ->(period) { where(period_type: period) }

  # 현재 진행중인 챌린지 찾기 (없으면 자동 생성)
  def self.current_weekly
    # 이번 주 월요일 00:00 ~ 일요일 23:59:59
    week_start = Date.current.beginning_of_week(:monday).to_time
    week_end = Date.current.end_of_week(:sunday).end_of_day

    challenge = where(period_type: 'weekly')
                 .where('start_date <= ? AND end_date >= ?', Time.current, Time.current)
                 .first

    # 없으면 자동 생성
    unless challenge
      challenge = create(
        title: "#{week_start.strftime('%Y년 %m월 %d일')} 주간 챌린지",
        period_type: 'weekly',
        start_date: week_start,
        end_date: week_end,
        status: :active
      )
    end

    challenge
  end

  def self.current_monthly
    # 이번 달 1일 00:00 ~ 마지막날 23:59:59
    month_start = Date.current.beginning_of_month.to_time
    month_end = Date.current.end_of_month.end_of_day

    challenge = where(period_type: 'monthly')
                 .where('start_date <= ? AND end_date >= ?', Time.current, Time.current)
                 .first

    # 없으면 자동 생성
    unless challenge
      challenge = create(
        title: "#{month_start.strftime('%Y년 %m월')} 챌린지",
        period_type: 'monthly',
        start_date: month_start,
        end_date: month_end,
        status: :active
      )
    end

    challenge
  end

  # 챌린지 기간 내의 제품들 가져오기
  def products
    Product.published.where(created_at: start_date..end_date)
  end

  # D-day 계산
  def days_remaining
    return 0 if ended?
    ((end_date.to_date - Date.current).to_i).clamp(0, Float::INFINITY)
  end

  # 상태 텍스트
  def status_text
    if active?
      days = days_remaining
      period_text = period_type == 'weekly' ? '이번 주' : '이번 달'
      "#{period_text} 챌린지 진행 중#{days > 0 ? " · 마감까지 D-#{days}" : ''}"
    elsif upcoming?
      "곧 시작됩니다"
    else
      "종료되었습니다"
    end
  end

  private

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?

    if end_date < start_date
      errors.add(:end_date, "must be after the start date")
    end
  end
end

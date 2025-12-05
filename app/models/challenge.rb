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

  # 현재 진행중인 챌린지 찾기
  def self.current_weekly
    current.by_period('weekly').first
  end

  def self.current_monthly
    current.by_period('monthly').first
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

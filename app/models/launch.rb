class Launch < ApplicationRecord
  belongs_to :product
  
  enum :status, { scheduled: 0, live: 1, closed: 2 }
  
  validates :launch_date, presence: true
  validates :region, presence: true
  
  scope :today, -> { where(launch_date: Date.current.beginning_of_day..Date.current.end_of_day) }
  scope :this_week, -> { where(launch_date: 1.week.ago..Time.current) }
  scope :this_month, -> { where(launch_date: 1.month.ago..Time.current) }
  
  def live?
    status == 'live' && launch_date <= Time.current
  end
end

class Customer < ActiveRecord::Base
  belongs_to :user
  belongs_to :property
  has_many :payments
  has_many :invoices
  has_many :trans

  validates :user_id, presence: true
  validates :property_id, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true

  after_find do
    today = Date.today

    if self.active && (today.day.to_s == self.due_date)
      unless self.charged_today?
        invoice = self.invoices.build(amount: self.rent, date: today, memo: "Rent for #{Date::MONTHNAMES[today.month]} #{today.year}")
        invoice.user = self.user
        invoice.save
        self.toggle!(:charged_today)
      end
    else
      if self.charged_today?
        self.toggle!(:charged_today)
      end
    end
  end

  after_create do
    self.property.toggle!(:rented)
  end


  def self.search(search, display_param, user)
    if search
      query = "first_name LIKE ? OR middle_name LIKE ?"\
       " OR last_name LIKE ? OR concat_ws(' ' , first_name, middle_name, last_name) LIKE ?"\
       " OR concat_ws(' ' , first_name, last_name) LIKE ?"\
       " OR properties.address LIKE ?",
       "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%"

      if display_param.blank? || display_param == 'active'
        return joins(:property).where(query).where(user: user, active: true)
      else
        return joins(:property).where(query).where(user: user)
      end
    else
      if display_param.blank? || display_param == 'active'
        return where(user: user, active: true)
      else
        return where(user: user)
      end
    end
  end

  def full_name
    "#{self.first_name} #{self.middle_name} #{self.last_name}"
  end

  def archive
    self.toggle!(:active)
    self.property.toggle!(:rented)
  end
end

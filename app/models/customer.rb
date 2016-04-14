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

    if today.day.to_s == self.due_date
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


  def self.search(search, user)
    if search
      joins(:property)
      .where("first_name LIKE ? OR middle_name LIKE ?"\
       " OR last_name LIKE ? OR concat_ws(' ' , first_name, middle_name, last_name) LIKE ?"\
       " OR concat_ws(' ' , first_name, last_name) LIKE ?"\
       " OR properties.address LIKE ?",
       "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%")
      .where(user: user)
    else
      where(user: user)
    end
  end

  def full_name
    "#{self.first_name} #{self.middle_name} #{self.last_name}"
  end
end

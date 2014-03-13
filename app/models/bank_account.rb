class BankAccount < ActiveRecord::Base
  CURRENCY_USD = 'USD'
  CURRENCY_RUB = 'RUB'
  CURRENCIES = [CURRENCY_USD, CURRENCY_RUB]

  belongs_to :organization, inverse_of: :bank_accounts
  has_many :transactions, dependent: :destroy, inverse_of: :bank_account

  monetize :balance_cents, with_model_currency: :currency

  validates :name,     presence: true
  validates :balance,  presence: true
  validates :currency, presence: true, inclusion: { in: CURRENCIES, message: "%{value} is not a valid currency" }

  def self.total_balance_cents(currency)
    where(currency: currency).sum(:balance_cents)
  end

  def recalculate_amount
    due = self.balance
    self.transactions.each do |transaction|
      due -= transaction.amount
    end

    self.balance = due
  end
end

# == Schema Information
#
# Table name: transactions
#
#  id              :integer          not null, primary key
#  amount_cents    :integer          default(0), not null
#  category_id     :integer          not null
#  bank_account_id :integer          not null
#  created_at      :datetime
#  updated_at      :datetime
#  comment         :string(255)
#

class Transaction < ActiveRecord::Base
  CURRENCIES = %w(USD RUB)

  belongs_to :category, inverse_of: :transactions
  belongs_to :bank_account, inverse_of: :transactions
  has_one :organization, through: :bank_account, inverse_of: :transactions

  monetize :amount_cents, with_model_currency: :currency

  delegate :currency, to: :bank_account, allow_nil: true
  delegate :income?, :expense?, to: :category

  default_scope { order(created_at: :desc) }

  validates :amount,   presence: true, numericality: { greater_than: 0 }
  validates :category, presence: true
  validates :bank_account, presence: true

  after_save do |transaction|
    recalculate_amount(transaction)
  end

  private

  def recalculate_amount(p_transaction)
    unless p_transaction.bank_account.nil?
      p_transaction.bank_account.recalculate_amount
      p_transaction.bank_account.save!
    end
  end
end

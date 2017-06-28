class AzStoreItem < ActiveRecord::Base
  belongs_to :item, :polymorphic => true
  belongs_to :az_scetch_program
  belongs_to :az_language

  has_many :az_purchases
  has_many :az_store_item_scetches, :dependent => :destroy

  has_attached_file :scheme, :styles => { :big => "600x1200>", :medium => '400x800>', :small => "200x400>", :tiny => "100x200>"}

  accepts_nested_attributes_for :az_store_item_scetches, :reject_if => proc { |attributes| attributes['scetch'].blank? }

  def buy(company)

    invoice = AzInvoice.new
    bill = AzBill.new
    bt = AzBalanceTransaction.new
    bill.fee = self.price
    bill.description = "Покупка #{self.item.class.get_model_name.downcase} '#{self.item.name}' (#{self.item.id})"

    ret = false

    AzStoreItem.transaction do

      
      ret = item.make_copy(company)
      bt.az_invoice = invoice
      #invoice.description = "Оплата по счету #{invoice.id}"
      invoice.save
      bill.az_invoice = invoice
      #bill.save
      invoice.az_bills << bill
      bt.amount = -invoice.get_total_fee
      bt.az_company = company
      bt.description = "Оплата по счету ##{invoice.id}"
      bt.save

      purchase = AzPurchase.new
      purchase.az_company = company
      purchase.az_store_item = self
      purchase.az_bill_id = bill.id
      purchase.save

    end

    return ret
  end

  def self.store_items
    return AzStoreItem.find(:all, :conditions => {:visible => true}, :order => 'created_at desc')
  end

  def self.latests
    return AzStoreItem.find(:all, :conditions => {:visible => true}, :order => 'created_at desc', :limit => 3)
  end

end

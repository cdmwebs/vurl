class Vurl < ActiveRecord::Base
  require 'open-uri'
  require 'nokogiri'

  validates_presence_of :url
  validates_format_of   :url, :with => /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix
  has_many :clicks

  before_save :fetch_url_data

  named_scope :most_popular, lambda {|*args| { :order => 'clicks_count desc', :limit => args.first || 5 } }
  named_scope :since, lambda {|*args| { :conditions => ["created_at >= ?", args.first || 7.days.ago] } }

  def self.random
    find(:first, :offset => (Vurl.count * rand).to_i)
  end

  def before_create
    if vurl = Vurl.find(:first, :order => 'id DESC')
      self.slug = vurl.slug.succ
    else
      self.slug = 'AA'
    end
  end

  def fetch_url_data
    begin
      document = Nokogiri::HTML(open(construct_url))

      self.title = document.at('title').text
      self.keywords = document.at("meta[@name*=eywords]/@content").to_s
      self.description = document.at("meta[@name*=escription]/@content").to_s
    rescue
      logger.warn "Could not fetch data for #{construct_url}."
    end
  end

  def construct_url
    url
  end
end

require File.dirname(__FILE__) + '/../spec_helper'

describe "Vurl" do

  before do
    @vurl = Vurl.new
  end

  it "should require a url" do
    @vurl.should have(2).errors_on(:url)
  end
  it "should require a valid url" do
    Factory.build(:vurl, :url => 'invalid_url').should_not be_valid
    Factory.build(:vurl, :url => 'http://sub-domain.mattremsik.com').should be_valid
  end
  it "has many clicks" do
    @vurl.should respond_to(:clicks)
  end

  it "should fetch url data before saving" do
    @vurl.should_receive(:fetch_url_data)
    @vurl.save_without_validation
  end

  it "handles the switch to AAA" do
    @vurl.save_without_validation
    @vurl.update_attribute(:slug, 'ZZ')
    other_vurl = Vurl.new
    other_vurl.save_without_validation
    other_vurl.write_attribute(:slug, 'AAA')
    new_vurl = Vurl.new
    new_vurl.save_without_validation
    new_vurl.slug.should == 'AAB'
  end

  describe ".random" do
    # Not entirely sure how to test this. Maybe stubbing count and rand and setting
    # an expectation that find is called with that offset? - Veez
  end

  describe ".most_popular" do
    it "returns the correct number of vurls" do
      5.times { Factory(:vurl) }
      Vurl.most_popular(4).length.should == 4
    end
    it "has a default number of results" do
      6.times { Factory(:vurl) }
      Vurl.most_popular.length.should == 5
    end
  end

  describe "#fetch_url_data" do
    before do
      @vurl.stub!(:construct_url).and_return(RAILS_ROOT + '/spec/data/nytimes_article.html')
    end
    it "assigns a title" do
      @vurl.should_receive(:title=).with('Suicide Attack Kills 5 G.I.’s and 2 Iraqis in Northern City - NYTimes.com')
      @vurl.fetch_url_data
    end
    it "assigns keywords" do
      @vurl.should_receive(:keywords=).with('Iraq,Iraq War (2003- ),United States Defense and Military Forces,Terrorism,Bombs and Explosives')
      @vurl.fetch_url_data
    end
    it "assigns a description" do
      @vurl.should_receive(:description=).with('The bombing of a Mosul police headquarters on Friday was the deadliest attack against American soldiers in 13 months.')
      @vurl.fetch_url_data
    end
  end
end

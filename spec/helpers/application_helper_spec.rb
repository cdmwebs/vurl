require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
include ApplicationHelper

describe ApplicationHelper do
  describe 'the flasher' do
    describe 'when empty' do
      it "should display nothing when no flash messages exist" do
        flasher.should be_nil
      end
    end

    describe 'with messages' do
      before(:each) do
        flash[:notice] = 'This is a notice.'
        flash[:error] = 'This is an error.'
        flash[:warning] = 'This is a warning.'
      end

      it "should render flash messages when present" do
        flasher.should_not be_nil
      end
    end
  end
end

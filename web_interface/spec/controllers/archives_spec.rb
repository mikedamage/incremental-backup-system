require File.join(File.dirname(__FILE__), "..", 'spec_helper.rb')

describe Archives, "index action" do
  before(:each) do
    dispatch_to(Archives, :index)
  end
end
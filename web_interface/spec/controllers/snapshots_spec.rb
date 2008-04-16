require File.join(File.dirname(__FILE__), "..", 'spec_helper.rb')

describe Snapshots, "index action" do
  before(:each) do
    dispatch_to(Snapshots, :index)
  end
end
require_relative '../lib/oculus/query'
require_relative '../lib/oculus/presenters/query_presenter'

describe Oculus::Presenters::QueryPresenter do
  let(:query) { Oculus::Query.new }
  let(:presenter) { Oculus::Presenters::QueryPresenter.new(query) }

  it "should delegate to the underlying query" do
    query.description = 'foo'
    presenter.description.should == 'foo'
  end

  it "has a formatted date" do
    query.date = Time.mktime(2010, 1, 1, 12, 34)
    presenter.formatted_date.should == '2010-01-01 12:34'
  end

  it "reports successful queries" do
    query.stub(:complete?).and_return(true)
    presenter.status.should == 'done'
  end

  it "reports failed queries" do
    query.stub(:complete?).and_return(true)
    query.stub(:error).and_return("you fail")
    presenter.status.should == 'error'
  end

  it "reports loading queries" do
    query.stub(:complete?).and_return(false)
    presenter.status.should == 'loading'
  end

  it "uses SQL for a description when there isn't one" do
    query.description = nil
    query.query = "SELECT * FROM foo"
    presenter.description.should == "SELECT * FROM foo"
  end

  it "reports that the query has been named" do
    query.description = "Select all the things"
    presenter.should be_named
  end

  it "reports that the query has not been named" do
    query.description = nil
    presenter.should_not be_named
  end
end

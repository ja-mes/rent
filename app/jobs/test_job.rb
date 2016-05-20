class TestJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    print "foo"
    # Do something later
  end
end

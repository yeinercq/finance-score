class CustomLogger < Logger
  def initialize
    super(Rails.root.join("log/custom_activity.log"), "daily")
    self.formatter = proc do |severity, datetime, progname, msg|
      "#{datetime.strftime('%Y-%m-%d %H:%M:%S')} #{severity}: #{msg}\n"
    end
  end
end

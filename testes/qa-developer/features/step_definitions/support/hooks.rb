# hooks.rb
require 'base64'
require 'report_builder'
require 'date'

Before do |scenario|
  Capybara.page.driver.browser.manage.window.resize_to('400','752') if Capybara.default_driver == :firefox_mobile
  Capybara.page.driver.browser.manage.window.maximize unless Capybara.default_driver == :firefox_mobile
end

After do |scenario|
  if scenario.failed?
    encoded_img = @browser.driver.screenshot_as(:base64)
    embed("data:image/png;base64,#{encoded_img}", 'image/png')
  end
	Capybara.current_session.driver.quit
end

at_exit do
  time = Time.now.strftime("%d_%m_%Y")
  @contents = {
      "Data do report" => time,
      "Tipo de teste" => "Web"
  }

  ReportBuilder.configure do |config|
      config.report_title = "Quero ser Clickbus"
      config.input_path = "log/report.json"
      config.report_path = "log/report_#{time}"
      config.report_types = [:html]
      config.additional_info = @contents
      config.color = "blue"
end
  ReportBuilder.build_report
end
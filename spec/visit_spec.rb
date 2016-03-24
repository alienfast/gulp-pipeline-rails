describe 'visit', :type => :feature, :js => true, :driver => :webkit do

  before do
    Capybara::Webkit.configure do |config|
      config.block_unknown_urls
      config.allow_url('https://code.jquery.com/jquery-2.2.2.min.js')
      config.allow_url('https://cdn.rawgit.com/HubSpot/tether/v1.2.0/dist/js/tether.min.js')
    end
  end

  it 'work!' do
    visit '/'
    expect(page).not_to have_content 'Full Trace'
    expect(page).to have_css('header h1', text: 'Welcome to gulp-pipeline-rails')
    page.driver.console_messages.each { |error| puts error }
    expect(page.driver.console_messages.length).to eq(0)
  end
end
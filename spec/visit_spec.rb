describe 'Gulp pipeline assets', :type => :feature, :js => true, :driver => :webkit do

  it 'work!' do
    visit home_path

    # expect(page).to have_css('header h1', text: 'Buy milk')
    expect(page).not_to have_content 'Full Trace'
  end
end
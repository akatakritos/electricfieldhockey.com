shared_examples "all pages" do 
  it 'has google analytics' do
    expect(page.html).to match "GoogleAnalyticsObject"
  end

  it 'has all-time nav links' do
    expect(page).to have_link 'Help', :href => tour_path
    expect(page).to have_link 'Levels', :href => levels_path
    expect(page).to have_link 'Users', :href => users_path
  end

  it 'has footer links' do
    expect(page).to have_link 'Matt Burke', :href => 'http://www.mattburkedev.com'
    expect(page).to have_link 'Twitter', :href => 'http://twitter.com/akatakritos/'
    expect(page).to have_link 'Github', :href => 'https://github.com/akatakritos/'
  end

end

shared_examples 'game levels' do
  it 'has a toggle button' do
    expect(page).to have_selector('button#stop', 'Start')
  end

  it 'has a reset button' do
    expect(page).to have_selector('button#reset', 'Reset')
  end
end

shared_examples 'admin pages' do
  describe 'no access to guests' do
    before { get the_path }
    it { should redirect_to signin_path }
  end

  describe 'no access to non admin' do 
    let(:non_admin_user) { FactoryGirl.create(:user) }
    before do
      sign_in non_admin_user
      get the_path
    end

    it { should redirect_to root_path }
  end 
end

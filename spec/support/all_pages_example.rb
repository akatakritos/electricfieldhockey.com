shared_examples "all pages" do 
  it 'has google analytics' do
    expect(page.html).to match "GoogleAnalyticsObject"
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
feature 'Adding new users' do
  scenario 'User count increments by 1 when user registers' do
    expect{sign_up}.to change{User.all.length}.by 1
  end

  scenario 'Displays welcome message for newly registered users' do
    sign_up
    expect(page).to have_content('Welcome Cameron')
  end

  scenario 'Email address is correct' do
    sign_up
    expect(User.first.email).to eq "cameron@gmail.com"
  end

  scenario 'form resubmission request when passwords do not match ' do
    expect{sign_up(password_confirmation: 'wrong')}.not_to change(User, :count)
    expect(current_path).to eq '/register'
    expect(page).to have_content 'Your passwords do not match! Please try again.'
  end
end

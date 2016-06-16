feature 'sign in' do


  scenario 'it authenticates a user' do
    sign_up
     visit('/sessions/new')
     fill_in('email', with: 'cameron@gmail.com')
     fill_in('password', with: 'password')
     click_button('submit')
    expect(page).to have_content "Welcome Cameron"
  end
  scenario 'it returns error if details are incorrect' do
    sign_up
    visit('/sessions/new')
    fill_in('email', with: 'camderon@gmail.com')
    fill_in('password', with: 'pasdsword')
    click_button('submit')
    expect(page).not_to have_content "Welcome Cameron"
  end
end

require 'spec_helper'

feature 'Update Menu' do
	
 let(:menu) {FactoryGirl.create(:chili_pepper_menu)}

  scenario 'shoud not allow me to visit the new or edit pages without being an admin' do
    visit chili_pepper.new_menu_path
	  expect(page).not_to have_content('New')
    visit chili_pepper.new_menu_path
    expect(page).not_to have_content('Edit')
	end

	scenario 'should allow me to add a menu when logged in as admin' do
    admin = FactoryGirl.create(:chili_pepper_admin)
    visit 'chili_pepper/admins/sign_in' 
    fill_in 'Email', with: admin.email
    fill_in 'Password', with: admin.password
    click_button 'Sign in'
		visit '/chili_pepper/menus/new'
		expect(page).to have_content 'New Menu'
		fill_in 'Name', with: 'Babou'
    click_button 'Create Menu'
    expect(current_path).to eq(chili_pepper.menu_path('babou'))
    expect(page).to have_content('Babou')
	end

  scenario 'allows to edit menu' do
    admin = FactoryGirl.create(:chili_pepper_admin)
    visit 'chili_pepper/admins/sign_in' 
    fill_in 'Email', with: admin.email
    fill_in 'Password', with: admin.password
    click_button 'Sign in'
    visit chili_pepper.edit_menu_path(menu)
    fill_in 'Name', with: 'PoteMenu Edited'
    click_button 'Update Menu'
    expect(current_path).to eq(chili_pepper.menu_path(menu))
    expect(page).to have_content('PoteMenu Edited')
  end

  scenario 'allows to delete menu' do
    admin = FactoryGirl.create(:chili_pepper_admin)
    visit 'chili_pepper/admins/sign_in' 
    fill_in 'Email', with: admin.email
    fill_in 'Password', with: admin.password
    click_button 'Sign in'
    visit chili_pepper.menu_path(menu)
    click_link 'Delete Menu'
   visit chili_pepper.menus_path
    expect(page).not_to have_content('A La Carte')
    expect(page).to have_content('New Menu')
  end

  scenario 'allows visit index of menus' do
    visit chili_pepper.menus_path
    visit chili_pepper.menu_path(menu)
    expect(page).to have_content('A La Carte')
  end

end

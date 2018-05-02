require 'spec_helper'

feature 'Announcements' do
  let(:member) { Fabricate(:member) }
  let(:chapter) { Fabricate(:chapter_with_groups) }

  before do
    member.add_role(:organiser, chapter)
    login_as_admin(member)
  end


  describe 'an authorised member' do
    describe 'can succesfuly create a new announcement' do
      scenario 'when they fill in all details' do
        visit new_admin_announcement_path
        fill_in 'Message', with: 'An announcement'
        click_on 'create'

        expect(page).to have_content('Announcement successfully created')
      end
    end

    describe 'can not create an announcement' do
      scenario 'when they don\'t fill in any of the mandatory details' do
        visit new_admin_announcement_path
        click_on 'create'

        expect(page).to have_content('Please make sure you fill in all mandatory fields')
      end
    end
  end

  scenario 'can view all announcements' do
    announcement = Fabricate(:announcement)
    old_announcement = Fabricate(:announcement, expires_at: Time.zone.now-1.week)

    visit admin_announcements_path

    expect(page).to have_content(announcement.message)
    expect(page).to have_content(old_announcement.message)
  end
end

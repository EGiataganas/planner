require 'spec_helper'

feature 'viewing a Chapter' do

  it 'a visitor to the website cannot accses non active chapters' do
    inactive_chapter = Fabricate(:chapter, active: false)
    visit chapter_path(inactive_chapter.slug)

    expect(page).to have_content("We can't find the chapter you are looking for")
  end

  it 'renders any upcoming workshops for the chapter' do
    chapter = Fabricate(:chapter)
    workshops = Fabricate.times(2, :workshop, chapter: chapter)

    visit chapter_path(chapter)
    workshops.each do |workshop|
      expect(page).to have_content "Workshop at #{workshop.host.name}"
    end
  end

  it 'renders the most recent past  workshop for the chapter' do
    chapter = Fabricate(:chapter)
    past_workshop = Fabricate(:workshop, chapter: chapter, date_and_time: Time.zone.today-2.week)
    recent_past_workshop = Fabricate(:workshop, chapter: chapter, date_and_time: Time.zone.today-1.week)

    visit chapter_path(chapter.name)
    expect(page).to have_content "Workshop at #{recent_past_workshop.host.name}"
    expect(page).to_not have_content "Workshop at #{past_workshop.host.name}"
  end
end

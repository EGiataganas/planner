require 'spec_helper'

describe MeetingInvitationMailer do
  let(:email) { ActionMailer::Base.deliveries.last }
  let(:meeting) { Fabricate(:meeting) }
  let(:member) { Fabricate(:member) }
  let(:invitation) { Fabricate(:meeting_invitation, meeting: meeting, member: member) }

  it '#invite' do
    email_subject = "You are invited to codebar's #{meeting.name} on #{humanize_date(meeting.date_and_time)}"
    MeetingInvitationMailer.invite(meeting, member).deliver_now

    expect(email.subject).to eq(email_subject)
    expect(email.body.encoded).to match(member.name)
  end

  it '#attending' do
    email_subject = "See you at #{meeting.name} on #{humanize_date(meeting.date_and_time)}"
    MeetingInvitationMailer.attending(meeting, member, invitation).deliver_now
    expect(email.subject).to eq(email_subject)
    expect(email.body.encoded).to match(member.name)
  end

  it '#approve_from_waitlist' do
    email_subject = "A spot opened up for #{meeting.name} on #{humanize_date(meeting.date_and_time)}"
    MeetingInvitationMailer.approve_from_waitlist(meeting, member, invitation).deliver_now
    expect(email.subject).to eq(email_subject)
    expect(email.body.encoded).to match(member.name)
  end

  it '#attendance_reminder' do
    email_subject = "Reminder: You have a spot for #{meeting.name} on #{humanize_date(meeting.date_and_time)}"
    MeetingInvitationMailer.attendance_reminder(meeting, member).deliver_now
    expect(email.subject).to eq(email_subject)
    expect(email.body.encoded).to match(member.name)
  end
end

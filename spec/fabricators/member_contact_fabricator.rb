Fabricator(:member_contact) do
  contact { Fabricate(:member) }
  sponsor
end
